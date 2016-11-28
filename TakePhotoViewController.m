//
//  TakePhotoViewController.m
//  ChristmasAR
//
//  Created by Izzy on 24/11/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import "TakePhotoViewController.h"
#import <AVFoundation/AVFoundation.h>


@interface TakePhotoViewController ()

@property AVCaptureVideoPreviewLayer *previewLayer;
@property AVCaptureSession *captureSession;
@property AVCaptureDevice *backCamera;
@property AVCaptureDevice *frontCamera;
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property AVCaptureStillImageOutput *stillImageOutput;

@end

@implementation TakePhotoViewController

#pragma mark - UI View Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"Take photo class");
    [self filterThroughDevices];
    [self liveCameraFeed];

}

#pragma mark - Camera Methods

-(void) liveCameraFeed  {
    //-- Setup Capture Session.
    _captureSession = [[AVCaptureSession alloc] init];
    //-- Creata a video device and input from that Device.  Add the input to the capture session.
    AVCaptureDevice * videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if(videoDevice == nil)
        assert(0);
    
    //-- Add the device to the session.
    NSError *error;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:_backCamera
                                                                        error:&error];
    if(error)
        assert(0);
    
    [_captureSession addInput:input];

    // Configure image output
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    [_captureSession addOutput:self.stillImageOutput];

    //-- Configure the preview layer
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [_previewLayer setFrame:CGRectMake(0, 0,
                                       self.view.frame.size.width,
                                       self.view.frame.size.height)];
    
    //-- Add the layer to the view that should display the camera input
    [self.cameraView.layer addSublayer:_previewLayer];
    
    //-- Start the camera
    [_captureSession startRunning];
}

-(void) obtainCaptureOutput {
    
}

-(void) filterThroughDevices    {
    NSArray *devices = [AVCaptureDevice devices];
    
    for (AVCaptureDevice *device in devices) {
        
        NSLog(@"Device name: %@", [device localizedName]);
        
        if ([device hasMediaType:AVMediaTypeVideo]) {
            
            if ([device position] == AVCaptureDevicePositionBack) {
                NSLog(@"Device position : back");
                _backCamera = device;
            }
            else {
                NSLog(@"Device position : front");
                _frontCamera = device;
                
            }
        }
    }
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == position)
            return device;
    }
    return nil;
}

- (void)captureStillImageAsynchronouslyFromConnection:(AVCaptureConnection *)connection
                                    completionHandler:(void (^)(CMSampleBufferRef imageDataSampleBuffer, NSError *error))handler
{
    
}

-(void) captureNow {
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    NSLog(@"about to request a capture from: %@", self.stillImageOutput);
    __weak typeof(self) weakSelf = self;
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil); //save to album
        
//        [weakSelf displayImage:image];
    }];
}
// note that `AVCaptureSession * session`
// make sure you have this method in your class
//



#pragma mark - Action Methods


- (IBAction)switchCameraButtonPressed:(UIButton *)sender {
    NSLog(@"Switch Camera");
    if(_captureSession)
    {
        [_captureSession beginConfiguration];
        
        AVCaptureInput *currentCameraInput = [_captureSession.inputs objectAtIndex:0];
        
        [_captureSession removeInput:currentCameraInput];
        
        AVCaptureDevice *newCamera = nil;
        
        if(((AVCaptureDeviceInput*)currentCameraInput).device.position == AVCaptureDevicePositionBack)
        {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
        }
        else
        {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
        }
        
        NSError *err = nil;
        
        AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:newCamera error:&err];
        
        if(!newVideoInput || err)
        {
            NSLog(@"Error creating capture device input: %@", err.localizedDescription);
        }
        else
        {
            [_captureSession addInput:newVideoInput];
        }
        
        [_captureSession commitConfiguration];
    }
}


- (IBAction)takePhotoButtonPressed:(UIButton *)sender {
    NSLog(@"Take PHoto");
    [self captureNow];
}

@end

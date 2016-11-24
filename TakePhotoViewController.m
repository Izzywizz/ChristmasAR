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
@property (weak, nonatomic) IBOutlet UIView *cameraPreviewView;

@end

@implementation TakePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"Take photo class");
    //-- Setup Capture Session.
    _captureSession = [[AVCaptureSession alloc] init];

}

-(void) liveCameraPeview    {
    
    //-- Creata a video device and input from that Device.  Add the input to the capture session.
    AVCaptureDevice * videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if(videoDevice == nil)
        assert(0);
    
    //-- Add the device to the session.
    NSError *error;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice
                                                                        error:&error];
    if(error)
        assert(0);
    
    [_captureSession addInput:input];
    
    //-- Configure the preview layer
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [_previewLayer setFrame:CGRectMake(0, 0,
                                       self.view.frame.size.width,
                                       self.view.frame.size.height)];
    
    //-- Add the layer to the view that should display the camera input
    [self.view.layer addSublayer:_previewLayer];
    
    //-- Start the camera
    [_captureSession startRunning];
}

@end

//
//  TakePhotoViewController.m
//  ChristmasAR
//
//  Created by Izzy on 24/11/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import "TakePhotoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SnowFalling.h"
#import <QuartzCore/QuartzCore.h>
#import "CameraPermissions.h"

@interface TakePhotoViewController ()

@property AVCaptureVideoPreviewLayer *previewLayer;
@property AVCaptureSession *captureSession;
@property AVCaptureDevice *backCamera;
@property AVCaptureDevice *frontCamera;
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property AVCaptureStillImageOutput *stillImageOutput;
@property (weak, nonatomic) IBOutlet UIImageView *imagePreview;
@property CameraPermissions *camPermissions;

@property SnowFalling *snow;


@end

@implementation TakePhotoViewController

#pragma mark - UI View Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self intialViewDidLoadSetup];
}

-(void) viewWillAppear:(BOOL)animated   {
    [self checkIfArIsActivated];
    [self liveCameraFeed]; //needs to be called everytime the view reappears
    [_captureSession startRunning];
}
-(void)viewWillDisappear:(BOOL)animated {
    [_captureSession stopRunning];
    _captureSession = nil;
}
#pragma mark - Animation Methods
/**
 Creating an animiated red nose! This method flicks between two static images of a raindeer with a red nose and with a brown nose.
 The images are animated using the animationImages property
 */
-(void) animateRedRaindeerNose  {
    
    _presentsPlaceholderImage.image = [UIImage imageNamed:@"presents-red-nose.png"]; // need to randomise it?!
    
    NSArray *images = [NSArray arrayWithObjects:[UIImage imageNamed:@"presents-red-nose.png"],[UIImage imageNamed:@"presents-brown-nose.png"], nil];
    //Then set array to UIImageViews "animationImages"property
    _presentsPlaceholderImage.animationImages = images;
    _presentsPlaceholderImage.animationDuration = 1;
    [_presentsPlaceholderImage startAnimating];
    //To stop animation just do this
    //[_imageView stopAnimating];
}

-(void) generateSnowflakes  {
    _snow = [[SnowFalling alloc] initWithView:self.view];
    // personalize values (optional)
    _snow.numbersOfFlake = 30;
    _snow.directionsOfFlake = SnowFlakeDirectionVertical;
    _snow.imageOfFlake = [UIImage imageNamed:[NSString stringWithFormat:@"snow-flake-1.png"]];
    _snow.hidden = NO;
}

#pragma mark - Helper Methods

-(void) intialViewDidLoadSetup  {
    _isArActivated = false; //Handles the AR Presents/snowing/ raindeeer flashing mechanic.
    _reTakePhotoButton.hidden = true; //hide the retake button intitally
    _shareButton.hidden = true;
    _saveButton.hidden = true;
    
    _snow = [[SnowFalling alloc] init];
    _camPermissions = [CameraPermissions new];
}

-(void) checkIfArIsActivated  {
    if (_isArActivated) {
        NSLog(@"activate the AR world");
        [self setupPresentsAndSnowAnimation];
    } else {
        NSLog(@"DO NOT activate AR");
    }
}

-(void) setupPresentsAndSnowAnimation   {
    [self animateRedRaindeerNose];
    [self generateSnowflakes];
}



#pragma mark - Sharing Functionality
-(void)shareContent{
    NSString * message = @"placeholder text";
    UIImage * image = _imagePreview.image;
    NSArray * shareItems = @[message, image];
    
    UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
    [self presentViewController:avc animated:YES completion:nil];
}

#pragma mark - Camera Methods

-(void) liveCameraFeed  {
    
    _reTakePhotoButton.hidden = true;
    _saveButton.hidden = true;
    //-- Setup Capture Session.
    _captureSession = [[AVCaptureSession alloc] init];
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

//GEt the image with the presents
-(UIImage *) takeScreenshot {
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(self.view.bounds.size);
    }
    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImagePNGRepresentation(image);
    if (imageData) {
        //        UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:imageData], nil, nil, nil);
        return [UIImage imageWithData:imageData];
    } else {
        NSLog(@"error while taking screenshot");
    }
    
    return nil;
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


/**
 Immediately take a hig res image from the camera (NOT a screenshot)
 */
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
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil); //save to album
        
        if (_isArActivated) {
            //            [self setupPresentsAndSnowAnimation];
            _imagePreview.image = image; //preview the image with the new presents
            _imagePreview.image = [self takeScreenshot];
            [_snow stopAnimating];
            
        } else  {
            _imagePreview.image = image; //preview the image WITHOUT presents
            _imagePreview.image = [self takeScreenshot];
        }
    }];
}

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
    [_presentsPlaceholderImage stopAnimating];
    _saveButton.hidden = false;
    _shareButton.hidden = false;
    _imagePreview.hidden = NO;
    _reTakePhotoButton.hidden = NO;
}

- (IBAction)shareButtonPresssed:(UIButton *)sender {
    [self shareContent];
}

- (IBAction)reTakenPhotoButton:(UIButton *)sender {
    [self liveCameraFeed];
    _imagePreview.hidden = true;
    _shareButton.hidden = true;
    _imagePreview.image = [UIImage imageNamed:@""];
    [_presentsPlaceholderImage startAnimating];
    [_snow startAnimating];
    
}

- (IBAction)saveButtonPressed:(UIButton *)sender {
    BOOL checkIfPermissionGranted = [_camPermissions checkPhotoAlbumPermission];
    if (checkIfPermissionGranted == false) {
        NSLog(@"no permissions :(");
        UIAlertController *alert = [_camPermissions setupAlertBoxForCameraAlbumSettings];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    if ([self takeScreenshot] == nil) {
        NSLog(@"No image has been taken from the screenshot method");
    } else {
        UIImageWriteToSavedPhotosAlbum([self takeScreenshot], nil, nil, nil);
    }
    _imagePreview.image = [UIImage imageNamed:@""];
    _imagePreview.hidden = true;
    _shareButton.hidden = true;
    _saveButton.hidden = true;
    [self liveCameraFeed];
    
    if (_isArActivated) {
        [_presentsPlaceholderImage startAnimating];
        [_snow startAnimating];
    }
}

@end

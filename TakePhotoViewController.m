//
//  TakePhotoViewController.m
//  ChristmasAR
//
//  Created by Izzy on 24/11/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import "TakePhotoViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface TakePhotoViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation TakePhotoViewController

#pragma mark - UIViewController Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Button Methods

//Share button
- (IBAction)shareButton:(id)sender {
    [self shareContent];
}

- (IBAction)captureButtonPressed:(UIButton *)sender {
    [self takePhotoUsingCamera:UIImagePickerControllerSourceTypeCamera];
}


#pragma mark - Sharing Functionality
-(void)shareContent{
    NSString * message = @"placeholder text";
    UIImage * image = _imageView.image;
    NSArray * shareItems = @[message, image];
    
    UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
    [self presentViewController:avc animated:YES completion:nil];
}

#pragma mark - Photo Methods
-(void) takePhotoUsingCamera: (UIImagePickerControllerSourceType) source   {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = source;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - Image Picker Controller delegate methods

/**
 These two delegate methods cause
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
@end

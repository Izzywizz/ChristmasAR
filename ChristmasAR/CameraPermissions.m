//
//  CameraPermissions.m
//  ChristmasAR
//
//  Created by Izzy on 29/11/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import "CameraPermissions.h"

@implementation CameraPermissions

#pragma mark - Camera Permission Methods
-(BOOL) checkPhotoAlbumPermission   {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    if (status == PHAuthorizationStatusAuthorized) {
        // Access has been granted.
        NSLog(@"Access Granted");

        return true;
    }
    
    else if (status == PHAuthorizationStatusDenied) {
        // Access has been denied.
        NSLog(@"Denied");
        
        return false;
    }
    
    else if (status == PHAuthorizationStatusNotDetermined) {
        
        // Access has not been determined.
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            
            if (status == PHAuthorizationStatusAuthorized) {
                // Access has been granted.
                NSLog(@"Access Granted");
            }
            
            else {
                // Access has been denied.
                NSLog(@"Denied");
            }
        }];
    }
    
    else if (status == PHAuthorizationStatusRestricted) {
        // Restricted access - normally won't happen.
        return false;
    }
    
    return false;
}

-(BOOL) askForCameraPermission {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    NSLog(@"status: %ld", (long)status);
    if(status == AVAuthorizationStatusAuthorized) { // authorized
        return true;
        
    }
    else if(status == AVAuthorizationStatusDenied){ // denied
        return false;
    }
    else if(status == AVAuthorizationStatusRestricted){ // restricted
        return false;
    }
    else if(status == AVAuthorizationStatusNotDetermined){ // not determined
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){ // Access has been granted ..do something
                
            } else { // Access denied ..do something
                NSLog(@"Denied Camera");
            }
        }];
    }
    
    return nil;
}

#pragma mark - AlertView Methods
-(UIAlertController *) setupAlertBoxForCameraAlbumSettings   {
    NSString *title;
    title = @"Camera Album Permissions needed";
    NSString *message = @"To save photos, the app needs permission to save to your camera roll";
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancel Selected");
    }];
    UIAlertAction *settings = [UIAlertAction actionWithTitle:@"Setting" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // Send the user to the Settings for this app
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:settings];
    
    return alertVC;
}

-(UIAlertController *) setupAlertBoxForCameraSettings   {
    NSString *title;
    title = @"Camera Permissions needed";
    NSString *message = @"To use the app the camera access is needed, you must turn on 'While Using the App' in the Camera Settings for the app";
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Cancel Selected");
    }];
    UIAlertAction *settings = [UIAlertAction actionWithTitle:@"Setting" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // Send the user to the Settings for this app
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:settings];
    
    return alertVC;
}


@end

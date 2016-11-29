//
//  CameraPermissions.m
//  ChristmasAR
//
//  Created by Izzy on 29/11/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import "CameraPermissions.h"

@implementation CameraPermissions

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
    
    return nil;
}


-(UIAlertController *) setupAlertSettingsBoxForCamera   {
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


@end

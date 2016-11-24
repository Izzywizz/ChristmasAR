//
//  TermsViewController.m
//  ChristmasAR
//
//  Created by Izzy on 23/11/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import "EmailViewController.h"
#import "SnowGeneratorView.h"
#import "RRRegistration.h"
#import <AVFoundation/AVFoundation.h>

@interface EmailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;

@end

@implementation EmailViewController

#pragma mark - UIView Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [self setupPlaceholderTextColour];
    [self askForCameraPermission];

}

-(void) viewWillAppear:(BOOL)animated   {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods

-(void) askForCameraPermission {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    NSLog(@"status: %ld", (long)status);
    if(status == AVAuthorizationStatusAuthorized) { // authorized
        
    }
    else if(status == AVAuthorizationStatusDenied){ // denied
        [self setupAlertSettingsBoxForCamera];
    }
    else if(status == AVAuthorizationStatusRestricted){ // restricted
        [self setupAlertSettingsBoxForCamera];
    }
    else if(status == AVAuthorizationStatusNotDetermined){ // not determined
        
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){ // Access has been granted ..do something
                
            } else { // Access denied ..do something
                [self setupAlertSettingsBoxForCamera];
            }
        }];
    }
}

-(void) setupPlaceholderTextColour  {
    NSString *placeholderText = @"Enter Email Address";
    if ([_emailAddressTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor whiteColor];
        _emailAddressTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderText attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
}

-(void) setupAlertSettingsBoxForCamera   {
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
    [self presentViewController:alertVC animated:YES completion:nil];
}

-(void) alertNoEmailView  {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Email Not Correct" message:@"Please enter an email addresss" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismiss = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"Dismiss");
    }];
    [alertVC addAction:dismiss];
    [self presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark - Action Methods
- (IBAction)acceptButtonPressed:(UIButton *)sender {
    RRRegistration *validation = [RRRegistration new];
    
//    if ([validation validateTextField:_emailAddressTextField]) {
        [self performSegueWithIdentifier:@"GoToTakePhoto" sender:self];
//    } else  {
//        NSLog(@"Alert Box");
//        [self alertNoEmailView];
//    }
}
- (IBAction)termsButtonPressed:(UIButton *)sender {
    NSLog(@"Terms Button Pressed");
}



@end

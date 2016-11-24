//
//  TermsViewController.m
//  ChristmasAR
//
//  Created by Izzy on 23/11/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import "TermsViewController.h"
#import "SnowGeneratorView.h"
#import "RRRegistration.h"

@interface TermsViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailAddressTextField;

@end

@implementation TermsViewController

#pragma mark - UIView Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    [self setupPlaceholderTextColour];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Helper Methods

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

-(void) alertSetupandView  {
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
    
    if ([validation validateTextField:_emailAddressTextField]) {
        [self performSegueWithIdentifier:@"GoToPhoto" sender:self];
    } else  {
        NSLog(@"Alert Box");
        [self alertSetupandView];
    }
}
- (IBAction)termsButtonPressed:(UIButton *)sender {
    NSLog(@"Terms Button Pressed");
}

@end

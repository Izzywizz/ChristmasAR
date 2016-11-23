//
//  TermsViewController.m
//  ChristmasAR
//
//  Created by Izzy on 23/11/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import "TermsViewController.h"
#import "SnowGeneratorView.h"

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

#pragma mark - Helper Functions

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

#pragma mark - Action Methods
- (IBAction)acceptButtonPressed:(UIButton *)sender {
    [self performSegueWithIdentifier:@"GoToPhoto" sender:self];
}

@end

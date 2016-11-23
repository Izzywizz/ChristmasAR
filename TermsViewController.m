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

@end

@implementation TermsViewController

#pragma mark - UIView Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    SnowGeneratorView *view = [[SnowGeneratorView alloc] init];
    [view generateSnowflakes:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Methods
- (IBAction)acceptButtonPressed:(UIButton *)sender {
    [self performSegueWithIdentifier:@"GoToPhoto" sender:self];
}

@end

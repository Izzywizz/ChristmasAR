//
//  ViewController.m
//  ChristmasAR
//
//  Created by Izzy on 23/11/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import "ViewController.h"
#import "SnowGeneratorView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *santaSnowmanRaindeerImageView;

@end

@implementation ViewController

#pragma mark - UIView Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self generateSnowflakes];
    [self animateRedRaindeerNose]; 
}

#pragma mark - Animation Methods
/**
 Creating an animiated red nose! This method flicks between two static images of a raindeer with a red nose and with a brown nose.
 The images are animated using the animationImages property
 */
-(void) animateRedRaindeerNose  {
    
    NSArray *images = [NSArray arrayWithObjects:[UIImage imageNamed:@"presents-red-nose.png"],[UIImage imageNamed:@"presents-brown-nose.png"], nil];
    //Then set array to UIImageViews "animationImages"property
    _santaSnowmanRaindeerImageView.animationImages = images;
    _santaSnowmanRaindeerImageView.animationDuration = 1;
    [_santaSnowmanRaindeerImageView startAnimating];
    //To stop animation just do this
    //[_imageView stopAnimating];
}


-(void) generateSnowflakes  {
    SnowGeneratorView *view = [[SnowGeneratorView alloc] init];
    [view generateSnowflakes:self.view];
}

@end

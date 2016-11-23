//
//  ViewController.m
//  ChristmasAR
//
//  Created by Izzy on 23/11/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import "ViewController.h"
#import "SnowFalling.h"


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
    
    NSArray *images = [NSArray arrayWithObjects:[UIImage imageNamed:@"characters.png"],[UIImage imageNamed:@"characters-brown-nose.png"], nil];
    //Then set array to UIImageViews "animationImages"property
    _santaSnowmanRaindeerImageView.animationImages = images;
    _santaSnowmanRaindeerImageView.animationDuration = 1;
    [_santaSnowmanRaindeerImageView startAnimating];
    //To stop animation just do this
    //[_imageView stopAnimating];
}

/**
 Genreate 3 different types of flakes and add them to the view using the custom framework called 'SnowFalling', the snowFalling class
 handles the genration/ animation, speed and rotation movement of the snowflakes and the individual properties/ method can be called
 on from the class. If you wish to add more snowflakes to the view ensure they are named snow-flakes-%d and increase the count on the loop
 */
-(void) generateSnowflakes  {
    for (int i = 1; i < 4; i++) {
        SnowFalling *snow = [[SnowFalling alloc] initWithView:self.view];
        // personalize values (optional)
        snow.numbersOfFlake = 20;
        snow.directionsOfFlake = SnowFlakeDirectionVertical;
        snow.imageOfFlake = [UIImage imageNamed:[NSString stringWithFormat:@"snow-flake-%d.png", i]];
        
        snow.hidden = NO;
    }
}

@end

//
//  SnowGeneratorView.m
//  ChristmasAR
//
//  Created by Izzy on 23/11/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import "SnowGeneratorView.h"
#import "SnowFalling.h"

@implementation SnowGeneratorView

/**
 Genreate 3 different types of flakes and add them to the view using the custom framework called 'SnowFalling', the snowFalling class
 handles the genration/ animation, speed and rotation movement of the snowflakes and the individual properties/ method can be called
 on from the class. If you wish to add more snowflakes to the view ensure they are named snow-flakes-%d and increase the count on the loop
 */
-(UIView *) generateSnowflakes: (UIView *) view  {
    
    for (int i = 1; i < 4; i++) {
        SnowFalling *snow = [[SnowFalling alloc] initWithView:view];
        // personalize values (optional)
        snow.numbersOfFlake = 20;
        snow.directionsOfFlake = SnowFlakeDirectionVertical;
        snow.imageOfFlake = [UIImage imageNamed:[NSString stringWithFormat:@"snow-flake-%d.png", i]];
        
        snow.hidden = NO;
    
    }
    
    return view;
}

@end

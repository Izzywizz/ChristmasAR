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

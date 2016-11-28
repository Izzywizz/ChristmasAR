//
//  TakePhotoViewController.h
//  ChristmasAR
//
//  Created by Izzy on 24/11/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TakePhotoViewController : UIViewController

@property BOOL isArActivated;
@property (weak, nonatomic) IBOutlet UIImageView *presentsPlaceholderImage;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *switchCameraButton;
@property (weak, nonatomic) IBOutlet UIButton *reTakePhotoButton;

@end

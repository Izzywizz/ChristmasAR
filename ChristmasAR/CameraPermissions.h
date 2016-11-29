//
//  CameraPermissions.h
//  ChristmasAR
//
//  Created by Izzy on 29/11/2016.
//  Copyright © 2016 Izzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface CameraPermissions : NSObject

-(BOOL) checkPhotoAlbumPermission;
-(UIAlertController *) setupAlertSettingsBoxForCamera;


@end

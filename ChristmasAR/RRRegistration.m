//
//  RRRegistration.m
//  GoalMachine
//
//  Created by Andy Chamberlain on 24/06/2016.
//  Copyright © 2016 Re Raise Design. All rights reserved.
//

#import "RRRegistration.h"

@implementation RRRegistration

+ (RRRegistration*)sharedInstance
{
    static RRRegistration *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^
                  {
                      _sharedInstance = [[RRRegistration alloc]init];
                  });
    
    return _sharedInstance;
}

-(BOOL)validateTextField:(UITextField *)textField
{
    NSString *text = textField.text;
    
    if ([text isEqualToString:@""])
    {
        return NO;
    }
    
    switch (textField.tag)
    {
        case FIRST_NAME:
            _firstName = text;
            return [self validateTextFieldText:textField];
            break;
            
        case LAST_NAME:
            _lastName = text;
            return [self validateTextFieldText:textField];
            break;
        case EMAIL:
            _email = text;
            return [self validateEmail:text];
            break;
            
        case PASSWORD:
            _password = text;
            return [self validatePassword];
            break;
            
        case CONFRIM_PASSWORD:
            _confirmPassword = text;
            return [self validatePassword];
            break;
            
        case PHOTO:
            return [self validatePhotoImageRef:_cgref andImageData:_cim];
            break;
        default:
            break;
    }
    
    return NO;
}

-(BOOL)validateTextFieldText:(UITextField*)textField
{
    if ([textField.text length] > 0)
    {
        return YES;
    }
    
    return NO;
}

-(BOOL) validatePhotoImageRef: (CGImageRef)cgref andImageData:(CIImage *) cim   {
    
    if (cim == nil && cgref == NULL)
    {
        NSLog(@"no underlying photo data");
        return NO;
    } else  {
        return YES;
    }
    
}


-(BOOL)validateEmail:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

-(BOOL)validatePassword
{
    if ([_password isEqualToString:_confirmPassword])
    {
        return YES;
    }
    return NO;
}


@end

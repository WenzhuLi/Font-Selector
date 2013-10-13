//
//  UIView+screenshot.m
//  top100
//
//  Created by Dai Cloud on 12-7-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIView+screenshot.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (screenshot)
static inline double radians (double degrees) {return degrees * M_PI/180;}
- (UIImage *)screenshot 
{	
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    UIGraphicsBeginImageContext(screenshot.size);
    
//    CGContextRef context = UIGraphicsGetCurrentContext();
    UIImageOrientation orientation;
    if ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeLeft) {
        orientation = UIImageOrientationLeft;
    }
    else orientation = UIImageOrientationRight;
    UIImage * PortraitImage = [[UIImage alloc] initWithCGImage: screenshot.CGImage
                                                         scale: 1.0
                                                   orientation: orientation];
    return PortraitImage;
}

- (UIImage *)screenshotWithOffset:(CGFloat)deltaY
{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext(); 
    //  KEY: need to translate the context down to the current visible portion of the tablview
    CGContextTranslateCTM(ctx, 0, deltaY);
    [self.layer renderInContext:ctx];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenshot;
}

@end

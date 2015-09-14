//
//  UIImage+ColorTransformToImage.m
//  SimuStock
//
//  Created by jhss on 14-7-15.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "UIImage+ColorTransformToImage.h"

@implementation UIImage (ColorTransformToImage)
+ (UIImage *)imageFromView:(UIView *)view
       withBackgroundColor:(UIColor *)backgroundColor {
  //只取大小
  UIView *newView = [[UIView alloc] initWithFrame:view.frame];
  newView.backgroundColor = backgroundColor;
  UIGraphicsBeginImageContextWithOptions(
      CGSizeMake(newView.bounds.size.width, newView.bounds.size.height), YES,
      newView.layer.contentsScale);
  [newView.layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}
+ (UIImage *)imageFromView:(UIView *)view {
  UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES,
                                         view.layer.contentsScale);
  [view.layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}
+ (UIImage *)imageFromView:(UIView *)view withIndex:(NSInteger)buttonIndex {
  CGRect frame = view.frame;
  UIGraphicsBeginImageContext(frame.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
  CGContextScaleCTM(context, frame.size.width, frame.size.height);
  CGFloat colors[] = {
      166.0 / 255.0, 26.0 / 255.0, 29.0 / 255.0, 1.0,
      212.0 / 255.0, 65.0 / 255.0, 66.0 / 255.0, 1.0,
  };
  CGGradientRef backGradient = CGGradientCreateWithColorComponents(
      rgb, colors, NULL, sizeof(colors) / (sizeof(colors[0]) * 4));
  CGColorSpaceRelease(rgb);
  CGContextDrawLinearGradient(context, backGradient, CGPointMake(0.5, 0),
                              CGPointMake(0.5, 1),
                              kCGGradientDrawsBeforeStartLocation);
  UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  CGGradientRelease(backGradient);
  return image;
}
@end

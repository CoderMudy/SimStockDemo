//
//  UIImage+colorful.m
//  SimuStock
//
//  Created by Mac on 15/4/14.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "UIImage+colorful.h"

@implementation UIImage (colorful)

+ (UIImage *)imageWithColor:(UIColor *)color
{
  CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGContextSetFillColorWithColor(context, [color CGColor]);
  CGContextFillRect(context, rect);
  
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return image;
}

@end

//
//  Globle.m
//  SlideSwitchDemo
//
//  Created by liulian on 13-4-23.
//  Copyright (c) 2013年 liulian. All rights reserved.
//

#import "Globle.h"

@implementation Globle

+ (UIColor *)colorFromHexRGB:(NSString *)inColorString {
  NSString *cString = [[inColorString
      stringByTrimmingCharactersInSet:
          [NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

  // String should be 6 or 8 characters
  if ([cString length] < 6)
    return DEFAULT_VOID_COLOR;

  // strip 0X if it appears
  if ([cString hasPrefix:@"0X"])
    cString = [cString substringFromIndex:2];
  if ([cString hasPrefix:@"#"])
    cString = [cString substringFromIndex:1];
  if ([cString length] != 6)
    return DEFAULT_VOID_COLOR;

  UIColor *result = nil;
  unsigned int colorCode = 0;
  unsigned char redByte, greenByte, blueByte;

  if (nil != cString) {
    NSScanner *scanner = [NSScanner scannerWithString:cString];
    (void)[scanner scanHexInt:&colorCode]; // ignore error
  }
  redByte = (unsigned char)(colorCode >> 16);
  greenByte = (unsigned char)(colorCode >> 8);
  blueByte = (unsigned char)(colorCode); // masks off high bits
  result = [UIColor colorWithRed:(float)redByte / 0xff
                           green:(float)greenByte / 0xff
                            blue:(float)blueByte / 0xff
                           alpha:1.0];
  return result;
}

+ (UIColor *)colorFromHexRGB:(NSString *)inColorString alpha:(CGFloat)alpha {
  NSString *cString = [[inColorString
      stringByTrimmingCharactersInSet:
          [NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

  // String should be 6 or 8 characters
  if ([cString length] < 6)
    return DEFAULT_VOID_COLOR;

  // strip 0X if it appears
  if ([cString hasPrefix:@"0X"])
    cString = [cString substringFromIndex:2];
  if ([cString hasPrefix:@"#"])
    cString = [cString substringFromIndex:1];
  if ([cString length] != 6)
    return DEFAULT_VOID_COLOR;

  UIColor *result = nil;
  unsigned int colorCode = 0;
  unsigned char redByte, greenByte, blueByte;

  if (nil != cString) {
    NSScanner *scanner = [NSScanner scannerWithString:cString];
    (void)[scanner scanHexInt:&colorCode]; // ignore error
  }
  redByte = (unsigned char)(colorCode >> 16);
  greenByte = (unsigned char)(colorCode >> 8);
  blueByte = (unsigned char)(colorCode); // masks off high bits
  result = [UIColor colorWithRed:(float)redByte / 0xff
                           green:(float)greenByte / 0xff
                            blue:(float)blueByte / 0xff
                           alpha:alpha];
  return result;
}

+ (UIColor *)colorWithRGB:(NSInteger)red
                 ForGreen:(NSInteger)green
                  ForBlue:(NSInteger)blue {
  return [UIColor colorWithRed:((float)red / 255.0f)
                         green:((float)green / 255.0f)
                          blue:((float)blue / 255.0f)
                         alpha:1.0f];
}

@end

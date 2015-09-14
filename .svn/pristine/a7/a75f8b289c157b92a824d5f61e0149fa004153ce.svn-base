//
//  ShareImageProvider.m
//  SimuStock
//
//  Created by Mac on 15/3/12.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ShareImageProvider.h"
#import "AppDelegate.h"
#import "WBImageView.h"

@implementation ShareImageProvider

//绘制大图（发布页面使用图，分享后的效果图仍然是image）
+ (UIImage *)bigImageFromImage:(UIImage *)image {
  UIImage *bigImage =
      [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height - 1,
                                                          0, 1, 0)
                            resizingMode:UIImageResizingModeTile];
  CGRect frame =
      [(AppDelegate *)[[UIApplication sharedApplication] delegate] window]
          .frame;
  //上方绘制空白
  WBImageView *downBigImageView = [[WBImageView alloc]
      initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width,
                               frame.size.height * 0.8f + image.size.height)];
  downBigImageView.image = bigImage;
  UIGraphicsBeginImageContext(downBigImageView.frame.size);
  [downBigImageView.image drawInRect:downBigImageView.frame];
  bigImage = UIGraphicsGetImageFromCurrentImageContext();

  //下方绘制空白
  UIImage *bigImage1 = [bigImage
      resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0,
                                                   bigImage.size.height - 1, 0)
                     resizingMode:UIImageResizingModeTile];
  WBImageView *upBigImageView = [[WBImageView alloc]
      initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width,
                               downBigImageView.frame.size.height +
                                   frame.size.height * 0.1f)];
  upBigImageView.image = bigImage1;
  UIGraphicsBeginImageContext(upBigImageView.frame.size);
  [upBigImageView.image drawInRect:upBigImageView.frame];
  bigImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return bigImage;
}
@end

//
//  MJPhoto.m
//
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.

#import "MJPhoto.h"

@implementation MJPhoto

#pragma mark 截图
- (UIImage *)capture:(UIImageView *)view {
  CGSize size = view.bounds.size;
  UIGraphicsBeginImageContextWithOptions(CGSizeMake(size.width, size.height), YES, 0.0);
  [view.layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return img;
}

- (void)setSrcImageView:(UIImageView *)srcImageView {
  _srcImageView = srcImageView;
  _placeholder = srcImageView.image;
  if (srcImageView.clipsToBounds) {
    _capture = [self capture:srcImageView];
  }
}

@end
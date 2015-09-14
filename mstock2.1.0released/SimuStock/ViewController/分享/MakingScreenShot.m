//
//  MakingScreenShot.m
//  SimuStock
//
//  Created by jhss on 14-6-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "MakingScreenShot.h"

@implementation MakingScreenShot
- (UIImage *)makingScreenShotWithFrame:(CGRect)frame
                              withView:(UIView *)view
                              withType:(NSInteger)shareType {
  UIGraphicsBeginImageContext(view.bounds.size); // currentView 当前的view
  // 创建一个基于位图的图形上下文并指定大小为
  [view.layer
      renderInContext:
          UIGraphicsGetCurrentContext()]; // renderInContext呈现接受者及其子范围到指定的上下文
  CGRect myImageRect;
  CGRect windowFrame = [[UIScreen mainScreen] bounds];
  switch (shareType) {
  case MakingScreenShotType_HomePage:
    myImageRect = CGRectMake(0, 0, frame.size.width, frame.size.height);
    break;
  case MakingScreenShotType_TrendPage_All:
    //截取整个屏幕
    myImageRect = CGRectMake(0, frame.origin.y, windowFrame.size.width,
                             windowFrame.size.height);
    break;
  case MakingScreenShotType_TrendPage_Half:
    myImageRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width,
                             frame.size.height);
    break;
  case MakingScreenShotType_TradePage:
    myImageRect = CGRectMake(0, 0, frame.size.width, frame.size.height);
    break;
  default:
    return nil;
  }
  CGSize changedSize = myImageRect.size;
  UIGraphicsBeginImageContextWithOptions(changedSize, NO, 0.0);
  [view.layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  [self writeImage:image toFileAtPath:@"screenshot.jpg"];
  //  UIGraphicsEndImageContext();
  //  //移除栈顶的基于当前位图的图形上下文会在本地生成图片记录，测试可以，正式环境要关掉
  //   UIImageWriteToSavedPhotosAlbum(image, self,
  //   @selector(image:didFinishSavingWithError:contextInfo:), nil);
  //   UIImageWriteToSavedPhotosAlbum(image, nil, nil,
  //   nil);//然后将该图片保存到图片图
  return image;
}

//图片存成本地文件
- (BOOL)writeImage:(UIImage *)image toFileAtPath:(NSString *)aPath {
  if ((image == nil) || (aPath == nil) || ([aPath isEqualToString:@""]))
    return NO;
  @try {
    NSData *imageData = nil;
    // get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];

    // make a file name to write the data to using the documents directory:
    NSString *filePath =
        [NSString stringWithFormat:@"%@/%@", documentsDirectory, aPath];

    NSString *ext = [aPath pathExtension];
    if ([ext isEqualToString:@"jpg"] || [ext isEqualToString:@"jpeg"]) {
      // the rest, we write to jpeg
      // 0. best, 1. lost. about compress.不压缩
      imageData = UIImageJPEGRepresentation(image, 0.0);
    } else {
      imageData = UIImagePNGRepresentation(image);
    }
    if ((imageData == nil) || ([imageData length] <= 0))
      return NO;
    [imageData writeToFile:filePath atomically:YES];
    return YES;
  } @catch (NSException *e) {
    NSLog(@"create thumbnail exception.");
  }
  return NO;
}
//是否保存成功
- (UIImage *)image:(UIImage *)image
    didFinishSavingWithError:(NSError *)error
                 contextInfo:(void *)contextInfo

{
  if (error != NULL) {
    return nil;
  } else {
    return image;
  }
}
@end

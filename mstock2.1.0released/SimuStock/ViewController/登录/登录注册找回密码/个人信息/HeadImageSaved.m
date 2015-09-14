//
//  HeadImageSaved.m
//  SimuStock
//
//  Created by jhss on 14-10-14.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "HeadImageSaved.h"

@implementation HeadImageSaved
+ (HeadImageSaved *)shareManager {
  static HeadImageSaved *sharedHeadImageSavedInstance = nil;
  static dispatch_once_t predicate;
  dispatch_once(&predicate,
                ^{ sharedHeadImageSavedInstance = [[self alloc] init]; });
  return sharedHeadImageSavedInstance;
}
- (BOOL)setPhotoToPath:(UIImage *)image isName:(NSString *)name {
  [self performSelector:@selector(refreshHeadImage)
             withObject:nil
             afterDelay:0.5];
  //此处首先指定了图片存取路径（默认写到应用程序沙盒 中）
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                       NSUserDomainMask, YES);
  //并给文件起个文件名
  NSString *uniquePath =
      [paths[0] stringByAppendingPathComponent:name];
  BOOL blHave = [[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
  if (blHave) {
    [self deleteFromName:name];
  }
  NSData *data = UIImagePNGRepresentation(image);
  BOOL result = [data writeToFile:uniquePath atomically:YES];
  if (result) {
    return YES;
  } else {
    return NO;
  }
}
- (void)refreshHeadImage {
}
- (BOOL)deleteFromName:(NSString *)name {
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                       NSUserDomainMask, YES);
  //文件名
  NSString *uniquePath =
      [paths[0] stringByAppendingPathComponent:name];
  BOOL blHave = [[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
  if (!blHave) {
    return NO;
  } else {
    BOOL blDele = [fileManager removeItemAtPath:uniquePath error:nil];
    if (blDele) {
      return YES;
    } else {
      return NO;
    }
  }
}
@end

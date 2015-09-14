//
//  JhssImageCache.m
//  SimuStock
//
//  Created by Mac on 14-10-24.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "JhssImageCache.h"
#import "NSString+MD5Addition.h"
#import "FTWCache.h"

@implementation JhssImageCache

+ (void)setImageView:(UIImageView *)imageView
                 withUrl:(NSString *)imageURL
    withDefaultImageName:(NSString *)defaultImageName {
  
  NSString *key = [imageURL stringFromMD5];
  NSData *data = [FTWCache objectForKey:key];
  if (data) {
    UIImage *image = [UIImage imageWithData:data];
    imageView.image = image;
  } else {
    imageView.image = [UIImage imageNamed:defaultImageName];
    if ([imageURL length] < 1) {
      return;
    }
    dispatch_queue_t queue =
        dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSData *data =
            [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
        if (data) {
          [FTWCache setObject:data forKey:key];
        }else{
          NSLog(@"头像链接失效....");
          //重新加载
          [FTWCache removeKeyOfObjcet:key];
        }
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(),
                       ^{ imageView.image = image; });
    });
  }
}

@end

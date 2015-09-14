//
//  ImageUtil.m
//  SimuStock
//
//  Created by Mac on 15/3/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ImageUtil.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"

@implementation ImageUtil

/** 返回图片高度，如果图片高度未知，则返回默认高度114px */
+ (NSNumber*)imageHeightFromUrl:(id)imageUrl withWeibo:(TweetListItem*)item {
  if (!imageUrl) {
    return @0;
  }

  if ([imageUrl isKindOfClass:[UIImage class]]) {
    UIImage* image = (UIImage*)imageUrl;
    int imageHeight = image ? image.size.height / ThumbnailFactor : 114;
    if (image) {
      item.heightCache[imageUrl] = @(imageHeight);
    }
    return @(imageHeight);
  }

  if (item.heightCache[imageUrl]) {
    return item.heightCache[imageUrl];
  }

  UIImage* image = [[SDImageCache sharedImageCache]
      imageFromMemoryOrDiskCacheForKey:imageUrl];

  int imageHeight = image ? image.size.height / ThumbnailFactor : 114;
  if (image) {
    item.heightCache[imageUrl] = @(imageHeight);
  }
  return @(imageHeight);
}

+ (UIImage*)loadImageFromUrl:(NSString*)imageUrl
         withOnReadyCallback:(OnDownloadImageFinished)onImageReadyCallback {
  //读内存
  UIImage* cachedImage =
      [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:imageUrl];
  if (!cachedImage) {
    //读磁盘
    cachedImage =
        [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageUrl];
  }

  if (cachedImage) {
    return cachedImage;
  } else {
    //下载
    SDWebImageManager* manager = [SDWebImageManager sharedManager];
    [manager downloadWithURL:[NSURL URLWithString:imageUrl]
        options:SDWebImageRetryFailed

        progress:^(NSUInteger receivedSize, int64_t expectedSize) {
          //加载过程处理
          NSLog(@"%ld %lld", (long)receivedSize, expectedSize);
        }

        completed:^(UIImage* downloadImage, NSError* error,
                    SDImageCacheType cacheType, BOOL finished) {
          if (finished && downloadImage) {
            [[SDImageCache sharedImageCache] storeImage:downloadImage
                                                 forKey:imageUrl
                                                 toDisk:YES];
            onImageReadyCallback(downloadImage, imageUrl);
          }
        }];
    return nil;
  }
}

+ (UIImage*)imageWithImage:(UIImage*)image scaleFactor:(CGFloat)factor {
  CGSize newSize =
      CGSizeMake(image.size.width * factor, image.size.height * factor);
  return [ImageUtil imageWithImage:image scaledToSize:newSize];
}

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
  // Create a graphics image context
  UIGraphicsBeginImageContext(newSize);

  // Tell the old image to draw in this new context, with the desired
  // new size
  [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];

  // Get the new image from the context
  UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();

  // End the context
  UIGraphicsEndImageContext();

  // Return the new image.
  return newImage;
}

+ (UIImage*)imageForUploadFromImage:(UIImage*)image {
  //最大支持的像素数为1200*900，大约此值则按此值以适当的比例缩小
  CGFloat maxPhotoArea = 1200.0f * 900.0f;
  CGFloat area = image.size.width * image.size.height;
  CGFloat scaleFactor = area > maxPhotoArea ? sqrtf(area / maxPhotoArea) : 1;
  return [ImageUtil imageWithImage:image
                      scaledToSize:CGSizeMake(image.size.width / scaleFactor,
                                              image.size.height / scaleFactor)];
}

@end

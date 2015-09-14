//
//  ImageUtil.h
//  SimuStock
//
//  Created by Mac on 15/3/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TweetListItem.h"

typedef void (^OnDownloadImageFinished)(UIImage* downloadImage,
                                        NSString* imageUrl);

static const CGFloat ThumbnailFactor = 3.0f;

@interface ImageUtil : NSObject

/**
 * 返回图片高度，如果图片高度未知，则返回默认高度114px
 * 此方法用于个人主页，好友圈，收藏等含有聊股列表的页面
 */
+ (NSNumber*)imageHeightFromUrl:(id)imageUrl withWeibo:(TweetListItem*)item;

/** 加载网络图片，
 * 如果在内存中，直接返回；
 * 如果在磁盘中，加载后返回；
 * 否则，从网络加载，返回nil
 */
+ (UIImage*)loadImageFromUrl:(NSString*)imageUrl
         withOnReadyCallback:(OnDownloadImageFinished)onImageReadyCallback;

/** 放大或缩小图片 */
+ (UIImage*)imageWithImage:(UIImage*)image scaleFactor:(CGFloat)factor;

/** 放大或缩小图片 */
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

/** 将图片转换为可以上传的图片（因为服务端对图片大小有要求，不能大约1M）*/
+ (UIImage*)imageForUploadFromImage:(UIImage*)image;

@end

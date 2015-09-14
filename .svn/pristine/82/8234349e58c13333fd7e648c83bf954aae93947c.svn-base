//
//  WBImageView.h
//  SimuStock
//
//  Created by jhss on 14-12-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManager.h"
#import "ImageUtil.h"

/** 可点击放大网络图片 */
@interface WBImageView : UIImageView <SDWebImageManagerDelegate>

/** 记录地址， */
@property(copy, nonatomic) NSString *imageUrl;

- (UIImage *)loadImageWithUrl:(NSString *)imageUrl
         onImageReadyCallback:(OnDownloadImageFinished)onImageReadyCallback;



@end

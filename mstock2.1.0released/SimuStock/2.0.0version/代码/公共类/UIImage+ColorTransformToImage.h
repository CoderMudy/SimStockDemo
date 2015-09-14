//
//  UIImage+ColorTransformToImage.h
//  SimuStock
//
//  Created by jhss on 14-7-15.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#define logout_button_index 1

@interface UIImage (ColorTransformToImage)
//截取纯色图片
+ (UIImage *)imageFromView:(UIView *)view
       withBackgroundColor:(UIColor *)backgroundColor;
//截取自定义图片
+ (UIImage *)imageFromView:(UIView *)view;
//渐变效果截图
+ (UIImage *)imageFromView:(UIView *)view withIndex:(NSInteger)buttonIndex;
@end

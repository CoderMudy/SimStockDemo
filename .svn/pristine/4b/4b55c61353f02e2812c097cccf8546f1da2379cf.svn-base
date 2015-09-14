//
//  NetLoadingWaitRevocableView.h
//  SimuStock
//
//  Created by jhss_wyz on 15/8/26.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimuBlockDefine.h"

@interface NetLoadingWaitRevocableView : UIView {
  //黑色旋转图片的半透明黑色背景
  UIImageView *nmv_backgroundImageView;
  //前方旋转图片
  UIImageView *nmv_frontImageView;

  UIActivityIndicatorView *indicator;
  //动画是否正在进行
  BOOL nmv_isAnimationRun;
  //定时期
  NSTimer *nmv_timer;
  //定时期频率时长
  CGFloat nmv_duration;
  /** 取消网络访问 */
  BOOL canceled;
}

- (void)startAnimating;
- (void)stopAnimating;
- (BOOL)isAnimating;
- (BOOL)isCanceled;

+ (id)sharedInstance;
+ (void)startAnimating;
+ (void)stopAnimating;

@end

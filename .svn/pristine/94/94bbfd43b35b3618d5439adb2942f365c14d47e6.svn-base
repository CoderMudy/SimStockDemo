// 1
//  EntranceFunctionsClass.h
//  SimuStock
//
//  Created by jhss on 14-3-21.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "DDPageControl.h"
#import "DataArray.h"

@interface EntranceFunctionsClass
    : NSObject <UIScrollViewDelegate, UIGestureRecognizerDelegate> {
  NSInteger time;
  NSTimer *timer;
  /**首次启动滚动视图*/
  UIImageView *circleImageView;
  /**引导页默认图上半部分*/
  UIImageView *headerImageView;
  /**引导页默认图下半部分*/
  UIImageView *footerImageView;
  /**logo图片*/
  UIImageView *logoImageView;
  /**背景图片*/
  UIImageView *backgroundImageView;

  /**绘制界面*/
  UIImageView *clearCircleImageView;
  CAGradientLayer *gradient;
  UIImageView *logonImageView;
  /**模拟炒股文字*/
  UIImageView *stockFontImageView;
  /**文字展示*/
  UILabel *showLabel;
  /**首次启动滚动视图*/
  UIScrollView *loadingScr;
  UIButton *endButton;
  /**保存根视图指针*/
  UIView *rootView;
  /**分页指示器*/
  DDPageControl *_entrancePageControl;

  /** 最新版本 */
  NSString *_newestVersion;
  /** 网络下载广告图片数据 */
  DataArray *dataArray;
  /** 广告图片 */
  UIImageView *adImage;
}

///展示
- (void)showStartPage;
- (id)initWithRoot:(UIView *)showView;

@end

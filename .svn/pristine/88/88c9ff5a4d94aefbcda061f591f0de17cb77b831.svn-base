//
//  NetLoadingWaitRevocableView.m
//  SimuStock
//
//  Created by jhss_wyz on 15/8/26.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "NetLoadingWaitRevocableView.h"

static NetLoadingWaitRevocableView *instance = nil;

@implementation NetLoadingWaitRevocableView

+ (id)sharedInstance {
  @synchronized(self) {
    if (instance == nil) {
      instance = [[self alloc] init];
    }
  }
  return instance;
}

+ (void)startAnimating {
  if ([[NetLoadingWaitRevocableView sharedInstance] isAnimating]) {
    //取消上次的延迟任务
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
  } else {
    [[NetLoadingWaitRevocableView sharedInstance] startAnimating];
  }

  //防止菊花不停止
  [[NetLoadingWaitRevocableView sharedInstance] performSelector:@selector(stopAnimating)
                                                     withObject:nil
                                                     afterDelay:60.0];
}
+ (void)stopAnimating {
  if ([[NetLoadingWaitRevocableView sharedInstance] isAnimating]) {
    //取消上次的延迟任务
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [[NetLoadingWaitRevocableView sharedInstance] stopAnimating];
  }
}
- (id)init {
  if (self = [super init]) {
    nmv_isAnimationRun = YES;
    [self creatviews];
    self.hidden = YES;
    canceled = NO;
  }
  return self;
}

//创建视图
- (void)creatviews {
  //创建透明背景
  CGRect fullrect = [UIScreen mainScreen].bounds;
  self.frame = WINDOW.bounds;
  self.backgroundColor = [UIColor clearColor];
  [WINDOW addSubview:self];

  CGPoint centerPoint = CGPointMake(CGRectGetMidX(fullrect), CGRectGetMidY(fullrect));
  //创建旋转图片背景
  UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 69, 69)];
  backgroundView.backgroundColor = [UIColor blackColor];
  backgroundView.center = centerPoint;
  backgroundView.alpha = 0.7;
  CALayer *layer = backgroundView.layer;
  [layer setMasksToBounds:YES];
  [layer setCornerRadius:10.0];
  [self addSubview:backgroundView];

  //活动指示器
  indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(15, 15, 40, 40)];
  indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
  indicator.center = centerPoint;
  [self addSubview:indicator];
  [indicator startAnimating];
}

#pragma mark
#pragma mark 对外接口
//开始显示联网等待动画
- (void)startAnimating {
  [WINDOW bringSubviewToFront:self];
  canceled = NO;
  nmv_isAnimationRun = YES;
  self.hidden = NO;
  [indicator startAnimating];
}
//隐藏联网等待动画
- (void)stopAnimating {
  [indicator stopAnimating];
  nmv_isAnimationRun = NO;
  self.hidden = YES;
}
//联网等待动画是否正在展示
- (BOOL)isAnimating {
  return nmv_isAnimationRun;
}
#pragma mark
#pragma mark 功能函数
- (void)repeatAnimation:(NSTimer *)timer {
  if (nmv_timer == timer) {
    nmv_frontImageView.transform =
        CGAffineTransformRotate(nmv_frontImageView.transform, (CGFloat)(M_PI / 20.0f));
  }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  canceled = YES;
  [self stopAnimating];
}

- (BOOL)isCanceled {
  return canceled;
}

@end

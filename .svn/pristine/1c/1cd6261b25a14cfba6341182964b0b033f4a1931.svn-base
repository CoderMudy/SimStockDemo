//
//  CutomerServiceButton.m
//  SimuStock
//
//  Created by 刘小龙 on 15/5/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "CutomerServiceButton.h"
#import "Globle.h"
#import "SimuIndicatorView.h"
#import "SimTopBannerView.h"
static CutomerServiceButton *_cutomrServiceButton = nil;
@implementation CutomerServiceButton

//单利
+ (CutomerServiceButton *)shareDataCenter {
  static dispatch_once_t onceToKen;
  dispatch_once(&onceToKen, ^{
    _cutomrServiceButton = [[super allocWithZone:NULL] init];
  });
  return _cutomrServiceButton;
}
+ (id)allocWithZone:(struct _NSZone *)zone {
  return [CutomerServiceButton shareDataCenter];
}
- (id)copyWithZone:(struct _NSZone *)zone {
  return [CutomerServiceButton shareDataCenter];
}

// init 初始化
- (id)initEstablisthCustomerServiceTelephonetopToolBar:
          (SimTopBannerView *)topToolBar indicatorView:
                                             (SimuIndicatorView *)inicatorView
                                                  hide:(BOOL)hide {
  self = [super init];
  if (self) {
    CGFloat width = hide == YES ? CGRectGetWidth(topToolBar.frame) - 10
                         : CGRectGetMinX(inicatorView.frame);
    self.frame =
        CGRectMake(width - 70, CGRectGetMinY(inicatorView.frame), 70, 44);
    self.titleLabel.font = [UIFont boldSystemFontOfSize:Font_Height_16_0];
    [self setTitle:@"客服热线" forState:UIControlStateNormal];
    self.titleLabel.numberOfLines = 0;
    [self setTitleColor:[Globle colorFromHexRGB:@"4dfdff"]
               forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:@"return_touch_down.png"]
                    forState:UIControlStateHighlighted];
    [self addTarget:self
                  action:@selector(dialSevicesTelephoneNumber)
        forControlEvents:UIControlEventTouchUpInside];
  }
  return self;
}

- (void)dialSevicesTelephoneNumber {
  //操作表
  NSString *number = @"01053599702";
  NSURL *backURL = [NSURL
      URLWithString:[NSString stringWithFormat:@"telprompt://%@", number]];
  [[UIApplication sharedApplication] openURL:backURL];
}

- (void)
establisthCustomerServiceTelephonetopToolBar:(SimTopBannerView *)topToolBar
                               indicatorView:(SimuIndicatorView *)inicatorView
                                        hide:(BOOL)hide {
  CGFloat width = hide == YES ? CGRectGetWidth(topToolBar.frame) - 10
                       : CGRectGetMinX(inicatorView.frame);
  _cutomrServiceButton.frame =
      CGRectMake(width - 70, CGRectGetMinY(inicatorView.frame), 70, 44);
  _cutomrServiceButton.titleLabel.font =
      [UIFont boldSystemFontOfSize:Font_Height_16_0];
  [_cutomrServiceButton setTitle:@"客服热线" forState:UIControlStateNormal];
  _cutomrServiceButton.titleLabel.numberOfLines = 0;
  [_cutomrServiceButton setTitleColor:[Globle colorFromHexRGB:@"4dfdff"]
                             forState:UIControlStateNormal];
  [_cutomrServiceButton
      setBackgroundImage:[UIImage imageNamed:@"return_touch_down.png"]
                forState:UIControlStateHighlighted];
  [_cutomrServiceButton addTarget:self
                           action:@selector(dialSevicesTelephoneNumber)
                 forControlEvents:UIControlEventTouchUpInside];
  [topToolBar addSubview:_cutomrServiceButton];
}


@end

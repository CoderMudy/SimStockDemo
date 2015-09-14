//
//  AboutUsViewController.m
//  Settings
//
//  Created by jhss on 13-9-9.
//  Copyright (c) 2013年 jhss. All rights reserved.
//

#import "AboutUsViewController.h"
#import "AboutWeIntroductionView.h"

@interface AboutUsViewController () <UIScrollViewDelegate> {
  AboutWeIntroductionView *_aboutWeIntroduction;
  UIScrollView *_scrollView;
}

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  //创建滚动视图
  _scrollView = [[UIScrollView alloc] initWithFrame:_clientView.bounds];
  _scrollView.showsHorizontalScrollIndicator = NO;
  _scrollView.showsVerticalScrollIndicator = YES;
  _scrollView.scrollEnabled = NO;
  _scrollView.delegate = self;
  _scrollView.bounces = YES;
  [_clientView addSubview:_scrollView];

  //回拉效果
  CGRect frame = self.view.bounds;
  if (frame.size.height > 500) {
    matchHight = 40;
  } else {
    matchHight = 0;
  }
  self.view.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  _indicatorView.hidden = YES;
  [_topToolBar resetContentAndFlage:@"关于我们" Mode:TTBM_Mode_Leveltwo];

  _aboutWeIntroduction = [AboutWeIntroductionView showAboutWeIntroductionView];
  _aboutWeIntroduction.frame = CGRectMake(0, matchHight, CGRectGetWidth(_aboutWeIntroduction.bounds),
                                          CGRectGetHeight(_aboutWeIntroduction.bounds));

  [_scrollView addSubview:_aboutWeIntroduction];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  _scrollView.contentSize =
      CGSizeMake(CGRectGetWidth(_clientView.bounds), CGRectGetHeight(_aboutWeIntroduction.bounds));
}

@end

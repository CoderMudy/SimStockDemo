//
//  MatchCreatingNewViewController.m
//  SimuStock
//
//  Created by Yuemeng on 15/7/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MatchCreatingViewController.h"
#import "MatchCreatingSubView.h"

#import "AwardsMatchViewController.h"

@interface MatchCreatingViewController () {
  MatchCreatingSubView *_matchVC;
}

@end

@implementation MatchCreatingViewController

- (instancetype)init {
  if (self = [super init]) {
    //
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  _storeUtil = [[StoreUtil alloc] initWithUIViewController:self];
  
  _indicatorView.frame =
  CGRectMake(_topToolBar.bounds.size.width - 95,
             _topToolBar.bounds.size.height - 45, 45, 45);

  [self resetTitle:@"创建比赛"];
  //提交按钮
  UIButton *sumitButton = [UIButton buttonWithType:UIButtonTypeCustom];
  sumitButton.frame = CGRectMake(self.view.frame.size.width - 60,
                                 _topToolBar.bounds.size.height - 45, 60, 45);
  sumitButton.backgroundColor = [UIColor clearColor];
  [sumitButton setTitleColor:[Globle colorFromHexRGB:@"4dfdff"]
                    forState:UIControlStateNormal];
  UIImage *rightImage = [[UIImage imageNamed:@"return_touch_down"]
      resizableImageWithCapInsets:UIEdgeInsetsMake(14, 14, 14, 14)];
  [sumitButton.titleLabel setFont:[UIFont systemFontOfSize:Font_Height_16_0]];
  [sumitButton setBackgroundImage:rightImage
                         forState:UIControlStateHighlighted];
  [sumitButton setTitle:@"提交" forState:UIControlStateNormal];
  [_topToolBar addSubview:sumitButton];

  //防止重复点击
  ButtonPressed buttonPressed = ^{
    [_matchVC validateMatch];
  };
  [sumitButton setOnButtonPressedHandler:buttonPressed];
  
  _matchVC = [[MatchCreatingSubView alloc] initWithSuperVC:self];
  _matchVC.view.frame = self.clientView.bounds;
  [self.clientView addSubview:_matchVC.view];
  [self addChildViewController:_matchVC];
}

#pragma mark-------CompetitionCycleViewDelegate-------
- (void)rechargeDataRequest {
  [_matchVC rechargeDataRequest];
}

- (void)buyNowProductId:(NSString *)productId {
  [_matchVC buyNowProductId:productId];
}

- (void)leftButtonPress {
  //邀请码重置下
  [[NSUserDefaults standardUserDefaults] setInteger:0
                                             forKey:@"inviteTimeInternal"];
  [[NSUserDefaults standardUserDefaults] synchronize];
  [super leftButtonPress];
  ;
}

@end

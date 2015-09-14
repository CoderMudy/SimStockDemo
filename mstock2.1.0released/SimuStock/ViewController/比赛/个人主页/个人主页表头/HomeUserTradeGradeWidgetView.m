//
//  HomeUserTradeGradeWidgetView.m
//  SimuStock
//
//  Created by Jhss on 15/7/27.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "HomeUserTradeGradeWidgetView.h"
#import "GameWebViewController.h"

@implementation HomeUserTradeGradeWidgetView

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    UIView *containerView =
        [[[UINib nibWithNibName:@"HomeUserTradeGradeWidgetView" bundle:nil]
            instantiateWithOwner:self
                         options:nil] objectAtIndex:0];
    CGRect newFrame =
        CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    containerView.frame = newFrame;
    [self addSubview:containerView];
  }
  return self;
}
- (void)awakeFromNib {
}

#pragma mark 用户交易评级控件生成及数据绑定
- (void)bindUserTradeGradeInfoWithItem:
    (HomePageTableHeaderData *)tableHeaderData {
  self.userId = tableHeaderData.userInfoData.userid;
  if (tableHeaderData.tradeGradeItem.isNil) {
    //没有评级数据则不创建
    return;
  }
  if (!self.userTradeGradeWidget) {
    //创建评级控件
    self.userTradeGradeWidget.userInteractionEnabled = NO;
  }
  if (tableHeaderData.tradeGradeItem != nil) {
    [self.userTradeGradeButton
        setBackgroundImage:[SimuUtil imageFromColor:Color_Gray_but alpha:0.5f]
                  forState:UIControlStateHighlighted];
    [self.userTradeGradeWidget refreshData:tableHeaderData.tradeGradeItem];
    [self.userTradeGradeButton addTarget:self
                                  action:@selector(userGradeWeb)
                        forControlEvents:UIControlEventTouchUpInside];
  }
}

#pragma mark 点击跳转评级报告页
- (void)userGradeWeb {
  //点击变背景色
  _userTradeGradeButton.backgroundColor =
      [Globle colorFromHexRGB:Color_Gray_but alpha:0.5f];
  [SimuUtil performBlockOnMainThread:^{
    _userTradeGradeButton.backgroundColor = [UIColor clearColor];
    //优顾交易评级报告
    NSString *textUrl = [wap_address
        stringByAppendingFormat:
            @"/mobile/wap_analysis/html/anaysis.html?userid=%@&matchid=%@",
            self.userId, @"1"];
    GameWebViewController *webView = [[GameWebViewController alloc]
        initWithNameTitle:@"优顾交易评级报告"
                  andPath:textUrl];
    webView.urlType = AdvUrlMOduleTypeTradeEvaluating;
    //切换
    [AppDelegate pushViewControllerFromRight:webView];

  } withDelaySeconds:0.2];
}

@end

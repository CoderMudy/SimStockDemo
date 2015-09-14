//
//  SimulationViewCell.m
//  SimuStock
//
//  Created by Mac on 15/4/12.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SimulationViewCell.h"
#import "SimuUserConterViewController.h"
#import "StockUtil.h"
#import "simuBuyViewController.h"
#import "simuSellViewController.h"
#import "simuCancellationViewController.h"

@implementation SimulationViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  self.clipsToBounds = YES;
  self.activityView.hidden = YES;
  // Initialization code
  UIColor *color = _SimulationBuybtn.titleLabel.textColor;
  [_SimulationBuybtn.layer setBorderColor:color.CGColor];
  [_SimulationBuybtn.layer setBorderWidth:0.5f];
  _SimulationBuybtn.layer.cornerRadius = 13;
  _SimulationBuybtn.clipsToBounds = YES;

  [self.SimulationBuybtn buttonWithTitle:@"买入"
                      andNormaltextcolor:Color_Blue_but
                andHightlightedTextColor:Color_White];
  [self.SimulationBuybtn setNormalBGColor:[Globle colorFromHexRGB:Color_White]];
  [self.SimulationBuybtn setHighlightBGColor:[Globle colorFromHexRGB:Color_Blue_but]];

  [_SimulationSellbtn.layer setBorderColor:color.CGColor];
  [_SimulationSellbtn.layer setBorderWidth:0.5f];
  _SimulationSellbtn.layer.cornerRadius = 13;
  _SimulationSellbtn.clipsToBounds = YES;

  [self.SimulationSellbtn buttonWithTitle:@"卖出"
                       andNormaltextcolor:Color_Blue_but
                 andHightlightedTextColor:Color_White];
  [self.SimulationSellbtn setNormalBGColor:[Globle colorFromHexRGB:Color_White]];
  [self.SimulationSellbtn setHighlightBGColor:[Globle colorFromHexRGB:Color_Blue_but]];

  [_SimulationEntrustbtn.layer setBorderColor:color.CGColor];
  [_SimulationEntrustbtn.layer setBorderWidth:0.5f];
  _SimulationEntrustbtn.layer.cornerRadius = 13;
  _SimulationEntrustbtn.clipsToBounds = YES;

  [self.SimulationEntrustbtn buttonWithTitle:@"查委托/撤单"
                          andNormaltextcolor:Color_Blue_but
                    andHightlightedTextColor:Color_White];
  [self.SimulationEntrustbtn setNormalBGColor:[Globle colorFromHexRGB:Color_White]];
  [self.SimulationEntrustbtn setHighlightBGColor:[Globle colorFromHexRGB:Color_Blue_but]];

  //买入按钮
  __weak SimulationViewCell *weakSelf = self;
  [self.SimulationBuybtn setOnButtonPressedHandler:^{
    SimulationViewCell *strongSelf = weakSelf;
    if (strongSelf) {
      [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
        [simuBuyViewController buyStockInMatch:@"1"];
      }];
    }
  }];

  //卖出按钮
  [self.SimulationSellbtn setOnButtonPressedHandler:^{
    SimulationViewCell *strongSelf = weakSelf;
    if (strongSelf) {
      [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
        [simuSellViewController sellStockInMatch:@"1"];
      }];
    }
  }];

  //撤单查询
  [self.SimulationEntrustbtn setOnButtonPressedHandler:^{
    SimulationViewCell *strongSelf = weakSelf;
    if (strongSelf) {
      [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
        [AppDelegate pushViewControllerFromRight:[[simuCancellationViewController alloc] initWithMatchId:@"1"
                                                                                           withAccountId:@""
                                                                                           withTitleName:@""
                                                                                        withUserOrExpert:StockBuySellOrdinaryType]];
      }];
    }
  }];

  [self Start_parentVC];
}

///刷新按钮的点击
- (IBAction)RefrashBtnClick:(UIButton *)sender {
  self.RefrashBtn.hidden = YES;
  [self.activityView startAnimating];
}

- (void)Start_parentVC {
  //资金充值按钮
  SimuleftImagButtonView *addmoneyBut =
      [[SimuleftImagButtonView alloc] initWithFrame:CGRectMake(WIDTH_OF_SCREEN - 100, 20, 86, 26)
                                          ImageName:@"资金充值.png"
                                          TitleName:@"资金充值"
                                          TextColor:@"#f0605f"
                                                Tag:100];
  [self addSubview:addmoneyBut];
  addmoneyBut.delegate = self;
  //帐户重置按钮
  _resetCountBut = [[SimuleftImagButtonView alloc]
      initWithFrame:CGRectMake(WIDTH_OF_SCREEN - 100, addmoneyBut.frame.origin.y + addmoneyBut.frame.size.height + 23, 86, 26)
          ImageName:@"账户重置.png"
          TitleName:@"帐户重置"
          TextColor:@"#31bce9"
                Tag:101];
  [self addSubview:_resetCountBut];
  _resetCountBut.delegate = self;
  _resetCountBut.hidden = YES;
}

- (void)ButtonPressUp:(NSInteger)index {
  if ([_delegate respondsToSelector:@selector(ButtonPressUp:)]) {
    [_delegate ButtonPressUp:index];
  }
}

#pragma mark
#pragma mark 对外接口
- (void)resetData:(UserAccountPageData *)pagedata {
  if (pagedata == nil)
    return;
  //总盈利率
  NSString *totalprofit = pagedata.profitrate;
  if (totalprofit == nil || [totalprofit length] == 0) {
    _Profitrate.textColor = [Globle colorFromHexRGB:Color_Red];
    _Profitrate.text = @"0.00%";
  } else {
    _Profitrate.textColor = [StockUtil getColorByText:totalprofit];
    _Profitrate.text = totalprofit;
    NSRange rang = [totalprofit rangeOfString:@"-"];
    //颜色设置
    if (rang.length > 0) {
      _resetCountBut.hidden = NO;
    } else {
      _resetCountBut.hidden = YES;
    }
    //不显示账户重置按钮，因为将要删除重置卡
    _resetCountBut.hidden = YES;
  }
  //总资产
  _TotalAssets.text = pagedata.totalAssets;
  //可用金额
  _FundBalance.text = pagedata.fundBalance;
  //股票市值
  _PositionValue.text = pagedata.positionValue;
  _FloatProfit.text = pagedata.floatProfit;
  _FloatProfit.textColor = [StockUtil getColorByText:pagedata.floatProfit];
}

@end

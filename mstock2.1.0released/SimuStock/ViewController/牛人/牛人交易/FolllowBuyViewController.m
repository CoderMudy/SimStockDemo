//
//  folllowBuyViewController.m
//  SimuStock
//
//  Created by jhss on 15-4-29.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "FolllowBuyViewController.h"
#import "simuRealTradeVC.h"
#import "UIImage+ColorTransformToImage.h"
#import "simuSellViewController.h"
#import "BrokerageAccountListVC.h"

@implementation FolllowBuyViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self createView];
}

- (void)createView {
  self.view.backgroundColor = [Globle colorFromHexRGB:@"#ffffff"];

  UIImage *inviteFriendImage =
      [UIImage imageFromView:self.simuBuyBtn
          withBackgroundColor:[Globle colorFromHexRGB:@"#df1515"]];
  [self.simuBuyBtn setBackgroundImage:inviteFriendImage
                             forState:UIControlStateHighlighted];
  [self.simuBuyBtn setTitleColor:[UIColor whiteColor]
                        forState:UIControlStateHighlighted];
  self.isBuy ? ([self.simuBuyBtn setTitle:@"模拟买入"
                                 forState:UIControlStateNormal])
             : ([self.simuBuyBtn setTitle:@"模拟卖出"
                                 forState:UIControlStateNormal]);
  self.simuBuyBtn.layer.borderWidth = 0.5f;
  self.simuBuyBtn.layer.borderColor =
      [[Globle colorFromHexRGB:@"#df1515"] CGColor];
  self.simuBuyBtn.layer.cornerRadius = self.simuBuyBtn.bounds.size.height / 2;
  [self.simuBuyBtn.layer setMasksToBounds:YES];
  [self.simuBuyBtn addTarget:self
                      action:@selector(showSimuBuyVC)
            forControlEvents:UIControlEventTouchUpInside];
  [self.realBuyBtn setBackgroundImage:inviteFriendImage
                             forState:UIControlStateHighlighted];
  self.isBuy ? ([self.realBuyBtn setTitle:@"实盘买入"
                                 forState:UIControlStateNormal])
             : ([self.realBuyBtn setTitle:@"实盘卖出"
                                 forState:UIControlStateNormal]);
  [self.realBuyBtn setTitleColor:[UIColor whiteColor]
                        forState:UIControlStateHighlighted];
  self.realBuyBtn.layer.borderWidth = 0.5f;
  self.realBuyBtn.layer.borderColor =
      [[Globle colorFromHexRGB:@"#df1515"] CGColor];
  self.realBuyBtn.layer.cornerRadius = self.realBuyBtn.bounds.size.height / 2;
  [self.realBuyBtn.layer setMasksToBounds:YES];
  [self.realBuyBtn addTarget:self
                      action:@selector(showRealTradeVC)
            forControlEvents:UIControlEventTouchUpInside];
}

///直接登录实盘主页
- (void)openRealTradeMainPage {
  //重新记录时间
  [SimuUser
      setUserFirmLogonSuccessTime:[NSDate timeIntervalSinceReferenceDate]];

  if (_isBuy) {
    _inputParameters = @{
      @"selectedIndex" : @1,
      @"stockCode" : _stockCode,
      @"stockName" : _stockName
    };
  } else {
    _inputParameters = @{
      @"selectedIndex" : @0,
      @"stockCode" : _stockCode,
      @"stockName" : _stockName
    };
  }

  [AppDelegate
      pushViewControllerFromRight:[[simuRealTradeVC alloc]
                                      initWithDictionary:_inputParameters]];
  NSLog(@"跳转到实盘交易界面");
}

- (void)showRealTradeVC {
  __weak FolllowBuyViewController *weakSelf = self;
  //实盘交易
  [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL
                                                                    isLogined) {
    if (isLogined) {
      if ([[SimuUtil getStockFirmFlag] isEqualToString:@"1"]) {
        [AccountsViewController checkLogonRealTradeAndDoBlock:^(BOOL logined) {
          [weakSelf openRealTradeMainPage];
        }];
      } else {
        //实盘开户
        [AppDelegate
            pushViewControllerFromRight:[[BrokerageAccountListVC alloc]
                                            initWithOnLoginCallbalck:nil]];
        NSLog(@"跳转到实盘开户界面");
      }
    }
  }];
}

- (void)showSimuBuyVC {
  //实盘交易
  [FullScreenLogonViewController
      checkLoginStatusWithCallBack:^(BOOL isLogined) {
        self.isBuy ? ([self buyStockCode:_stockCode StockName:_stockName])
                   : ([self sellStockCode:_stockCode StockName:_stockName]);
      }];
}

//买入
- (void)buyStockCode:(NSString *)stockCode StockName:(NSString *)stockName {
  [simuBuyViewController buyStockWithStockCode:stockCode
                                 withStockName:stockName
                                   withMatchId:@"1"];
}

//卖出
- (void)sellStockCode:(NSString *)stockCode StockName:(NSString *)stockName {
  [simuSellViewController sellStockWithStockCode:stockCode
                                   withStockName:stockName
                                     withMatchId:@"1"];
}

@end

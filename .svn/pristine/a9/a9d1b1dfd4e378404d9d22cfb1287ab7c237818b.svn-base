//
//  FollowBuyClientVC.m
//  SimuStock
//
//  Created by jhss on 15-4-29.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "FollowBuyClientVC.h"
@implementation FollowBuyClientVC
- (id)initWithStockCode:(NSString *)stockCode
          withStockName:(NSString *)stockName
              withIsBuy:(BOOL)isBuy {
  if (self = [super init]) {
    _isBuy = isBuy;
    _stockCodeLong = stockCode;
    //股票代码统一显示为6位
    (stockCode.length == 8) ? (_stockCode = [stockCode substringFromIndex:2])
                            : (_stockCode = stockCode);
    _stockName = stockName;
  }
  return self;
}
- (void)viewDidLoad {
  [super viewDidLoad];
  //创建顶部topBar
  [self createTopBarView];
  //创建跟买CV
  [self createFollowBuyVC];
}

///创建顶部topBar
- (void)createTopBarView {
  if (_isBuy) {
    [_topToolBar resetContentAndFlage:@"买入股票" Mode:TTBM_Mode_Leveltwo];
  } else {
    [_topToolBar resetContentAndFlage:@"卖出股票" Mode:TTBM_Mode_Leveltwo];
  }

  //隐藏菊花
  self.indicatorView.hidden = YES;
}

///创建✨跟买✨VC
- (void)createFollowBuyVC {
  if (!followBuyVC) {
    followBuyVC = [[FolllowBuyViewController alloc]
        initWithNibName:@"FolllowBuyViewController"
                 bundle:nil];
    followBuyVC.isBuy = _isBuy;
    CGRect frame = CGRectMake(0, 0, self.clientView.bounds.size.width,
                              CGRectGetHeight(self.clientView.bounds));
    followBuyVC.view.frame = frame;
  }

  followBuyVC.stockCode = _stockCode;
  followBuyVC.stockName = _stockName;
  self.clientView.clipsToBounds = YES;
  [self.clientView addSubview:followBuyVC.view];
}
@end

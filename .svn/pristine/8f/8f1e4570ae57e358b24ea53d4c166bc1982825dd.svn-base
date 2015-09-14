//
//  NoSelfStockView.m
//  SimuStock
//
//  Created by Mac on 15/4/27.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "NoSelfStockView.h"
#import "SelectStocksViewController.h"
#import "TrendViewController.h"

@implementation NoSelfStockView

- (void)awakeFromNib {
  [super awakeFromNib];
  _plusButtonView.backgroundColor = [UIColor clearColor];

  if (_plusButtonView.gestureRecognizers.count == 0) {
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]
        initWithTarget:self
                action:@selector(showSearchStockPage)];
    [_plusButtonView addGestureRecognizer:recognizer];
  }
}

- (void)showSearchStockPage {
  OnStockSelected callback =
      ^(NSString *stockCode, NSString *stockName, NSString *firstType) {
        [TrendViewController showDetailWithStockCode:stockCode
                                       withStockName:stockName
                                       withFirstType:firstType
                                         withMatchId:@"1"];
      };
  SelectStocksViewController *selectStocksVC =
      [[SelectStocksViewController alloc] initStartPageType:SelfStockPage
                                               withCallBack:callback];

  [AppDelegate pushViewControllerFromRight:selectStocksVC];
}

@end

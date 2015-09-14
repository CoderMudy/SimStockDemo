//
//  FundHoldStockHeaderCell.m
//  SimuStock
//
//  Created by Mac on 15/5/14.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "FundHoldStockHeaderCell.h"
#import "UIButton+Block.h"
#import "FundHoldStocksViewController.h"
#import "AppDelegate.h"

@implementation FundHoldStockHeaderCell

- (void)awakeFromNib {
  _lblUpdateTime.text = @"";
}

- (void)bindUpdateDate:(NSString *)date
          withFundCode:(NSString *)fundCode
          withFundName:(NSString *)fundName {
  _lblUpdateTime.text = [@"" isEqualToString:date] ? @"" : [NSString stringWithFormat:@"更新%@", date];
  [_btnHoldStockDetail setOnButtonPressedHandler:^{
    if (fundCode == nil) {
      return;
    }
    FundHoldStocksViewController *vc =
        [[FundHoldStocksViewController alloc] initWithFundCode:fundCode withFundName:fundName];
    [AppDelegate pushViewControllerFromRight:vc];
  }];
}

@end

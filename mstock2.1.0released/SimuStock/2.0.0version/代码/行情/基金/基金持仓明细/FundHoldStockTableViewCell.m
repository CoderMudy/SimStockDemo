//
//  FundHoldStockTableViewCell.m
//  SimuStock
//
//  Created by Mac on 15/5/11.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "FundHoldStockTableViewCell.h"

@implementation FundHoldStockTableViewCell {
  FundHoldStock *_stock;
}

- (void)bindFundHoldStock:(FundHoldStock *)stock {
  _stock = stock;
  self.lblStockCode.text = stock.fund.stockCode;
  self.lblStockName.text = stock.fund.name;
  CGFloat holdVol = ((NSInteger)(stock.holdingVol / 10000.f * 100)) / 100.f;
  self.lblCurPrice.text = [NSString stringWithFormat:@"%.2f", holdVol];
  self.lblChange.text =
      [NSString stringWithFormat:@"%.2f%%", stock.PCTOfNAVEnd];
}

@end

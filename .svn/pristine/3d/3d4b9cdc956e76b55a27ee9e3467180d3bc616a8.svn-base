//
//  BuyInStockActulTradingView.m
//  SimuStock
//
//  Created by jhss_wyz on 15/3/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BuyInStockActualTradingView.h"
#import "Globle.h"

@implementation BuyInStockActualTradingView

- (void)setupSubviews {
  self.applyMoneyBtn.titleLabel.text = @"申请配资";
  self.buyBtn.titleLabel.text = @"配资买入";

  [self.applyMoneyBtn setTitleColor:[Globle colorFromHexRGB:@"#df1515"]
                           forState:UIControlStateNormal];
  [self.buyBtn setTitleColor:[Globle colorFromHexRGB:@"#df1515"]
                    forState:UIControlStateNormal];

  self.grayLineView.backgroundColor = [Globle colorFromHexRGB:@"#e9e9e9"];
}

- (void)setupButtonLayer {
  [self.applyMoneyBtn.layer setMasksToBounds:YES];
  [self.applyMoneyBtn.layer setCornerRadius:self.applyMoneyBtn.height / 2];
  [self.applyMoneyBtn.layer setBorderWidth:1.0];
  [self.applyMoneyBtn.layer
      setBorderColor:[Globle colorFromHexRGB:@"#df1515"].CGColor];

  [self.buyBtn.layer setMasksToBounds:YES];
  [self.buyBtn.layer setCornerRadius:self.applyMoneyBtn.height / 2];
  [self.buyBtn.layer setBorderWidth:1.0];
  [self.buyBtn.layer
      setBorderColor:[Globle colorFromHexRGB:@"#df1515"].CGColor];
}

@end

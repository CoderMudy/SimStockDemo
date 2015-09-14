//
//  SimulatorBuyInStockView.m
//  SimuStock
//
//  Created by jhss_wyz on 15/3/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SimulatorBuyInStockView.h"
#import "Globle.h"

@implementation SimulatorBuyInStockView

- (void)setupButtonLayer {
  [self.simulatorBuyBtn.layer setMasksToBounds:YES];
  [self.simulatorBuyBtn.layer setCornerRadius:self.simulatorBuyBtn.height / 2];
  [self.simulatorBuyBtn.layer setBorderWidth:1.0];
  [self.simulatorBuyBtn.layer
      setBorderColor:[Globle colorFromHexRGB:@"#df1515"].CGColor];
}

@end

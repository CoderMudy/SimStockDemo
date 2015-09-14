//
//  RechargePaymentView.m
//  SimuStock
//
//  Created by jhss_wyz on 15/6/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

@implementation RechargePaymentView

- (void)awakeFromNib {
  [self.selectBtn
   setBackgroundImage:[SimuUtil imageFromColor:Color_BG_Common]
   forState:UIControlStateHighlighted];
}

@end

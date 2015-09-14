//
//  AddBankCardBigView.m
//  SimuStock
//
//  Created by jhss_wyz on 15/4/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "AddBankCardBigView.h"
#import "Globle.h"
#import "UILabel+SetProperty.h"

@implementation AddBankCardBigView

- (void)awakeFromNib {
  [super awakeFromNib];
   self.clipsToBounds=YES;
  [self setupSubviews];
}

- (void)setupSubviews {
  self.backgroundColor = [Globle colorFromHexRGB:Color_White];

  [self setupAddCardButton];

  [self.addCardLable
      setupLableWithText:@"添加银行卡"
            andTextColor:[Globle colorFromHexRGB:Color_Gray]
             andTextFont:[UIFont systemFontOfSize:Font_Height_15_0]
            andAlignment:NSTextAlignmentCenter];

  self.backgroundColor = [Globle colorFromHexRGB:Color_White];
  self.marginLine.backgroundColor = [Globle colorFromHexRGB:@"#ececec"];
}

- (void)setupAddCardButton {
  [self.addCardBtn setTitle:@"" forState:UIControlStateNormal];
  [self.addCardBtn setImage:[UIImage imageNamed:@"添加小图标.png"]
                   forState:UIControlStateNormal];
  [self.addCardBtn setTintColor:[Globle colorFromHexRGB:@"#b7b7b7"]];
}

@end

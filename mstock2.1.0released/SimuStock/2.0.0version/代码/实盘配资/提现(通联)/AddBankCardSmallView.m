//
//  AddBankCardSmallView.m
//  SimuStock
//
//  Created by jhss_wyz on 15/4/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "AddBankCardSmallView.h"
#import "Globle.h"

@implementation AddBankCardSmallView

- (void)awakeFromNib {
  [self setupSubviews];
}

- (void)setupSubviews {
  self.marginView.backgroundColor = [Globle colorFromHexRGB:@"#e7e7e7"];
  self.addCardButton.userInteractionEnabled = YES;
  self.addCardButton.enabled = YES;

  self.addCardLableBtn.contentHorizontalAlignment =
      UIControlContentHorizontalAlignmentLeft;
  self.addCardLableBtn.titleLabel.font =
      [UIFont systemFontOfSize:Font_Height_15_0];
  [self.addCardLableBtn setTitle:@"添加银行卡" forState:UIControlStateNormal];
  [self.addCardLableBtn setTitle:@"添加银行卡" forState:UIControlStateSelected];
  [self.addCardLableBtn setTitleColor:[Globle colorFromHexRGB:Color_Text_Common]
                             forState:UIControlStateNormal];
  [self.addCardLableBtn setTitleColor:[Globle colorFromHexRGB:@"#31bce9"]
                             forState:UIControlStateSelected];
  self.addCardLableBtn.userInteractionEnabled = NO;

  [self.addCardImageBtn setTitle:@"" forState:UIControlStateNormal];
  [self.addCardImageBtn setTitle:@"" forState:UIControlStateSelected];
  [self.addCardImageBtn setImage:[UIImage imageNamed:@"添加小图标.png"]
                        forState:UIControlStateNormal];
  self.addCardImageBtn.userInteractionEnabled = NO;

  [self SetAddBankcardBtnState:NO];
}

- (void)SetAddBankcardBtnState:(BOOL)couldAdd {
  self.addCardImageBtn.selected = couldAdd;
  self.addCardLableBtn.selected = couldAdd;
  [self.addCardImageBtn
      setTintColor:[Globle
                       colorFromHexRGB:(couldAdd ? @"#31bce9" : @"#b7b7b7")]];
}

@end

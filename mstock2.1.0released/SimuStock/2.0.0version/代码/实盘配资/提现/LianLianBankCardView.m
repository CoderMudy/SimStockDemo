//
//  BankCardView.m
//  SimuStock
//
//  Created by jhss_wyz on 15/4/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "LianLianBankCardView.h"
#import "UILabel+SetProperty.h"
#import "Globle.h"
#import "UIImageView+WebCache.h"
#import "WFAccountInterface.h"
@implementation LianLianBankCardView

- (void)awakeFromNib {
  [super awakeFromNib];
  self.clipsToBounds = YES;
  [self setupSubviews];
}

- (void)setupSubviews {
  self.marginView.backgroundColor = [Globle colorFromHexRGB:@"#e7e7e7"];
}

- (void)bindDataFromYouGuu:(WFBindedBankcardYouGuuResult *)info {
  if (info) {
    self.bankName = info.bank_name;
    self.bankLogo = info.bank_logo;
    self.bankNOLast = info.cardNo;
    [self bindData];
  }
}

- (void)bindData {
  NSString *bankName = [NSString stringWithFormat:@"%@\n", self.bankName];
  NSString *bankCarid =
      [NSString stringWithFormat:@"尾号%@的储蓄卡", self.bankNOLast];

  [self.bankCardInfoLable
      setAttributedTextWithFirstString:bankName
                          andFirstFont:[UIFont
                                           systemFontOfSize:Font_Height_15_0]
                         andFirstColor:[Globle
                                           colorFromHexRGB:Color_Text_Common]
                       andSecondString:bankCarid
                         andSecondFont:[UIFont
                                           systemFontOfSize:Font_Height_13_0]
                        andSecondColor:[Globle colorFromHexRGB:Color_Gray]];
  self.bankCardInfoLable.numberOfLines = 0;

  [self.LogoImage setImageWithURL:[NSURL URLWithString:self.bankLogo]];
}

@end

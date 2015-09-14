//
//  BankCardView.m
//  SimuStock
//
//  Created by jhss_wyz on 15/4/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BankCardView.h"
#import "UILabel+SetProperty.h"
#import "RadioButton.h"
#import "UIImageView+WebCache.h"
@implementation BankCardView

- (void)awakeFromNib {
  [self setupSubviews];
}

- (void)setupSubviews {
  self.marginView.backgroundColor = [Globle colorFromHexRGB:@"#e7e7e7"];
}

- (void)getDataToBandCard:(WFBindedBankcardInfo *)info {
  if (info) {
    NSString *bankName = [NSString stringWithFormat:@"%@\n", info.bankName];
    NSString *bankCarid = [NSString stringWithFormat:@"尾号为%04d的储蓄卡", [info.card_no_tail intValue]];
    self.bankCardId = info.youguuId;

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
    
    [self.selectedBtn setTintColor:[UIColor clearColor]];
    
    [self.LogoImage setImageWithURL:[NSURL URLWithString:info.bankLogo]];
  }
}

@end

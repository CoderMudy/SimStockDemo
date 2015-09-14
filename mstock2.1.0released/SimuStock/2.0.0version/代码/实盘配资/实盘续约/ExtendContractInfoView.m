//
//  ExtendContractInfoView.m
//  SimuStock
//
//  Created by jhss_wyz on 15/4/26.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ExtendContractInfoView.h"
#import "UILabel+SetProperty.h"
#import "Globle.h"

#define Money_Number_Color [Globle colorFromHexRGB:Color_Text_Common]
#define Money_Number_Font_Height 23.0f

@implementation ExtendContractInfoView

+ (ExtendContractInfoView *)extendContractInfoView {
  ExtendContractInfoView *temp_view =
      [[[NSBundle mainBundle] loadNibNamed:@"ExtendContractInfoView"
                                     owner:nil
                                   options:nil] lastObject];
  return temp_view;
}

- (void)setupManagementInfoWithManagementFee:(NSString *)managementFee {
  self.mgrAmount.textAlignment = NSTextAlignmentRight;
  if (managementFee && ![managementFee isEqualToString:@""]) {
    NSArray *cashAmountArray = [managementFee componentsSeparatedByString:@"."];
    NSString *firstStr = cashAmountArray[0];
    NSString *lastStr = [@"." stringByAppendingString:cashAmountArray[1]];
    [self.mgrAmount
        setAttributedTextWithFirstString:firstStr
                            andFirstFont:[UIFont systemFontOfSize:
                                                     Money_Number_Font_Height]
                           andFirstColor:Money_Number_Color
                         andSecondString:lastStr
                           andSecondFont:[UIFont
                                             systemFontOfSize:Font_Height_12_0]
                          andSecondColor:Money_Number_Color];
  } else {
    self.mgrAmount.attributedText =
        [[NSAttributedString alloc] initWithString:@""];
  }
}

@end

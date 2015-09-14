//
//  ApplyActulTradingInfoView.m
//  SimuStock
//
//  Created by jhss_wyz on 15/3/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#define Button_Imagename @"帮助中心.png"
#define Money_Number_Color [Globle colorFromHexRGB:Color_Text_Common]
#define Money_Unit_Color [Globle colorFromHexRGB:Color_Text_Common]
#define Money_Number_Font_Height 23.0f
#define Money_Unit_Font_Height Font_Height_10_0
#define Deposit_And_Managementfee_Title_Font Font_Height_11_0

@implementation ApplyActulTradingInfoView

+ (ApplyActulTradingInfoView *)applyActulTradingInfoView {
  ApplyActulTradingInfoView *temp_view =
      [[[NSBundle mainBundle] loadNibNamed:@"ApplyActulTradingInfoView"
                                     owner:nil
                                   options:nil] lastObject];
  return temp_view;
}

- (void)setupSubviews {
  [self setupLableFormat];
}

/** 设置冻结保证金及管理费字体格式 */
- (void)setupLableFormat {
  [self.depositTitle
      setupLableWithText:@"冻结保证金"
            andTextColor:[Globle colorFromHexRGB:@"#b4b4b4"]
             andTextFont:
                 [UIFont systemFontOfSize:Deposit_And_Managementfee_Title_Font]
            andAlignment:NSTextAlignmentCenter];

  [self.managementFeeTitle
      setupLableWithText:@"账户管理费"
            andTextColor:[Globle colorFromHexRGB:@"#b4b4b4"]
             andTextFont:
                 [UIFont systemFontOfSize:Deposit_And_Managementfee_Title_Font]
            andAlignment:NSTextAlignmentCenter];
}
/** 冻结保证金说明按钮点击相应函数 */
- (IBAction)clickOnDepositInstructionBtn:(UIButton *)clickBtn {
  [self appearAlertWithInfo:@"保" @"证"
   @"金会在操盘结束盈利时与盈利一起全部返还给"
   @"您，亏" @"损时用来弥补亏损"];
}

/** 账户管理费说明按钮点击相应函数 */
- (IBAction)clickOnFeeInstructionBtn:(UIButton *)clickBtn {
  [self appearAlertWithInfo:@"按交易日收取，周末节假日免费"];
}

/** 弹出内容为string的提示框 */
- (void)appearAlertWithInfo:(NSString *)string {
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                      message:string
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil];
  [alertView show];
}

/** 设置冻结保证金数额 */
- (void)setupTradingInfoWithfreezeDeposit:(NSString *)freezeDepositString {
  self.freezeDepositLabel.textAlignment = NSTextAlignmentCenter;

  [self.freezeDepositLabel
      setAttributedTextWithFirstString:freezeDepositString == nil
                                           ? @""
                                           : freezeDepositString
                          andFirstFont:
                              [UIFont systemFontOfSize:Money_Number_Font_Height]
                         andFirstColor:Money_Number_Color
                         andSecondString:freezeDepositString == nil
                                        ? @""
                                        : @"元"
                         andSecondFont:
                             [UIFont systemFontOfSize:Money_Unit_Font_Height]
                        andSecondColor:Money_Unit_Color];
}

/** 设置每日管理费数额 */
- (void)setupTradingInfoWithmanagementFee:(NSString *)managementFeeString {
  self.managementFeeLable.textAlignment = NSTextAlignmentCenter;

  [self.managementFeeLable
      setAttributedTextWithFirstString:managementFeeString == nil
                                           ? @""
                                           : managementFeeString
                          andFirstFont:
                              [UIFont systemFontOfSize:Money_Number_Font_Height]
                         andFirstColor:Money_Number_Color
                         andSecondString:managementFeeString == nil
                                        ? @""
                                        : @"元"
                         andSecondFont:
                             [UIFont systemFontOfSize:Money_Unit_Font_Height]
                        andSecondColor:Money_Unit_Color];
}

/** 设置合计支付金额 */
- (void)setupTotalAmount:(NSString *)totalAmount {
  self.totalAmount.textAlignment = NSTextAlignmentRight;
  self.totalAmount.text =
      (totalAmount == nil ? @"" : [totalAmount stringByAppendingString:@"元"]);
}

@end

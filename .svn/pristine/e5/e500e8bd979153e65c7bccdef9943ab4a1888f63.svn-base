//
//  TotalTableViewCell.m
//  SimuStock
//
//  Created by Mac on 15/5/15.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "TotalTableViewCell.h"
#import "SchollWebViewController.h"
#import "UILabel+SetProperty.h"

#define Button_Imagename @"帮助中心.png"
#define Money_Number_Color [Globle colorFromHexRGB:Color_Text_Common]
#define Money_Unit_Color [Globle colorFromHexRGB:Color_Text_Common]
#define Money_Number_Font_Height 23.0f
#define Money_Unit_Font_Height Font_Height_10_0
#define Deposit_And_Managementfee_Title_Font Font_Height_11_0

@implementation TotalTableViewCell

- (void)awakeFromNib {
  [self setupSubviews];

  [self.haveReadBtn setImage:[UIImage imageNamed:@"小对号图标.png"]
                    forState:UIControlStateNormal];
  [self.haveReadBtn setImage:[UIImage imageNamed:@"小对号图标.png"]
                    forState:UIControlStateSelected];
  [self.haveReadBtn setImage:[UIImage imageNamed:@"小对号图标.png"]
                    forState:UIControlStateHighlighted];

  [self.haveReadBtn setBackgroundImage:[SimuUtil imageFromColor:@"#71BB46"]
                              forState:UIControlStateSelected];
  self.haveReadBtn.normalBGColor = [Globle colorFromHexRGB:@"#AFB3b5"];
  self.haveReadBtn.highlightBGColor = [Globle colorFromHexRGB:@"#055081"];
  self.haveReadBtn.imageEdgeInsets = UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0);
  self.haveReadBtn.layer.cornerRadius = self.haveReadBtn.width / 2;
  self.haveReadBtn.layer.masksToBounds = YES;
  self.haveReadBtn.enabled = YES;
  self.haveReadBtn.selected = YES;
}

/** 已阅读按钮点击相应函数 */
- (IBAction)clickOnHaveReadBtn:(UIButton *)clickBtn {
  if (clickBtn.selected) {
    clickBtn.selected = NO;
  } else {
    clickBtn.selected = YES;
  }
  self.block(clickBtn.selected);
}

/** 优顾用户操盘按钮点击响应函数 */
- (IBAction)clickOnProtocolBtn:(UIButton *)clickBtn {
  [SchollWebViewController
      startWithTitle:@"优顾用户配资协议"
             withUrl:@"http://m.youguu.com/mobile/wap_agreement/"
             @"agreement_borrow.html"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
}

- (void)setupSubviews {
  [self setupLableFormat];
}

/** 设置冻结保证金及管理费字体格式 */
- (void)setupLableFormat {
  [self.depositTitle
      setupLableWithText:@"冻结保证金（元）"
            andTextColor:[Globle colorFromHexRGB:@"#939393"]
             andTextFont:
                 [UIFont systemFontOfSize:Deposit_And_Managementfee_Title_Font]
            andAlignment:NSTextAlignmentCenter];

  [self.managementFeeTitle
      setupLableWithText:@"账户管理费（元）"
            andTextColor:[Globle colorFromHexRGB:@"#939393"]
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

/** 设置冻结保证金数额 或者 设置管理费数额*/
- (void)setupTradingInfoWithLabelStyle:(UILabel *)tradingLabel
                     WithTradingNumber:(NSString *)tradingAmount {
  tradingLabel.textAlignment = NSTextAlignmentCenter;
  if (tradingAmount && ![tradingAmount isEqualToString:@""]) {
    NSArray *cashAmountArray = [tradingAmount componentsSeparatedByString:@"."];
    NSString *firstStr = cashAmountArray[0];
    NSString *lastStr = [@"." stringByAppendingString:cashAmountArray[1]];
    [tradingLabel
        setAttributedTextWithFirstString:firstStr
                            andFirstFont:[UIFont systemFontOfSize:
                                                     Money_Number_Font_Height]
                           andFirstColor:Money_Number_Color
                         andSecondString:lastStr
                           andSecondFont:[UIFont
                                             systemFontOfSize:Font_Height_12_0]
                          andSecondColor:Money_Number_Color];
  } else {
    tradingLabel.attributedText =
        [[NSAttributedString alloc] initWithString:@""];
  }
}

@end

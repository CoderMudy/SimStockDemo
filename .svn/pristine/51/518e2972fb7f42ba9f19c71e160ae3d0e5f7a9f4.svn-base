//
//  WithdrawInfoView.m
//  SimuStock
//
//  Created by jhss_wyz on 15/4/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SimuUtil.h"
#import "BaseRequester.h"
/** 文字颜色 */
#define Title_Color Color_Text_Common
/** 文字大小 */
#define Title_Font_Height Font_Height_15_0

@implementation WithdrawInfoView

- (void)awakeFromNib {
  [self setupSubviews];
  [self UsersAssetsInquiry];
}

/** 设置子控件 */
- (void)setupSubviews {
  self.withdrawView.backgroundColor = [Globle colorFromHexRGB:Color_White];
  self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];

  [self.withdrawInfoLable
      setupLableWithText:@"提现信息"
            andTextColor:[Globle colorFromHexRGB:Color_Table_Title]
             andTextFont:[UIFont systemFontOfSize:Title_Font_Height]
            andAlignment:NSTextAlignmentLeft];

  [self.accountBalanceLable
      setupLableWithText:@"账户余额"
            andTextColor:[Globle colorFromHexRGB:Title_Color]
             andTextFont:[UIFont systemFontOfSize:Title_Font_Height]
            andAlignment:NSTextAlignmentLeft];

  [self.accountBalanceAccountLable
      setupLableWithText:@"200元"
            andTextColor:[Globle colorFromHexRGB:@"#fe8519"]
             andTextFont:[UIFont systemFontOfSize:Title_Font_Height]
            andAlignment:NSTextAlignmentLeft];

  [self.serviceFeeLable
      setupLableWithText:@"手续费"
            andTextColor:[Globle colorFromHexRGB:Title_Color]
             andTextFont:[UIFont systemFontOfSize:Title_Font_Height]
            andAlignment:NSTextAlignmentRight];

  [self.serviceFeeAccountLable
      setupLableWithText:@"免费"
            andTextColor:[Globle colorFromHexRGB:@"#fe8519"]
             andTextFont:[UIFont systemFontOfSize:Title_Font_Height]
            andAlignment:NSTextAlignmentCenter];

  [self.withdrawLable
      setupLableWithText:@"提取现额"
            andTextColor:[Globle colorFromHexRGB:Title_Color]
             andTextFont:[UIFont systemFontOfSize:Title_Font_Height]
            andAlignment:NSTextAlignmentLeft];

  self.inputMoney.inputType = INPUTE_TYPE_DECIMAL_NUMBER;
  self.inputMoney.numberOfDecimalPlaces = 2;
  self.inputMoney.inputTextField.placeholder = @"请输入提取金额";
  self.inputMoney.inputTextField.font =
      [UIFont systemFontOfSize:Title_Font_Height];
  self.inputMoney.inputTextField.textAlignment = NSTextAlignmentLeft;
  self.inputMoney.inputTextField.borderStyle = UITextBorderStyleNone;

  [self.receivedLable
      setupLableWithText:@"到账金额"
            andTextColor:[Globle colorFromHexRGB:Title_Color]
             andTextFont:[UIFont systemFontOfSize:Title_Font_Height]
            andAlignment:NSTextAlignmentLeft];

  [self.receivedAccountLable
      setupLableWithText:@"200元"
            andTextColor:[Globle colorFromHexRGB:Title_Color]
             andTextFont:[UIFont systemFontOfSize:Title_Font_Height]
            andAlignment:NSTextAlignmentLeft];

  [self.promptLable
      setupLableWithText:@"温馨提示:"
            andTextColor:[Globle colorFromHexRGB:Color_Gray]
             andTextFont:[UIFont systemFontOfSize:Font_Height_12_0]
            andAlignment:NSTextAlignmentLeft];

  self.promptInfoLable.numberOfLines = 0;
  [self.promptInfoLable
      setupLableWithText:@"小" @"于"
      @"100元的金额需一次性提取完成，每日限提取3次，" @"通常"
      @"到账时间为1～2个工作日"
            andTextColor:[Globle colorFromHexRGB:Color_Gray]
             andTextFont:[UIFont systemFontOfSize:Font_Height_12_0]
            andAlignment:NSTextAlignmentLeft];

  [self.determineWithdrawBtn setTitle:@"确认提现"
                             forState:UIControlStateNormal];
  [self.determineWithdrawBtn setTitleColor:[Globle colorFromHexRGB:Color_White]
                                  forState:UIControlStateNormal];
  self.determineWithdrawBtn.backgroundColor =
      [Globle colorFromHexRGB:@"#fd8418"];
  self.determineWithdrawBtn.layer.cornerRadius =
      self.determineWithdrawBtn.height / 2;

  [self setupMarginView];
  
  ///用户账户资产查询
  
}

/** 设置分割线 */
- (void)setupMarginView {
  self.marginViewOne.backgroundColor = [Globle colorFromHexRGB:@"#ececec"];
  self.marginViewTwo.backgroundColor = [Globle colorFromHexRGB:@"#ececec"];
  self.marginViewThree.backgroundColor = [Globle colorFromHexRGB:@"#ececec"];
  self.marginViewFour.backgroundColor = [Globle colorFromHexRGB:@"#ececec"];
  self.marginViewFive.backgroundColor = [Globle colorFromHexRGB:@"#ececec"];
}

///用户账户资产查询
-(void)UsersAssetsInquiry
{
  if (![SimuUtil isExistNetwork]) {
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  //解析
  __weak WithdrawInfoView *weakSelf = self;
  callback.onSuccess = ^(NSObject *obj) {
    WithdrawInfoView *strongSelf = weakSelf;
    if (strongSelf) {
      WFAccountBalance * wfobj=(WFAccountBalance*)obj;
      if (obj) {
        NSString * bankFee = [ProcessInputData convertMoneyString:wfobj.BankFee];
        NSString * amount = [ProcessInputData convertMoneyString:wfobj.amount];
        NSString * remainingCash =[NSString stringWithFormat:@"%0.2lf元",[amount doubleValue]-[bankFee doubleValue]];
        amount = [NSString stringWithFormat:@"%@元",amount];
        bankFee = [NSString stringWithFormat:@"%@元",bankFee];
        if ([wfobj.BankFee intValue]==0)
        {
          bankFee = @"免费";
        }

        self.serviceFeeAccountLable.text = bankFee;
        self.accountBalanceAccountLable.text = amount;
        self.receivedAccountLable.text = remainingCash;
      }
    }
  };
  [WFAccountInterface WFCheckAccountBalanceWithCallback:callback];
}

@end

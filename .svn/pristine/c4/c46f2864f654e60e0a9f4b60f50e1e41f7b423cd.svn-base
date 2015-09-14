//
//  WithdrawInfoView.m
//  SimuStock
//
//  Created by jhss_wyz on 15/4/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "LianLianWithdrawInfoView.h"
#import "InputTextFieldView.h"
#import "UILabel+SetProperty.h"
#import "Globle.h"
#import "SimuUtil.h"
#import "BaseRequester.h"
#import "WFAccountInterface.h"
#import "ProcessInputData.h"
#import "NetLoadingWaitView.h"

/** 文字颜色 */
#define Title_Color Color_Text_Common
/** 文字大小 */
#define Title_Font_Height Font_Height_15_0

@implementation LianLianWithdrawInfoView

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
      setupLableWithText:@""
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
      setupLableWithText:@"提现金额"
            andTextColor:[Globle colorFromHexRGB:Title_Color]
             andTextFont:[UIFont systemFontOfSize:Title_Font_Height]
            andAlignment:NSTextAlignmentLeft];

  self.inputMoney.inputType = INPUTE_TYPE_DECIMAL_NUMBER;
  self.inputMoney.numberOfDecimalPlaces = 2;
  self.inputMoney.numberOfIntegerPlaces = 9;
  self.inputMoney.inputTextField.placeholder = @"请输入提现金额";
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
      setupLableWithText:@""
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
      setupLableWithText:@"最低提现金额为100元，小于100元的金额需要一次性提取完成，每日限提取1次，通常到账时间为1~2个工作日"
            andTextColor:[Globle colorFromHexRGB:Color_Gray]
             andTextFont:[UIFont systemFontOfSize:Font_Height_12_0]
            andAlignment:NSTextAlignmentLeft];

  [self.determineWithdrawBtn buttonWithTitle:@"确认提现"
                          andNormaltextcolor:Color_White
                    andHightlightedTextColor:Color_White];
  self.determineWithdrawBtn.normalBGColor =
      [Globle colorFromHexRGB:Color_WFOrange_btn];
  self.determineWithdrawBtn.highlightBGColor =
      [Globle colorFromHexRGB:Color_WFOrange_btnDown];
  self.determineWithdrawBtn.clipsToBounds = YES;
  self.determineWithdrawBtn.layer.cornerRadius =
      self.determineWithdrawBtn.height / 2;

  LianLianWithdrawInfoView *strongSelf = self;
  self.inputMoney.changeTextBlock = ^(NSString *textStr, BOOL isChanged) {
    if (strongSelf && isChanged) {
      [strongSelf setupReceiveAmountWith:textStr];
    }
  };
}

/** 设置到账金额 */
- (void)setupReceiveAmountWith:(NSString *)inputAmount {
  if ([inputAmount doubleValue] >
      [_accountBalanceAccountLable.text doubleValue]) {
    self.inputMoney.inputTextField.textColor = [UIColor redColor];
    self.receivedAccountLable.textColor = [UIColor redColor];
    self.receivedAccountLable.text = @"提现金额不能大于账户余额";
    self.receivedAccountLable.font = [UIFont systemFontOfSize:Font_Height_13_0];
  } else {
    self.receivedAccountLable.textColor = [UIColor blackColor];
    self.inputMoney.inputTextField.textColor = [UIColor blackColor];
    NSString *bankfee = self.serviceFeeAccountLable.text;
    if ([bankfee isEqualToString:@"免费"]) {
      bankfee = 0;
    }

    double receivedAccount = [inputAmount doubleValue] - [bankfee doubleValue];
    if (receivedAccount > 0) {
      self.receivedAccountLable.text =
          [NSString stringWithFormat:@"%.2lf", receivedAccount];
    } else {
      self.receivedAccountLable.text = @"";
    }
  }
}

///用户账户资产查询
- (void)UsersAssetsInquiry {
  if (![SimuUtil isExistNetwork]) {
    [NetLoadingWaitView stopAnimating];
    [NewShowLabel showNoNetworkTip];
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  //解析
  __weak LianLianWithdrawInfoView *weakSelf = self;
  callback.onSuccess = ^(NSObject *obj) {
    LianLianWithdrawInfoView *strongSelf = weakSelf;
    if (strongSelf) {
      WFAccountBalance *wfobj = (WFAccountBalance *)obj;
      if (obj) {
        NSString *bankFee = [ProcessInputData convertMoneyString:wfobj.BankFee];
        NSString *amount = [ProcessInputData convertMoneyString:wfobj.amount];
        //如果账户余额小于100元，输入框不可编辑
        if (([amount intValue] < 100) && ([amount intValue] > 0) ) {
          strongSelf.inputMoney.inputTextField.text = amount;
          [strongSelf.inputMoney.inputTextField setUserInteractionEnabled:NO];
        }else
        {
         [strongSelf.inputMoney.inputTextField setUserInteractionEnabled:YES];
        }
        amount = [NSString stringWithFormat:@"%@元", amount];
        bankFee = [NSString stringWithFormat:@"%@元", bankFee];
        if ([wfobj.BankFee intValue] == 0) {
          bankFee = @"免费";
        }
        self.serviceFeeAccountLable.text = bankFee;
        self.accountBalanceAccountLable.text = amount;
      
        if (strongSelf.inputMoney.inputTextField.text) {
          [strongSelf
              setupReceiveAmountWith:strongSelf.inputMoney.inputTextField.text];
        }
      }
    }
    [NetLoadingWaitView stopAnimating];
  };
  
  callback.onError = ^(BaseRequestObject *obj, NSException *exc) {
    LianLianWithdrawInfoView *strongSelf = weakSelf;
    if (strongSelf) {
      [BaseRequester defaultErrorHandler];
    }
    [NetLoadingWaitView stopAnimating];
  };
  
  callback.onFailed = ^ {
    LianLianWithdrawInfoView *strongSelf = weakSelf;
    if (strongSelf) {
      [BaseRequester defaultFailedHandler];
    }
    [NetLoadingWaitView stopAnimating];
  };
  
  [WFAccountInterface WFCheckAccountBalanceWithCallback:callback];
}








@end

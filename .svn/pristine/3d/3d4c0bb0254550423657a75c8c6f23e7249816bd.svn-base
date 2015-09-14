//
//  realTradeFundTransferINVC.m
//  SimuStock
//
//  Created by Mac on 14-9-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "RealTradeFundTransferVC.h"

#import "SimuUtil.h"
#import "realTradeComboxView.h"
#import "RealTradeFundTransferResult.h"
#import "RealTradeRequester.h"
#import "NetLoadingWaitView.h"
#import "ProcessInputData.h"
#import "SimuTextField.h"
#import "NSStringCategory.h"

@interface RealTradeFundTransferVC () <UITextFieldDelegate, customizeNumKeyBoardDelegate> {
  //页面类型标志 yes 是资金转入页面 no 是资金转出页面
  BOOL rtft_IsFundIn;

  //左右边界距离
  float rtft_leftrightspace;
  //上边距离
  float rtft_topspace;
  //标题长度
  float rtft_titleWidth;
  //编辑框长度
  float rtft_editWidth;
  //字体高
  float rtft_fontHeight;
  //银行信息
  NSMutableArray *rtft_BankInfoArray;
  //币种信息
  NSMutableArray *rtft_MoneyTypeArray;
  Commbox *rtft_bankEditfild;
  //币种编辑框
  Commbox *rtft_moneyTypeEditeFild;
  //币种选择框
  UILabel *rtft_moneyTypeLable;
  //转账金额编辑框
  UITextField *rtft_moneyAtoumTextField;
  //密码编辑框
  UITextField *rtft_passwordTextField;
  //自定义密码键盘
  CustomizeNumberKeyBoard *rtft_customKeyBoard;
}

@end

@implementation RealTradeFundTransferVC

//初始化页面 is_transferIn：yes 资金转入页面，no 资金转出页面
- (id)init:(BOOL)is_transferIn {
  if (self = [super init]) {
    rtft_IsFundIn = is_transferIn;
    rtft_leftrightspace = 15;
    rtft_topspace = 25;
    rtft_titleWidth = 70;
    rtft_editWidth = WIDTH_OF_SCREEN - rtft_leftrightspace * 2 - rtft_titleWidth - 2; // 216;
    rtft_fontHeight = 16;
    rtft_BankInfoArray = [[NSMutableArray alloc] init];
    rtft_MoneyTypeArray = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  [self creatControlerViews];
  //联网取得银行信息
  [self getBankInfo];
}

//取消当前响应
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  //解决问题：表格打开，点击表格外部
  UITouch *touch = [[event allTouches] anyObject];
  CGPoint tempPoint = [touch locationInView:self.self.view];
  CGRect platFormRect = self.clientView.frame;
  if (CGRectContainsPoint(platFormRect, tempPoint) && platFormRect.size.height > 10.0f) {
    [rtft_bankEditfild visibleShow];
    [rtft_moneyTypeEditeFild visibleShow];
  }
}

#pragma mark
#pragma mark 创建控件
- (void)creatControlerViews {
  [self resetTopToolBarView];
  [self createCustomizeKeyBoard];
  [self creatlableAndEdits];
}
//创建上导航栏控件
- (void)resetTopToolBarView {
  //上标题栏

  if (rtft_IsFundIn) {
    [_topToolBar resetContentAndFlage:@"资金转入" Mode:TTBM_Mode_Leveltwo];
  } else {
    [_topToolBar resetContentAndFlage:@"资金转出" Mode:TTBM_Mode_Leveltwo];
  }
  // self.indicatorView.hidden = NO;
  self.indicatorView.butonIsVisible = NO;
}
/**
 *自定义键盘
 */
- (void)createCustomizeKeyBoard {
  rtft_customKeyBoard = [[CustomizeNumberKeyBoard alloc]
      initWithFrame:CGRectMake(0, self.view.frame.size.height - 218, self.view.frame.size.width, 218)];
  rtft_customKeyBoard.delegate = self;
}
//创建标题和编辑框控件
- (void)creatlableAndEdits {
  //转账银行
  CGRect nameLabelRect = CGRectMake(rtft_leftrightspace, rtft_topspace, rtft_titleWidth, 16);
  UILabel *bankNameLable = [[UILabel alloc] initWithFrame:nameLabelRect];
  bankNameLable.backgroundColor = [UIColor clearColor];
  bankNameLable.textAlignment = NSTextAlignmentRight;
  bankNameLable.font = [UIFont systemFontOfSize:15];
  bankNameLable.textColor = [Globle colorFromHexRGB:Color_Blue_but];
  bankNameLable.text = @"转账银行:";
  [self.clientView addSubview:bankNameLable];
  //转账银行编辑框
  //    CGRect editRect=CGRectMake(rtft_leftrightspace+rtft_titleWidth +2,
  //    rtft_topspace, rtft_editWidth,16);
  NSArray *array = [NSArray arrayWithObjects:nil];
  float linewidth = 0;
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    // ios7.0及以上版本
    linewidth = 5.f;
  } else {
    // ios7.0版本
    linewidth = 7.f;
  }

  NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:array];
  Commbox *_commbox = rtft_bankEditfild =
      [[Commbox alloc] initWithFrame:CGRectMake(rtft_leftrightspace + rtft_titleWidth + 2, rtft_topspace - linewidth,
                                                rtft_editWidth, 20 * [arr count] + 16)];
  _commbox.textField.text = @"";
  _commbox.tableArray = arr;

  _commbox.comboxTouch = ^void(Commbox *touchCombox) {
    if (touchCombox == rtft_bankEditfild) {
      [rtft_moneyTypeEditeFild visibleShow];
    } else {
      [rtft_bankEditfild visibleShow];
    }
  };
  _commbox.selectedCallBack = ^void(NSInteger selindex) {
    //设置币种信息
    if ([rtft_BankInfoArray count] >= selindex) {
      RealTradeBankItem *bankItem = rtft_BankInfoArray[selindex];
      for (RealTradeCurrencyType *obj in rtft_MoneyTypeArray) {
        if ([obj.abbr isEqualToString:bankItem.currencyType] == YES)
          rtft_moneyTypeLable.text = obj.name;
      }
    }

  };
  [self.clientView addSubview:_commbox];
  //画线
  CGRect lineRect = CGRectMake(rtft_leftrightspace, rtft_topspace + rtft_fontHeight + 6,
                               self.clientView.bounds.size.width - 2 * rtft_leftrightspace, 1.2);
  CALayer *lineView = [CALayer layer];
  lineView.frame = CGRectOffset(lineRect, 0, 0);
  lineView.backgroundColor = [Globle colorFromHexRGB:Color_Blue_but].CGColor;
  [self.clientView.layer addSublayer:lineView];

  //转账币种
  CGRect namerect = CGRectOffset(nameLabelRect, 0, 45);
  UILabel *fCurrencyLable = [[UILabel alloc] initWithFrame:namerect];
  fCurrencyLable.backgroundColor = [UIColor clearColor];
  fCurrencyLable.textAlignment = NSTextAlignmentRight;
  fCurrencyLable.font = [UIFont systemFontOfSize:15];
  fCurrencyLable.textColor = [Globle colorFromHexRGB:Color_Blue_but];
  fCurrencyLable.text = @"转账币种:";
  [self.clientView addSubview:fCurrencyLable];
  //币种选择
  rtft_moneyTypeLable =
      [[UILabel alloc] initWithFrame:CGRectMake(rtft_leftrightspace + rtft_titleWidth + 14, rtft_topspace + 45, rtft_editWidth, 15)];
  rtft_moneyTypeLable.backgroundColor = [UIColor clearColor];
  rtft_moneyTypeLable.font = [UIFont systemFontOfSize:Font_Height_16_0];
  rtft_moneyTypeLable.text = @"";
  rtft_moneyTypeLable.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  [self.clientView addSubview:rtft_moneyTypeLable];

  //  array = [NSArray arrayWithObjects:@"人民币", nil];
  //  arr = [[NSMutableArray alloc] initWithArray:array];
  //  _commbox = rtft_moneyTypeEditeFild = [[Commbox alloc]
  //      initWithFrame:CGRectMake(rtft_leftrightspace + rtft_titleWidth + 2,
  //                               rtft_topspace + 45, rtft_editWidth,
  //                               20 * [arr count] + 16)];
  //  _commbox.textField.placeholder = @"人民币";
  //  _commbox.tableArray = arr;
  //  [self.clientView addSubview:_commbox];
  //  _commbox.comboxTouch = ^void(Commbox *touchCombox) {
  //      if (touchCombox == temp_bankEdit) {
  //        [temp_moneyEdit visibleShow];
  //      } else {
  //        [temp_bankEdit visibleShow];
  //      }
  //  };

  //画线
  lineView = [CALayer layer];
  lineView.frame = CGRectOffset(lineRect, 0, 45);
  lineView.backgroundColor = [Globle colorFromHexRGB:Color_Blue_but].CGColor;
  [self.clientView.layer addSublayer:lineView];

  //转账金额
  UILabel *fundatoumLable = [[UILabel alloc] initWithFrame:CGRectOffset(nameLabelRect, 0, 2 * 45)];
  fundatoumLable.backgroundColor = [UIColor clearColor];
  fundatoumLable.textAlignment = NSTextAlignmentRight;
  fundatoumLable.font = [UIFont systemFontOfSize:15];
  fundatoumLable.textColor = [Globle colorFromHexRGB:Color_Blue_but];
  fundatoumLable.text = @"转账金额:";
  [self.clientView addSubview:fundatoumLable];
  //金额
  UITextField *rtft_fundsAmountField = rtft_moneyAtoumTextField =
      [[SimuTextField alloc] initWithFrame:CGRectMake(rtft_leftrightspace + rtft_titleWidth + 2 + 12,
                                                      rtft_topspace + 2 * 45, rtft_editWidth, 16)];
  // rtft_fundsAmountField.clearsOnBeginEditing=YES;
  rtft_fundsAmountField.clearButtonMode = UITextFieldViewModeWhileEditing;
  rtft_fundsAmountField.delegate = self;
  rtft_fundsAmountField.returnKeyType = UIReturnKeyDone;
  rtft_fundsAmountField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
  rtft_fundsAmountField.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  if (rtft_IsFundIn)
    rtft_fundsAmountField.placeholder = @"要转到证券账户的金额";
  else
    rtft_fundsAmountField.placeholder = @"要转到银行账户的金额";
  rtft_fundsAmountField.textAlignment = NSTextAlignmentLeft;
  rtft_fundsAmountField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  rtft_fundsAmountField.font = [UIFont systemFontOfSize:Font_Height_14_0];
  rtft_fundsAmountField.adjustsFontSizeToFitWidth = YES;
  rtft_fundsAmountField.borderStyle = UITextBorderStyleNone;
  [rtft_fundsAmountField addTarget:self
                            action:@selector(textfieldChange:)
                  forControlEvents:UIControlEventEditingChanged];
  [self.clientView addSubview:rtft_fundsAmountField];
  //画线
  lineView = [CALayer layer];
  lineView.frame = CGRectOffset(lineRect, 0, 2 * 45);
  lineView.backgroundColor = [Globle colorFromHexRGB:Color_Blue_but].CGColor;
  [self.clientView.layer addSublayer:lineView];

  //交易密码
  UILabel *passwordLable = [[UILabel alloc] initWithFrame:CGRectOffset(nameLabelRect, 0, 3 * 45)];
  passwordLable.backgroundColor = [UIColor clearColor];
  passwordLable.textAlignment = NSTextAlignmentRight;
  passwordLable.font = [UIFont systemFontOfSize:15];
  passwordLable.textColor = [Globle colorFromHexRGB:Color_Blue_but];
  if (rtft_IsFundIn) {
    passwordLable.text = @"银行密码:";
  } else {
    passwordLable.text = @"资金密码:";
  }

  [self.clientView addSubview:passwordLable];
  //输入密码
  UITextField *rtft_passwrodField = rtft_passwordTextField =
      [[SimuTextField alloc] initWithFrame:CGRectMake(rtft_leftrightspace + rtft_titleWidth + 2 + 12,
                                                      rtft_topspace + 3 * 45, rtft_editWidth, 16)];
  rtft_passwrodField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
  rtft_passwrodField.delegate = self;
  rtft_passwrodField.returnKeyType = UIReturnKeyDone;
  rtft_passwrodField.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  if (rtft_IsFundIn) {
    rtft_passwrodField.placeholder = @"请输入银行卡密码";
  } else {
    rtft_passwrodField.placeholder = @"请输入资金密码";
  }

  [rtft_passwrodField setSecureTextEntry:YES];
  rtft_passwrodField.textAlignment = NSTextAlignmentLeft;
  rtft_passwrodField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  rtft_passwrodField.font = [UIFont systemFontOfSize:Font_Height_14_0];
  rtft_passwrodField.adjustsFontSizeToFitWidth = YES;
  rtft_passwrodField.borderStyle = UITextBorderStyleNone;
  rtft_passwrodField.inputView = rtft_customKeyBoard;
  [self.clientView addSubview:rtft_passwrodField];
  //画线
  lineView = [CALayer layer];
  lineView.frame = CGRectOffset(lineRect, 0, 3 * 45);
  lineView.backgroundColor = [Globle colorFromHexRGB:Color_Blue_but].CGColor;
  [self.clientView.layer addSublayer:lineView];

  //资金转账页面
  BGColorUIButton *uibutton = [BGColorUIButton buttonWithType:UIButtonTypeCustom];
  uibutton.frame =
      CGRectMake(rtft_leftrightspace, rtft_topspace + 225, (self.clientView.bounds.size.width - 40), 35);
  if (rtft_IsFundIn) {
    [uibutton buttonWithTitle:@"立即转入"
              andNormaltextcolor:Color_White
        andHightlightedTextColor:Color_White];
  } else {
    [uibutton buttonWithTitle:@"立即转出"
              andNormaltextcolor:Color_White
        andHightlightedTextColor:Color_White];
  }
  [uibutton setNormalBGColor:[Globle colorFromHexRGB:Color_Blue_but]];
  [uibutton setHighlightBGColor:[Globle colorFromHexRGB:Color_Blue_butDown]];
  [uibutton addTarget:self
                action:@selector(buttonPressDwon:)
      forControlEvents:UIControlEventTouchUpInside];
  uibutton.tag = 40001;
  [self.clientView addSubview:uibutton];
}

#pragma mark
#pragma mark 一般功能函数
- (BOOL)isCanTransferAcount {

  if (rtft_BankInfoArray == nil || [rtft_BankInfoArray count] == 0) {
    [NewShowLabel setMessageContent:@"无银行信息"];
    return NO;
  }
  //转账金额
  NSString *amount = rtft_moneyAtoumTextField.text;
  if (amount == nil || amount.length <= 0) {
    [NewShowLabel setMessageContent:@"您还没有输入转账金额"];
    return NO;
  }
  //判断下 金额数是否为零
  BOOL isEnd = [self theNumberOfInputToDetemineWhertherTheAmountOfZero:amount];
  if (isEnd == NO) {
    return NO;
  }
  //交易密码
  NSString *passworkd = rtft_passwordTextField.text;
  if (passworkd == nil || passworkd.length <= 0) {
    [NewShowLabel setMessageContent:@"您还没有输入密码"];
    return NO;
  }
  return YES;
}

//判断金额是否为零
- (BOOL)theNumberOfInputToDetemineWhertherTheAmountOfZero:(NSString *)money {
  if ([money rangeOfString:@"."].location != NSNotFound) {
    NSArray *array = [money componentsSeparatedByString:@"."];
    if (array.count != 0) {
      NSString *str1 = array[0];
      NSString *str2 = array[1];
      BOOL fristZero = [self whetherAStringIsComposedByZero:str1];
      BOOL secondZero = [self whetherAStringIsComposedByZero:str2];
      if (fristZero == YES && secondZero == YES) {
        [NewShowLabel setMessageContent:@"转账金额应大于0"];
        return NO;
      }
    }
  } else {
    BOOL threeZero = [self whetherAStringIsComposedByZero:money];
    if (threeZero == YES) {
      [NewShowLabel setMessageContent:@"转账金额应大于0"];
      return NO;
    }
  }
  return YES;
}

//判断字符串是否都是由零组成的
- (BOOL)whetherAStringIsComposedByZero:(NSString *)string {
  if (string.length != 0) {
    for (int i = 0; i < string.length; i++) {
      NSString *a = [string substringWithRange:NSMakeRange(i, 1)];
      if (![a isEqualToString:@"0"]) {
        return NO;
      }
    }
  }
  return YES;
}

- (void)transferAcountFromNet {
  if (rtft_IsFundIn) {
    //资金转入
    [self transferFundsIn];
  } else {
    //资金转出
    [self transferFundsOut];
  }
}
- (void)comboxTouch:(Commbox *)tempcombox {
}

#pragma mark
#pragma mark 协议回调函数
// SimuIndicatorDelegate
- (void)refreshButtonPressDown {
  [self getBankInfo];
}
// UITextFieldDelegate 协议
- (void)textFieldDidBeginEditing:(UITextField *)textField {
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
  if (action == @selector(cut:)) {
    return NO;
  } else if (action == @selector(copy:)) {
    return NO;
  } else if (action == @selector(paste:)) {
    return NO;
  } else if (action == @selector(select:)) {
    return NO;
  } else if (action == @selector(selectAll:)) {
    return NO;
  } else {

    return NO; //[super canPerformAction:action withSender:sender];
  }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return YES;
}
- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
  if (textField == rtft_moneyAtoumTextField) {
    //过滤，只输入数字和小数点
    if ([string isNumber]) {
      return YES;
    } else if ([textField.text isNumber] && [string isEqualToString:@"."]) {
      return YES;
    } else {
      return NO;
    }
  }
  return YES;
}
//自己写的方法 时时判断输入的内容
- (void)textfieldChange:(UITextField *)textfield {
  [rtft_bankEditfild visibleShow];
  if (textfield == rtft_moneyAtoumTextField) {
    if ([textfield.text rangeOfString:@"."].location != NSNotFound) {
      NSArray *array = [textfield.text componentsSeparatedByString:@"."];
      if (array.count >= 3) {
      } else {
        if (textfield.text.length > 8) {
          textfield.text = [textfield.text substringToIndex:8];
          NSString *str =
              [ProcessInputData numbersAndTwoPunctuation:textfield.text andValidDecimalDigit:2];
          textfield.text = str;
        } else {
          textfield.text =
              [ProcessInputData numbersAndTwoPunctuation:textfield.text andValidDecimalDigit:2];
        }
      }
    } else {
      if (textfield.text.length > 8) {
        textfield.text = [textfield.text substringToIndex:8];
        NSString *str =
            [ProcessInputData numbersAndTwoPunctuation:textfield.text andValidDecimalDigit:2];
        textfield.text = str;
      } else if (textfield.text.length == 0) {

      } else {
        textfield.text =
            [ProcessInputData numbersAndTwoPunctuation:textfield.text andValidDecimalDigit:2];
      }
    }
  }
}
//资金转入/转出按钮点击
- (void)buttonPressDwon:(UIButton *)button {
  [rtft_moneyAtoumTextField resignFirstResponder];
  [rtft_passwordTextField resignFirstResponder];
  [rtft_bankEditfild visibleShow];
  [rtft_moneyTypeEditeFild visibleShow];
  if ([self isCanTransferAcount] == NO) {
    return;
  }
  NSString *transInfo = @"";
  //转账银行
  NSString *bankinfo = [rtft_bankEditfild.textField.text stringByAppendingString:@"\n"];
  transInfo = [@"转账银行:" stringByAppendingString:bankinfo];

  //转账币种
  transInfo = [transInfo stringByAppendingString:@"转账币种:"];
  NSString *moneytype = [rtft_moneyTypeLable.text stringByAppendingString:@"   \n"];
  transInfo = [transInfo stringByAppendingString:moneytype];

  //转账金额
  transInfo = [transInfo stringByAppendingString:@"转账金额:"];
  NSString *amount = [rtft_moneyAtoumTextField.text stringByAppendingString:@"   \n"];
  transInfo = [transInfo stringByAppendingString:amount];
  if (rtft_IsFundIn) {
    //转入
    transInfo = [transInfo stringByAppendingString:@"您确认要转入资金吗?"];
  } else {
    //转出
    transInfo = [transInfo stringByAppendingString:@"您确认要转出资金吗?"];
  }
  //提示
  UIAlertView *alartView = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                      message:transInfo
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                            otherButtonTitles:@"确定", nil];
  alartView.tag = 9999;
  [alartView show];
}
- (void)selectRandomMethod:(NSString *)theValue {
  //删除、确定键
  if ([theValue isEqualToString:@"clear"]) {
    NSString *text = rtft_passwordTextField.text;
    NSInteger lenth = [text length] - 1;
    if (lenth > -1) {
      text = [text substringToIndex:[text length] - 1];
    }
    rtft_passwordTextField.text = text;
    if ([rtft_passwordTextField.text length] == 0) {
    }
    return;
  } else if ([theValue isEqualToString:@"enter"]) {
    [rtft_passwordTextField resignFirstResponder];
    return;
  }
  NSString *oldValue = [NSString stringWithFormat:@"%@", rtft_passwordTextField.text];
  //限制密码长度
  if ([oldValue length] > 15) {
    return;
  }
  NSString *newValue = [oldValue stringByAppendingString:theValue];
  [rtft_passwordTextField setText:newValue];
}
// UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (alertView.tag == 9999) {
    if (buttonIndex == 0) {
      //取消
    } else {
      [self transferAcountFromNet];
    }
  }
}
- (void)willPresentAlertView:(UIAlertView *)alertView {
  for (UIView *view in [alertView.window subviews]) {
    if ([view isKindOfClass:[UILabel class]]) {
      UILabel *label = (UILabel *)view;
      label.textAlignment = NSTextAlignmentLeft;
    }
  }
}

#pragma mark
#pragma mark 网络函数
//取得银行信息
- (void)getBankInfo {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  [_indicatorView startAnimating];

  __weak RealTradeFundTransferVC *weakSelf = self;
  HttpRequestCallBack *callback = [HttpRequestCallBack initWithOwner:self
                                                       cleanCallback:^{
                                                         [weakSelf.indicatorView stopAnimating];
                                                       }];
  callback.onSuccess = ^(NSObject *obj) {
    [weakSelf.indicatorView stopAnimating];
    if (rtft_BankInfoArray == nil)
      return;
    [rtft_BankInfoArray removeAllObjects];
    [rtft_MoneyTypeArray removeAllObjects];
    SecuritiesBankInfo *bankInfoes = (SecuritiesBankInfo *)obj;
    [rtft_BankInfoArray addObjectsFromArray:bankInfoes.banks];
    [rtft_MoneyTypeArray addObjectsFromArray:bankInfoes.currencyTypes];
    //银行名称数组
    NSMutableArray *nameArray = [[NSMutableArray alloc] init];
    //币种数组
    NSMutableArray *moneyTypeArray = [[NSMutableArray alloc] init];
    for (RealTradeBankItem *bankItem in rtft_BankInfoArray) {
      [nameArray addObject:bankItem.bankName];
    }
    //设置银行信息
    [rtft_bankEditfild reset:nameArray];
    if (nameArray && [nameArray count] > 0) {
      rtft_bankEditfild.textField.text = nameArray[0];
    }
    for (RealTradeCurrencyType *obj in rtft_MoneyTypeArray) {
      [moneyTypeArray addObject:obj.name];
    }
    //设置币种信息
    if ([rtft_BankInfoArray count] > 0) {
      RealTradeBankItem *bankItem = rtft_BankInfoArray[0];
      for (RealTradeCurrencyType *obj in rtft_MoneyTypeArray) {
        if ([obj.abbr isEqualToString:bankItem.currencyType] == YES)
          rtft_moneyTypeLable.text = obj.name;
      }
    }
  };

  NSString *url = [[[RealTradeAuthInfo singleInstance] urlFactory] getBankSecuInfo];
  [SecuritiesBankInfo loadSecuritiesBankInfoWithUrl:url WithCallback:callback];
}

//清空 转账金额和密码的方法
- (void)clearMoneyAndPasswordText {
  rtft_passwordTextField.delegate = nil;
  rtft_passwordTextField.inputView = nil;
  rtft_passwordTextField.text = @"";
  rtft_moneyAtoumTextField.text = @"";

  [rtft_moneyAtoumTextField resignFirstResponder];
  [rtft_passwordTextField resignFirstResponder];
  rtft_passwordTextField.inputView = rtft_customKeyBoard;
  rtft_passwordTextField.delegate = self;
}

- (void)resetUI {
  [NetLoadingWaitView stopAnimating];
  [self clearMoneyAndPasswordText];
}

//资金转入
- (void)transferFundsIn {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  if (rtft_BankInfoArray == nil || [rtft_BankInfoArray count] == 0) {
    [NewShowLabel setMessageContent:@"无银行信息"];
    return;
  }

  //资金
  NSString *ms_fundsMonye = rtft_moneyAtoumTextField.text;
  if (ms_fundsMonye == nil || [ms_fundsMonye length] == 0) {
    [NewShowLabel setMessageContent:@"请输入转账金额！"];
    return;
  }
  //密码
  NSString *ms_passWord = rtft_passwordTextField.text;
  if (ms_passWord == nil || [ms_passWord length] == 0) {
    [NewShowLabel setMessageContent:@"请输入资金密码！"];
    return;
  }
  //银行信息
  NSString *bankName = rtft_bankEditfild.textField.text;
  if (bankName == nil || [bankName length] == 0) {
    [NewShowLabel setMessageContent:@"请选择转账银行！"];
    return;
  }
  RealTradeBankItem *bankItem = nil;
  for (RealTradeBankItem *obj in rtft_BankInfoArray) {
    if ([obj.bankName isEqual:bankName]) {
      bankItem = obj;
    }
  }
  if (bankItem == nil) {
    [NewShowLabel setMessageContent:@"暂无银行信息，请刷新"];
    return;
  }

  [NetLoadingWaitView startAnimating];

  __weak RealTradeFundTransferVC *weakSelf = self;
  CleanAction clearAction = ^{
    [weakSelf resetUI];
  };
  HttpRequestCallBack *callback =
      [HttpRequestCallBack initWithOwner:self cleanCallback:clearAction];
  callback.onSuccess = ^(NSObject *obj) {

    NSString *moneyAtoun = rtft_moneyAtoumTextField.text;

    //转账成功
    UIAlertView *alartView = [[UIAlertView alloc]
            initWithTitle:@"温馨提示"
                  message:@"银证转账委托提交成功，可在转账流水中查询结果"
                 delegate:nil
        cancelButtonTitle:@"我知道了"
        otherButtonTitles:nil, nil];
    [alartView show];

    NSLog(@"SUCCESS");

    //添加紫荆转出或转入统计接口
    [self statisticsFundsShiftToRollOutPort:rtft_IsFundIn andMoney:moneyAtoun];
    [weakSelf resetUI];
  };

  [RealTradeFundTransferResult transferInWithMoneyAmount:ms_fundsMonye
                                            withPassword:ms_passWord
                                             WitBankInfo:bankItem
                                            WithCallback:callback];
}

//资金转出
- (void)transferFundsOut {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  if (rtft_BankInfoArray == nil || [rtft_BankInfoArray count] == 0) {
    [NewShowLabel setMessageContent:@"无银行信息"];
    return;
  }
  //资金
  NSString *ms_fundsMonye = rtft_moneyAtoumTextField.text;
  if (ms_fundsMonye == nil || [ms_fundsMonye length] == 0) {
    [NewShowLabel setMessageContent:@"请输入转账金额！"];
    return;
  }
  //密码
  NSString *ms_passWord = rtft_passwordTextField.text;
  if (ms_passWord == nil || [ms_passWord length] == 0) {
    [NewShowLabel setMessageContent:@"请输入银行卡密码！"];
    return;
  }
  //银行信息
  NSString *bankName = rtft_bankEditfild.textField.text;
  if (bankName == nil || [bankName length] == 0) {
    [NewShowLabel setMessageContent:@"请选择转账银行！"];
    return;
  }
  RealTradeBankItem *bankItem = nil;
  for (RealTradeBankItem *obj in rtft_BankInfoArray) {
    if ([obj.bankName isEqual:bankName]) {
      bankItem = obj;
    }
  }
  if (bankItem == nil) {
    [NewShowLabel setMessageContent:@"暂无银行信息，请刷新"];
    return;
  }

  [NetLoadingWaitView startAnimating];

  __weak RealTradeFundTransferVC *weakSelf = self;
  CleanAction clearAction = ^{
    [weakSelf resetUI];
  };
  HttpRequestCallBack *callback =
      [HttpRequestCallBack initWithOwner:self cleanCallback:clearAction];

  callback.onSuccess = ^(NSObject *obj) {

    NSString *moneyAtoun = rtft_moneyAtoumTextField.text;
    UIAlertView *alartView = [[UIAlertView alloc]
            initWithTitle:@"温馨提示"
                  message:@"银证转账委托提交成功，可在转账流水中查询结果"
                 delegate:nil
        cancelButtonTitle:@"我知道了"
        otherButtonTitles:nil, nil];
    [alartView show];

    NSLog(@"SUCCESS");
    //添加紫荆转出或转入统计接口
    [self statisticsFundsShiftToRollOutPort:rtft_IsFundIn andMoney:moneyAtoun];
    [self resetUI];
  };

  [RealTradeFundTransferResult transferOutWithMoneyAmount:ms_fundsMonye
                                             withPassword:ms_passWord
                                              WitBankInfo:bankItem
                                             WithCallback:callback];
}

#pragma mark - 统计资金转入转出接口
- (void)statisticsFundsShiftToRollOutPort:(BOOL)isTransferIn andMoney:(NSString *)money {

  HttpRequestCallBack *callBackll = [[HttpRequestCallBack alloc] init];

  callBackll.onSuccess = ^(NSObject *obj) {
    NSLog(@"实盘资金转入转出统计接口请求成功");
  };
  callBackll.onFailed = ^() {
    NSLog(@"实盘资金转入转出统计接口请求成功请求失败");
  };
  callBackll.onError = ^(BaseRequestObject *obj, NSException *ex) {
    NSLog(@"实盘资金转入转出统计接口请求成功请求失败%@", obj ? obj : ex);
  };

  //资金转入转出 统计接口调用
  NSInteger brokerType = [[[RealTradeUrls singleInstance] getBrokerStockInfor:GetBrokerType] integerValue];
  [ActualQuotationMoneyShiftToOrRolloffData requestActualQuotationMoneyShiftToOrRolloff:money
                                                                                andType:isTransferIn
                                                                         withBrokerType:brokerType
                                                                            andCallBack:callBackll];
}

@end

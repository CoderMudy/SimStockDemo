//
//  ProfitAndStopClienVC.m
//  SimuStock
//
//  Created by tanxuming on 15/5/25.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ProfitAndStopClientVC.h"
#import "NewShowLabel.h"
#import "BaseRequester.h"
#import "StockUtil.h"
#import "ProcessInputData.h"
#import "SelectPositionStockViewController.h"

@implementation ProfitAndStopClientVC

/** 设定初始的股票代码和股票名称 */
- (id)initWithAccountId:(NSString *)accountId
          withTargetUid:(NSString *)targetUid
          WithStockCode:(NSString *)stockCode
          withStockName:(NSString *)stockName
            withMatchId:(NSString *)matchId
       withUserOrExpert:(StockBuySellType)userOrExpert {
  self = [super init];
  if (self) {
    self.tempStockCode = stockCode;
    self.tempStockName = stockName;
    self.scv_marichid = matchId;
    self.accountId = accountId;
    self.targetUid = targetUid;
    self.userOrExpert = userOrExpert;
  }
  return self;
}

#pragma mark - 对外提供方法 点击止盈止损按钮后 才调用查询
- (void)clickTheStopButton {
  if (_scv_profitAndStopView.stockCodeLabel.text.length != 0) {
    _scv_profitAndStopView.stockInfoDefaultLab.hidden = YES;
    [self statrNetLoadingView];
    [self
        querySellInfoWidthStockCode:_scv_profitAndStopView.stockCodeLabel.text];
  } else {
    if (self.indiactorStatrAnimation) {
      self.indiactorStopAnimation();
    }
  }
}

- (void)textFieldDealloc {
  [_scv_profitAndStopView.stopWinPriceTF resignFirstResponder];
  [_scv_profitAndStopView.stopWinRateTF resignFirstResponder];
  [_scv_profitAndStopView.stopLosePriceTF resignFirstResponder];
  [_scv_profitAndStopView.stopLoseRateTF resignFirstResponder];
  [_scv_profitAndStopView.stockSellNumTF resignFirstResponder];
}
/** 加载动画 */
- (void)statrNetLoadingView {
  if (self.indiactorStopAnimation) {
    self.indiactorStatrAnimation();
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(synchronousData:)
                                               name:@"SynchronousBuySellVCData"
                                             object:nil];
  _simuSellQueryData = [[SimuTradeBaseData alloc] init];
  _scv_buystockNumber = 0;
  _scv_lastprice = 0.0;
  _scv_buystockNumber = 0;
  //创建止盈止损信息
  [self creatProfitAndStopView];
  //创建股票价格信息视图
  [self creatStockInfoView];
  //开盘时间提醒
  [self creatopeningTimeView];

  self.tempStockCode.length == 0
      ? (_scv_profitAndStopView.stockInfoDefaultLab.hidden = NO)
      : (_scv_profitAndStopView.stockInfoDefaultLab.hidden = YES);

  _scv_profitAndStopView.stockCodeLabel.text = self.tempStockCode;
  _scv_profitAndStopView.stockNameLabel.text = self.tempStockName;
  if (self.indiactorStopAnimation) {
    self.indiactorStatrAnimation();
  }
  // [self querySellInfoWidthStockCode:self.tempStockCode];

  _textField1 = @[
    _scv_profitAndStopView.stopWinPriceTF,
    _scv_profitAndStopView.stopWinRateTF
  ];
  _textField2 = @[
    _scv_profitAndStopView.stopLosePriceTF,
    _scv_profitAndStopView.stopLoseRateTF
  ];
  _switchs = @[
    _scv_profitAndStopView.stopWinSwitch,
    _scv_profitAndStopView.stopLoseSwitch
  ];
  [_switchs enumerateObjectsUsingBlock:^(UISwitch *aSwitch, NSUInteger idx,
                                         BOOL *stop) {
    [aSwitch addTarget:self
                  action:@selector(changeSwitch:)
        forControlEvents:UIControlEventValueChanged];
  }];
  _scv_profitAndStopView.stopWinPriceTF.delegate = self;
  _scv_profitAndStopView.stopWinRateTF.delegate = self;
  _scv_profitAndStopView.stopLosePriceTF.delegate = self;
  _scv_profitAndStopView.stopLoseRateTF.delegate = self;
  _scv_profitAndStopView.stockSellNumTF.delegate = self;

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(synchronousToken:)
                                               name:@"SynchronousBuySellVCToken"
                                             object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(clearData)
                                               name:@"ClearProfitAndStopVCData"
                                             object:nil];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(textFiledEditChanged:)
             name:UITextFieldTextDidChangeNotification
           object:nil];
}

- (void)synchronousToken:(NSNotification *)notification {
  self.token = [notification.userInfo valueForKey:@"token"];
}

- (void)synchronousData:(NSNotification *)notification {

  NSString *stockCode = [notification.userInfo valueForKey:@"stockCode"];
  NSString *stockName = [notification.userInfo valueForKey:@"stockName"];
  stockCode.length == 0
      ? (_scv_profitAndStopView.stockInfoDefaultLab.hidden = NO)
      : (_scv_profitAndStopView.stockInfoDefaultLab.hidden = YES);
  _scv_profitAndStopView.stockCodeLabel.text = stockCode;
  _scv_profitAndStopView.stockNameLabel.text = stockName;
}

- (void)clearData {
  [self followingTransactionClearsData];
}

//收到通知后执行的方法
- (void)textFiledEditChanged:(NSNotification *)obj {
  UITextField *textField = (UITextField *)obj.object;
  NSString *toBeString = textField.text;
  if (_scv_profitAndStopView.stockSellNumTF == textField) {
    //过虑除数字以外的字符
    NSString *filtered = [ProcessInputData processDigitalData:toBeString];
    if (_simuSellQueryData != nil) {
      if ([filtered integerValue] <= _scv_buystockNumber) {
        textField.text = filtered;
        _scv_profitAndStopView.sliderView.value = [filtered integerValue];
      } else {
        textField.text =
            [NSString stringWithFormat:@"%lld", _scv_buystockNumber];
        _scv_profitAndStopView.sliderView.value = (float)_scv_buystockNumber;
      }
    } else {
      textField.text = filtered;
    }
  }
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)changeSwitch:(id)sender {

  //打开止盈开关止盈价止盈比例显示，止损开关关闭并清除数据
  if ([_scv_profitAndStopView.stopWinSwitch isEqual:sender] &&
      _scv_profitAndStopView.stopWinSwitch.on) {
    _scv_profitAndStopView.stopWinPriceTF.text = self.stopWinPri;
    _scv_profitAndStopView.stopWinPriceTF.textColor =
        [Globle colorFromHexRGB:Color_Black];
    _scv_profitAndStopView.stopWinRateTF.text = self.stopWinRate;
    _scv_profitAndStopView.stopWinRateTF.textColor =
        [Globle colorFromHexRGB:Color_Black];
    _scv_profitAndStopView.stopLosePriceTF.text = @"";
    _scv_profitAndStopView.stopLoseRateTF.text = @"";
    [_scv_profitAndStopView.stopLoseSwitch setOn:NO animated:YES];
    return;
  }

  //关闭止盈开关止盈价止盈比例清除
  if ([_scv_profitAndStopView.stopWinSwitch isEqual:sender] &&
      !_scv_profitAndStopView.stopWinSwitch.on) {
    _scv_profitAndStopView.stopWinPriceTF.text = @"";
    _scv_profitAndStopView.stopWinRateTF.text = @"";
    _scv_profitAndStopView.stopLosePriceTF.text = @"";
    _scv_profitAndStopView.stopLoseRateTF.text = @"";
    return;
  }

  //打开止损开关止损价止损比例显示，止盈开关关闭并清除数据
  if ([_scv_profitAndStopView.stopLoseSwitch isEqual:sender] &&
      _scv_profitAndStopView.stopLoseSwitch.on) {
    _scv_profitAndStopView.stopWinPriceTF.text = @"";
    _scv_profitAndStopView.stopWinRateTF.text = @"";
    _scv_profitAndStopView.stopLosePriceTF.text = self.stopLosePri;
    _scv_profitAndStopView.stopLosePriceTF.textColor =
        [Globle colorFromHexRGB:Color_Black];
    _scv_profitAndStopView.stopLoseRateTF.text = self.stopLoseRate;
    _scv_profitAndStopView.stopLoseRateTF.textColor =
        [Globle colorFromHexRGB:Color_Black];
    [_scv_profitAndStopView.stopWinSwitch setOn:NO animated:YES];
    return;
  }

  //关闭止损开关止损价止损比例清除
  if ([_scv_profitAndStopView.stopLoseSwitch isEqual:sender] &&
      !_scv_profitAndStopView.stopLoseSwitch.on) {
    _scv_profitAndStopView.stopWinPriceTF.text = @"";
    _scv_profitAndStopView.stopWinRateTF.text = @"";
    _scv_profitAndStopView.stopLosePriceTF.text = @"";
    _scv_profitAndStopView.stopLoseRateTF.text = @"";
    return;
  }
}

///限制输入个数（最多6位）且只能输入一个小数点且小数点后保留2位小数。
static const CGFloat MAXLENGTH = 3;
- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {

  NSString *newString =
      [textField.text stringByReplacingCharactersInRange:range
                                              withString:string];
  NSArray *arrayOfString = [newString componentsSeparatedByString:@"."];
  NSInteger decimalPointNum = arrayOfString.count - 1;
  if (newString.length <= textField.text.length) {
    return YES;
  }

  ///不允许有2个小数点
  if (decimalPointNum > 1) {
    return NO;
  }

  //禁止输入数字以外的非法字符。
  BOOL isValidChar = YES;
  NSCharacterSet *tmpSet =
      [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
  NSUInteger i = 0;
  while (i < string.length) {
    NSString *substring = [string substringWithRange:NSMakeRange(i, 1)];
    if ([substring rangeOfCharacterFromSet:tmpSet].length == 0) {
      isValidChar = NO;
      break;
    }
    i++;
  }
  if (!isValidChar) {
    return NO;
  }

  if ([textField isEqual:_scv_profitAndStopView.stockSellNumTF]) {
    //最多输入六位整数
    if (newString.length > 6) {
      return NO;
    }
    return YES;
  }

  //判断小数点后浮点数是否过长
  NSInteger limited = 0;
  if (_simuSellQueryData.tradeType == 1) {
    limited = 3;
  } else {
    limited = 2;
  }

  NSUInteger floatNumber = 0;
  if ([textField isEqual:_scv_profitAndStopView.stopWinRateTF] ||
      [textField isEqual:_scv_profitAndStopView.stopLoseRateTF]) {
    //判断总长度是否过长
    if (newString.length > 9) {
      return NO;
    }
    if (decimalPointNum > 0) {
      for (NSInteger i = newString.length - 1; i >= 0; i--) {
        if ([newString characterAtIndex:i] == '.') {
          if (floatNumber > 2) {
            return NO;
          }
          break;
        }
        floatNumber++;
      }
    }
    return YES;
  }

  NSUInteger floatNum = 0;
  if (decimalPointNum > 0) {
    for (NSInteger i = newString.length - 1; i >= 0; i--) {
      if ([newString characterAtIndex:i] == '.') {
        if (floatNum > limited) {
          return NO;
        }
        break;
      }
      floatNum++;
    }
  }

  //判断总长度是否过长
  if (newString.length > MAXLENGTH + floatNum + decimalPointNum) {
    return NO;
  }
  return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {

  if (_simuSellQueryData != nil) {
    [self calculate:textField];
  } else {
    return;
  }

  if ([_scv_profitAndStopView.stopWinPriceTF.text
          isEqualToString:_scv_profitAndStopView.costLabel.text] &&
      textField == _scv_profitAndStopView.stopWinPriceTF) {
    _scv_profitAndStopView.stopWinPriceTF.textColor =
        [Globle colorFromHexRGB:Color_Black];
    _scv_profitAndStopView.stopWinRateTF.textColor =
        [Globle colorFromHexRGB:Color_Red];
  } else if ([_scv_profitAndStopView.stopWinPriceTF.text
                 isEqualToString:_scv_profitAndStopView.costLabel.text] &&
             textField == _scv_profitAndStopView.stopWinRateTF) {
    _scv_profitAndStopView.stopWinPriceTF.textColor =
        [Globle colorFromHexRGB:Color_Red];
    _scv_profitAndStopView.stopWinRateTF.textColor =
        [Globle colorFromHexRGB:Color_Black];
  }

  if ([_scv_profitAndStopView.stopLosePriceTF.text
          isEqualToString:_scv_profitAndStopView.costLabel.text] &&
      textField == _scv_profitAndStopView.stopLosePriceTF) {
    _scv_profitAndStopView.stopLosePriceTF.textColor =
        [Globle colorFromHexRGB:Color_Black];
    _scv_profitAndStopView.stopLoseRateTF.textColor =
        [Globle colorFromHexRGB:Color_Red];
  } else if ([_scv_profitAndStopView.stopLosePriceTF.text
                 isEqualToString:_scv_profitAndStopView.costLabel.text] &&
             textField == _scv_profitAndStopView.stopLoseRateTF) {
    _scv_profitAndStopView.stopLosePriceTF.textColor =
        [Globle colorFromHexRGB:Color_Red];
    _scv_profitAndStopView.stopLoseRateTF.textColor =
        [Globle colorFromHexRGB:Color_Black];
  }

  if ([_textField1 containsObject:textField] &&
      !_scv_profitAndStopView.stopWinSwitch.on) {
    [_scv_profitAndStopView.stopWinSwitch setOn:YES animated:YES];
    [_scv_profitAndStopView.stopLoseSwitch setOn:NO animated:YES];
    _scv_profitAndStopView.stopWinPriceTF.text = self.stopWinPri;
    _scv_profitAndStopView.stopWinPriceTF.textColor =
        [Globle colorFromHexRGB:Color_Black];
    _scv_profitAndStopView.stopWinRateTF.text = self.stopWinRate;
    _scv_profitAndStopView.stopWinRateTF.textColor =
        [Globle colorFromHexRGB:Color_Black];
    _scv_profitAndStopView.stopLosePriceTF.text = @"";
    _scv_profitAndStopView.stopLoseRateTF.text = @"";
  } else if ([_textField2 containsObject:textField] &&
             !_scv_profitAndStopView.stopLoseSwitch.on) {
    [_scv_profitAndStopView.stopLoseSwitch setOn:YES animated:YES];
    [_scv_profitAndStopView.stopWinSwitch setOn:NO animated:YES];
    _scv_profitAndStopView.stopWinPriceTF.text = @"";
    _scv_profitAndStopView.stopWinRateTF.text = @"";
    _scv_profitAndStopView.stopLosePriceTF.text = self.stopLosePri;
    _scv_profitAndStopView.stopLosePriceTF.textColor =
        [Globle colorFromHexRGB:Color_Black];
    _scv_profitAndStopView.stopLoseRateTF.text = self.stopLoseRate;
    _scv_profitAndStopView.stopLoseRateTF.textColor =
        [Globle colorFromHexRGB:Color_Black];
  }
  // view上移
  if (textField == _scv_profitAndStopView.stockSellNumTF) {
    [self resetSelfViewUpper];
  }
}

///输入止盈价点击盈利达到自动计算出止盈率
- (void)calculate:(UITextField *)textField {

  //由止盈价推算止盈率
  if (_scv_profitAndStopView.stopWinSwitch.on &&
      textField == _scv_profitAndStopView.stopWinRateTF &&
      _scv_profitAndStopView.stopWinPriceTF.text.length != 0 &&
      [_scv_profitAndStopView.stopWinPriceTF.text floatValue] !=
          [self.stopWinPri floatValue]) {

    if ([_scv_profitAndStopView.stopWinPriceTF.text floatValue] <
        [_scv_profitAndStopView.costLabel.text floatValue]) {
      _scv_profitAndStopView.stopWinPriceTF.text =
          _scv_profitAndStopView.costLabel.text;
      _scv_profitAndStopView.stopWinPriceTF.textColor =
          [Globle colorFromHexRGB:Color_Red];
    } else {
      _scv_profitAndStopView.stopWinPriceTF.textColor =
          [Globle colorFromHexRGB:Color_Black];
      _scv_profitAndStopView.stopWinRateTF.textColor =
          [Globle colorFromHexRGB:Color_Black];
    }

    [self stopWinPriceToStopWinRate];
  }

  //由止盈率推算出止盈价
  if (_scv_profitAndStopView.stopWinSwitch.on &&
      textField == _scv_profitAndStopView.stopWinPriceTF &&
      _scv_profitAndStopView.stopWinRateTF.text.length != 0 &&
      [_scv_profitAndStopView.stopWinRateTF.text floatValue] !=
          [self.stopWinRate floatValue]) {
    _scv_profitAndStopView.stopWinPriceTF.textColor =
        [Globle colorFromHexRGB:Color_Black];
    [self stopWinRateToStopWinPrice];
  }

  //由止损价推算止损率
  if (_scv_profitAndStopView.stopLoseSwitch.on &&
      textField == _scv_profitAndStopView.stopLoseRateTF &&
      _scv_profitAndStopView.stopLosePriceTF.text.length != 0 &&
      [_scv_profitAndStopView.stopLosePriceTF.text floatValue] !=
          [self.stopLosePri floatValue]) {

    if ([_scv_profitAndStopView.stopLosePriceTF.text floatValue] >
        [_scv_profitAndStopView.costLabel.text floatValue]) {
      _scv_profitAndStopView.stopLosePriceTF.text =
          _scv_profitAndStopView.costLabel.text;
      _scv_profitAndStopView.stopLosePriceTF.textColor =
          [Globle colorFromHexRGB:Color_Red];
    } else {
      _scv_profitAndStopView.stopLosePriceTF.textColor =
          [Globle colorFromHexRGB:Color_Black];
      _scv_profitAndStopView.stopLoseRateTF.textColor =
          [Globle colorFromHexRGB:Color_Black];
    }

    [self stopLosePriceToStopLoseRate];
  }

  //由止损率推算止盈价
  if (_scv_profitAndStopView.stopLoseSwitch.on &&
      textField == _scv_profitAndStopView.stopLosePriceTF &&
      _scv_profitAndStopView.stopLoseRateTF.text.length != 0 &&
      [_scv_profitAndStopView.stopLoseRateTF.text floatValue] !=
          [self.stopLoseRate floatValue]) {
    [self stopLoseRateToStopLosePrice];
    _scv_profitAndStopView.stopLosePriceTF.textColor =
        [Globle colorFromHexRGB:Color_Black];
  }
}

//收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self textFieldDealloc];
}

#pragma mark - 刷新
- (void)refreshButtonPressDownSDFS {
  if (_scv_profitAndStopView.stockCodeLabel.text.length != 0) {
    if (self.indiactorStatrAnimation) {
      self.indiactorStatrAnimation();
    }
    [self querySellInfoWidthStockCode:self.tempStockCode];
  } else {
    if (self.indiactorStopAnimation) {
      self.indiactorStopAnimation();
    }
  }
}

#pragma mark 卖出查询
- (void)querySellInfoWidthStockCode:(NSString *)stockCode {
  if (stockCode == nil || stockCode.length == 0) {
    [self stopLoading];
    return;
  }

  if (![SimuUtil isLogined]) {
    [self stopLoading];
    return;
  }

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak ProfitAndStopClientVC *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    ProfitAndStopClientVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    ProfitAndStopClientVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindSimuDoSellQueryData:(SimuTradeBaseData *)obj];
    }
  };
  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };

  callback.onError = ^(BaseRequestObject *error, NSException *ex) {
    if (error) {
      if ([error.status isEqualToString:@"0101"]) {
        [[NSNotificationCenter defaultCenter]
            postNotificationName:Illegal_Logon_SimuStock
                          object:nil];
      } else {
        if ([error.message isEqualToString:@"该" @"股"
                           @"票停牌，仅允许市价卖出"]) {
          return [NewShowLabel
              setMessageContent:
                  @"该股票已停牌，不能进行卖出操作"];
        }
        [NewShowLabel setMessageContent:error.message];
      }
      return;
    }
    [NewShowLabel setMessageContent:REQUEST_FAILED_MESSAGE];
  };

  if (_userOrExpert == StockBuySellOrdinaryType) {
    [SimuTradeBaseData requestSimuDoSellQueryDataWithMatchId:self.scv_marichid
                                               withStockCode:stockCode
                                                withCatagory:@"5"
                                                withCallback:callback];

  } else if (_userOrExpert == StockBuySellExpentType) {
    [SimuTradeBaseData requestExpertPlanSell:self.accountId
                                withCategory:@"5"
                               withStockCode:stockCode
                                withCallback:callback];
  }
}

#pragma mark 卖出查询回调
- (void)bindSimuDoSellQueryData:(SimuTradeBaseData *)sellQueryData {

  //信息记录
  _simuSellQueryData = sellQueryData;

  self.token = _simuSellQueryData.token;

  _format =
      [StockUtil getPriceFormatWithTradeType:_simuSellQueryData.tradeType];

  self.stopWinPri = [NSString
      stringWithFormat:_format, [@([_simuSellQueryData.stopWinPri floatValue])
                                        floatValue]];
  ;

  self.stopLosePri = [NSString
      stringWithFormat:_format, [@([_simuSellQueryData.stopLosePri floatValue])
                                        floatValue]];

  self.stopWinRate = [NSString
      stringWithFormat:@"%.2f", [@([_simuSellQueryData.stopWinRate floatValue] *
                                   100) floatValue]];
  self.stopLoseRate = [NSString
      stringWithFormat:@"%.2f",
                       [@([_simuSellQueryData.stopLoseRate floatValue] * 100)
                               floatValue]];

  @try {
    _scv_profitAndStopView.costLabel.text =
        [NSString stringWithFormat:_format, _simuSellQueryData.costPri];
  }
  @catch (NSException *exception) {
    NSLog(@"%@", exception);
  }

  _scv_profitAndStopView.currentProfitAndLossLab.text = [NSString
      stringWithFormat:@"%.2f%%", [@([sellQueryData.profitRate floatValue] *
                                     100) floatValue]];

  if ([sellQueryData.profitRate floatValue] == 0) {

    _scv_profitAndStopView.currentProfitAndLossLab.textColor =
        [Globle colorFromHexRGB:Color_Black];
    _scv_profitAndStopView.costLabel.textColor =
        [Globle colorFromHexRGB:Color_Black];

  } else if ([sellQueryData.profitRate floatValue] > 0) {

    _scv_profitAndStopView.currentProfitAndLossLab.textColor =
        [Globle colorFromHexRGB:Color_Red];
    _scv_profitAndStopView.costLabel.textColor =
        [Globle colorFromHexRGB:Color_Red];
  } else if ([sellQueryData.profitRate floatValue] < 0) {

    _scv_profitAndStopView.currentProfitAndLossLab.textColor =
        [Globle colorFromHexRGB:Color_Green];
    _scv_profitAndStopView.costLabel.textColor =
        [Globle colorFromHexRGB:Color_Green];
  } else {
    _scv_profitAndStopView.currentProfitAndLossLab.textColor =
        [Globle colorFromHexRGB:Color_Black];
    _scv_profitAndStopView.costLabel.textColor =
        [Globle colorFromHexRGB:Color_Black];
  }

  _scv_lastprice = sellQueryData.salePrice;
  _scv_profitAndStopView.stockSellNumTF.text = sellQueryData.sellable;
  _scv_buystockNumber = [sellQueryData.sellable longLongValue];
  if (_scv_profitAndStopView.sliderView) {
    if ([sellQueryData.sellable longLongValue] >= 1) {
      _scv_profitAndStopView.sliderView.minimumValue = 1;
      _scv_profitAndStopView.sliderView.maximumValue =
          [sellQueryData.sellable longLongValue];
      _scv_profitAndStopView.sliderView.value =
          [sellQueryData.sellable longLongValue];
      _scv_profitAndStopView.miniLabel.text = @"1";
      _scv_profitAndStopView.maxLabel.text = [NSString
          stringWithFormat:@"%lld", [sellQueryData.sellable longLongValue]];
    } else {
      [self sliderDataInitialization];
    }
  }

  NSDictionary *userInfo = @{
    @"stockCode" : _simuSellQueryData.stockCode,
    @"stockName" : _simuSellQueryData.stockName,
    @"firstType" :
        [NSString stringWithFormat:@"%d", (int)_simuSellQueryData.tradeType],
    @"buyAmount" : _simuSellQueryData.sellable
  };
  [[NSNotificationCenter defaultCenter]
      postNotificationName:@"SynchronousWinLoseVCData"
                    object:nil
                  userInfo:userInfo];

  if (_scv_stockInfoView) {
    [_scv_stockInfoView setUserPageData:sellQueryData isBuy:NO];
  }
  [_scv_profitAndStopView.stopWinSwitch setOn:NO];
  [_scv_profitAndStopView.stopLoseSwitch setOn:NO];
  _scv_profitAndStopView.stopWinPriceTF.text = @"";
  _scv_profitAndStopView.stopWinRateTF.text = @"";
  _scv_profitAndStopView.stopLosePriceTF.text = @"";
  _scv_profitAndStopView.stopLoseRateTF.text = @"";
}

//滑块数据初始化
- (void)sliderDataInitialization {
  _scv_profitAndStopView.miniLabel.text = @"0";
  _scv_profitAndStopView.maxLabel.text = @"0";
  _scv_lastprice = 0.0;
  _scv_buystockNumber = 0;
}

- (void)setNoNetwork {
  [NewShowLabel showNoNetworkTip]; //显示无网络提示
  if (self.indiactorStopAnimation) {
    self.indiactorStopAnimation();
  }
}

- (void)stopLoading {
  [self stopNetLoadingView];
}

/**
 *停止动画
 */
- (void)stopNetLoadingView {
  //菊花停止
  [self.indicatorView stopAnimating];
  if (self.indiactorStatrAnimation) {
    self.indiactorStatrAnimation();
  }
}

//创建股票价格信息视图
- (void)creatStockInfoView {
  _scv_stockInfoView = (SimuStockInfoView *)
      [[[NSBundle mainBundle] loadNibNamed:@"SimuStockInfoView"
                                     owner:nil
                                   options:nil] firstObject];
  _scv_stockInfoView.frame =
      CGRectMake(0, 275, self.view.bounds.size.width, 90);
  [_scv_stockInfoView setTradeType:NO];
  [self.view addSubview:_scv_stockInfoView];
}

//创建止盈止损视图
- (void)creatProfitAndStopView {
  _scv_profitAndStopView = (ProfitAndStopView *)
      [[[NSBundle mainBundle] loadNibNamed:@"ProfitAndStopView"
                                     owner:nil
                                   options:nil] firstObject];
  [_scv_profitAndStopView.sellBtn addTarget:self
                                     action:@selector(sellBtnClick)
                           forControlEvents:UIControlEventTouchUpInside];
  _scv_profitAndStopView.stockInfoDefaultLab.hidden = YES;
  //添加tap手势跳转到个人交易明细页面
  [self addTapGesture];

  self.view.backgroundColor = [UIColor whiteColor];
  //  self.view.backgroundColor = [Globle colorFromHexRGB:@"ffffff"];
  self.view.clipsToBounds = YES;
  [self.view addSubview:_scv_profitAndStopView];
}

//在stockInfoView添加tap手势
- (void)addTapGesture {

  UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(creatSearchStockView)];
  singleTap.numberOfTapsRequired = 1;
  singleTap.numberOfTouchesRequired = 1;
  [_scv_profitAndStopView.stockInfoView addGestureRecognizer:singleTap];
}

- (void)sellBtnClick {
  //无网判断
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }

  if (_simuSellQueryData.newstockPrice == 0) {
    [NewShowLabel setMessageContent:@"获取股票信息失败,请刷新"];
    return;
  }

  if (_scv_profitAndStopView.stockCodeLabel.text.length == 0) {
    [NewShowLabel setMessageContent:@"请选择要卖出的股票"];
    return;
  }

  //  //有网但是没有获取到最新价的情况下
  //  if ([_scv_profitAndStopView.costLabel.text isEqualToString:@"--"]) {
  //    [NewShowLabel setMessageContent:@"获取股票信息失败,请刷新"];
  //    return;
  //  }

  NSInteger inputMount =
      [_scv_profitAndStopView.stockSellNumTF.text integerValue];

  NSString *content = nil;
  //卖出
  if (inputMount == 0) {
    content = @"卖出数量必须大于0，小于可卖股数";
    [self anotherAlartView:content];
    return;
  } else {
    CGFloat highMonunt = 0.0f;
    highMonunt = [_simuSellQueryData.sellable floatValue];
    if (inputMount > highMonunt) {
      content = [NSString
          stringWithFormat:
              @"止盈止损数量大于您的持有数量，请重新输入"];
      [self anotherAlartView:content];
      return;
    }
  }

  if ([_scv_profitAndStopView.stopLoseRateTF isFirstResponder]) {
    [self stopLoseRateToStopLosePrice];
  }

  if ([_scv_profitAndStopView.stopWinRateTF isFirstResponder]) {
    [self stopWinRateToStopWinPrice];
  }

  if (![_scv_profitAndStopView validateStopWinPrice] &&
      _scv_profitAndStopView.stopWinSwitch.on) {
    [NewShowLabel setMessageContent:@"止盈价应大于成本价"];
    _scv_profitAndStopView.stopWinPriceTF.text =
        _scv_profitAndStopView.costLabel.text;
    _scv_profitAndStopView.stopWinPriceTF.textColor =
        [Globle colorFromHexRGB:Color_Red];
    _scv_profitAndStopView.stopWinRateTF.text = @"0.00";
    _scv_profitAndStopView.stopWinRateTF.textColor =
        [Globle colorFromHexRGB:Color_Red];
    return;
  }

  if (![_scv_profitAndStopView validateStopLosePrice] &&
      _scv_profitAndStopView.stopLoseSwitch.on) {
    [NewShowLabel setMessageContent:@"止跌价应小于成本价"];
    _scv_profitAndStopView.stopLosePriceTF.text =
        _scv_profitAndStopView.costLabel.text;
    _scv_profitAndStopView.stopLosePriceTF.textColor =
        [Globle colorFromHexRGB:Color_Red];
    _scv_profitAndStopView.stopLoseRateTF.text = @"0.00";
    _scv_profitAndStopView.stopLoseRateTF.textColor =
        [Globle colorFromHexRGB:Color_Red];

    return;
  }

  if (!_scv_profitAndStopView.stopWinSwitch.on &&
      !_scv_profitAndStopView.stopLoseSwitch.on) {
    [NewShowLabel setMessageContent:@"请开启止盈或止损按钮"];
    return;
  }

  if (_scv_profitAndStopView.stopLoseSwitch.on) {
    if ([_scv_profitAndStopView.stopLosePriceTF isFirstResponder]) {
      [self calculateForSellClick:_scv_profitAndStopView.stopLosePriceTF];
    } else {
      [self calculateForSellClick:_scv_profitAndStopView.stopLoseRateTF];
    }
    NSString *content = [NSString
        stringWithFormat:@"您确定要以%@元的止损价卖出[%@]%@股吗?",
                         _scv_profitAndStopView.stopLosePriceTF.text,
                         _scv_profitAndStopView.stockNameLabel.text,
                         _scv_profitAndStopView.stockSellNumTF.text];
    //如果是止损价
    [self alertShow:content];
    return;
  }

  if (_scv_profitAndStopView.stopWinSwitch.on) {
    if ([_scv_profitAndStopView.stopWinPriceTF isFirstResponder]) {
      [self calculateForSellClick:_scv_profitAndStopView.stopWinPriceTF];
    } else {
      [self calculateForSellClick:_scv_profitAndStopView.stopWinRateTF];
    }

    NSString *content = [NSString
        stringWithFormat:@"您确定要以%@元的止盈价卖出[%@]%@股吗?",
                         _scv_profitAndStopView.stopWinPriceTF.text,
                         _scv_profitAndStopView.stockNameLabel.text,
                         _scv_profitAndStopView.stockSellNumTF.text];
    //如果是止盈价
    [self alertShow:content];
    return;
  }
}

///输入了止盈价，点击卖出自动计算出相应的止盈率
- (void)calculateForSellClick:(UITextField *)textField {

  //由止盈价推算止盈率
  if (_scv_profitAndStopView.stopWinSwitch.on &&
      textField == _scv_profitAndStopView.stopWinPriceTF) {
    [self stopWinPriceToStopWinRate];
    [self resetStopWinTextFieldColor];
  }

  //由止盈率推算出止盈价
  if (_scv_profitAndStopView.stopWinSwitch.on &&
      textField == _scv_profitAndStopView.stopWinRateTF) {
    [self stopWinRateToStopWinPrice];
    [self resetStopWinTextFieldColor];
  }

  //由止损价推算止损率
  if (_scv_profitAndStopView.stopLoseSwitch.on &&
      textField == _scv_profitAndStopView.stopLosePriceTF) {
    [self stopLosePriceToStopLoseRate];
    [self resetStopLoseTextFieldColor];
  }

  //由止损率推算止盈价
  if (_scv_profitAndStopView.stopLoseSwitch.on &&
      textField == _scv_profitAndStopView.stopLoseRateTF) {
    [self resetStopLoseTextFieldColor];
    [self stopLoseRateToStopLosePrice];
  }
}

///重置止盈textFiled颜色
- (void)resetStopWinTextFieldColor {
  _scv_profitAndStopView.stopWinPriceTF.textColor =
      [Globle colorFromHexRGB:Color_Black];
  _scv_profitAndStopView.stopWinRateTF.textColor =
      [Globle colorFromHexRGB:Color_Black];
}

///止盈价推算出止盈率
- (void)stopWinPriceToStopWinRate {
  if ([_scv_profitAndStopView.costLabel.text floatValue] != 0) {
    _scv_profitAndStopView.stopWinRateTF.text = [NSString
        stringWithFormat:
            @"%.2f", (([_scv_profitAndStopView.stopWinPriceTF.text floatValue] -
                       [_scv_profitAndStopView.costLabel.text floatValue]) /
                      [_scv_profitAndStopView.costLabel.text floatValue]) *
                         100];
  }
}

///止盈率推算出止盈价
- (void)stopWinRateToStopWinPrice {
  NSNumber *stopWinPri =
      @((int)[_scv_profitAndStopView.costLabel.text floatValue] *
            ([_scv_profitAndStopView.stopWinRateTF.text floatValue] / 100) +
        [_scv_profitAndStopView.costLabel.text floatValue]);
  if ([stopWinPri floatValue] > 1000) {
    _scv_profitAndStopView.stopWinPriceTF.text = @"999.99";
  } else {
    if (_format.length != 0) {
      _scv_profitAndStopView.stopWinPriceTF.text = [NSString
          stringWithFormat:
              _format,
              [_scv_profitAndStopView.costLabel.text floatValue] *
                      ([_scv_profitAndStopView.stopWinRateTF.text floatValue] /
                       100) +
                  [_scv_profitAndStopView.costLabel.text floatValue]];
    } else {
      // Do Nothing
    }
  }
}

///重置止损textFiled颜色
- (void)resetStopLoseTextFieldColor {
  _scv_profitAndStopView.stopLosePriceTF.textColor =
      [Globle colorFromHexRGB:Color_Black];
  _scv_profitAndStopView.stopLoseRateTF.textColor =
      [Globle colorFromHexRGB:Color_Black];
}

///止损价推算出止损率
- (void)stopLosePriceToStopLoseRate {
  if ([_scv_profitAndStopView.costLabel.text floatValue] != 0) {
    _scv_profitAndStopView.stopLoseRateTF.text = [NSString
        stringWithFormat:@"%.2f",
                         (([_scv_profitAndStopView.costLabel.text floatValue] -
                           [_scv_profitAndStopView.stopLosePriceTF
                                   .text floatValue]) /
                          [_scv_profitAndStopView.costLabel.text floatValue]) *
                             100];
  } else {
    return;
  }
}

///止损率推算出止损价
- (void)stopLoseRateToStopLosePrice {

  if ([_scv_profitAndStopView.stopLoseRateTF.text floatValue] >= 100) {
    if (_format.length != 0) {
      _scv_profitAndStopView.stopLosePriceTF.text = [NSString
          stringWithFormat:
              _format,
              [_scv_profitAndStopView.costLabel.text floatValue] -
                  ([_scv_profitAndStopView.costLabel.text floatValue] * 0.99)];
    } else {
      // Do nothing
    }

  } else {
    if (_format.length != 0) {
      _scv_profitAndStopView.stopLosePriceTF.text = [NSString
          stringWithFormat:
              _format,
              [_scv_profitAndStopView.costLabel.text floatValue] -
                  ([_scv_profitAndStopView.costLabel.text floatValue] *
                   ([_scv_profitAndStopView.stopLoseRateTF.text floatValue] /
                    100))];
    } else {
      // Do nothing
    }
  }
}

- (void)alertShow:(NSString *)message {
  __weak ProfitAndStopClientVC *weakSelf = self;
  if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    UIAlertController *alertController = [UIAlertController
        alertControllerWithTitle:@"温馨提示"
                         message:message
                  preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction =
        [UIAlertAction actionWithTitle:@"取消"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action){
                               }];

    [alertController addAction:cancelAction];

    UIAlertAction *yesAction =
        [UIAlertAction actionWithTitle:@"确定"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action) {
                                 if (_scv_profitAndStopView.stopLoseSwitch.on) {
                                   [weakSelf doStopLoseRequest];
                                 }

                                 if (_scv_profitAndStopView.stopWinSwitch.on) {
                                   [weakSelf doStopWinRequest];
                                 }
                               }];

    [alertController addAction:yesAction];

    [self presentViewController:alertController animated:YES completion:nil];
  } else {
    //提示框
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    [alert show];
  }
}

//创建警告框
- (void)anotherAlartView:(NSString *)message {

  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                  message:message
                                                 delegate:nil
                                        cancelButtonTitle:@"确定"
                                        otherButtonTitles:nil, nil];
  [alert show];
}

- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) {

    if (_scv_profitAndStopView.stopLoseSwitch.on) {
      [self doStopLoseRequest];
    }

    if (_scv_profitAndStopView.stopWinSwitch.on) {
      [self doStopWinRequest];
    }
  } else {
    // doNothing
  }
}

#pragma mark 止盈下单
- (void)doStopWinRequest {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];

  callback.onSuccess = ^(NSObject *obj) {
    if (_scvc_openingTimeView.sttbv_alarmIV.hidden == NO) {
      NSString *message = [NSString
          stringWithFormat:@"您的委托\"卖出%@"
                           @"\"已提交\n现在休市，要等到开盘后才可能成交哦",
                           _scv_profitAndStopView.stockNameLabel.text];
      [NewShowLabel setMessageContent:message];
    }

    NSLog(@"止盈下单成功!!!");
    _sellBtnClickBlock();
    [self followingTransactionClearsData];
  };
  callback.onFailed = ^{
    NSLog(@"止盈下单失败!!!");
  };

  callback.onError = ^(BaseRequestObject *error, NSException *ex) {
    if (error) {
      if ([error.status isEqualToString:@"0101"]) {
        [[NSNotificationCenter defaultCenter]
            postNotificationName:Illegal_Logon_SimuStock
                          object:nil];
      } else {
        if ([error.message isEqualToString:@"该" @"股"
                           @"票停牌，仅允许市价卖出"]) {
          return [NewShowLabel
              setMessageContent:
                  @"该股票已停牌，不能进行卖出操作"];
        }
        [NewShowLabel setMessageContent:error.message];
      }
      return;
    }
    [NewShowLabel setMessageContent:REQUEST_FAILED_MESSAGE];
  };

  if (_userOrExpert == StockBuySellOrdinaryType) {
    [SimuTradeBaseData requestProfitAndStopWithMatchId:self.scv_marichid
                                         withStockCode:_scv_profitAndStopView
                                                           .stockCodeLabel.text
                                            withAmount:_scv_profitAndStopView
                                                           .stockSellNumTF.text
                                             withToken:self.token
                                          withCategory:@"2"
                                             withPrice:_scv_profitAndStopView
                                                           .stopWinPriceTF.text
                                          withCallback:callback];
  } else if (_userOrExpert == StockBuySellExpentType) {

    [SimuTradeBaseData
        requestExpertProfitAndStopWithAccountId:self.accountId
                                   withCategory:@"2"
                                  withStockCode:_scv_profitAndStopView
                                                    .stockCodeLabel.text
                                      withPrice:_scv_profitAndStopView
                                                    .stopWinPriceTF.text
                                     withAmount:_scv_profitAndStopView
                                                    .stockSellNumTF.text
                                      withToken:self.token
                                   withCallback:callback];
  }
}

#pragma mark 止损下单
- (void)doStopLoseRequest {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];

  callback.onSuccess = ^(NSObject *obj) {
    //交易股票信息
    if (_scvc_openingTimeView.sttbv_alarmIV.hidden == NO) {
      NSString *message = [NSString
          stringWithFormat:@"您的委托\"卖出%@"
                           @"\"已提交\n现在休市，要等到开盘后才可能成交哦",
                           _scv_profitAndStopView.stockNameLabel.text];
      [NewShowLabel setMessageContent:message];
    }
    NSLog(@"止损下单成功!!!");
    _sellBtnClickBlock();
    [self followingTransactionClearsData];
  };

  callback.onFailed = ^{
    NSLog(@"止损下单失败!!!");
  };

  callback.onError = ^(BaseRequestObject *error, NSException *ex) {
    if (error) {
      if ([error.status isEqualToString:@"0101"]) {
        [[NSNotificationCenter defaultCenter]
            postNotificationName:Illegal_Logon_SimuStock
                          object:nil];
      } else {
        if ([error.message isEqualToString:@"该" @"股"
                           @"票停牌，仅允许市价卖出"]) {
          return [NewShowLabel
              setMessageContent:
                  @"该股票已停牌，不能进行卖出操作"];
        }
        [NewShowLabel setMessageContent:error.message];
      }
      return;
    }
    [NewShowLabel setMessageContent:REQUEST_FAILED_MESSAGE];
  };

  if (_userOrExpert == StockBuySellOrdinaryType) {
    [SimuTradeBaseData requestProfitAndStopWithMatchId:self.scv_marichid
                                         withStockCode:_scv_profitAndStopView
                                                           .stockCodeLabel.text
                                            withAmount:_scv_profitAndStopView
                                                           .stockSellNumTF.text
                                             withToken:self.token
                                          withCategory:@"3"
                                             withPrice:_scv_profitAndStopView
                                                           .stopLosePriceTF.text
                                          withCallback:callback];

  } else if (_userOrExpert == StockBuySellExpentType) {
    [SimuTradeBaseData
        requestExpertProfitAndStopWithAccountId:self.accountId
                                   withCategory:@"3"
                                  withStockCode:_scv_profitAndStopView
                                                    .stockCodeLabel.text
                                      withPrice:_scv_profitAndStopView
                                                    .stopLosePriceTF.text
                                     withAmount:_scv_profitAndStopView
                                                    .stockSellNumTF.text
                                      withToken:self.token
                                   withCallback:callback];
  }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
  if (textField == _scv_profitAndStopView.stockSellNumTF) {
    [self resetSelfViewDown];
  } else if (textField == _scv_profitAndStopView.stopWinPriceTF &&
             _scv_profitAndStopView.stopWinSwitch.on) {
    [self stopWinPriceToStopWinRate];
  } else if (textField == _scv_profitAndStopView.stopWinRateTF &&
             _scv_profitAndStopView.stopWinSwitch.on) {
    [self stopWinRateToStopWinPrice];
  } else if (textField == _scv_profitAndStopView.stopLosePriceTF &&
             _scv_profitAndStopView.stopLoseSwitch.on) {
    [self stopLosePriceToStopLoseRate];
  } else if (textField == _scv_profitAndStopView.stopLoseRateTF &&
             _scv_profitAndStopView.stopLoseSwitch.on) {
    [self stopLoseRateToStopLosePrice];
  }
}

//弹键盘view上移
- (void)resetSelfViewUpper {
  ///日涨幅弹键盘view竖直位移距离
  static const CGFloat displacementofdailyGains = 50;

  CGRect frame = _scv_profitAndStopView.frame;

  [UIView animateWithDuration:0.001
                   animations:^{
                     _scv_profitAndStopView.frame = CGRectMake(
                         0, frame.origin.y - displacementofdailyGains,
                         frame.size.width, frame.size.height);
                   }];
}

//收键盘view下移
- (void)resetSelfViewDown {
  CGRect frame = _scv_profitAndStopView.frame;
  [UIView animateWithDuration:0.001
                   animations:^{
                     _scv_profitAndStopView.frame =
                         CGRectMake(0, 0, frame.size.width, frame.size.height);
                   }];
}

//交易成功后清空数据
- (void)followingTransactionClearsData {

  self.stopLosePri = @"";
  self.stopWinPri = @"";
  self.stopWinRate = @"";
  self.stopLoseRate = @"";
  _simuSellQueryData = nil;
  _scv_buystockNumber = 0.0;
  _scv_lastprice = 0.0;

  [_scv_profitAndStopView resetView];
  [self textFieldDealloc];

  if (_scv_stockInfoView) {
    [_scv_stockInfoView clearControlData];
  }
}

//创上方闹钟和时间显示控件
- (void)creatopeningTimeView {
  if (_scvc_openingTimeView == nil) {
    _scvc_openingTimeView = [[OpeningTimeView alloc]
        initWithFrame:CGRectMake(10.0, 250, self.view.bounds.size.width, 29.5)];
    _scvc_openingTimeView.backgroundColor = [UIColor clearColor];
    [_scv_profitAndStopView addSubview:_scvc_openingTimeView];
    [_scvc_openingTimeView timeVisible:NO];
  }
}

//创建搜索股票页面
- (void)creatSearchStockView {

  SelectPositionStockViewController *searchView =
      [[SelectPositionStockViewController alloc]
            initWithMatchId:self.scv_marichid
          withStartPageType:InSellStockPage
              withAccountId:self.accountId
              withTargetUid:self.targetUid
           withUserOrExpert:self.userOrExpert
               withCallBack:^(NSString *code, NSString *stockName,
                              NSString *firstType) {
                 [_scvc_openingTimeView timeVisible:YES];
                 if (code == nil || [code length] < 2)
                   return;
                 _scv_profitAndStopView.stockCodeLabel.text = code;
                 _scv_profitAndStopView.stockNameLabel.text = stockName;
                 _scv_profitAndStopView.stockInfoDefaultLab.hidden = YES;
                 [self querySellInfoWidthStockCode:code];
               }];

  [AppDelegate pushViewControllerFromRight:searchView];
}

@end

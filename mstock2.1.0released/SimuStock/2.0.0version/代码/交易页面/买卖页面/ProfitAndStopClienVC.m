//
//  ProfitAndStopClienVC.m
//  SimuStock
//
//  Created by jhss on 15/5/25.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ProfitAndStopClienVC.h"
#import "BaseRequester.h"

@implementation ProfitAndStopClienVC
- (id)initWithStockCode:(NSString *)stockCode
          withStockName:(NSString *)stockName
            withMatchId:(NSString *)matchId {
  if (self = [super init]) {
    self.tempStockCode = stockCode;
    self.tempStockName = stockName;
    self.scv_marichid = matchId;
  }
  return self;
}
- (void)viewDidLoad {
  [super viewDidLoad];

  simuSellQueryData = [[SimuTradeBaseData alloc] init];
  scv_buystockNumber = 0;
  scv_lastprice = 0.0;
  scv_buystockNumber = 0;
  //创建止盈止损信息
  [self creatProfitAndStopView];
  //创建股票价格信息视图
  [self creatStockInfoView];
  //开盘时间提醒
  [self creatopeningTimeView];
  scv_profitAndStopView.stockCodeLabel.text = self.tempStockCode;
  scv_profitAndStopView.stockNameLabel.text = self.tempStockName;
  if (self.indiactorStopAnimation) {
    self.indiactorStatrAnimation();
  }
  [self querySellInfoWidthStockCode:self.tempStockCode];

  textField1 = @[
    scv_profitAndStopView.stopWinPriceTF,
    scv_profitAndStopView.stopWinRateTF
  ];
  textField2 = @[
    scv_profitAndStopView.stopLosePriceTF,
    scv_profitAndStopView.stopLoseRateTF
  ];
  switchs = @[
    scv_profitAndStopView.stopWinSwitch,
    scv_profitAndStopView.stopLoseSwitch
  ];
  [switchs enumerateObjectsUsingBlock:^(UISwitch *aSwitch, NSUInteger idx,
                                        BOOL *stop) {
    [aSwitch addTarget:self
                  action:@selector(changeSwitch:)
        forControlEvents:UIControlEventValueChanged];
  }];
  scv_profitAndStopView.stopWinPriceTF.delegate = self;
  scv_profitAndStopView.stopWinRateTF.delegate = self;
  scv_profitAndStopView.stopLosePriceTF.delegate = self;
  scv_profitAndStopView.stopLoseRateTF.delegate = self;
  scv_profitAndStopView.stockSellNumTF.delegate = self;

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(textFiledEditChanged:)
             name:UITextFieldTextDidChangeNotification
           object:nil];
}

//收到通知后执行的方法
- (void)textFiledEditChanged:(NSNotification *)obj {
  UITextField *textField = (UITextField *)obj.object;
  NSString *toBeString = textField.text;
  if (scv_profitAndStopView.stockSellNumTF == textField) {
    //过虑除数字以外的字符
    NSString *filtered = [ProcessInputData processDigitalData:toBeString];
    if ([filtered integerValue] <= scv_buystockNumber) {
      textField.text = filtered;
      scv_profitAndStopView.sliderView.value = [filtered integerValue];
    } else {
      textField.text = [NSString stringWithFormat:@"%lld", scv_buystockNumber];
      scv_profitAndStopView.sliderView.value = (float)scv_buystockNumber;
    }
  }
}

- (void)dealloc {

  [[NSNotificationCenter defaultCenter]
      removeObserver:self
                name:UITextFieldTextDidChangeNotification
              object:nil];
}

- (void)changeSwitch:(id)sender {

  //打开止盈开关止盈价止盈比例显示，止损开关关闭并清除数据
  if ([scv_profitAndStopView.stopWinSwitch isEqual:sender] &&
      scv_profitAndStopView.stopWinSwitch.on) {
    scv_profitAndStopView.stopWinPriceTF.text = self.stopWinPri;
    scv_profitAndStopView.stopWinPriceTF.textColor =
        [Globle colorFromHexRGB:Color_Black];
    scv_profitAndStopView.stopWinRateTF.text = self.stopWinRate;
    scv_profitAndStopView.stopWinRateTF.textColor =
        [Globle colorFromHexRGB:Color_Black];
    scv_profitAndStopView.stopLosePriceTF.text = @"";
    scv_profitAndStopView.stopLoseRateTF.text = @"";
    [scv_profitAndStopView.stopLoseSwitch setOn:NO animated:YES];
    return;
  }

  //关闭止盈开关止盈价止盈比例清除
  if ([scv_profitAndStopView.stopWinSwitch isEqual:sender] &&
      !scv_profitAndStopView.stopWinSwitch.on) {
    scv_profitAndStopView.stopWinPriceTF.text = @"";
    scv_profitAndStopView.stopWinRateTF.text = @"";
    scv_profitAndStopView.stopLosePriceTF.text = @"";
    scv_profitAndStopView.stopLoseRateTF.text = @"";
    return;
  }

  //打开止损开关止损价止损比例显示，止盈开关关闭并清除数据
  if ([scv_profitAndStopView.stopLoseSwitch isEqual:sender] &&
      scv_profitAndStopView.stopLoseSwitch.on) {
    scv_profitAndStopView.stopWinPriceTF.text = @"";
    scv_profitAndStopView.stopWinRateTF.text = @"";
    scv_profitAndStopView.stopLosePriceTF.text = self.stopLosePri;
    scv_profitAndStopView.stopLosePriceTF.textColor =
        [Globle colorFromHexRGB:Color_Black];
    scv_profitAndStopView.stopLoseRateTF.text = self.stopLoseRate;
    scv_profitAndStopView.stopLoseRateTF.textColor =
        [Globle colorFromHexRGB:Color_Black];
    [scv_profitAndStopView.stopWinSwitch setOn:NO animated:YES];
    return;
  }

  //关闭止损开关止损价止损比例清除
  if ([scv_profitAndStopView.stopLoseSwitch isEqual:sender] &&
      !scv_profitAndStopView.stopLoseSwitch.on) {
    scv_profitAndStopView.stopWinPriceTF.text = @"";
    scv_profitAndStopView.stopWinRateTF.text = @"";
    scv_profitAndStopView.stopLosePriceTF.text = @"";
    scv_profitAndStopView.stopLoseRateTF.text = @"";
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

  if ([textField isEqual:scv_profitAndStopView.stockSellNumTF]) {
    //禁止输入数字和小数点以外的非法字符。
    BOOL isValidChar = YES;
    NSCharacterSet *tmpSet =
        [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
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

    //最多输入六位整数
    if (newString.length > 6) {
      return NO;
    }
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

  //判断小数点后浮点数是否过长
  NSInteger limited = 0;
  if ([StockUtil isFund:_firstType]) {
    limited = 3;
  } else {
    limited = 2;
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

  //由止盈价推算止盈率
  if (scv_profitAndStopView.stopWinSwitch.on &&
      textField == scv_profitAndStopView.stopWinRateTF &&
      scv_profitAndStopView.stopWinPriceTF.text.length != 0 &&
      [scv_profitAndStopView.stopWinPriceTF.text floatValue] !=
          [self.stopWinPri floatValue]) {

    if ([scv_profitAndStopView.stopWinPriceTF.text floatValue] <
        [scv_profitAndStopView.costLabel.text floatValue]) {
      scv_profitAndStopView.stopWinPriceTF.text =
          scv_profitAndStopView.costLabel.text;
      scv_profitAndStopView.stopWinPriceTF.textColor =
          [Globle colorFromHexRGB:Color_Red];
    }

    scv_profitAndStopView.stopWinRateTF.text = [NSString
        stringWithFormat:
            @"%.2f", (([scv_profitAndStopView.stopWinPriceTF.text floatValue] -
                       [scv_profitAndStopView.costLabel.text floatValue]) /
                      [scv_profitAndStopView.costLabel.text floatValue]) *
                         100];
  }

  //由止盈率推算出止盈价
  if (scv_profitAndStopView.stopWinSwitch.on &&
      textField == scv_profitAndStopView.stopWinPriceTF &&
      scv_profitAndStopView.stopWinRateTF.text.length != 0 &&
      [scv_profitAndStopView.stopWinRateTF.text floatValue] !=
          [self.stopWinRate floatValue]) {
    scv_profitAndStopView.stopWinPriceTF.text = [NSString
        stringWithFormat:@"%.2f",
                         [scv_profitAndStopView.costLabel.text floatValue] *
                                 ([scv_profitAndStopView.stopWinRateTF
                                          .text floatValue] /
                                  100) +
                             [scv_profitAndStopView.costLabel.text floatValue]];
  }

  //由止损价推算止损率
  if (scv_profitAndStopView.stopLoseSwitch.on &&
      textField == scv_profitAndStopView.stopLoseRateTF &&
      scv_profitAndStopView.stopLosePriceTF.text.length != 0 &&
      [scv_profitAndStopView.stopLosePriceTF.text floatValue] !=
          [self.stopLosePri floatValue]) {

    if ([scv_profitAndStopView.stopLosePriceTF.text floatValue] >
        [scv_profitAndStopView.costLabel.text floatValue]) {
      scv_profitAndStopView.stopLosePriceTF.text =
          scv_profitAndStopView.costLabel.text;
      scv_profitAndStopView.stopLosePriceTF.textColor =
          [Globle colorFromHexRGB:Color_Red];
    }
    scv_profitAndStopView.stopLoseRateTF.text = [NSString
        stringWithFormat:@"%.2f",
                         (([scv_profitAndStopView.costLabel.text floatValue] -
                           [scv_profitAndStopView.stopLosePriceTF
                                   .text floatValue]) /
                          [scv_profitAndStopView.costLabel.text floatValue]) *
                             100];
  }

  //由止损率推算止盈价
  if (scv_profitAndStopView.stopLoseSwitch.on &&
      textField == scv_profitAndStopView.stopLosePriceTF &&
      scv_profitAndStopView.stopLoseRateTF.text.length != 0 &&
      [scv_profitAndStopView.stopLoseRateTF.text floatValue] !=
          [self.stopLoseRate floatValue]) {
    scv_profitAndStopView.stopLosePriceTF.text = [NSString
        stringWithFormat:
            @"%.2f",
            [scv_profitAndStopView.costLabel.text floatValue] -
                ([scv_profitAndStopView.costLabel.text floatValue] *
                 ([scv_profitAndStopView.stopLoseRateTF.text floatValue] /
                  100))];
  }

  if ([scv_profitAndStopView.stopWinPriceTF.text
          isEqualToString:scv_profitAndStopView.costLabel.text] &&
      textField == scv_profitAndStopView.stopWinPriceTF) {
    scv_profitAndStopView.stopWinPriceTF.textColor =
        [Globle colorFromHexRGB:Color_Black];
    scv_profitAndStopView.stopWinRateTF.textColor =
        [Globle colorFromHexRGB:Color_Red];
  } else if ([scv_profitAndStopView.stopWinPriceTF.text
                 isEqualToString:scv_profitAndStopView.costLabel.text] &&
             textField == scv_profitAndStopView.stopWinRateTF) {
    scv_profitAndStopView.stopWinPriceTF.textColor =
        [Globle colorFromHexRGB:Color_Red];
    scv_profitAndStopView.stopWinRateTF.textColor =
        [Globle colorFromHexRGB:Color_Black];
  }

  if ([scv_profitAndStopView.stopLosePriceTF.text
          isEqualToString:scv_profitAndStopView.costLabel.text] &&
      textField == scv_profitAndStopView.stopLosePriceTF) {
    scv_profitAndStopView.stopLosePriceTF.textColor =
        [Globle colorFromHexRGB:Color_Black];
    scv_profitAndStopView.stopLoseRateTF.textColor =
        [Globle colorFromHexRGB:Color_Red];
  } else if ([scv_profitAndStopView.stopLosePriceTF.text
                 isEqualToString:scv_profitAndStopView.costLabel.text] &&
             textField == scv_profitAndStopView.stopLoseRateTF) {
    scv_profitAndStopView.stopLosePriceTF.textColor =
        [Globle colorFromHexRGB:Color_Red];
    scv_profitAndStopView.stopLoseRateTF.textColor =
        [Globle colorFromHexRGB:Color_Black];
  }

  if ([textField1 containsObject:textField] &&
      !scv_profitAndStopView.stopWinSwitch.on) {
    [scv_profitAndStopView.stopWinSwitch setOn:YES animated:YES];
    [scv_profitAndStopView.stopLoseSwitch setOn:NO animated:YES];
    scv_profitAndStopView.stopWinPriceTF.text = self.stopWinPri;
    scv_profitAndStopView.stopWinPriceTF.textColor =
        [Globle colorFromHexRGB:Color_Black];
    scv_profitAndStopView.stopWinRateTF.text = self.stopWinRate;
    scv_profitAndStopView.stopWinRateTF.textColor =
        [Globle colorFromHexRGB:Color_Black];
    scv_profitAndStopView.stopLosePriceTF.text = @"";
    scv_profitAndStopView.stopLoseRateTF.text = @"";
  } else if ([textField2 containsObject:textField] &&
             !scv_profitAndStopView.stopLoseSwitch.on) {
    [scv_profitAndStopView.stopLoseSwitch setOn:YES animated:YES];
    [scv_profitAndStopView.stopWinSwitch setOn:NO animated:YES];
    scv_profitAndStopView.stopWinPriceTF.text = @"";
    scv_profitAndStopView.stopWinRateTF.text = @"";
    scv_profitAndStopView.stopLosePriceTF.text = self.stopLosePri;
    scv_profitAndStopView.stopLosePriceTF.textColor =
        [Globle colorFromHexRGB:Color_Black];
    scv_profitAndStopView.stopLoseRateTF.text = self.stopLoseRate;
    scv_profitAndStopView.stopLoseRateTF.textColor =
        [Globle colorFromHexRGB:Color_Black];
  }
  // view上移
  if (textField == scv_profitAndStopView.stockSellNumTF) {
    [self resetSelfViewUpper];
  }
}
//收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [scv_profitAndStopView.stopWinPriceTF resignFirstResponder];
  [scv_profitAndStopView.stopWinRateTF resignFirstResponder];
  [scv_profitAndStopView.stopLosePriceTF resignFirstResponder];
  [scv_profitAndStopView.stopLoseRateTF resignFirstResponder];
  [scv_profitAndStopView.stockSellNumTF resignFirstResponder];
}

#pragma mark - 刷新
- (void)refreshButtonPressDown
{
  if (self.indiactorStopAnimation) {
    self.indiactorStatrAnimation();
  }
  if (scv_profitAndStopView.stockCodeLabel.text.length != 0) {
    [self querySellInfoWidthStockCode:self.tempStockCode];
  }else{
    if (self.indiactorStatrAnimation) {
      self.indiactorStopAnimation();
    }
  }
  
}

#pragma mark 卖出查询
- (void)querySellInfoWidthStockCode:(NSString *)stockCode {
  if (stockCode == nil || stockCode.length == 0)
    return;

  if (![SimuUtil isLogined]) {
    return;
  }

  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak ProfitAndStopClienVC *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    ProfitAndStopClienVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    ProfitAndStopClienVC *strongSelf = weakSelf;
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

  [SimuTradeBaseData requestSimuDoSellQueryDataWithMatchId:self.scv_marichid
                                             withStockCode:stockCode
                                              withCatagory:@"5"
                                              withCallback:callback];
}

#pragma mark 卖出查询回调
- (void)bindSimuDoSellQueryData:(SimuTradeBaseData *)sellQueryData {

  //信息记录
  simuSellQueryData = sellQueryData;

  //绑定止盈止损信息
  self.stopWinPri = [NSString
      stringWithFormat:@"%.2f", [@([simuSellQueryData.stopWinPri floatValue])
                                        floatValue]];
  ;
  self.stopWinRate = [NSString
      stringWithFormat:@"%.2f", [@([simuSellQueryData.stopWinRate floatValue] *
                                   100) floatValue]];
  ;

  self.stopLosePri = [NSString
      stringWithFormat:@"%.2f", [@([simuSellQueryData.stopLosePri floatValue])
                                        floatValue]];
  self.stopLoseRate = [NSString
      stringWithFormat:@"%.2f", [@([simuSellQueryData.stopLoseRate floatValue] *
                                   100) floatValue]];

  NSString *format =
      [StockUtil getPriceFormatWithTradeType:simuSellQueryData.tradeType];

  @try {
    scv_profitAndStopView.costLabel.text =
        [NSString stringWithFormat:format, simuSellQueryData.costPri];
  }
  @catch (NSException *exception) {
    NSLog(@"%@", exception);
  }

  scv_profitAndStopView.currentProfitAndLossLab.text = [NSString
      stringWithFormat:@"%.2f%%", [@([sellQueryData.profitRate floatValue] *
                                     100) floatValue]];

  if ([sellQueryData.profitRate floatValue] == 0) {

    scv_profitAndStopView.currentProfitAndLossLab.textColor =
        [Globle colorFromHexRGB:Color_Black];
    scv_profitAndStopView.costLabel.textColor =
        [Globle colorFromHexRGB:Color_Black];

  } else if ([sellQueryData.profitRate floatValue] > 0) {

    scv_profitAndStopView.currentProfitAndLossLab.textColor =
        [Globle colorFromHexRGB:Color_Red];
    scv_profitAndStopView.costLabel.textColor =
        [Globle colorFromHexRGB:Color_Red];
  } else if ([sellQueryData.profitRate floatValue] < 0) {

    scv_profitAndStopView.currentProfitAndLossLab.textColor =
        [Globle colorFromHexRGB:Color_Green];
    scv_profitAndStopView.costLabel.textColor =
        [Globle colorFromHexRGB:Color_Green];
  } else {
    scv_profitAndStopView.currentProfitAndLossLab.textColor =
        [Globle colorFromHexRGB:Color_Black];
    scv_profitAndStopView.costLabel.textColor =
        [Globle colorFromHexRGB:Color_Black];
  }

  scv_lastprice = sellQueryData.salePrice;
  scv_profitAndStopView.stockSellNumTF.text = sellQueryData.sellable;
  scv_buystockNumber = [sellQueryData.sellable longLongValue];
  if (scv_profitAndStopView.sliderView) {
    if ([sellQueryData.sellable longLongValue] >= 1) {
      scv_profitAndStopView.sliderView.minimumValue = 1;
      scv_profitAndStopView.sliderView.maximumValue =
          [sellQueryData.sellable longLongValue];
      scv_profitAndStopView.sliderView.value =
          [sellQueryData.sellable longLongValue];
      scv_profitAndStopView.miniLabel.text = @"1";
      scv_profitAndStopView.maxLabel.text = [NSString
          stringWithFormat:@"%lld", [sellQueryData.sellable longLongValue]];
    } else {
      [self sliderDataInitialization];
    }
  }
  if (scv_stockInfoView) {
    [scv_stockInfoView setUserPageData:sellQueryData isBuy:NO];
  }
}

//滑块数据初始化
- (void)sliderDataInitialization {
  scv_profitAndStopView.miniLabel.text = @"0";
  scv_profitAndStopView.maxLabel.text = @"0";
  scv_lastprice = 0.0;
  scv_buystockNumber = 0;
}
- (void)setNoNetwork {
  [NewShowLabel showNoNetworkTip];//显示无网络提示
  if (self.indiactorStatrAnimation) {
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
  //加入阻塞
  if ([NetLoadingWaitView isAnimating]) {
    [NetLoadingWaitView stopAnimating];
  }
  //菊花停止
  if (self.indiactorStatrAnimation) {
    self.indiactorStopAnimation();
  }
}

//创建股票价格信息视图
- (void)creatStockInfoView {
  scv_stockInfoView = (SimuStockInfoView *)
      [[[NSBundle mainBundle] loadNibNamed:@"SimuStockInfoView"
                                     owner:nil
                                   options:nil] firstObject];
  scv_stockInfoView.frame = CGRectMake(0, 275, self.view.bounds.size.width, 90);
  [scv_stockInfoView setTradeType:NO];
  [self.view addSubview:scv_stockInfoView];
}

//创建止盈止损视图
- (void)creatProfitAndStopView {
  scv_profitAndStopView = (ProfitAndStopView *)
      [[[NSBundle mainBundle] loadNibNamed:@"ProfitAndStopView"
                                     owner:nil
                                   options:nil] firstObject];
  [scv_profitAndStopView.sellBtn addTarget:self
                                    action:@selector(sellBtnClick)
                          forControlEvents:UIControlEventTouchUpInside];
  scv_profitAndStopView.stockInfoDefaultLab.hidden = YES;
  //添加tap手势跳转到个人交易明细页面
  [self addTapGesture];

  self.view.backgroundColor = [UIColor whiteColor];
//  self.view.backgroundColor = [Globle colorFromHexRGB:@"ffffff"];
  self.view.clipsToBounds = YES;
  [self.view addSubview:scv_profitAndStopView];
}

//在stockInfoView添加tap手势
- (void)addTapGesture {

  UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]
      initWithTarget:self
              action:@selector(creatSearchStockView)];
  singleTap.numberOfTapsRequired = 1;
  singleTap.numberOfTouchesRequired = 1;
  [scv_profitAndStopView.stockInfoView addGestureRecognizer:singleTap];
}

- (void)sellBtnClick {
  //无网判断
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }

  if (scv_profitAndStopView.stockCodeLabel.text.length == 0) {
    [NewShowLabel setMessageContent:@"请选择要卖出的股票"];
    return;
  }

  //有网但是没有获取到最新价的情况下，提示"没有获取到行情数据，无法设置提醒"
  if ([scv_profitAndStopView.costLabel.text isEqualToString:@"--"]) {
    [NewShowLabel setMessageContent:@"获取股票信息失败"];
    return;
  }

  if (![scv_profitAndStopView validateStopWinPrice] &&
      ![scv_profitAndStopView.stopWinPriceTF.text isEqualToString:@""]) {
    [NewShowLabel setMessageContent:@"止盈价应大于成本价"];
    scv_profitAndStopView.stopWinPriceTF.text =
        scv_profitAndStopView.costLabel.text;
    scv_profitAndStopView.stopWinPriceTF.textColor =
        [Globle colorFromHexRGB:Color_Red];
    scv_profitAndStopView.stopWinRateTF.text = @"0.00";
    scv_profitAndStopView.stopWinRateTF.textColor =
        [Globle colorFromHexRGB:Color_Red];
    return;
  }

  if (![scv_profitAndStopView validateStopLosePrice] &&
      ![scv_profitAndStopView.stopLosePriceTF.text isEqualToString:@""]) {
    [NewShowLabel setMessageContent:@"止跌价应小于成本价"];
    scv_profitAndStopView.stopLosePriceTF.text =
        scv_profitAndStopView.costLabel.text;
    scv_profitAndStopView.stopLosePriceTF.textColor =
        [Globle colorFromHexRGB:Color_Red];
    scv_profitAndStopView.stopLoseRateTF.text = @"0.00";
    scv_profitAndStopView.stopLoseRateTF.textColor =
        [Globle colorFromHexRGB:Color_Red];

    return;
  }

  if (!scv_profitAndStopView.stopWinSwitch.on &&
      !scv_profitAndStopView.stopLoseSwitch.on) {
    [NewShowLabel setMessageContent:@"请开启止盈或止损按钮"];
    return;
  }

  if (scv_profitAndStopView.stopLoseSwitch.on) {
    NSString *content = [NSString
        stringWithFormat:@"您确定要以%@元的止损价卖出[%@]%@股吗?",
                         scv_profitAndStopView.stopLosePriceTF.text,
                         scv_profitAndStopView.stockNameLabel.text,
                         scv_profitAndStopView.stockSellNumTF.text];
    //如果是限价
    [self alertShow:content];
    return;
  }

  if (scv_profitAndStopView.stopWinSwitch.on) {
    NSString *content = [NSString
        stringWithFormat:@"您确定要以%@元的止盈价卖出[%@]%@股吗?",
                         scv_profitAndStopView.stopLosePriceTF.text,
                         scv_profitAndStopView.stockNameLabel.text,
                         scv_profitAndStopView.stockSellNumTF.text];
    //如果是限价
    [self alertShow:content];
    return;
  }
}

- (void)alertShow:(NSString *)message {
  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                  message:message
                                                 delegate:self
                                        cancelButtonTitle:@"取消"
                                        otherButtonTitles:@"确定", nil];
  [alert show];
}

- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) {

    if (scv_profitAndStopView.stopLoseSwitch.on) {
      [self doStopLoseRequest];
    }

    if (scv_profitAndStopView.stopWinSwitch.on) {
      [self doStopWinRequest];
    }
  }
}
#pragma mark 止盈下单
- (void)doStopWinRequest {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];

  callback.onSuccess = ^(NSObject *obj) {
    NSLog(@"止盈下单成功!!!");
    [self followingTransactionClearsData];
  };
  callback.onFailed = ^{
    NSLog(@"止盈下单失败!!!");
  };

  callback.onError = ^(BaseRequestObject *error, NSException *ex) {
    NSLog(@"止盈下单异常!!!");
  };

  [SimuTradeBaseData
      requestProfitAndStopWithMatchId:MATCHID
                        withStockCode:scv_profitAndStopView.stockCodeLabel.text
                           withAmount:scv_profitAndStopView.stockSellNumTF.text
                            withToken:simuSellQueryData.token
                         withCategory:@"2"
                            withPrice:scv_profitAndStopView.stopWinPriceTF.text
                         withCallback:callback];
}

#pragma mark 止损下单
- (void)doStopLoseRequest {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];

  callback.onSuccess = ^(NSObject *obj) {
    NSLog(@"止损下单成功!!!");
    [self followingTransactionClearsData];
  };
  callback.onFailed = ^{
    NSLog(@"止损下单失败!!!");
  };

  callback.onError = ^(BaseRequestObject *error, NSException *ex) {
    NSLog(@"止损下单异常!!!");
  };

  [SimuTradeBaseData
      requestProfitAndStopWithMatchId:MATCHID
                        withStockCode:scv_profitAndStopView.stockCodeLabel.text
                           withAmount:scv_profitAndStopView.stockSellNumTF.text
                            withToken:simuSellQueryData.token
                         withCategory:@"3"
                            withPrice:scv_profitAndStopView.stopLosePriceTF.text
                         withCallback:callback];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {

  if (textField == scv_profitAndStopView.stockSellNumTF) {
    [self resetSelfViewDown];
  }
}

//弹键盘view上移
- (void)resetSelfViewUpper {
  ///日涨幅弹键盘view竖直位移距离
  static const CGFloat displacementofdailyGains = 50;

  CGRect frame = scv_profitAndStopView.frame;

  [UIView animateWithDuration:0.001
                   animations:^{
                     scv_profitAndStopView.frame = CGRectMake(
                         0, frame.origin.y - displacementofdailyGains,
                         frame.size.width, frame.size.height);
                   }];
}

//收键盘view下移
- (void)resetSelfViewDown {
  CGRect frame = scv_profitAndStopView.frame;
  [UIView animateWithDuration:0.001
                   animations:^{
                     scv_profitAndStopView.frame =
                         CGRectMake(0, 0, frame.size.width, frame.size.height);
                   }];
}

//交易成功后清空数据
- (void)followingTransactionClearsData {
  [scv_profitAndStopView resetView];
  if (scv_stockInfoView) {
    [scv_stockInfoView clearControlData];
  }
}

//创上方闹钟和时间显示控件
- (void)creatopeningTimeView {
  if (scvc_openingTimeView == nil) {
    scvc_openingTimeView = [[OpeningTimeView alloc]
        initWithFrame:CGRectMake(10.0, 250, self.view.bounds.size.width, 29.5)];
    scvc_openingTimeView.backgroundColor = [UIColor clearColor];
    [scv_profitAndStopView addSubview:scvc_openingTimeView];
    [scvc_openingTimeView timeVisible:NO];
  }
}

//创建搜索股票页面
- (void)creatSearchStockView {
  SelectPositionStockViewController *searchView =
      [[SelectPositionStockViewController alloc]
            initWithMatchId:self.scv_marichid
          withStartPageType:OtherSellPage
               withCallBack:^(NSString *code, NSString *stockName,
                              NSString *firstType) {
                 [scvc_openingTimeView timeVisible:YES];
                 if (code == nil || [code length] < 2)
                   return;
                 scv_profitAndStopView.stockCodeLabel.text = code;
                 scv_profitAndStopView.stockNameLabel.text = stockName;
                 scv_profitAndStopView.stockInfoDefaultLab.hidden = YES;
                 [self querySellInfoWidthStockCode:code];
               }];
  [AppDelegate pushViewControllerFromRight:searchView];
}

@end

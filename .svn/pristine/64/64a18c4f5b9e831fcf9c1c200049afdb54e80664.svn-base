//
//  FirmSaleBuyOrSellInputView.m
//  SimuStock
//
//  Created by Yuemeng on 14-9-22.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "FirmSaleBuyOrSellInputView.h"

#import "SimuUtil.h"
#import "ProcessInputData.h"
#import "NewShowLabel.h"

#import "StockDBManager.h"
#import "StockUtil.h"

#define DISTANCE_OF_INDENT 20.0 / 2 //行首行尾缩进距离

@interface FirmSaleBuyOrSellInputView () {
  //涨停价格
  NSString *_hightPrice;
  //跌停价格
  NSString *_downPrice;
}

@end

@implementation FirmSaleBuyOrSellInputView

///默认显示2位有效数字
static NSInteger decimalNum = 2;

- (id)initWithFrame:(CGRect)frame isBuy:(BOOL)buyOrSell {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    isBuy = buyOrSell;
    self.addAndSubtract = NO;
    decimalNum = 2;
    [self createUI];
  }
  return self;
}

static CGFloat RowHeight = 68.0 / 2;
static CGFloat PriceHeight = 70.0 / 2;
static CGFloat UpDownWidth = 72.f / 2;

- (void)createUI {
  //添加键盘改变通知
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(textFieldEditChanged:)
                                               name:UITextFieldTextDidChangeNotification
                                             object:nil];

  //选股按钮（隐藏的，位于股票代码和名称之下）
  _selectStockButton = [UIButton buttonWithType:UIButtonTypeCustom];
  _selectStockButton.frame = CGRectMake(0, 0, self.width, RowHeight);
  _selectStockButton.layer.backgroundColor = [[UIColor whiteColor] CGColor];
  _selectStockButton.layer.borderColor = [[Globle colorFromHexRGB:Color_Border] CGColor]; // Color_Border
  _selectStockButton.layer.borderWidth = 1;
  [_selectStockButton addTarget:self
                         action:@selector(selectStockButtonClick)
               forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:_selectStockButton];

  //股票代码label
  _stockCodeLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(DISTANCE_OF_INDENT, 0, self.width - DISTANCE_OF_INDENT, RowHeight)];
  _stockCodeLabel.text = @"选择股票";
  _stockCodeLabel.textColor = [Globle colorFromHexRGB:Color_Gray];
  _stockCodeLabel.textAlignment = NSTextAlignmentLeft;
  _stockCodeLabel.font = [UIFont systemFontOfSize:26.0 / 2];
  [self addSubview:_stockCodeLabel];
  _stockCodeLabel.userInteractionEnabled = NO;

  _stockCodeLabel.backgroundColor = [UIColor clearColor];

  //股票名称label
  _stockNameLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width - DISTANCE_OF_INDENT, RowHeight)];
  _stockNameLabel.textAlignment = NSTextAlignmentRight;
  _stockNameLabel.font = [UIFont systemFontOfSize:26.0 / 2];
  [self addSubview:_stockNameLabel];
  _stockNameLabel.userInteractionEnabled = NO;
  _stockNameLabel.backgroundColor = [UIColor clearColor];
  _stockNameLabel.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  _stockNameLabel.backgroundColor = [UIColor clearColor];

  //“股票价格”显示股价的textField
  _stockPriceTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 88.0 / 2, self.width, PriceHeight)];
  _stockPriceTextField.textAlignment = NSTextAlignmentCenter;
  _stockPriceTextField.backgroundColor = [UIColor whiteColor];
  _stockPriceTextField.layer.borderColor = [[Globle colorFromHexRGB:Color_Border] CGColor];
  _stockPriceTextField.layer.borderWidth = 1;
  _stockPriceTextField.keyboardType = UIKeyboardTypeDecimalPad;
  _stockPriceTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  [self addSubview:_stockPriceTextField];

  //减价按钮，每次减少0.01
  _subButton = [UIButton buttonWithType:UIButtonTypeCustom];
  _subButton.frame = CGRectMake(0, 88.0 / 2, UpDownWidth, PriceHeight);
  _subButton.backgroundColor = [Globle colorFromHexRGB:@"#06a31c"];
  //点击变色
  [_subButton setImage:[SimuUtil imageFromColor:@"#087217"] forState:UIControlStateHighlighted];
  //"-"图片
  UIImageView *subImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sub"]];
  subImageView.frame = CGRectMake(19.0 / 2, 10.0 / 2, 34.0 / 2, 34.0 / 2);
  // 0.01label
  _stepLabelLeft = [[UILabel alloc] initWithFrame:CGRectMake(0, 52.0 / 2, 72.0 / 2, 18.0 / 2)];
  _stepLabelLeft.text = @"0.01";
  _stepLabelLeft.textAlignment = NSTextAlignmentCenter;
  _stepLabelLeft.textColor = [Globle colorFromHexRGB:Color_White];
  _stepLabelLeft.font = [UIFont systemFontOfSize:Font_Height_14_0 / 2];
  _stepLabelLeft.backgroundColor = [UIColor clearColor];
  [_subButton addSubview:subImageView];
  [_subButton addSubview:_stepLabelLeft];
  [_subButton addTarget:self
                 action:@selector(priceButtonClick:)
       forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:_subButton];

  //加价按钮，每次增加0.01
  _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
  _addButton.frame = CGRectMake(self.width - UpDownWidth, 88.0 / 2, UpDownWidth, PriceHeight);
  _addButton.backgroundColor = [Globle colorFromHexRGB:@"#e43006"];
  //点击变色
  [_addButton setImage:[SimuUtil imageFromColor:@"#b02a0a"] forState:UIControlStateHighlighted];
  //"+"图片
  UIImageView *addImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add"]];
  addImageView.frame = CGRectMake(19.0 / 2, 10.0 / 2, 34.0 / 2, 34.0 / 2);
  // 0.01label
  _stepLabelRight = [[UILabel alloc] initWithFrame:CGRectMake(0, 52.0 / 2, UpDownWidth, 18.0 / 2)];
  _stepLabelRight.text = @"0.01";
  _stepLabelRight.textAlignment = NSTextAlignmentCenter;
  _stepLabelRight.textColor = [Globle colorFromHexRGB:Color_White];
  _stepLabelRight.font = [UIFont systemFontOfSize:Font_Height_14_0 / 2];
  _stepLabelRight.backgroundColor = [UIColor clearColor];
  [_addButton addSubview:addImageView];
  [_addButton addSubview:_stepLabelRight];
  [_addButton addTarget:self
                 action:@selector(priceButtonClick:)
       forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:_addButton];

  //减价按钮下面的跌停Label
  _downStopLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 164.0 / 2, self.width / 2, 21.0 / 2)];
  _downStopLabel.textAlignment = NSTextAlignmentLeft;
  _downStopLabel.font = [UIFont systemFontOfSize:Font_Height_21_0 / 2];
  _downStopLabel.textColor = [Globle colorFromHexRGB:Color_Green];
  _downStopLabel.backgroundColor = [UIColor clearColor];
  [self addSubview:_downStopLabel];

  //加价按钮下面的涨停Label
  _upStopLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(self.width / 2, 164.0 / 2, self.width / 2, 21.0 / 2)];
  _upStopLabel.textAlignment = NSTextAlignmentRight;
  _upStopLabel.font = [UIFont systemFontOfSize:Font_Height_21_0 / 2];
  _upStopLabel.textColor = [Globle colorFromHexRGB:Color_Red];
  _upStopLabel.backgroundColor = [UIColor clearColor];
  [self addSubview:_upStopLabel];

  //“数量”。输入的股票数量文本框，判断是否为数字，否则return
  _stockNumberTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 199.0 / 2, self.width, RowHeight)];
  _stockNumberTextField.placeholder = @"数量";
  _stockNumberTextField.font = [UIFont systemFontOfSize:26.0 / 2];
  _stockNumberTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  _stockNumberTextField.textAlignment = NSTextAlignmentLeft;
  _stockNumberTextField.leftView =
      [[UIView alloc] initWithFrame:CGRectMake(0, 0, DISTANCE_OF_INDENT, RowHeight)];
  _stockNumberTextField.leftViewMode = UITextFieldViewModeAlways;
  _stockNumberTextField.layer.backgroundColor = [[UIColor whiteColor] CGColor];
  _stockNumberTextField.layer.borderColor = [[Globle colorFromHexRGB:Color_Border] CGColor];
  _stockNumberTextField.layer.borderWidth = 1;
  _stockNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
  _stockNumberTextField.backgroundColor = [UIColor clearColor];
  [self addSubview:_stockNumberTextField];

  //“可买9900股”。显示的可买或可卖数量的label，根据isBuy来区分显示“可买入xx数量”或“可卖出xx数量“
  _couldBuyOrSellNumberLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(self.width / 2, 199.0 / 2, self.width / 2 - DISTANCE_OF_INDENT, RowHeight)];
  _couldBuyOrSellNumberLabel.textAlignment = NSTextAlignmentRight;
  _couldBuyOrSellNumberLabel.font = [UIFont systemFontOfSize:26.0 / 2];
  _couldBuyOrSellNumberLabel.textColor = [Globle colorFromHexRGB:@"#939393"];
  _couldBuyOrSellNumberLabel.backgroundColor = [UIColor clearColor];
  [self addSubview:_couldBuyOrSellNumberLabel];

  //买入或卖出button
  _buyOrSellButton = [UIButton buttonWithType:UIButtonTypeCustom];
  _buyOrSellButton.titleLabel.textAlignment = NSTextAlignmentCenter;
  _buyOrSellButton.titleLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:40.0 / 2];
  [_buyOrSellButton setBackgroundImage:[SimuUtil imageFromColor:Color_Blue_but]
                              forState:UIControlStateNormal];

  //点击变色
  [_buyOrSellButton setBackgroundImage:[SimuUtil imageFromColor:@"#055081"]
                              forState:UIControlStateHighlighted];
  //禁用颜色
  [_buyOrSellButton setBackgroundImage:[SimuUtil imageFromColor:@"#afb3b5"]
                              forState:UIControlStateDisabled];
  [_buyOrSellButton addTarget:self
                       action:@selector(buyOrSellButtonClick)
             forControlEvents:UIControlEventTouchUpInside];
  _buyOrSellButton.frame = CGRectMake(1.0 / 2, 287.0 / 2, self.width - 1, 73.0 / 2);
  if (isBuy) {
    [_buyOrSellButton setTitle:@"买入" forState:UIControlStateNormal];
    [_buyOrSellButton setTitle:@"买入" forState:UIControlStateHighlighted];
  } else {
    [_buyOrSellButton setTitle:@"卖出" forState:UIControlStateNormal];
    [_buyOrSellButton setTitle:@"卖出" forState:UIControlStateHighlighted];
  }
  [self addSubview:_buyOrSellButton];
  [self setNeedsLayout];
}

#pragma mark - button触发的方法
//选择股票按钮
- (void)selectStockButtonClick {
  _selectStockButtonClickBlock();
}

//加减价按钮
- (void)priceButtonClick:(UIButton *)button {
  //如果还没选股票，直接返回
  if (!_stockNameLabel.text) {
    return;
  }
  CGFloat stockPrice;
  if (_addButton == button) {
    stockPrice = [_stockPriceTextField.text floatValue] + [_stepLabelRight.text floatValue];
  } else if (_subButton == button) {
    stockPrice = [_stockPriceTextField.text floatValue] - [_stepLabelLeft.text floatValue];
  } else {
    return;
  }

  NSString *localStockPrice;
  if ([_stepLabelLeft.text doubleValue] <= 0.001) {
    localStockPrice = [NSString stringWithFormat:@"%.3f", stockPrice];
  } else if ([_stepLabelLeft.text doubleValue] <= 0.01) {
    localStockPrice = [NSString stringWithFormat:@"%.2f", stockPrice];
  } else {
    localStockPrice = [NSString stringWithFormat:@"%.1f", stockPrice];
  }
  //回调数据请求
  _computeEntrustAmountBlock(_stockCodeLabel.text, localStockPrice, YES);
}

//判断是基金还是股票
- (BOOL)judgmentIsTheFundOrStock:(NSString *)stockCode andStockName:(NSString *)stockName {
  NSArray *array;
  //通过8位股票代码查询
  if ([stockCode length] == 8) {
    array = [StockDBManager searchFromDataBaseWith8CharCode:stockCode withRealTradeFlag:YES];
  }
  //通过股票名称查询
  if (array == nil || [array count] == 0) {
    array = [StockDBManager searchFromDataBaseWithName:stockName withRealTradeFlag:YES];
  }
  //通过股票代码片段查询， 可能出现混淆的情况
  if (array == nil || [array count] == 0) {
    array = [StockDBManager searchStockWithQueryText:stockCode withRealTradeFlag:YES];
  }

  if (array && [array count] > 0) {
    StockFunds *stock = array[0];
    BOOL fundIsStock = [StockUtil isFund:[stock.firstType stringValue]];
    return fundIsStock;
  }
  return NO;
}

//买入或卖出按钮
- (void)buyOrSellButtonClick {
  //先收键盘
  [_stockPriceTextField resignFirstResponder];
  [_stockNumberTextField resignFirstResponder];

  //如果股票名称为空，则提示用户选择
  if (!_stockNameLabel.text) {
    if (isBuy) {
      [NewShowLabel setMessageContent:@"请选择要买入的股票"];
    } else {
      [NewShowLabel setMessageContent:@"请选择要卖出的股票"];
    }
    return;
  }

  //如果价格范围不正确，则AlertView提示
  [_stockPriceTextField.text floatValue];
  if ([_stockPriceTextField.text floatValue] <= 0) {
    [[[UIAlertView alloc] initWithTitle:@"温馨提示"
                                message:@"股票价格需要大于0哦~"
                               delegate:self
                      cancelButtonTitle:@"确定"
                      otherButtonTitles:nil] show];
    return;
  }

  //如果股票数量为0则提示，如果不为0且不为100的整数倍，提示
  NSInteger stockNumber = [_stockNumberTextField.text integerValue];
  if (!stockNumber) {
    if (isBuy) {
      [NewShowLabel setMessageContent:@"请输入要买入的数量"];
    } else {
      [NewShowLabel setMessageContent:@"请输入要卖出的数量"];
    }
    return;
  } else {
    //如果是买且数量不为100的整数倍
    if (isBuy && stockNumber % 100) {
      [NewShowLabel setMessageContent:@"买" @"入" @"数" @"量"
                                                           @"必须为100的整数倍，请重新输入"];
      return;
    }
  }
  //买入卖出最后用户提示
  NSString *message;
  if ([_stepLabelLeft.text floatValue] <= 0.002) {
    message =
        [NSString stringWithFormat:@"您确定要以%.3f元的价格%@ [%@] %ld股?",
                                   [_stockPriceTextField.text floatValue], (isBuy ? @"买入" : @"卖出"),
                                   _stockNameLabel.text, (long)[_stockNumberTextField.text integerValue]];
  } else {
    message =
        [NSString stringWithFormat:@"您确定要以%.2f元的价格%@ [%@] %ld股?",
                                   [_stockPriceTextField.text floatValue], (isBuy ? @"买入" : @"卖出"),
                                   _stockNameLabel.text, (long)[_stockNumberTextField.text integerValue]];
  }

  [[[UIAlertView alloc] initWithTitle:@"温馨提示"
                              message:message
                             delegate:self
                    cancelButtonTitle:@"取消"
                    otherButtonTitles:@"确定", nil] show];
}

#pragma mark - 警告框回调方法，用户选择确定后调用的方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) {
    _buyOrSellButtonClickBlock(_stockCodeLabel.text, _stockPriceTextField.text,
                               _stockNumberTextField.text, _stockNameLabel.text);
    //按要求清空 所选股票 股票价格 买入数量信息
    [self clearStockInfo];
  }
}

#pragma mark - 买卖成功后，需要清除所有数据
- (void)clearStockInfo {
  _stockCodeLabel.text = @"选择股票";
  _stockCodeLabel.textColor = [Globle colorFromHexRGB:Color_Gray];
  _downStopLabel.text = nil;
  _upStopLabel.text = nil;
  _stockNameLabel.text = nil;
  _stockPriceTextField.text = nil;
  _stockNumberTextField.text = nil;
  _couldBuyOrSellNumberLabel.text = nil;
}

//对外提供的清空方法
- (void)emptyAllData {
  if (_stockNameLabel.text.length != 0 || !_stockNameLabel) {
    [self clearStockInfo];
  }
}

#pragma mark - 回调函数，刷新界面数据
- (void)dataRequestComplete:(RealTradeStockPriceInfo *)data {
  if (data) {
    decimalNum = data.tradePrice.length - 2;
    _stockNameLabel.text = data.stockName;
    _stockCodeLabel.text = data.stockCode;
    _stockCodeLabel.textColor = [Globle colorFromHexRGB:Color_Stock_Code];

    //如果停盘，则返回
    if (data.suspend) {
      [NewShowLabel setMessageContent:@"此股票已停牌"];
      //此时需要禁用所有提交类控件
      _buyOrSellButton.alpha = 0.7;
      _downStopLabel.alpha = 0;
      _upStopLabel.alpha = 0;
      _stockPriceTextField.text = @"";
      _stockNumberTextField.text = @"";
      _couldBuyOrSellNumberLabel.text = @"";
      [_buyOrSellButton setEnabled:NO];
      [_stockPriceTextField setEnabled:NO];
      [_stockNumberTextField setEnabled:NO];
      return;
    }
    //恢复禁用的
    //判断是股票 还是基金

    [_buyOrSellButton setEnabled:YES];
    [_stockPriceTextField setEnabled:YES];
    [_stockNumberTextField setEnabled:YES];
    _buyOrSellButton.alpha = 1;
    _downStopLabel.alpha = 1;
    _upStopLabel.alpha = 1;
    //买入价格用委托价格，卖出价格用最新价格
    //    isBuy ? (_stockPriceTextField.text = data.entrustPrice)
    //          : (_stockPriceTextField.text = data.latestPrice);
    _stepLabelLeft.text = data.tradePrice;
    _stepLabelRight.text = data.tradePrice;
    _stockPriceTextField.text = data.entrustPrice;
    _downStopLabel.text = [NSString stringWithFormat:@"跌停：%@", data.lowPrice];
    _upStopLabel.text = [NSString stringWithFormat:@"涨停：%@", data.highPrice];
    _couldBuyOrSellNumber = data.entrustAmount;
    _stockNumberTextField.text = @"";
    if (isBuy) {
      _couldBuyOrSellNumberLabel.text = [NSString stringWithFormat:@"可买%@股", data.entrustAmount];
    } else {
      _couldBuyOrSellNumberLabel.text = [NSString stringWithFormat:@"可卖%@股", data.entrustAmount];
    }
    _couldBuyOrSellNumberLabel.adjustsFontSizeToFitWidth = YES;
  }
}

#pragma mark-- 配资界面
- (void)capitalDataRequestComplete:(WFStockByInfoData *)data {
  if (data.stockCode.length == 0 || [data.stockCode isEqualToString:@""]) {
    return;
  }
  if (data) {
    _stockNameLabel.text = data.stockName;
    _stockCodeLabel.text = data.stockCode;
    _stockCodeLabel.textColor = [Globle colorFromHexRGB:Color_Stock_Code];

    //如果停盘，则返回
    if ([data.stockInfoSuspend intValue] == 1) {
      [NewShowLabel setMessageContent:data.message];
      //此时需要禁用所有提交类控件
      _buyOrSellButton.alpha = 0.7;
      _downStopLabel.alpha = 0;
      _upStopLabel.alpha = 0;
      _stockPriceTextField.text = @"";
      _stockNumberTextField.text = @"";
      _couldBuyOrSellNumberLabel.text = @"";
      [_buyOrSellButton setEnabled:NO];
      [_stockPriceTextField setEnabled:NO];
      [_stockNumberTextField setEnabled:NO];
      return;
    }
    //恢复禁用的
    //判断是基金 还是股票
    if ([data.stockType isEqualToString:@"2"] || [data.stockType isEqualToString:@"3"]) {
      decimalNum = 2;
    } else {
      decimalNum = 3;
    }

    [_buyOrSellButton setEnabled:YES];
    [_stockPriceTextField setEnabled:YES];
    [_stockNumberTextField setEnabled:YES];
    _buyOrSellButton.alpha = 1;
    _downStopLabel.alpha = 1;
    _upStopLabel.alpha = 1;
    _stepLabelLeft.text = data.tradePrice;
    _stepLabelRight.text = data.tradePrice;
    _hightPrice = data.highPrice;
    _downPrice = data.lowPrice;
    _stockPriceTextField.text = data.entrustPrice;
    _downStopLabel.text = [NSString stringWithFormat:@"跌停：%@", data.lowPrice];
    _upStopLabel.text = [NSString stringWithFormat:@"涨停：%@", data.highPrice];
    _couldBuyOrSellNumber = data.entrustAmount;
    _stockNumberTextField.text = @"";
    if (isBuy) {
      _couldBuyOrSellNumberLabel.text = [NSString stringWithFormat:@"可买%@股", data.entrustAmount];
    } else {
      _couldBuyOrSellNumberLabel.text = [NSString stringWithFormat:@"可卖%@股", data.entrustAmount];
    }
  }
}

#pragma mark - 键盘字符限定
- (void)textFieldEditChanged:(NSNotification *)obj {
  UITextField *textField = (UITextField *)obj.object;
  NSString *toBeString = textField.text;
  //股票价格,限定为3位数字或加小数点下6位数字
  if (_stockPriceTextField == textField) {
    textField.text = [ProcessInputData numbersAndPunctuationData:toBeString decimalNum:decimalNum];
  }
  //股票数量，大于最大可购买数则直接变为最大数
  else if (_stockNumberTextField == textField) {
    textField.text = [ProcessInputData processDigitalData:toBeString];
    textField.textColor = [UIColor blackColor];
    if ([textField.text integerValue] > [_couldBuyOrSellNumber integerValue]) {
      int num = [_couldBuyOrSellNumber intValue];
      textField.text = [NSString stringWithFormat:@"%d", num];
    }
  }
}

#pragma mark - 对外刷新函数
- (void)updateData {
  _computeEntrustAmountBlock(_stockCodeLabel.text, @"", NO);
}

#pragma mark - 析构函数，取消注册通知
- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

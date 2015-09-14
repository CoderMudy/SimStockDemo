//
//  StockBuySellView.m
//  SimuStock
//
//  Created by 刘小龙 on 15/6/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "StockBuySellView.h"
#import "Globle.h"
#import "StockUtil.h"
#import "PriceBuySellTool.h"
#import "ProcessInputData.h"

@interface StockBuySellView () {
  //记录 位置 价格 和 数量
  CGFloat priceRect;
  CGFloat amountRect;

  BOOL _oldBuySell;
  BOOL _oldMarketFixed;

  /** 买卖type */
  BuySellType _buySellType;
  /** 市价限价type */
  MarketFixedPriceType _marketFixedType;
  /** 数据 */
  SimuTradeBaseData *_simuTradeData;
  /** 基金 还是 股票 */
  NSInteger decimalNumber;

  /** 记录上一次输入的价格 */
  double lastPrice;
}
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *buyAmountTFTopHeight;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *buyAmountViewTopHeight;
@end

@implementation StockBuySellView

+ (StockBuySellView *)staticInitalizationStockBuySellView {
  NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"StockBuySellView" owner:self options:nil];
  return [array lastObject];
}

// XIB 在这里设置
- (void)awakeFromNib {
  [super awakeFromNib];
  _isOriginalView = YES;
  //设置背景框
  self.stockNameBackView.layer.borderColor = [[Globle colorFromHexRGB:@"#d5d5d5"] CGColor];
  self.stockNameBackView.layer.borderWidth = 0.5f;
  self.stockNameBackView.layer.masksToBounds = YES;

  //价格背景框
  self.buyPriceBackView.layer.borderColor = [[Globle colorFromHexRGB:@"#d5d5d5"] CGColor];
  self.buyPriceBackView.layer.borderWidth = 0.5f;
  self.buyPriceBackView.layer.masksToBounds = YES;

  //数量背景框
  self.buyAmountBackView.layer.borderColor = [[Globle colorFromHexRGB:@"#d5d5d5"] CGColor];
  self.buyAmountBackView.layer.borderWidth = 0.5f;
  self.buyAmountBackView.layer.masksToBounds = YES;
  //输入框
  self.stockCodeTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  self.stockCodeTF.adjustsFontSizeToFitWidth = YES;

  [self.stockCodeTF setValue:[Globle colorFromHexRGB:@"#939393"]
                  forKeyPath:@"_placeholderLabel.textColor"];

  self.stockNameTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  self.stockNameTF.adjustsFontSizeToFitWidth = YES;

  self.buyAmountTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  self.buyAmountTF.adjustsFontSizeToFitWidth = YES;

  self.buyAmountTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  self.buyAmountTF.adjustsFontSizeToFitWidth = YES;

  self.stockNameTF.delegate = self;
  self.stockCodeTF.delegate = self;
  self.buyAmountTF.delegate = self;
  self.buyPriceTF.delegate = self;

  //记录价格
  priceRect = self.buyAmountTFTopHeight.constant;
  amountRect = self.buyAmountViewTopHeight.constant;

  //给键盘添加一个监听  监听键盘输入框里内容的变化
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(textFiledEditChanged:)
                                               name:UITextFieldTextDidChangeNotification
                                             object:nil];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UITextFieldTextDidChangeNotification
                                                object:nil];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  if (_buySellType == FixedPriceType) {
    [self reSituationWithBuySellType:_buySellType withMarketFixedType:_marketFixedType];
  }
}

/** 根据情况 重新设定 买入卖出 限价市价 */
- (void)reSituationWithBuySellType:(BuySellType)buySellType
               withMarketFixedType:(MarketFixedPriceType)marketFixedType {
  _buySellType = buySellType;
  _marketFixedType = marketFixedType;
  BOOL isEnd;
  if (_buySellType == StockBuyType) {
    //买
    self.buyPrice.text = @"买入价格";
    self.buyAmount.text = @"买入数量";
    if (marketFixedType == MarketPriceType) {
      //市价
      isEnd = YES;
      self.buyPrice.hidden = isEnd;
      self.buyPriceBackView.hidden = isEnd;
      self.buyAmount.hidden = isEnd;
      self.buyAmountBackView.hidden = isEnd;
    } else if (_marketFixedType == FixedPriceType) {
      isEnd = NO;
      self.buyPrice.hidden = isEnd;
      self.buyPriceBackView.hidden = isEnd;
      self.buyAmount.hidden = isEnd;
      self.buyAmountBackView.hidden = isEnd;
    }
  } else if (_buySellType == StockSellType) {
    //卖出
    self.buyPrice.text = @"卖出价格";
    self.buyAmount.text = @"卖出数量";
    if (marketFixedType == MarketPriceType) {
      //市价
      isEnd = YES;
      self.buyPrice.hidden = isEnd;
      self.buyPriceBackView.hidden = isEnd;
      self.buyAmountTFTopHeight.constant = -CGRectGetHeight(_buyPrice.bounds);
      self.buyAmountViewTopHeight.constant = -CGRectGetHeight(_buyPriceBackView.bounds);
    } else if (_marketFixedType == FixedPriceType) {
      //限价
      isEnd = NO;
      self.buyAmountTFTopHeight.constant = priceRect;
      self.buyAmountViewTopHeight.constant = amountRect;
      self.buyPrice.hidden = isEnd;
      self.buyPriceBackView.hidden = isEnd;
    }
  }
}

/** 绑定数据  */
- (void)bindData:(NSArray *)array {
  if (array.count > 0 && array != nil) {
    self.buyPriceTF.text = array[0];
    self.buyAmountTF.text = array[1];
  }
}

/** 绑定数据 */
- (void)bindWithSimuTradeBaseData:(SimuTradeBaseData *)data withBuySellType:(BuySellType)type {
  _simuTradeData = data;
  decimalNumber = data.tradeType == 1 ? 3 : 2;
  NSString *formate = [StockUtil getPriceFormatWithTradeType:data.tradeType];
  if (type == StockBuyType) {
    self.buyPriceTF.text = [NSString stringWithFormat:formate, data.buyPrice];
    lastPrice = [self.buyPriceTF.text doubleValue];
    self.buyAmountTF.text = data.maxBuy;
  } else if (type == StockSellType) {
    self.buyPriceTF.text = [NSString stringWithFormat:formate, data.salePrice];
    self.buyAmountTF.text = data.sellable;
  }
}

/** 判断输入框里的 内容 */
- (BOOL)judgeTextFieldContent {
  //判断股票名称
  NSString *code = _stockCodeTF.text;
  if (code.length == 0) {
    return NO;
  }
  return YES;
}

/** 判断价格 */
- (NSString *)judgePriceTextFieldContent {
  if (_buySellType == StockBuyType) {
    //买
    NSString *string = [self judgeMarkerFixedPriceForTextFiled:@"买入"];
    if (![string isEqualToString:@""]) {
      return string;
    } else {
      return @"";
    }
  } else if (_buySellType == StockSellType) {
    //卖
    NSString *string = [self judgeMarkerFixedPriceForTextFiled:@"卖出"];
    if (![string isEqualToString:@""]) {
      return string;
    } else {
      return @"";
    }
  }
  return nil;
}

/** 判断数量 */
- (NSString *)judgeAmountTextFieldContent {
  if (_buySellType == StockBuyType) {
    NSString *string = [self judgeMarkerFiexdAmountForTextFilde:@"买入"];
    if (![string isEqualToString:@""]) {
      return string;
    }
    return @"";
  } else if (_buySellType == StockSellType) {
    NSString *string = [self judgeMarkerFiexdAmountForTextFilde:@"卖出"];
    if (![string isEqualToString:@""]) {
      return string;
    }
    return @"";
  }
  return nil;
}

/** 不管买卖 判断价格的方法都一样 分为在市价和限价  返回@“” 为正确*/
- (NSString *)judgeMarkerFixedPriceForTextFiled:(NSString *)buySell {
  if (_marketFixedType == MarketPriceType) {
    //不用判断
    return @"";
  } else if (_marketFixedType == FixedPriceType) {
    //限价
    if ([_buyPriceTF.text isEqualToString:@""] || _buyPriceTF.text.length == 0 ||
        [_buyPriceTF.text floatValue] <= 0.0) {
      NSString *string = [NSString stringWithFormat:@"请输入%@价格", buySell];
      return string;
    } else {
      NSString *string = [PriceBuySellTool reasonablePrice:_buyPriceTF.text
                                           withBuySellType:_buySellType
                                         withSimuTradeData:_simuTradeData];
      if (![string isEqualToString:@""]) {
        return string;
      }
    }
  }
  return @"";
}
/** 判断数量 */
- (NSString *)judgeMarkerFiexdAmountForTextFilde:(NSString *)buySell {
  if (_marketFixedType == MarketPriceType) {
    //如果是买入 不用判断 如果是卖出 用作判断
    if (_buySellType == StockBuyType) {
      return @"";
    } else if (_buySellType == StockSellType) {
      NSString *string = [self amountForTextField:@"卖出"];
      if (![string isEqualToString:@""]) {
        return string;
      }
      return @"";
    }
  } else if (_marketFixedType == FixedPriceType) {
    if (_buySellType == StockBuyType) {
      NSString *string = [self amountForTextField:@"买入"];
      if (![string isEqualToString:@""]) {
        return string;
      }
      return @"";
    } else if (_buySellType == StockSellType) {
      NSString *string = [self amountForTextField:@"卖出"];
      if (![string isEqualToString:@""]) {
        return string;
      }
      return @"";
    }
  }
  return @"";
}

/** 对于卖出数量做的判断 不管限价还是市价都一样的判断 */
- (NSString *)amountForTextField:(NSString *)type {
  if ([_buyAmountTF.text isEqualToString:@""] || _buyAmountTF.text.length == 0 ||
      [_buyAmountTF.text integerValue] <= 0) {
    NSString *content = nil;
    if (_buySellType == StockBuyType) {
      content = [NSString stringWithFormat:@"买入数量必须为100的整数倍,请重新输入"];
    } else if (_buySellType == StockSellType) {
      content = @"卖出数量必须大于0，小于可卖股数";
    }
    return content;
  } else {
    NSString *content = nil;
    NSInteger inputMount = [_buyAmountTF.text integerValue];
    if (_buySellType == StockBuyType) {
      if (inputMount % 100 != 0 || inputMount < 100) {
        content = @"买入数量必须为100的整数倍,请重新输入";
        return content;
      } else {
        NSInteger hightAmount = [_simuTradeData.maxBuy integerValue];
        if (inputMount > hightAmount) {
          content = @"买入数量大于最大可买数，请重新输入";
          return content;
        }
        return @"";
      }
    } else if (_buySellType == StockSellType) {
      if (inputMount <= 0) {
        content = @"卖出数量必须大于0，小于可卖股数";
        return content;
      } else {
        CGFloat highMonunt = [_simuTradeData.sellable floatValue];
        if (inputMount > highMonunt) {
          content = @"卖出数量大于您的持有数量，请重新输入";
          return content;
        }
        return @"";
      }
    }
  }
  return nil;
}

/** 清楚数据 */
- (void)clearData {
  _simuTradeData = nil;
  self.stockNameTF.text = @"";
  self.stockCodeTF.text = @"";
  self.buyAmountTF.text = @"";
  self.buyPriceTF.text = @"";
}

#pragma mark-- TextFieldDelegate
/** 输入将要开始的时候 */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  if (textField.tag == 100 || textField.tag == 101) {
    _isOriginalView = NO;
    [_buyPriceTF resignFirstResponder];
    [_buyAmountTF resignFirstResponder];
    //返回一个block
    if (self.createStockViewBlock) {
      self.createStockViewBlock(_buySellType);
    }
    return NO;
  } else {
    if (_simuTradeData.newstockPrice != 0) {
      _isOriginalView = YES;
    }
  }
  return YES;
}

/** 结束时 */
- (void)textFieldDidEndEditing:(UITextField *)textField {
  if (textField.tag == 102 && textField == _buyPriceTF) {
    //判断有没有选中股票
    if (![self judgeTextFieldContent]) {
      return;
    }
    if (_buySellType == StockBuyType) {
      if (_isOriginalView) {
        //判断价格是否合理 只在本界面判断
        NSString *price = [PriceBuySellTool reasonablePrice:textField.text
                                            withBuySellType:_buySellType
                                          withSimuTradeData:_simuTradeData];
        if (![price isEqualToString:@""]) {
          [NewShowLabel setMessageContent:price];
          [textField becomeFirstResponder];
        } else {
          if (lastPrice != [textField.text doubleValue]) {
            //重新请求数据
            if (self.requsetBuyAmountBlock) {
              self.requsetBuyAmountBlock(textField.text);
            }
          }
        }
      }
    }
  }
}

- (void)textFiledEditChanged:(NSNotification *)obj {
  UITextField *textField = (UITextField *)obj.object;
  NSString *toBeString = textField.text;
  if ([self judgeTextFieldContent]) {
    if (_buyPriceTF == textField) {
      //价格发生变动 过虑除数字和小数点以外的字符
      textField.text =
          [ProcessInputData numbersAndPunctuationData:toBeString decimalNum:decimalNumber];
      if (_buySellType == StockBuyType) {
        //记录限价值
        if (self.showPriceLabelBlock) {
          self.showPriceLabelBlock(textField.text, YES, _buySellType);
        }
      }
    } else if (_buyAmountTF == textField) {
      //数量发生变化时
      //过虑除数字以外的字符
      NSString *filtered = [ProcessInputData processDigitalData:toBeString];
      if (!_isOriginalView) {
        if (filtered.length > 9) {
          textField.text = [filtered substringToIndex:9];
        } else {
          textField.text = filtered;
        }
        return;
      }
      if (self.showPriceLabelBlock) {
        self.showPriceLabelBlock(filtered, NO, _buySellType);
      }
    }
  }
}

/** 校验数据 */
- (BOOL)checkDataForBuySellTextFiled {
  if (self.stockCodeTF.text.length <= 0 || [self.stockCodeTF.text isEqualToString:@""] ||
      self.stockCodeTF.text == nil) {
    return NO;
  }
  if (self.stockNameTF.text.length <= 0 || [self.stockNameTF.text isEqualToString:@""] ||
      self.stockNameTF.text == nil) {
    return NO;
  }
  return YES;
}

/** 释放 */
- (void)textfieldDealloc {
  _stockCodeTF.delegate = nil;
  _stockNameTF.delegate = nil;
  _buyPriceTF.delegate = nil;
  _buyAmountTF.delegate = nil;
  [_stockNameTF resignFirstResponder];
  [_stockCodeTF resignFirstResponder];
  [_buyAmountTF resignFirstResponder];
  [_buyPriceTF resignFirstResponder];
}

- (void)textfieldResignFirstRsp {
  [_stockNameTF resignFirstResponder];
  [_stockCodeTF resignFirstResponder];
  [_buyAmountTF resignFirstResponder];
  [_buyPriceTF resignFirstResponder];
}

@end

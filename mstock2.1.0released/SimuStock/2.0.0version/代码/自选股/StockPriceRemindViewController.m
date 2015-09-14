//
//  StockPriceRemindViewController.m
//  SimuStock
//
//  Created by xuming tan on 15-3-12.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "StockPriceRemindViewController.h"
#import "UITextField+SaveStockAlarmRulesTextField.h"
#import "StockUtil.h"

@interface StockPriceRemindViewController () <UITextFieldDelegate> {
  ///输入框数组
  NSArray *textFields;

  ///滑块开关数组
  NSArray *switchs;

  ///数据合法时显示的颜色
  UIColor *validColor;

  ///数据非法时显示的颜色
  UIColor *inValidColor;
}
@end

@implementation StockPriceRemindViewController

- (void)dealloc {
  [switchs enumerateObjectsUsingBlock:^(UISwitch *aSwitch, NSUInteger idx,
                                        BOOL *stop) {
    [aSwitch removeTarget:nil
                   action:NULL
         forControlEvents:UIControlEventAllEvents];
  }];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  validColor = [Globle colorFromHexRGB:Color_Black_Stock_Price];
  inValidColor = [Globle colorFromHexRGB:Color_Red_Stock_Price];

  [self setTextFieldInputPosition];
  [self initSwitchState];
  [self resetTextColorOfTextField];
}

///当是大盘指数股价提醒页面要作改变
- (void)changeElement {
  if ([StockUtil isMarketIndex:self.firstType]) {
    _shotSpiritView.hidden = YES;
    _stockPriceUpToLabel.text = [NSString stringWithFormat:@"点数涨到:"];
    _stockPriceDropToLabel.text = [NSString stringWithFormat:@"点数跌到:"];
    _unitOfStockPriceUpto.text = [NSString stringWithFormat:@"点"];
    _unitOfStockPriceDropTo.text = [NSString stringWithFormat:@"点"];
  }
}
//初始化switch状态
- (void)initSwitchState {

  textFields = @[
    _stockPriceUptoTextField,
    _stockPriceDropstoTextField,
    _dailyGainsTextField,
    _dailyDropsTextField
  ];

  switchs = @[
    _stockPriceUptoSwitch,
    _stockPriceDowntoSwitch,
    _dailyGainsToSwitch,
    _dailyDropsToSwitch,
    _shotSpiritSwitch
  ];

  //给textField赋tag值
  [textFields enumerateObjectsUsingBlock:^(UITextField *textField,
                                           NSUInteger idx, BOOL *stop) {
    textField.tag = idx;
    [textField addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];

    //重置textField状态，如果输入不为空，开关打开，否则开关关闭
    UISwitch *aSwitch = switchs[idx];
    [aSwitch setOn:((textField.text.length) != 0) ? YES : NO animated:YES];

  }];

  [switchs enumerateObjectsUsingBlock:^(UISwitch *aSwitch, NSUInteger idx,
                                        BOOL *stop) {
    [aSwitch addTarget:self
                action:@selector(changeSwitch:)
      forControlEvents:UIControlEventValueChanged];
  }];
}

- (void)textFieldDidChange:(UITextField *)textFiled {
  NSString *text = textFiled.text;
  NSInteger idx = 0;
  // 00 -->0
  // 0000 -->0
  // 00.1 --> 0.1
  // 01.00 --> 1.00
  for (idx = 0; idx < text.length; idx++) {
    if ([text characterAtIndex:idx] == '0') {
      if (idx == text.length - 1) { // 000情况
        break;
      }
      continue;
    }
    if ([text characterAtIndex:idx] == '.') {
      idx--;
      break;
    }
    break;
  }
  if (idx > 0) {
    textFiled.text = [text substringFromIndex:idx];
  }

  [self resetTextColorOfTextField];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {

  //打开对应的滑块开关
  NSUInteger index = [textFields indexOfObject:textField];
  UISwitch *switchView = switchs[index];
  if (!switchView.on) {
    [switchs[index] setOn:YES animated:YES];
  }

  [self resetTextColorOfTextField];

  //关闭空的输入框对应的滑块开关
  [textFields enumerateObjectsUsingBlock:^(UITextField *textFieldItem,
                                           NSUInteger idx, BOOL *stop) {
    if (textField.tag == textFieldItem.tag) {
      // do nothing
    } else {
      if (textFieldItem.text.length == 0) {
        [switchs[idx] setOn:NO animated:YES];
      }
    }
  }];

  // view上移
  if (textField == _dailyGainsTextField || textField == _dailyDropsTextField) {
    [self resetSelfViewUpper];
  }
}

///设置股价提醒四个条件的输入起始位置（空一格）
- (void)setTextFieldInputPosition {
  [_stockPriceUptoTextField resetInputPositionOfStockPriceUpAndDown];
  [_stockPriceDropstoTextField resetInputPositionOfStockPriceUpAndDown];
  [_dailyGainsTextField resetInputPositionOfDailyGains];
  [_dailyDropsTextField resetInputPositionOfDailyDrops];
}

- (void)setColorWithTextField:(UITextField *)textField
                    withValid:(BOOL)dataValid {
  [textField setTextColor:dataValid ? validColor : inValidColor];
}

///重置股价涨到股价跌到输入文本颜色
- (void)resetTextColorOfTextField {
  [self setColorWithTextField:_stockPriceUptoTextField
                    withValid:[self validatePriceUpLimit]];
  [self setColorWithTextField:_stockPriceDropstoTextField
                    withValid:[self validatePriceDownLimit]];
  [self setColorWithTextField:_dailyGainsTextField
                    withValid:[self validateDailyGain]];
  [self setColorWithTextField:_dailyDropsTextField
                    withValid:[self validateDailyDrop]];
}

///限制输入个数（最多6位）且只能输入一个小数点且小数点后保留2位小数。
static const CGFloat MAXLENGTH = 6;
- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {

  NSString *newString =
      [textField.text stringByReplacingCharactersInRange:range
                                              withString:string];
  NSArray *arrayOfString = [newString componentsSeparatedByString:@"."];
  NSInteger decimalPointNum = arrayOfString.count - 1;
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

//收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [_stockPriceUptoTextField resignFirstResponder];
  [_stockPriceDropstoTextField resignFirstResponder];
  [_dailyGainsTextField resignFirstResponder];
  [_dailyDropsTextField resignFirstResponder];
}

//弹键盘view上移
- (void)resetSelfViewUpper {
  ///日涨幅弹键盘view竖直位移距离
  static const CGFloat displacementofdailyGains = 100;

  CGRect frame = self.view.frame;

  [UIView animateWithDuration:0.001
                   animations:^{
                     self.view.frame = CGRectMake(
                         0, frame.origin.y - displacementofdailyGains,
                         frame.size.width, frame.size.height);
                   }];
}

//收键盘view下移
- (void)resetSelfViewDown {
  CGRect frame = self.view.frame;
  [UIView animateWithDuration:0.001
                   animations:^{
                     self.view.frame =
                         CGRectMake(0, 0, frame.size.width, frame.size.height);
                   }];
}

- (void)changeSwitch:(id)sender {

  [textFields enumerateObjectsUsingBlock:^(UITextField *textField,
                                           NSUInteger idx, BOOL *stop) {
    UISwitch *switchView = switchs[idx];
    //输入字数为空, 开关关闭，否则开关打开
    if (switchView != sender && ![textField isFirstResponder] &&
        textField.text.length == 0 && switchView.on) {
      [switchView setOn:NO animated:YES];
    }
    if (switchView == sender && !switchView.on &&
        [textField isFirstResponder]) {
      [textField resignFirstResponder];
    }
  }];
  [self resetTextColorOfTextField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

  [self resetTextColorOfTextField];
  //给textField赋tag值
  [textFields enumerateObjectsUsingBlock:^(UITextField *textFieldItem,
                                           NSUInteger idx, BOOL *stop) {

    if (textField == _dailyGainsTextField ||
        textField == _dailyDropsTextField) {
      [self resetSelfViewDown];
    }
  }];
}

- (BOOL)validateInputValue:(NSString *)inputValue {
  if ([@"" isEqualToString:inputValue] || [@"0" isEqualToString:inputValue] ||
      [@"." isEqualToString:inputValue]) {
    return NO;
  } else {
    return YES;
  }
}

- (BOOL)validateLatestPrice {
  NSString *text = _latestPriceLabel.text;

  if (![self validateInputValue:text] || [text floatValue] == 0) {
    return NO;
  }
  return YES;
}

- (BOOL)validateDailyGain {
  if (!_dailyGainsToSwitch.on) {
    return YES;
  }
  if (![self validateInputValue:_dailyGainsTextField.text] ||
      [_dailyGainsTextField.text floatValue] == 0) {
    return NO;
  }
  return YES;
}

- (BOOL)validateDailyDrop {
  if (!_dailyDropsToSwitch.on) {
    return YES;
  }
  if (![self validateInputValue:_dailyDropsTextField.text] ||
      [_dailyDropsTextField.text floatValue] == 0) {
    return NO;
  }
  return YES;
}

- (BOOL)validatePriceUpLimit {
  if (!_stockPriceUptoSwitch.on) {
    return YES;
  }
  if (![self validateInputValue:_stockPriceUptoTextField.text]) {
    return NO;
  }

  CGFloat latestPrice = [_latestPriceLabel.text floatValue];
  if ([_stockPriceUptoTextField.text floatValue] <= latestPrice) {
    return NO;
  }

  return YES;
}

- (BOOL)validatePriceDownLimit {
  if (!_stockPriceDowntoSwitch.on) {
    return YES;
  }

  if (![self validateInputValue:_stockPriceDropstoTextField.text]) {
    return NO;
  }

  CGFloat latestPrice = [_latestPriceLabel.text floatValue];
  if ([_stockPriceDropstoTextField.text floatValue] >= latestPrice) {
    return NO;
  }

  return YES;
};

@end

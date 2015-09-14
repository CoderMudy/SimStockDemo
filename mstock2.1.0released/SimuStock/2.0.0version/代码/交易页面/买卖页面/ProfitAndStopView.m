//
//  ProfitAndStopView.m
//  SimuStock
//
//  Created by tanxuming on 15/5/25.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ProfitAndStopView.h"
#import "UITextField+SaveStockAlarmRulesTextField.h"
#import "Globle.h"
#import "UIImage+ColorTransformToImage.h"

@implementation ProfitAndStopView
- (void)awakeFromNib {
  [super awakeFromNib];
  self.frame = CGRectMake(0, 0, WIDTH_OF_SCREEN, self.frame.size.height);
  simuSellQueryData = [[SimuTradeBaseData alloc] init];
  [_sliderView addTarget:self
                  action:@selector(sliderValueChanged:)
        forControlEvents:UIControlEventValueChanged];
  _sliderView.backgroundColor = [UIColor clearColor];
  _sliderView.minimumValue = 0.0; //下限
  _sliderView.maximumValue = 0.0; //上限
  _sliderView.value = 0.0;
  [_sliderView setThumbImage:[UIImage imageNamed:@"滑动按钮.png"]
                    forState:UIControlStateNormal];
  [_sliderView setThumbImage:[UIImage imageNamed:@"滑动按钮.png"]
                    forState:UIControlStateHighlighted];
  [_sliderView
      setMaximumTrackImage:[[UIImage imageNamed:@"买入数量进度条.png"]
                               stretchableImageWithLeftCapWidth:4
                                                   topCapHeight:0]
                  forState:UIControlStateNormal];
  [_sliderView
      setMinimumTrackImage:[[UIImage imageNamed:@"买入数量进度条左.png"]
                               stretchableImageWithLeftCapWidth:4
                                                   topCapHeight:0]
                  forState:UIControlStateNormal];
  _stockInfoView.layer.borderWidth = 0.5;
  _stockInfoView.layer.borderColor = [Globle colorFromHexRGB:@"d5d5d5"].CGColor;
  _stopWinPriBackgrounView.layer.borderWidth = 0.5;
  _stopWinPriBackgrounView.layer.borderColor =
      [Globle colorFromHexRGB:@"d5d5d5"].CGColor;
  _stopWinRateBackgrounView.layer.borderWidth = 0.5;
  _stopWinRateBackgrounView.layer.borderColor =
      [Globle colorFromHexRGB:@"d5d5d5"].CGColor;
  _stopLosePriBackgroundView.layer.borderWidth = 0.5;
  _stopLosePriBackgroundView.layer.borderColor =
      [Globle colorFromHexRGB:@"d5d5d5"].CGColor;
  _stopLoseRateBackgroundView.layer.borderWidth = 0.5;
  _stopLoseRateBackgroundView.layer.borderColor =
      [Globle colorFromHexRGB:@"d5d5d5"].CGColor;
  _stockSellNumView.layer.borderWidth = 0.5;
  _stockSellNumView.layer.borderColor =
      [Globle colorFromHexRGB:@"d5d5d5"].CGColor;
  // textField开头空一格
  [_stockSellNumTF resetInputPositionOfStockPriceUpAndDown];

  UIImage *inviteFriendImage =
      [UIImage imageFromView:_sellBtn
          withBackgroundColor:[Globle colorFromHexRGB:@"#086dae"]];
  [_sellBtn setBackgroundImage:inviteFriendImage
                      forState:UIControlStateHighlighted];
  [_sellBtn setTitleColor:[UIColor whiteColor]
                 forState:UIControlStateHighlighted];
}

- (void)resetView {
  _stockInfoDefaultLab.hidden = NO;
  _stockCodeLabel.text = @"";
  _stockNameLabel.text = @"";
  _costLabel.text = @"--";
  _costLabel.textColor = [Globle colorFromHexRGB:Color_Black];
  _currentProfitAndLossLab.text = @"--";
  _currentProfitAndLossLab.textColor = [Globle colorFromHexRGB:Color_Black];
  _stockSellNumTF.text = @"";
  _stopWinPriceTF.text = @"";
  _stopWinRateTF.text = @"";
  _stopLoseRateTF.text = @"";
  _stopLosePriceTF.text = @"";
  _sliderView.minimumValue = 0;
  _sliderView.maximumValue = 0;
  _sliderView.value = 0;
  _sliderMaxValueLab.text = @"";
  _sliderMinValueLab.text = @"";
  [_stopWinSwitch setOn:NO animated:YES];
  [_stopLoseSwitch setOn:NO animated:YES];
}

- (void)sliderValueChanged:(id)sender {
  if (_stockCodeLabel.text.length == 0) {
    return;
  }
  UISlider *control = (UISlider *)sender;
  if (control == _sliderView) {
    float value = control.value;
    float maxvalue = control.maximumValue;
    if (maxvalue == 0) {
      return;
    }
    if ((int)maxvalue) {
      _stockSellNumTF.text = [NSString stringWithFormat:@"%d", (int)value];
    }
  }
}

- (BOOL)validateInputValue:(NSString *)inputValue {
  if ([@"" isEqualToString:inputValue]) {
    return NO;
  } else {
    return YES;
  }
}

- (BOOL)validateStopWinPrice {

  if (![self validateInputValue:_stopWinPriceTF.text]) {
    return NO;
  }

  CGFloat stopWinPrice = [_costLabel.text floatValue];
  if ([_stopWinPriceTF.text floatValue] <= stopWinPrice) {
    return NO;
  }
  return YES;
}

- (BOOL)validateStopLosePrice {

  CGFloat stopLosePrice = [_costLabel.text floatValue];

  if (![self validateInputValue:_stopLosePriceTF.text]) {
    return NO;
  }
  if ([_stopLosePriceTF.text floatValue]<
          stopLosePrice && [_stopLosePriceTF.text floatValue]> 0) {
    return YES;
  }
  return NO;
}
@end

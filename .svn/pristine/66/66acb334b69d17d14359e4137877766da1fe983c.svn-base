//
//  StockPositionSwitchButtonsView.m
//  SimuStock
//
//  Created by Yuemeng on 14/11/4.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "StockPositionSwitchButtonsView.h"
#import "Globle.h"
#import "SimuUtil.h"

@interface StockPositionSwitchButtonsView () {
  //持仓按钮
  UIButton *_positionedButton;
  //清仓按钮
  UIButton *_clearPositionButton;
}

@end

@implementation StockPositionSwitchButtonsView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    [self createSwitchButtons];
  }
  return self;
}

#pragma mark - 持仓选择按钮控件
- (void)createSwitchButtons {
  CGFloat selfHeight = self.bounds.size.height;
  CGFloat selfWidth = self.bounds.size.width;
  //创建当前持仓按钮
  _positionedButton = [UIButton buttonWithType:UIButtonTypeCustom];
  _positionedButton.frame = CGRectMake(0, 0, selfWidth / 2, selfHeight);
  [_positionedButton setTitle:@"当前持仓" forState:UIControlStateNormal];
  //    [_positionedButton setTitle:positionString
  //    forState:UIControlStateSelected];
  _positionedButton.titleLabel.font =
      [UIFont systemFontOfSize:Font_Height_16_0];
  [_positionedButton setTitleColor:[Globle colorFromHexRGB:Color_Icon_Title]
                          forState:UIControlStateNormal];
  [_positionedButton setTitleColor:[Globle colorFromHexRGB:Color_Blue_but]
                          forState:UIControlStateSelected];
  [_positionedButton setTitleColor:[Globle colorFromHexRGB:Color_Blue_but]
                          forState:UIControlStateHighlighted];
  [_positionedButton
      setBackgroundColor:[Globle colorFromHexRGB:Color_Pressed_Gray]];
  [_positionedButton
   setBackgroundImage:[SimuUtil imageFromColor:Color_BG_Common]
   forState:UIControlStateSelected];
  [_positionedButton addTarget:self
                        action:@selector(switchButtionClick:)
              forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:_positionedButton];

  //创建已清仓按钮
  _clearPositionButton = [UIButton buttonWithType:UIButtonTypeCustom];
  _clearPositionButton.frame =
      CGRectMake(selfWidth / 2, 0, selfWidth / 2, selfHeight);
  [_clearPositionButton setTitle:@"已经清仓" forState:UIControlStateNormal];
  //    [_closePositionButton setTitle:closePositionString
  //    forState:UIControlStateSelected];
  _clearPositionButton.titleLabel.font =
      [UIFont systemFontOfSize:Font_Height_16_0];
  [_clearPositionButton setTitleColor:[Globle colorFromHexRGB:Color_Icon_Title]
                             forState:UIControlStateNormal];
  [_clearPositionButton setTitleColor:[Globle colorFromHexRGB:Color_Blue_but]
                             forState:UIControlStateSelected];
  [_clearPositionButton setTitleColor:[Globle colorFromHexRGB:Color_Blue_but]
                             forState:UIControlStateHighlighted];
  [_clearPositionButton
      setBackgroundColor:[Globle colorFromHexRGB:Color_Pressed_Gray]];
  [_clearPositionButton
      setBackgroundImage:[SimuUtil imageFromColor:Color_BG_Common]
                forState:UIControlStateSelected];
  [_clearPositionButton addTarget:self
                           action:@selector(switchButtionClick:)
                 forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:_clearPositionButton];

  //默认选中持仓
  _positionedButton.selected = YES;
}

#pragma mark - 设置按钮标题方法
- (void)setButtonsTitleWithPositionNumber:(NSString *)positionNumber
                              clearNumber:(NSString *)clearNumber {
  //如果都有数据
  if (positionNumber && clearNumber) {
    [_positionedButton
        setTitle:[NSString
                     stringWithFormat:@"当前持仓 ( %@ )", positionNumber]
        forState:UIControlStateNormal];
    [_positionedButton
        setTitle:[NSString
                     stringWithFormat:@"当前持仓 ( %@ )", positionNumber]
        forState:UIControlStateSelected];

    [_clearPositionButton
        setTitle:[NSString stringWithFormat:@"已经清仓 ( %@ )", clearNumber]
        forState:UIControlStateNormal];
    [_clearPositionButton
        setTitle:[NSString stringWithFormat:@"已经清仓 ( %@ )", clearNumber]
        forState:UIControlStateSelected];

    //如果没有网
  } else {
    [_positionedButton setTitle:@"当前持仓" forState:UIControlStateNormal];
    [_clearPositionButton setTitle:@"已经清仓" forState:UIControlStateNormal];
  }
}

//单独设置持仓数
- (void)setPositonButtonTitle:(NSString *)positionNumber {
  if (positionNumber) {
    [_positionedButton
        setTitle:[NSString
                     stringWithFormat:@"当前持仓 ( %@ )", positionNumber]
        forState:UIControlStateNormal];
    [_positionedButton
        setTitle:[NSString
                     stringWithFormat:@"当前持仓 ( %@ )", positionNumber]
        forState:UIControlStateSelected];

  } else {
    [_positionedButton setTitle:@"当前持仓" forState:UIControlStateNormal];
  }
}

//单独设置清仓数
- (void)setClearPositonButtonTitle:(NSString *)clearNumber {
  if (clearNumber) {
    [_clearPositionButton
        setTitle:[NSString stringWithFormat:@"已经清仓 ( %@ )", clearNumber]
        forState:UIControlStateNormal];
    [_clearPositionButton
        setTitle:[NSString stringWithFormat:@"已经清仓 ( %@ )", clearNumber]
        forState:UIControlStateSelected];
  } else {
    [_clearPositionButton setTitle:@"已经清仓" forState:UIControlStateNormal];
  }
}

#pragma mark - 切换按钮点击事件
- (void)switchButtionClick:(UIButton *)button {
  if (button == _positionedButton) {
    _positionedButton.selected = YES;
    _clearPositionButton.selected = NO;
    //回调
    _switchButtonsClickBlock(YES);

  } else {
    _positionedButton.selected = NO;
    _clearPositionButton.selected = YES;
    //回调
    _switchButtonsClickBlock(NO);
  }
}

@end

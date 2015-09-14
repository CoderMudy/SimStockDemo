//
//  TopToolBarView.m
//  SimuStock
//
//  Created by Mac on 14-5-14.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "TopToolBarView.h"
#import "SimuUtil.h"

@implementation TopToolBarView

- (id)initWithFrame:(CGRect)frame
          DataArray:(NSArray *)dataArray
withInitButtonIndex:(int)buttonIndex {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    self.backgroundColor = [Globle colorFromHexRGB:@"ffffff"]; //#f8f8f8
    _currentSelectedIndex = buttonIndex;
    _buttonArray = [[NSMutableArray alloc] init];
    [self createUI:dataArray];
    _isAnimationStarting = NO;
  }
  return self;
}

#pragma mark
#pragma mark 创建各个控件
- (void)createUI:(NSArray *)dataArray {

  NSInteger count = [dataArray count];

  CGFloat width = self.bounds.size.width / (count);
  int index = 0;
  for (NSString *str in dataArray) {

    //区域记录
    CGRect ButtonRect = CGRectMake(width * index, 0, width, self.bounds.size.height);

    if (count < 10) {
      _rectArray[index] = CGRectMake(width * index, self.bounds.size.height - 3,
                                     self.bounds.size.width / count, 3);
    }
    //加入按钮
    UIButton *selButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selButton.titleLabel.font = [UIFont systemFontOfSize:Font_Height_16_0];
    [selButton setTitle:str forState:UIControlStateNormal];
    [selButton setTitle:str forState:UIControlStateHighlighted];
    [selButton setTitleColor:[Globle colorFromHexRGB:Color_Text_Common]
                    forState:UIControlStateNormal];

    [_buttonArray addObject:selButton];

    selButton.frame = ButtonRect;
    selButton.tag = index;
    selButton.backgroundColor = [UIColor clearColor];
    [selButton addTarget:self
                  action:@selector(butonPressDown:)
        forControlEvents:UIControlEventTouchDown];
    [self addSubview:selButton];
    index++;
  }
  
  _maxlineView =
      [[UIView alloc] initWithFrame:_rectArray[_currentSelectedIndex]];
  _maxlineView.backgroundColor = [Globle colorFromHexRGB:Color_Blue_but];
  [self addSubview:_maxlineView];

  _bottomLineView = [[UIView alloc]
      initWithFrame:CGRectMake(0, HEIGHT_OF_VIEW - 1, WIDTH_OF_VIEW, 1)];
  _bottomLineView.backgroundColor = [Globle colorFromHexRGB:Color_Blue_but];
  [self addSubview:_bottomLineView];

  [self resetButtons];
}

- (void)butonPressDown:(UIButton *)button {
  if (_currentSelectedIndex == button.tag)
    return;
  if (_isAnimationStarting == YES)
    return;
  _isAnimationStarting = YES;
  _currentSelectedIndex = button.tag;
  //设定按钮颜色
  [self resetButtons];
  [self buttonMoveWithAnimation:_currentSelectedIndex];
  [self setDelegatedate];
}

- (void)resetButtons {
  for (UIButton *obj in _buttonArray) {
    if (_currentSelectedIndex == obj.tag) {
      [obj setTitleColor:[Globle colorFromHexRGB:Color_Blue_but]
                forState:UIControlStateNormal];
      obj.titleLabel.font = [UIFont boldSystemFontOfSize:Font_Height_16_0];
    } else {
      [obj setTitleColor:[Globle colorFromHexRGB:Color_Text_Common]
                forState:UIControlStateNormal];
      obj.titleLabel.font = [UIFont systemFontOfSize:Font_Height_16_0];
    }
  }
}

- (void)setDelegatedate {
  if (self.delegate) {
    [self.delegate changeToIndex:_currentSelectedIndex];
  }
}

#pragma mark
#pragma mark 动画相关函数
- (void)buttonMoveWithAnimation:(NSInteger)index {
  [UIView beginAnimations:nil context:nil];
  //持续时间
  [UIView setAnimationDuration:0.4];
  //在出动画的时候减缓速度
  [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
  //添加动画开始及结束的代理
  [UIView setAnimationDelegate:self];
  [UIView setAnimationDidStopSelector:@selector(stopPickViewAni)];
  [UIView commitAnimations];
}

- (void)stopPickViewAni {
  _isAnimationStarting = NO;
}

#pragma mark
#pragma mark 对外接口
- (void)changTapToIndex:(NSInteger)index {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.tag = index;
  [self butonPressDown:button];
}

@end

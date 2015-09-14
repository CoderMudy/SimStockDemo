//
//  simuTabSelView.m
//  SimuStock
//
//  Created by Mac on 14-8-10.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "simuTabSelView.h"
#import "SimuUtil.h"
#import "SeperatorLine.h"

@implementation simuTabSelView

///标题默认颜色
static UIColor *titleColorNormal;
///标题选中颜色
static UIColor *titleColorHighlight;

- (id)initWithFrame:(CGRect)frame titleArray:(NSArray *)array {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor whiteColor];
    titleColorNormal = [Globle colorFromHexRGB:Color_Icon_Title];
    titleColorHighlight = [Globle colorFromHexRGB:Color_Blue_but];
    _selectedTabIndex = -1;
    _tabTitleArray = [[NSMutableArray alloc] initWithArray:array];
    _tabButtonArray = [[NSMutableArray alloc] init];
    _seperateLineArray = [[NSMutableArray alloc] init];
    [self creatControlsViews];
  }
  return self;
}

- (void)resetTabTitleArray:(NSArray *)titleArray
          andSelectedIndex:(NSInteger)index {
  if (titleArray == nil)
    return;
  _selectedTabIndex = index;
  [_tabTitleArray removeAllObjects];
  [_tabTitleArray addObjectsFromArray:titleArray];

  [self creatControlsViews];
}

- (void)creatControlsViews {
  //移除所有的tab按钮
  for (UIButton *button in _tabButtonArray) {
    [button removeFromSuperview];
  }
  [_tabButtonArray removeAllObjects];

  //移除所有的分割线
  for (UIView *line in _seperateLineArray) {
    [line removeFromSuperview];
  }
  [_seperateLineArray removeAllObjects];

  //添加tab按钮和分割线
  NSInteger tabButtonNum = [_tabTitleArray count];
  tabButtonWidth = self.bounds.size.width / tabButtonNum;
  [_tabTitleArray enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx,
                                               BOOL *stop) {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(idx * tabButtonWidth, 0, tabButtonWidth,
                              self.bounds.size.height);
    [button setBackgroundColor:[UIColor clearColor]];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];

    [button addTarget:self
                  action:@selector(buttonSelected:)
        forControlEvents:UIControlEventTouchUpInside];
    button.tag = idx;
    [self addSubview:button];
    [_tabButtonArray addObject:button];

    if (idx != tabButtonNum - 1) {
      StockVerticalSeperatorLine *line = [[StockVerticalSeperatorLine alloc]
          initWithFrame:CGRectMake((idx + 1) * tabButtonWidth, 3.f, 0.5f,
                                   self.bounds.size.height - 6.f)];
      line.backgroundColor = [UIColor clearColor];
      [self addSubview:line];
      [_seperateLineArray addObject:line];
    }

  }];
  [self createIndicatorLine];

  [self _setButtonTitleColor];
}

- (void)createIndicatorLine {
  if (_blueLineView) {
    [_blueLineView removeFromSuperview];
  }
  if (_bottomLineView) {
    [_bottomLineView removeFromSuperview];
  }

  //创建蓝色滑动粗线

  _blueLineView = [[UIView alloc]
      initWithFrame:CGRectMake(tabButtonWidth * _selectedTabIndex,
                               self.bounds.size.height - 3, tabButtonWidth,
                               2.5)];
  _blueLineView.backgroundColor = titleColorHighlight;
  [self addSubview:_blueLineView];

  _bottomLineView = [[UIView alloc]
      initWithFrame:CGRectMake(0, HEIGHT_OF_VIEW - 1, WIDTH_OF_VIEW, 1)];
  _bottomLineView.backgroundColor = titleColorHighlight;
  [self addSubview:_bottomLineView];
}

/** 点击按钮 */
- (void)buttonSelected:(UIButton *)button {
  NSInteger index = button.tag;
  [self buttonSelectedAtIndex:index animation:YES];
}

- (void)buttonSelectedAtIndex:(NSInteger)index animation:(BOOL)animation {
  //忽略无效请求
  if (index < 0 || _tabButtonArray.count <= index) {
    return;
  }

  _selectedTabIndex = index;
  //重置按钮颜色
  [self _setButtonTitleColor];

  //通知观察者
  if (_tabSelectedAtIndex) {
    _tabSelectedAtIndex(index);
  }

  [self resetBlueLineWithAnimation:animation];
}

///重置蓝色滑块：按钮点击的，采用动画方式；页面滑动触发的，采用非动画方式
- (void)resetBlueLineWithAnimation:(BOOL)animation {
  [UIView beginAnimations:nil context:NULL];
  if (animation) {
    [UIView setAnimationDuration:0.3];
  } else {
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.05];
  }

  [UIView setAnimationCurve:UIViewAnimationCurveLinear];
  _blueLineView.left = _selectedTabIndex * tabButtonWidth;

  [UIView commitAnimations];
}

///重置按钮颜色
- (void)_setButtonTitleColor {
  NSInteger index = _selectedTabIndex;
  [_tabButtonArray enumerateObjectsUsingBlock:^(UIButton *button,
                                                NSUInteger idx, BOOL *stop) {
    if (idx == index) {
      [button setTitleColor:titleColorHighlight forState:UIControlStateNormal];
      button.titleLabel.font = [UIFont boldSystemFontOfSize:Font_Height_16_0];
    } else {
      [button setTitleColor:titleColorNormal forState:UIControlStateNormal];
      button.titleLabel.font = [UIFont systemFontOfSize:Font_Height_16_0];
    }
    [button setTitleColor:titleColorHighlight
                 forState:UIControlStateHighlighted];
  }];
}

@end

@implementation SimuBottomTabView

- (void)createIndicatorLine {
  [super createIndicatorLine];

  //创建蓝色滑动粗线
  self.blueLineView.frame =
      CGRectMake(tabButtonWidth * _selectedTabIndex, 0, tabButtonWidth, 3);

  _bottomLineView.frame = CGRectMake(0, 0, WIDTH_OF_VIEW, 1);
  _bottomLineView.backgroundColor = [Globle colorFromHexRGB:@"#d1d3d8"];
}

@end

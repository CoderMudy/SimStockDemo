//
//  simuTabSelView.m
//  SimuStock
//
//  Created by Mac on 14-8-10.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

@implementation SimuTabSelelctorView

- (id)initWithFrame:(CGRect)frame TitleArray:(NSArray *)array;
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    _selectedIndex = 0;
    _animationIsRuning = NO;
    _titleArray = [[NSMutableArray alloc] initWithArray:array];
    _buttonArray = [[NSMutableArray alloc] init];
    [self creatControlsViews];
  }
  return self;
}

- (void)resetTitleArray:(NSArray *)titleArray andIndex:(NSInteger)index
{
  if (!titleArray)
    return;
  _selectedIndex = index;
  [_titleArray removeAllObjects];
  for (UIButton *button in _buttonArray) {
    [button removeFromSuperview];
  }
  [_buttonArray removeAllObjects];
  [_titleArray addObjectsFromArray:titleArray];
  [_blueLineView removeFromSuperview];
  _blueLineView = nil;
  [self creatControlsViews];
}


- (void)creatControlsViews {
  float button_width = self.bounds.size.width / [_titleArray count];
  int i = 0;
  for (NSString *title in _titleArray) {
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneButton.frame =
        CGRectMake(i * button_width, 0, button_width, self.bounds.size.height);
    [phoneButton setBackgroundColor:[UIColor clearColor]];
    [phoneButton setTitle:title forState:UIControlStateNormal];
    [phoneButton setTitle:title forState:UIControlStateHighlighted];
    if (i == 0) {
      [phoneButton setTitleColor:[Globle colorFromHexRGB:COLOR_DARK_BLUE]
                        forState:UIControlStateNormal];
    } else {
      [phoneButton setTitleColor:[Globle colorFromHexRGB:Color_Icon_Title]
                        forState:UIControlStateNormal];
    }
    [phoneButton setTitleColor:[Globle colorFromHexRGB:COLOR_DARK_BLUE]
                      forState:UIControlStateHighlighted];
    phoneButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [phoneButton addTarget:self
                    action:@selector(buttonSelected:)
          forControlEvents:UIControlEventTouchUpInside];
    phoneButton.tag = i;
    [self addSubview:phoneButton];
    [_buttonArray addObject:phoneButton];
    i++;
  }

  
  //创建蓝色滑动粗线
  _blueLineView =
      [[UIView alloc] initWithFrame:CGRectMake(button_width * _selectedIndex, self.bounds.size.height - 3,
                                               button_width, 2.5)];
  _blueLineView.backgroundColor = [Globle colorFromHexRGB:COLOR_DARK_BLUE];
  [self addSubview:_blueLineView];
}

//(大的标题，@“行情，资讯，F10资料，聊股”按钮选择被选择状态)
- (void)resetWidthIndexNoCallBack:(NSInteger)index{
    int i = 0;
    if (_selectedIndex == index)
        return;
    _selectedIndex = index;
    //设定按钮颜色
    for (UIButton *button in _buttonArray) {
        if (i == index) {
            [button setTitleColor:[Globle colorFromHexRGB:COLOR_DARK_BLUE]
                         forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[Globle colorFromHexRGB:Color_Icon_Title]
                         forState:UIControlStateNormal];
        }
        i++;
    }
}
//(大的标题，@“行情，资讯，F10资料，聊股”按钮选择被选择状态)
- (void)resetWidthIndex:(NSInteger)index {
  int i = 0;

  //设定按钮颜色
  for (UIButton *button in _buttonArray) {
    if (i == index) {
      [button setTitleColor:[Globle colorFromHexRGB:COLOR_DARK_BLUE]
                   forState:UIControlStateNormal];
      if (_delegate && [_delegate respondsToSelector:@selector(setSelectedTab:)]) {
        [_delegate setSelectedTab:i];
      }
    } else {
      [button setTitleColor:[Globle colorFromHexRGB:Color_Icon_Title]
                   forState:UIControlStateNormal];
    }
    i++;
  }
  //设定地步位置
  [self viewcontrolerHideWidthAnimation];
}

- (void)buttonSelected:(UIButton *)button {
  if (_animationIsRuning)
    return;
  _animationIsRuning = YES;
  [self performSelector:@selector(stopSelfViewContolerAnimation)
             withObject:nil
             afterDelay:0.3];
  int i = 0;
  NSInteger index = button.tag;
  if (_selectedIndex == index)
    return;
  _selectedIndex = index;
  //设定按钮颜色
  for (UIButton *button in _buttonArray) {
    if (i == index) {
      [button setTitleColor:[Globle colorFromHexRGB:COLOR_DARK_BLUE]
                   forState:UIControlStateNormal];
    } else {
      [button setTitleColor:[Globle colorFromHexRGB:Color_Icon_Title]
                   forState:UIControlStateNormal];
    }
    i++;
  }
  if (_delegate && [_delegate respondsToSelector:@selector(setSelectedTab:)]) {
    [_delegate setSelectedTab:_selectedIndex];
  }
  //设定地步位置
  [self viewcontrolerHideWidthAnimation];
}
- (void)viewcontrolerHideWidthAnimation {
  [UIView beginAnimations:@"animationID" context:nil];
  [UIView setAnimationDuration:0.2];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
  [UIView commitAnimations];
}
- (void)stopSelfViewContolerAnimation {
  _animationIsRuning = NO;
}

@end

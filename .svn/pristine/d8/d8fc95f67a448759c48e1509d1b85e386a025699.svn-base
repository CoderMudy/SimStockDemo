//
//  simuCenterTabView.m
//  SimuStock
//
//  Created by Mac on 14-8-12.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuCenterTabView.h"
#import "SimuUtil.h"

@interface SimuCenterTabView () {
  //线
  NSMutableArray *_lineArray;
}

@end

@implementation SimuCenterTabView

- (void)awakeFromNib {
  _buttonArray = [[NSMutableArray alloc] init];
  _lineArray = [NSMutableArray array];
  _index = 0;
  _array = [[NSMutableArray array] init];
  self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
}

- (id)initWithFrame:(CGRect)frame titleArray:(NSArray *)array {
  self = [super initWithFrame:frame];
  if (self) {
    _index = 0;
    self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
    _array = [[NSMutableArray alloc] initWithArray:array];
    _buttonArray = [[NSMutableArray alloc] init];
    _lineArray = [NSMutableArray array];
    [self creatViews];
  }
  return self;
}

- (void)creatViews {
  NSLog(@"%@", NSStringFromCGRect(self.bounds));
  if (_array.count == 0)
    return;

  self.layer.borderColor = [Globle colorFromHexRGB:Color_Blue_but].CGColor;
  self.layer.borderWidth = 0.5f;
  self.layer.masksToBounds = YES;

  float space = self.bounds.size.width / _array.count;
  int i = 0;
  for (NSString *title in _array) {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(i * space - 1, 0, space + 1, self.bounds.size.height);
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = [UIFont systemFontOfSize:Font_Height_12_0];
    button.tag = i;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    [button setTitleColor:[Globle colorFromHexRGB:Color_Blue_but] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [button addTarget:self
                  action:@selector(buttonPressDown:)
        forControlEvents:UIControlEventTouchDown];

    if (button.tag == _index) {
      button.backgroundColor = [Globle colorFromHexRGB:Color_Blue_but];
      [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    [_buttonArray addObject:button];
    [self addSubview:button];
    i++;
  }
  //画线条
  for (int i = 1; i < _array.count; i++) {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(space * i, 0, 0.5f, self.bounds.size.height)];
    line.backgroundColor = [Globle colorFromHexRGB:Color_Blue_but];
    [self addSubview:line];
    [_lineArray addObject:line];
  }
}
- (void)buttonPressDown:(UIButton *)button {
  _index = button.tag;
  for (UIButton *button in _buttonArray) {
    if (button.tag == _index) {
      button.backgroundColor = [Globle colorFromHexRGB:Color_Blue_but];
      [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    } else {
      button.backgroundColor = [UIColor clearColor];
      [button setTitleColor:[Globle colorFromHexRGB:Color_Blue_but] forState:UIControlStateNormal];
    }
  }
  if (_delegate && [_delegate respondsToSelector:@selector(tabSelected:)]) {
    [_delegate tabSelected:_index];
    //新增的判断方法，用于判断具体是哪个view
  }
}

- (void)buttonSelected:(NSInteger)index {
  [_buttonArray enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
    if (button.tag == index) {
      [self buttonPressDown:button];
    }
  }];
}

- (void)resetButtons:(NSArray *)array {
  [_array removeAllObjects];
  [_array addObjectsFromArray:array];
  [_buttonArray removeAllObjects];
  [self removeAllSubviews];
  [self creatViews];
}

/** 重新设置frame */
- (void)reSetUpFrameSimuCenterTableView {
  float space = self.bounds.size.width / _array.count;
  //边框和分割线

  for (int i = 0; i < _lineArray.count; i++) {
    UIView *lineView = _lineArray[i];
    lineView.frame = CGRectMake((i + 1) * space, 0, 0.5f, self.bounds.size.height);
  }
  for (int i = 0; i < _buttonArray.count; i++) {
    UIButton *btn = _buttonArray[i];
    btn.frame = CGRectMake(i * space - 1, 0, space + 1, self.bounds.size.height);
  }
}

-(void)layoutSubviews
{
  [super layoutSubviews];
  [self reSetUpFrameSimuCenterTableView];
}

@end

//
//  TopToolBarView.m
//  SimuStock
//
//  Created by Mac on 14-5-14.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "TopToolBarUIScrollView.h"
#import "SimuUtil.h"
#import "NewsChannelList.h"

@implementation TopToolBarUIScrollView

@synthesize Tooldelegate = _Tooldelegate;

- (id)initWithFrame:(CGRect)frame
          DataArray:(NSArray *)dataArray
withInitButtonIndex:(int)buttonIndex {
  self = [super initWithFrame:frame];
  if (self) {
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.bounces = NO;
    // Initialization code
    self.backgroundColor = [Globle colorFromHexRGB:@"ffffff"]; //#f8f8f8
    _ttlv_corSelIndex = buttonIndex;
    ttlv_buttonArray = [[NSMutableArray alloc] init];
    [self creatCtrlor:dataArray];
    ttlv_isAnimationRuning = NO;

    topStatus = NO;
  }
  return self;
}

#pragma mark
#pragma mark - 计算cell的自适应高度
//测试文字的的高度
- (CGFloat)label_size_comment_view:(NSString *)str {

  UIFont *font = [UIFont systemFontOfSize:Font_Height_16_0];

  CGFloat WidTH = 0.0f;
  WidTH = [str sizeWithFont:font
              constrainedToSize:CGSizeMake(self.width, 30)
                  lineBreakMode:NSLineBreakByCharWrapping]
              .width;

  //    获得尺寸  UILineBreakModeWordWrap

  return WidTH + 1;
}

#pragma mark
#pragma mark 创建各个控件
- (void)creatCtrlor:(NSArray *)dataArray {
  [ttlv_buttonArray removeAllObjects];
  [self removeAllSubviews];
  self.contentOffset = CGPointMake(0, 0);
  self.contentSize = CGSizeMake(0, self.height);
  if (dataArray.count > 0) {
    //创建底部颜色
    UIView *botomlineview =
        [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 2,
                                                 self.bounds.size.width, 2)];
    botomlineview.backgroundColor = [UIColor whiteColor];
    [self addSubview:botomlineview];

    int index = 1000;
    CGFloat m_top = 0.f;
    CGFloat m_width = WIDTH_OF_SCREEN / 4.f;
    ///当前下划线的rect
    CGRect lineRect = CGRectMake(0, self.height - 2.5, m_width, 2);
    for (NewsChannelItem *obj in dataArray) {
      //[self label_size_comment_view:obj.name];

      //区域记录
      CGRect ButonRect = CGRectMake(m_top, 0, m_width, self.bounds.size.height);
      //起点
      m_top = m_top + m_width;
      if (_ttlv_corSelIndex == index - 1000) {
        lineRect = CGRectMake(ButonRect.origin.x, self.height - 2.5,
                              ButonRect.size.width, 2);
      }
      //加入按钮
      UIButton *selButton = [UIButton buttonWithType:UIButtonTypeCustom];
      selButton.titleLabel.font = [UIFont systemFontOfSize:Font_Height_16_0];
      [selButton setTitle:obj.name forState:UIControlStateNormal];
      selButton.titleLabel.textAlignment = NSTextAlignmentCenter;
      [selButton setTitle:obj.name forState:UIControlStateHighlighted];
      [selButton setTitleColor:[Globle colorFromHexRGB:Color_Text_Common]
                      forState:UIControlStateNormal];
      [ttlv_buttonArray addObject:selButton];

      selButton.frame = ButonRect;
      selButton.tag = index;
      selButton.backgroundColor = [UIColor clearColor];
      [selButton addTarget:self
                    action:@selector(buttonHighlight:)
          forControlEvents:UIControlEventTouchDown];
      [selButton addTarget:self
                    action:@selector(butonPressDown:)
          forControlEvents:UIControlEventTouchDown];
      [selButton addTarget:self
                    action:@selector(buttonNormal:)
          forControlEvents:UIControlEventTouchUpOutside];
      [self addSubview:selButton];

      index++;
    }
    self.contentSize = CGSizeMake(m_top, self.height);
    UIButton *button = (UIButton *)[self viewWithTag:_ttlv_corSelIndex + 1000];
    [self maxlineViewWithFrame:button];

    _maxlineView = [[UIView alloc] initWithFrame:lineRect];
    _maxlineView.backgroundColor = [Globle colorFromHexRGB:Color_Blue_but];
    [self addSubview:_maxlineView];

    ttlv_bottomLineView = [[UIView alloc]
        initWithFrame:CGRectMake(0, HEIGHT_OF_VIEW - 1, m_top, 1)];
    ttlv_bottomLineView.backgroundColor =
        [Globle colorFromHexRGB:Color_Blue_but];
    [self addSubview:ttlv_bottomLineView];
    [self resetButtons];
  }
}
- (void)buttonHighlight:(UIButton *)button {
  [button setTitleColor:[Globle colorFromHexRGB:Color_Blue_butDown]
               forState:UIControlStateNormal];
}

- (void)buttonNormal:(UIButton *)button {
  [button setTitleColor:[Globle colorFromHexRGB:Color_Text_Common]
               forState:UIControlStateNormal];
}
- (void)butonPressDown:(UIButton *)button {
  [self buttonNormal:button];
  ///偏移量
  [self maxlineViewWithFrame:button];

  if (_ttlv_corSelIndex == button.tag - 1000)
    return;
  if (ttlv_isAnimationRuning == YES)
    return;
  ttlv_isAnimationRuning = YES;
  _ttlv_corSelIndex = button.tag - 1000;
  //设定按钮颜色
  [self resetButtons];
  [self setDelegatedate];
}

///偏移量
- (void)maxlineViewWithFrame:(UIButton *)button {
  CGRect lineRect =
      CGRectMake(button.origin.x, self.height - 2.5, button.size.width, 2);
  [self buttonMoveWithAnimation:lineRect];
  ///让按钮居中
  if (lineRect.origin.x > self.width / 2 - lineRect.size.width / 2) {
    CGFloat y_w = button.origin.x + lineRect.size.width / 2 + self.width / 2;
    if (y_w > self.contentSize.width) {
      y_w = button.origin.x - (self.width / 2 - lineRect.size.width / 2) -
            (y_w - self.contentSize.width);
    } else {
      y_w = button.origin.x - (self.width / 2 - lineRect.size.width / 2);
    }

    [self setContentOffset:CGPointMake(y_w, 0) animated:YES];
  } else {
    [self setContentOffset:CGPointMake(0, 0) animated:YES];
  }
}

- (void)resetButtons {
  for (UIButton *obj in ttlv_buttonArray) {
    if (_ttlv_corSelIndex == obj.tag - 1000) {
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
  if (self.Tooldelegate && topStatus == NO) {
    [self.Tooldelegate changeToIndex:_ttlv_corSelIndex];
  } else {
    topStatus = NO;
  }
}

#pragma mark
#pragma mark 动画相关函数
- (void)buttonMoveWithAnimation:(CGRect)rect {
  [UIView beginAnimations:nil context:nil];
  //持续时间
  [UIView setAnimationDuration:0.1];
  //在出动画的时候减缓速度
  [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
  //添加动画开始及结束的代理
  [UIView setAnimationDelegate:self];
  //[UIView setAnimationWillStartSelector:@selector(begin)];
  [UIView setAnimationDidStopSelector:@selector(stopPickViewAni)];

  _maxlineView.frame = rect;
  [UIView commitAnimations];
}

- (void)stopPickViewAni {
  ttlv_isAnimationRuning = NO;
}
#pragma mark
#pragma mark 对外接口
- (void)changTapToIndex:(NSInteger)index {
  if (index >= 0 && index < ttlv_buttonArray.count) {
    UIButton *button = (UIButton *)[self viewWithTag:index + 1000];
    topStatus = YES;
    [self butonPressDown:button];
  }
}

@end

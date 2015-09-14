//
//  RoundButtonView.m
//  SimuStock
//
//  Created by Mac on 14-5-14.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "RoundButtonView.h"
#import "SimuUtil.h"

#import "UIImage+ColorTransformToImage.h"

@implementation RoundButtonView
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
              DataArray:(NSArray *)dataArray
    withInitButtonIndex:(int)buttonIndex {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
    sqv_corTopButtonindex = buttonIndex;
    sqv_buttonArray = [[NSMutableArray alloc] init];
    [self creatCtrlor:dataArray];
    sqv_isButtonAnimateRun = NO;
  }
  return self;
}
#pragma mark
#pragma mark 创建各个控件
- (void)creatCtrlor:(NSArray *)dataArray {

  if (dataArray == Nil)
    return;

  //创建按钮
  NSInteger count = 1;
  if (dataArray && [dataArray count] != 0) {
    count = [dataArray count];
  }
  int index = 0;
  CGFloat m_height = self.bounds.size.height;
  CGFloat m_width = self.bounds.size.width / (count);
  CGRect ButonRect = CGRectMake(0.5, 0, m_width, self.bounds.size.height);
  ;
  //按钮选中背景
  sqv_butselImageView = [[UIImageView alloc] initWithFrame:ButonRect];
  UIImage *selbuttonimage =
      [UIImage imageFromView:sqv_butselImageView
          withBackgroundColor:
              [Globle colorFromHexRGB:Color_Blue_but]]; // SST_Top_buttonsel.png
  [sqv_butselImageView setImage:selbuttonimage];
  [self addSubview:sqv_butselImageView];

  for (NSString *obj in dataArray) {
    //区域记录
    if (count < 10) {
      sqv_buttonselbackRect[index] = CGRectMake(
          m_width * index, 0, self.bounds.size.width / count, m_height);
    }
    //创建上方按钮
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = sqv_buttonselbackRect[index];
    button1.tag = index;
    [button1 setTitle:obj forState:UIControlStateNormal];
    if (index == sqv_corTopButtonindex) {
      [button1 setTitleColor:[UIColor whiteColor]
                    forState:UIControlStateNormal];
      sqv_butselImageView.frame =
          CGRectMake(sqv_buttonselbackRect[index].origin.x + 0.5, 0,
                     sqv_buttonselbackRect[index].size.width,
                     sqv_buttonselbackRect[index].size.height);
    } else {
      [button1 setTitleColor:[Globle colorFromHexRGB:Color_Icon_Title]
                    forState:UIControlStateNormal]; //原#2F2E2E
    }

    [button1.layer setBorderWidth:0.5];
    [button1.layer setBorderColor:[Globle colorFromHexRGB:Color_Blue_but].CGColor];
    [self addSubview:button1];
    button1.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [button1 addTarget:self
                  action:@selector(TopButtonPress:)
        forControlEvents:UIControlEventTouchDown];
    [sqv_buttonArray addObject:button1];

    index++;
  }
}
#pragma amrk
#pragma mark 事件处理相关
- (void)TopButtonPress:(UIButton *)button {
  if (sqv_corTopButtonindex == button.tag)
    return;
  if (sqv_isButtonAnimateRun == YES)
    return;
  [self buttonMoveWidthAnimation:button.tag];
  //修改按钮字颜色
  for (UIButton *obj in sqv_buttonArray) {
    if (obj.tag == button.tag) {
      [obj setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
      [obj setTitleColor:[Globle colorFromHexRGB:Color_Icon_Title]
                forState:UIControlStateNormal]; //原#2F2E2E
    }
  }
  if (_delegate) {
    [_delegate roundSelectedChange:sqv_corTopButtonindex];
  }
}
//上方按钮动画
- (void)buttonMoveWidthAnimation:(NSInteger)index {
  if (sqv_corTopButtonindex == index)
    return;
  if (sqv_isButtonAnimateRun == YES)
    return;
  sqv_corTopButtonindex = index;
  sqv_isButtonAnimateRun = YES;
  [UIView beginAnimations:nil context:nil];
  //持续时间
  [UIView setAnimationDuration:0.4];
  //在出动画的时候减缓速度
  [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
  //添加动画开始及结束的代理
  [UIView setAnimationDelegate:self];
  //[UIView setAnimationWillStartSelector:@selector(begin)];
  [UIView setAnimationDidStopSelector:@selector(stopAni)];
  sqv_butselImageView.frame =
      CGRectMake(sqv_buttonselbackRect[index].origin.x + 0.5, 0,
                 sqv_buttonselbackRect[index].size.width,
                 sqv_buttonselbackRect[index]
                     .size.height); // sqv_buttonselbackRect[index];
  [UIView commitAnimations];
}
//动画结束
- (void)stopAni {
  sqv_isButtonAnimateRun = NO;
}
- (void)resetTabIndex:(NSInteger)index {
  UIButton *buton = [UIButton buttonWithType:UIButtonTypeCustom];
  buton.tag = index;
  [self TopButtonPress:buton];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

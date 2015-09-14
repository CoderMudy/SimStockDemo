//
//  SimuTabView.m
//  SimuStock
//
//  Created by Mac on 13-8-28.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "SimuTabView.h"
#import "SimuUtil.h"

@implementation SimuTabView

@synthesize delegate = _delegate;
@synthesize corIndexTab = stv_corIndexTab;

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    stv_corIndexTab = 0;
    stv_buttonBackImageView = [[UIImageView alloc]
        initWithImage:[UIImage imageNamed:@"TopTool_button.png"]];
    stv_buttonBackImageView.contentMode = UIViewContentModeTopLeft;
    stv_buttonBackImageView.frame = CGRectMake(153, 0, 151, 49);
    [self addSubview:stv_buttonBackImageView];

    stv_buttonBackleftImageView = [[UIImageView alloc]
        initWithImage:[UIImage imageNamed:@"TopTool_button.png"]];
    stv_buttonBackleftImageView.contentMode = UIViewContentModeTopLeft;
    stv_buttonBackleftImageView.frame = CGRectMake(0, 0, 151, 49);
    [self addSubview:stv_buttonBackleftImageView];
    stv_buttonBackleftImageView.hidden = YES;

    stv_leftBackImageView = [[UIImageView alloc]
        initWithImage:[UIImage imageNamed:@"TopTool_tableft.png"]];
    stv_leftBackImageView.contentMode = UIViewContentModeTopLeft;
    stv_leftBackImageView.frame = CGRectMake(0, 0, 305, 49);
    [self addSubview:stv_leftBackImageView];

    stv_rightBackImageView = [[UIImageView alloc]
        initWithImage:[UIImage imageNamed:@"TopTool_tabright.png"]];
    stv_rightBackImageView.contentMode = UIViewContentModeTopLeft;
    stv_rightBackImageView.frame = CGRectMake(0, 0, 305, 49);
    [self addSubview:stv_rightBackImageView];
    stv_rightBackImageView.hidden = YES;

    //加入图标
    UIImage *buyimage = [UIImage imageNamed:@"buy.png"];
    UIImageView *buyimageView = [[UIImageView alloc] initWithImage:buyimage];
    buyimageView.frame =
        CGRectMake(stv_buttonBackleftImageView.frame.origin.x + 36,
                   stv_buttonBackleftImageView.frame.origin.y + 7,
                   buyimage.size.width, buyimage.size.height);
    [self addSubview:buyimageView];
    //加入按钮
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.frame = stv_buttonBackleftImageView.frame;
    leftbutton.backgroundColor = [UIColor clearColor];
    leftbutton.tag = 0;
    [leftbutton setTitle:@"买入" forState:UIControlStateNormal];
    [leftbutton setTitle:@"买入" forState:UIControlStateHighlighted];
    [leftbutton setTitleColor:[Globle colorFromHexRGB:Color_Dark]
                     forState:UIControlStateNormal];
    leftbutton.titleLabel.font = [UIFont boldSystemFontOfSize:Font_Height_16_0];
    NSString *content = @"买入";
    CGSize size =
        [content sizeWithFont:[UIFont boldSystemFontOfSize:Font_Height_16_0]];
    float but_width =
        (stv_buttonBackleftImageView.frame.size.width - size.width) / 2;
    float but_height =
        (stv_buttonBackleftImageView.frame.size.height - size.height) / 2;
    leftbutton.titleEdgeInsets =
        UIEdgeInsetsMake(but_height - 5, but_width, but_height + 5, but_width);
    [leftbutton addTarget:self
                   action:@selector(butonPress:)
         forControlEvents:UIControlEventTouchUpInside];
    leftbutton.backgroundColor = [UIColor clearColor];
    [self addSubview:leftbutton];

    UIImage *sellimage = [UIImage imageNamed:@"sell.png"];
    UIImageView *sellimageView = [[UIImageView alloc] initWithImage:sellimage];
    sellimageView.frame =
        CGRectMake(stv_buttonBackImageView.frame.origin.x + 36,
                   stv_buttonBackImageView.frame.origin.y + 7,
                   buyimage.size.width, buyimage.size.height);
    [self addSubview:sellimageView];

    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.frame = stv_buttonBackImageView.frame;
    rightbutton.backgroundColor = [UIColor clearColor];
    rightbutton.tag = 1;
    [rightbutton setTitle:@"卖出" forState:UIControlStateNormal];
    [rightbutton setTitle:@"卖出" forState:UIControlStateHighlighted];
    [rightbutton setTitleColor:[Globle colorFromHexRGB:Color_Dark]
                      forState:UIControlStateNormal];
    rightbutton.titleEdgeInsets =
        UIEdgeInsetsMake(but_height - 5, but_width, but_height + 5, but_width);
    rightbutton.titleLabel.font =
        [UIFont boldSystemFontOfSize:Font_Height_16_0];
    [rightbutton addTarget:self
                    action:@selector(butonPress:)
          forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightbutton];
  }
  return self;
}
//按钮点击
- (void)butonPress:(UIButton *)button {
  NSInteger tag = button.tag;
  if (stv_corIndexTab == tag)
    return;
  stv_corIndexTab = tag;
  if (_delegate && [_delegate respondsToSelector:@selector(tabChange:)]) {
    [_delegate tabChange:stv_corIndexTab];
  }
  [self viewChangeWidthAnimation:button.tag];
}

// tab点击处理
- (void)viewChangeWidthAnimation:(NSInteger)tag {
  stv_rightBackImageView.hidden = NO;
  stv_buttonBackleftImageView.hidden = NO;
  stv_rightBackImageView.hidden = NO;
  stv_buttonBackleftImageView.hidden = NO;

  if (stv_corIndexTab == 0) {
    //点击左边按钮
    //        stv_rightBackImageView.hidden=YES;
    //        stv_buttonBackleftImageView.hidden=YES;
    //        stv_rightBackImageView.hidden=NO;
    //        stv_buttonBackleftImageView.hidden=NO;

    stv_leftBackImageView.alpha = 0;
    stv_buttonBackImageView.alpha = 0;
    stv_rightBackImageView.alpha = 1;
    stv_buttonBackleftImageView.alpha = 1;
    stv_leftBackImageView.hidden = NO;
    stv_buttonBackImageView.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    //持续时间
    [UIView setAnimationDuration:0.2];
    //在出动画的时候减缓速度
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    //添加动画开始及结束的代理
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationWillStartSelector:@selector(begin)];
    //[UIView setAnimationDidStopSelector:@selector(stopPickViewAni)];
    stv_leftBackImageView.alpha = 1;
    stv_buttonBackImageView.alpha = 1;
    stv_rightBackImageView.alpha = 0;
    stv_buttonBackleftImageView.alpha = 0;
    [UIView commitAnimations];

  } else if (stv_corIndexTab == 1) {
    //点击右边按钮
    //        stv_leftBackImageView.hidden=YES;
    //        stv_buttonBackImageView.hidden=YES;
    //        stv_rightBackImageView.hidden=NO;
    //        stv_buttonBackleftImageView.hidden=NO;
    stv_leftBackImageView.alpha = 1;
    stv_buttonBackImageView.alpha = 1;
    stv_rightBackImageView.alpha = 0;
    stv_buttonBackleftImageView.alpha = 0;
    stv_leftBackImageView.hidden = NO;
    stv_buttonBackImageView.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    //持续时间
    [UIView setAnimationDuration:0.2];
    //在出动画的时候减缓速度
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    //添加动画开始及结束的代理
    [UIView setAnimationDelegate:self];
    //[UIView setAnimationWillStartSelector:@selector(begin)];
    //[UIView setAnimationDidStopSelector:@selector(stopPickViewAni)];
    stv_leftBackImageView.alpha = 0;
    stv_buttonBackImageView.alpha = 0;
    stv_rightBackImageView.alpha = 1;
    stv_buttonBackleftImageView.alpha = 1;
    [UIView commitAnimations];
  }
}

//无动画切换tab状态
- (void)changTabwithoutAnimation:(NSInteger)index {
  if (stv_corIndexTab == index)
    return;
  stv_corIndexTab = index;
  [self viewChangeWidthAnimation:index];
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

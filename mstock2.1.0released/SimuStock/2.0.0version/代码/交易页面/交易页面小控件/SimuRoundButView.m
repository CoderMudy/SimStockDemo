//
//  simuRoundButView.m
//  SimuStock
//
//  Created by Mac on 14-7-14.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuRoundButView.h"
#import "SimuUtil.h"
#import "UIImage+ColorTransformToImage.h"

@implementation SimuRoundButView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
          TitleName:(NSString *)title
                Tag:(NSInteger)m_tag {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    srbv_tag = m_tag;
    srbv_backView = [[UIView alloc] initWithFrame:self.bounds];
    srbv_backView.backgroundColor = [UIColor clearColor];
    srbv_backView.layer.cornerRadius = 27 / 2; //设置那个圆角的有多圆
    srbv_backView.layer.borderWidth = 0.5; //设置边框的宽度，当然可以不要
    srbv_backView.layer.borderColor =
        [[Globle colorFromHexRGB:Color_Blue_but] CGColor]; //设置边框的颜色
    srbv_backView.layer.masksToBounds = YES;           //设为NO去试试
    [self addSubview:srbv_backView];
    //加入按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.frame = self.bounds;
    [button.layer setMasksToBounds:YES];
    [button.layer setCornerRadius:13.5];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [button setTitleColor:[Globle colorFromHexRGB:Color_Blue_but]
                 forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor]
                 forState:UIControlStateHighlighted];
    UIImage *selectedImage =
        [UIImage imageFromView:button
            withBackgroundColor:[Globle colorFromHexRGB:Color_Blue_but]];
    [button setBackgroundImage:selectedImage
                      forState:UIControlStateHighlighted];
    [button addTarget:self
                  action:@selector(pressup:)
        forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
  }
  return self;
}

//按钮点击响应
- (void)pressup:(UIButton *)button {
  srbv_backView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  if (_delegate &&
      [_delegate respondsToSelector:@selector(roundButPressDown:)]) {
    [_delegate roundButPressDown:srbv_tag];
  }
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

//
//  simuButtonView.m
//  SimuStock
//
//  Created by Mac on 14-7-11.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuButtonView.h"
#import "SimuUtil.h"

@implementation SimuButtonView

- (id)initWithFrame:(CGRect)frame
          imageName:(NSString *)name
              Title:(NSString *)title
                Tag:(NSInteger)tag {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    _buttonTag = tag;
    self.backgroundColor = [UIColor whiteColor];
    UIView *view =
        [[UIView alloc] initWithFrame:CGRectInset(self.bounds, 1, 1)];
    view.backgroundColor = [Globle colorFromHexRGB:Color_White]; //#f0efef
    [self addSubview:view];
    //设定图片
    if (name && [name length] > 0) {
      UIImage *image = [UIImage imageNamed:name];
      UIImageView *imageview = [[UIImageView alloc]
          initWithFrame:CGRectMake((self.bounds.size.width - image.size.width) /
                                       2,
                                   6, image.size.width, image.size.height)];
      imageview.image = image;
      [self addSubview:imageview];
    }
    //设定地下的名称标签
    UILabel *namelable = [[UILabel alloc]
        initWithFrame:CGRectMake(0, self.bounds.size.height - 6 - 10,
                                 self.bounds.size.width, 10)];
    namelable.backgroundColor = [UIColor clearColor];
    namelable.textColor = [Globle colorFromHexRGB:Color_Icon_Title];
    namelable.font = [UIFont systemFontOfSize:Font_Height_10_0];
    namelable.textAlignment = NSTextAlignmentCenter;
    namelable.text = title;
    [self addSubview:namelable];
    //设定按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    button.frame = self.bounds;
    [button setBackgroundImage:[UIImage imageNamed:@"点击背景图.png"]
                      forState:UIControlStateHighlighted];
    [button addTarget:self
                  action:@selector(PressUp:)
        forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
  }
  return self;
}

#pragma mark
#pragma mark 按钮响应函数
//按钮抬起
- (void)PressUp:(UIButton *)button {
  if (self.delegate &&
      [self.delegate
          respondsToSelector:@selector(simuButtonPressDownDelegate:)]) {
    [self.delegate simuButtonPressDownDelegate:_buttonTag];
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

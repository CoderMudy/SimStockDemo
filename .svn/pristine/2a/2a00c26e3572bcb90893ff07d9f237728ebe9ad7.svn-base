//
//  animationView.m
//  SimuStock
//
//  Created by moulin wang on 14-7-24.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "animationView.h"
#import "SimuUtil.h"
@implementation animationView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
//    self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
    [self createView];
  }
  return self;
}
- (void)createView {
  fishImageView =
      [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"小鱼01"]];
  fishImageView.frame = CGRectMake((self.bounds.size.width - 272.0 / 2) / 2,
                                   30.0f, 272.0 / 2, 223.0 / 2);
  [self addSubview:fishImageView];
  //设置动画帧
  fishImageView.animationImages =
      @[[UIImage imageNamed:@"小鱼01"],
          [UIImage imageNamed:@"小鱼02"],
          [UIImage imageNamed:@"小鱼03"],
          [UIImage imageNamed:@"小鱼04"]];

  //设置动画总时间
  fishImageView.animationDuration = 1.5;
  //设置重复次数，0表示不重复
  fishImageView.animationRepeatCount = -1;
  //开始动画
  [fishImageView startAnimating];

  UILabel *loginLabel = [[UILabel alloc] init];
  loginLabel.frame = CGRectMake(0,36.0 / 2 + 223.0 / 2+20,
                                self.bounds.size.width, 30.0 / 2);
  loginLabel.text = @"首次登录即送10万元模拟炒股资金";
  loginLabel.textAlignment = NSTextAlignmentCenter;
  loginLabel.backgroundColor = [UIColor clearColor];
  loginLabel.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  loginLabel.font = [UIFont systemFontOfSize:Font_Height_14_0];
  [self addSubview:loginLabel];

//  //登录按钮
//  UIButton *logInBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//  logInBtn.frame = self.bounds;
//  logInBtn.backgroundColor = [UIColor clearColor];
//  [logInBtn addTarget:self
//                action:@selector(loginButtonTriggeringMethod:)
//      forControlEvents:UIControlEventTouchUpInside];
//  [self addSubview:logInBtn];
}
- (void)loginButtonTriggeringMethod:(UIButton *)btn {
  if (_delegate && [_delegate respondsToSelector:@selector(logInMethod)]) {
    [_delegate logInMethod];
  }
}


@end

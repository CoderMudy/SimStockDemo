//
//  SimuJoinBottomTabView.m
//  SimuStock
//
//  Created by Mac on 14-8-2.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuJoinBottomTabView.h"
#import "SimuUtil.h"

@implementation SimuJoinBottomTabView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }
  return self;
}
- (void)creatContrller {
  //toolBar顶端一像素的线
  UIView *toolBarTopLineView =
  [[UIView alloc] initWithFrame:CGRectMake(0,0,WIDTH_OF_SCREEN, 1)];
  toolBarTopLineView.backgroundColor = [Globle colorFromHexRGB:@"#000000"];
  toolBarTopLineView.alpha = 0.08;
  [self addSubview:toolBarTopLineView];
  //名称
  NSArray *nameArray =
      @[@"账户", @"买入", @"卖出", @"委托",
          @"聊股"];
  //普通图片名称
  NSArray *upnameArray =
      @[@"交易_UP", @"买入_up", @"卖出_up",
          @"查委托_up", @"聊股_UP"];
  //按下图片名称数组
  NSArray *downnameArray =
      @[@"交易_down", @"买入_down", @"卖出_down",
          @"查委托_down", @"聊股_down"];
  float btnWidth = self.bounds.size.width / [upnameArray count];

  for (int i = 0; i < [upnameArray count]; i++) {
    UIImage *up_image = [UIImage imageNamed:upnameArray[i]];
    UIImage *down_image = [UIImage imageNamed:downnameArray[i]];
    CGRect rect = CGRectMake(btnWidth * i + (btnWidth - up_image.size.width) / 2.0f,
                             4+(19.5-up_image.size.height)/2.0f, up_image.size.width, up_image.size.height);
    //未点击的图片
    UIImageView *up_imageview = [[UIImageView alloc] initWithImage:up_image];
    up_imageview.frame = rect;
    [self addSubview:up_imageview];
    [sbtb_UpImageViewArray addObject:up_imageview];
    //点击后的图片
    UIImageView *down_imageview =
        [[UIImageView alloc] initWithImage:down_image];
    down_imageview.frame = rect;
    [self addSubview:down_imageview];
    down_imageview.hidden = YES;
    [sbtb_DownImageViewArray addObject:down_imageview];
    //文字数组
    UILabel *titleLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(btnWidth * i,
                                 27,
                                 btnWidth, 10)];
    titleLabel.font = [UIFont boldSystemFontOfSize:9];
    titleLabel.textColor = [Globle colorFromHexRGB:@"#444444"];
    titleLabel.text = nameArray[i];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [sbtb_LableArray addObject:titleLabel];
    [self addSubview:titleLabel];
    //加入按钮
    UIButton *sttbv_sysmsgbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    sttbv_sysmsgbutton.frame =
        CGRectMake(btnWidth * i, 0, btnWidth, self.bounds.size.height);
    sttbv_sysmsgbutton.backgroundColor = [UIColor clearColor];
    [sttbv_sysmsgbutton addTarget:self
                           action:@selector(buttonpressdown:)
                 forControlEvents:UIControlEventTouchUpInside];
    sttbv_sysmsgbutton.tag = i;
    [self addSubview:sttbv_sysmsgbutton];
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

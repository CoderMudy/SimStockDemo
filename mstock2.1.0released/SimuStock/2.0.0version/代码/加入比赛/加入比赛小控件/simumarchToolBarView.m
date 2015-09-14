//
//  simumarchToolBarView.m
//  SimuStock
//
//  Created by Mac on 14-7-29.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "simumarchToolBarView.h"
#import "SimuUtil.h"

@implementation simumarchToolBarView
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    sbtb_selectedindex = -1;
    sbtb_isButtonVisible = YES;
    sbtb_UpImageViewArray = [[NSMutableArray alloc] init];
    //按下图片数组
    sbtb_DownImageViewArray = [[NSMutableArray alloc] init];
    //文字lable数组
    sbtb_LableArray = [[NSMutableArray alloc] init];
    self.backgroundColor = [UIColor whiteColor];
    [self creatContrller];
    [self resetSelectedState:0];
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
  NSArray *nameArray = @[@"账户持仓", @"交易明细", @"历史持仓"];
  //普通图片名称
  NSArray *upnameArray =
      @[@"交易_UP", @"交易明细小图标_UP",
          @"历史持仓小图标_UP"];
  //按下图片名称数组
  NSArray *downnameArray =
      @[@"交易_down", @"交易明细_down",
          @"历史持仓小图标_down"];
  float m_width = self.bounds.size.width / 3;

  for (int i = 0; i < [upnameArray count]; i++) {
    UIImage *up_image = [UIImage imageNamed:upnameArray[i]];
    UIImage *down_image = [UIImage imageNamed:downnameArray[i]];
    CGRect rect = CGRectMake(m_width * i + (m_width - up_image.size.width) / 2,
                             6, up_image.size.width, up_image.size.height);
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
    UILabel *titlelable = [[UILabel alloc]
        initWithFrame:CGRectMake(m_width * i,
                                 up_imageview.frame.origin.y +
                                     up_imageview.bounds.size.height + 3,
                                 m_width, 10)];
    titlelable.font = [UIFont boldSystemFontOfSize:9];
    titlelable.textColor = [Globle colorFromHexRGB:@"#444444"];
    titlelable.text = nameArray[i];
    titlelable.textAlignment = NSTextAlignmentCenter;
    [sbtb_LableArray addObject:titlelable];
    [self addSubview:titlelable];
    //加入按钮
    UIButton *sttbv_sysmsgbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    sttbv_sysmsgbutton.frame =
        CGRectMake(m_width * i, 0, 120, self.bounds.size.height);
    sttbv_sysmsgbutton.backgroundColor = [UIColor clearColor];
    [sttbv_sysmsgbutton addTarget:self
                           action:@selector(buttonpressdown:)
                 forControlEvents:UIControlEventTouchUpInside];
    sttbv_sysmsgbutton.tag = i;
    [self addSubview:sttbv_sysmsgbutton];
  }
}

- (void)resetSelectedState:(NSInteger)new_index {
  if (new_index == sbtb_selectedindex)
    return;
  if (new_index < 0 || new_index > 3) {
    return;
  }
  sbtb_selectedindex = new_index;
  for (int i = 0; i < [sbtb_DownImageViewArray count]; i++) {
    //先前选中的图片和标签，重新设置状态
    UIImageView *imageview = sbtb_DownImageViewArray[i];
    imageview.hidden = YES;
    UIImageView *down_imageview = sbtb_UpImageViewArray[i];
    down_imageview.hidden = NO;
    UILabel *lable = sbtb_LableArray[i];
    lable.textColor = [Globle colorFromHexRGB:@"#444444"];
  }
  //设置新的图片和标签状态
  UIImageView *imageview = sbtb_DownImageViewArray[new_index];
  imageview.hidden = NO;
  UIImageView *down_imageview = sbtb_UpImageViewArray[new_index];
  down_imageview.hidden = YES;
  UILabel *lable = sbtb_LableArray[new_index];
  lable.textColor = [Globle colorFromHexRGB:Color_Blue_but];
}

#pragma mark
#pragma mark 按钮点击
- (void)buttonpressdown:(UIButton *)button {
  if (button.tag == sbtb_selectedindex)
    return;
  if (sbtb_isButtonVisible == NO)
    return;
  sbtb_isButtonVisible = NO;
  [self performSelector:@selector(ButtonCanPress)
             withObject:Nil
             afterDelay:0.5];
  [self resetSelectedState:button.tag];
  if (_delegate &&
      [_delegate respondsToSelector:@selector(bottomButtonPressDown:)]) {
    [_delegate bottomButtonPressDown:sbtb_selectedindex];
  }
}

- (void)ButtonCanPress {
  sbtb_isButtonVisible = YES;
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

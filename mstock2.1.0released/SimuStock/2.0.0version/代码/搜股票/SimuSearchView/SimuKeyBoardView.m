//
//  SimuKeyBoardView.m
//  SimuStock
//
//  Created by Mac on 13-9-14.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "SimuKeyBoardView.h"
#import "SimuUtil.h"

@implementation SimuKeyBoardView

@synthesize delegate = _delegate;
@synthesize siShiftDown = skbv_siShiftDown;

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    [self creatviews];
    skbv_siShiftDown = NO;
  }
  return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
//创建各个按钮和图片
- (void)creatviews {
  //背景图片
  UIView *backgroundImageView = [[UIImageView alloc] init];
  backgroundImageView.frame =
      CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
  backgroundImageView.backgroundColor = [Globle colorFromHexRGB:@"#dbdcdf"];
  [self addSubview:backgroundImageView];
  //创建数字键盘
  [self creatNumberKeyView];
  //创建字母键盘
  [self creatCharKeyView];
}
//创建字母键盘视图
- (void)creatCharKeyView {
  //字母键盘承载视图
  skbv_charKeyBaseView = [[UIView alloc] initWithFrame:self.bounds];
  skbv_charKeyBaseView.backgroundColor = [UIColor clearColor];
  [self addSubview:skbv_charKeyBaseView];
  skbv_charKeyBaseView.hidden = YES;

  //各个按钮
  NSArray *array = @[
    @"Q",
    @"W",
    @"E",
    @"R",
    @"T",
    @"Y",
    @"U",
    @"I",
    @"O",
    @"P",
    @"A",
    @"S",
    @"D",
    @"F",
    @"G",
    @"H",
    @"J",
    @"K",
    @"L",
    @"清空",
    @"Z",
    @"X",
    @"C",
    @"V",
    @"B",
    @"N",
    @"M",
    @"",
    @"隐藏",
    @"确认",
    @"123"
  ];
  int i = 0;
  //删除键盘前景
  UIImage *deleteImageDeleteUp = [UIImage imageNamed:@"消退"];
  UIImage *deleteImageDeleteDwon = [UIImage imageNamed:@"消退_down"];

  CGFloat leftSapce = 2.f;
  CGFloat topSpace = 10.f;
  CGFloat topSpaceFirst = 9.f;
  CGFloat btnSpaceWidth = 4.f;
  CGFloat btnSpaceHeight = 13.f;

  CGFloat btnWidth =
      (self.width - leftSapce * 2.f - btnSpaceWidth * 9.f) / 10.f;
  CGFloat butheight = 41.f;
  CGFloat secondLeftSpace = leftSapce + btnSpaceWidth / 2.f + btnWidth / 2.f;
  CGFloat shiftBtnLeftSpace = 10.f;
  CGFloat shiftBtnWidth = (self.width - btnWidth * 7.f - btnSpaceWidth * 6.f -
                           shiftBtnLeftSpace * 2.f - leftSapce * 2.f) /
                          2.f;
  CGFloat shiftBtnHeight = 41.f;
  CGFloat abcBtnWidth =
      (self.width - leftSapce * 2.f - btnSpaceWidth * 2.f) / 4.f;
  CGFloat abcBtnHeight = 41.f;

  for (NSString *obj in array) {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    ///(YL)是否接收处理唯一的触摸或点击事件
    [button setExclusiveTouch:YES];
    [button setTitle:obj forState:UIControlStateNormal];
    [button setTitle:obj forState:UIControlStateHighlighted];
    [button.layer setMasksToBounds:YES];
    button.layer.cornerRadius = 5.0;
    button.backgroundColor = [Globle colorFromHexRGB:@"#fcfcfc"];
    [button setTitleColor:[Globle colorFromHexRGB:@"#0c0c0c"]
                 forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor]
                 forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button addTarget:self
                  action:@selector(touchdown:)
        forControlEvents:UIControlEventTouchDown];
    [button addTarget:self
                  action:@selector(outSide:)
        forControlEvents:UIControlEventTouchUpOutside];
    [button addTarget:self
                  action:@selector(charButtonPress:)
        forControlEvents:UIControlEventTouchUpInside];
    button.tag = i;
    [skbv_charKeyBaseView addSubview:button];
    if (i < 10) {
      button.frame = CGRectMake(leftSapce + (btnSpaceWidth + btnWidth) * i,
                                topSpace, btnWidth, butheight);
    } else if (i < 19) {
      button.frame =
          CGRectMake(secondLeftSpace + (btnSpaceWidth + btnWidth) * (i - 10),
                     topSpaceFirst + (butheight + btnSpaceHeight) * 1, btnWidth,
                     butheight);
    } else if (i == 19) {
      //一键清空
      [button setTitleColor:[Globle colorFromHexRGB:@"#0c0c0c"]
                   forState:UIControlStateNormal];
      [button setTitleColor:[UIColor whiteColor]
                   forState:UIControlStateHighlighted];
      button.backgroundColor = [Globle colorFromHexRGB:@"#c4c6ca"];
      button.frame = CGRectMake(leftSapce, topSpaceFirst +
                                               (btnSpaceHeight + butheight) * 2,
                                shiftBtnWidth, shiftBtnHeight);
      [button addTarget:self
                    action:@selector(touchdown1:)
          forControlEvents:UIControlEventTouchDown];
      [button addTarget:self
                    action:@selector(outSide1:)
          forControlEvents:UIControlEventTouchUpOutside];
    } else if (i < 27) {
      button.frame =
          CGRectMake(leftSapce + shiftBtnWidth + shiftBtnLeftSpace +
                         (btnSpaceWidth + btnWidth) * (i - 20),
                     topSpaceFirst + (btnSpaceHeight + butheight) * 2, btnWidth,
                     butheight);
    } else if (i == 27) {
      //删除键
      button.frame =
          CGRectMake(self.bounds.size.width - shiftBtnWidth - 2,
                     topSpaceFirst + (btnSpaceHeight + butheight) * 2,
                     shiftBtnWidth, shiftBtnHeight);
      button.backgroundColor = [Globle colorFromHexRGB:@"#c4c6ca"];
      [button setImage:deleteImageDeleteUp forState:UIControlStateNormal];
      [button setImage:deleteImageDeleteDwon
              forState:UIControlStateHighlighted];
      [button setTitleColor:[Globle colorFromHexRGB:@"#0c0c0c"]
                   forState:UIControlStateNormal];
      [button setTitleColor:[UIColor whiteColor]
                   forState:UIControlStateHighlighted];
      [button addTarget:self
                    action:@selector(touchdown1:)
          forControlEvents:UIControlEventTouchDown];
      [button addTarget:self
                    action:@selector(outSide1:)
          forControlEvents:UIControlEventTouchUpOutside];

    } else if (i == 28) {
      //隐藏
      button.frame = CGRectMake(leftSapce, topSpaceFirst +
                                               (btnSpaceHeight + butheight) * 3,
                                abcBtnWidth, abcBtnHeight);
      button.backgroundColor = [Globle colorFromHexRGB:@"#c4c6ca"];
      [button setTitleColor:[Globle colorFromHexRGB:@"#0c0c0c"]
                   forState:UIControlStateNormal];
      [button setTitleColor:[UIColor whiteColor]
                   forState:UIControlStateHighlighted];
      [button addTarget:self
                    action:@selector(touchdown1:)
          forControlEvents:UIControlEventTouchDown];
      [button addTarget:self
                    action:@selector(outSide1:)
          forControlEvents:UIControlEventTouchUpOutside];

    } else if (i == 29) {
      //确认键
      button.frame =
          CGRectMake(leftSapce + abcBtnWidth + btnSpaceWidth,
                     topSpaceFirst + (btnSpaceHeight + butheight) * 3,
                     abcBtnWidth * 2.f, abcBtnHeight);
      button.backgroundColor = [Globle colorFromHexRGB:@"#fcfcfc"];
      [button setTitleColor:[Globle colorFromHexRGB:@"#0c0c0c"]
                   forState:UIControlStateNormal];
      [button setTitleColor:[UIColor whiteColor]
                   forState:UIControlStateHighlighted];
      [button addTarget:self
                    action:@selector(touchdown:)
          forControlEvents:UIControlEventTouchDown];
      [button addTarget:self
                    action:@selector(outSide:)
          forControlEvents:UIControlEventTouchUpOutside];

    } else if (i == 30) {
      // 123
      button.frame =
          CGRectMake(leftSapce + abcBtnWidth * 3.f + btnSpaceWidth * 2.f,
                     topSpaceFirst + (btnSpaceHeight + butheight) * 3,
                     abcBtnWidth, abcBtnHeight);
      button.backgroundColor = [Globle colorFromHexRGB:@"#c4c6ca"];
      [button setTitleColor:[Globle colorFromHexRGB:@"#0c0c0c"]
                   forState:UIControlStateNormal];
      [button setTitleColor:[UIColor whiteColor]
                   forState:UIControlStateHighlighted];
      [button addTarget:self
                    action:@selector(touchdown1:)
          forControlEvents:UIControlEventTouchDown];
      [button addTarget:self
                    action:@selector(outSide1:)
          forControlEvents:UIControlEventTouchUpOutside];
    }
    i++;
  }
}
//创建数字键盘
- (void)creatNumberKeyView {
  //数字键盘承载视图
  skbv_NumberKeyBaseView = [[UIView alloc] initWithFrame:self.bounds];
  skbv_NumberKeyBaseView.backgroundColor = [UIColor clearColor];
  [self addSubview:skbv_NumberKeyBaseView];
  //各个按钮
  NSArray *array = @[
    @"600",
    @"1",
    @"2",
    @"3",
    @"",
    @"601",
    @"4",
    @"5",
    @"6",
    @"隐藏",
    @"300",
    @"7",
    @"8",
    @"9",
    @"清空",
    @"000",
    @"0",
    @"确认",
    @"abc"
  ];
  int i = 0;

  //删除键盘前景
  UIImage *deleteFrontImageUp = [UIImage imageNamed:@"消退_down"];
  UIImage *deleteFrontImageDown = [UIImage imageNamed:@"消退"];

  CGFloat leftSapce = 4.f;
  CGFloat topSpace = 4.f;
  CGFloat topSpaceFirst = 9.f;
  CGFloat btnWidth = (self.width - leftSapce * 6.f) / 5.f;
  CGFloat btnHeight = 48.5f;
  CGFloat bacBtnWidth = btnWidth * 2.f + leftSapce;

  for (NSString *obj in array) {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button.layer setMasksToBounds:YES];
    button.layer.cornerRadius = 5.0;
    [button setTitle:obj forState:UIControlStateNormal];
    [button setTitle:obj forState:UIControlStateHighlighted];
    [button setTitleColor:[Globle colorFromHexRGB:@"#0c0c0c"]
                 forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor]
                 forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    button.backgroundColor = [Globle colorFromHexRGB:@"#fcfcfc"];
    [button addTarget:self
                  action:@selector(touchdown:)
        forControlEvents:UIControlEventTouchDown];
    [button addTarget:self
                  action:@selector(outSide:)
        forControlEvents:UIControlEventTouchUpOutside];
    [button addTarget:self
                  action:@selector(buttonpress:)
        forControlEvents:UIControlEventTouchUpInside];
    button.tag = i;
    [skbv_NumberKeyBaseView addSubview:button];
    if (i < 5) {
      button.frame = CGRectMake(leftSapce + (leftSapce + btnWidth) * i,
                                topSpaceFirst, btnWidth, btnHeight);
      if (i == 4) {
        button.backgroundColor = [Globle colorFromHexRGB:@"#c4c6ca"];
        [button setTitleColor:[Globle colorFromHexRGB:@"#0c0c0c"]
                     forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor]
                     forState:UIControlStateHighlighted];
        [button addTarget:self
                      action:@selector(touchdown1:)
            forControlEvents:UIControlEventTouchDown];
        [button addTarget:self
                      action:@selector(outSide1:)
            forControlEvents:UIControlEventTouchUpOutside];
        [button setImage:deleteFrontImageDown forState:UIControlStateNormal];
        [button setImage:deleteFrontImageUp forState:UIControlStateHighlighted];
      }
    } else if (i < 10) {
      if (i == 9) {
        button.backgroundColor = [Globle colorFromHexRGB:@"#c4c6ca"];
        [button setTitleColor:[Globle colorFromHexRGB:@"#0c0c0c"]
                     forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor]
                     forState:UIControlStateHighlighted];
        [button addTarget:self
                      action:@selector(touchdown1:)
            forControlEvents:UIControlEventTouchDown];
        [button addTarget:self
                      action:@selector(outSide1:)
            forControlEvents:UIControlEventTouchUpOutside];
      }
      button.frame = CGRectMake(leftSapce + (leftSapce + btnWidth) * (i - 5),
                                topSpaceFirst + (topSpace + btnHeight) * 1,
                                btnWidth, btnHeight);
    } else if (i < 15) {
      if (i == 14) {
        button.backgroundColor = [Globle colorFromHexRGB:@"#c4c6ca"];
        [button setTitleColor:[Globle colorFromHexRGB:@"#0c0c0c"]
                     forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor]
                     forState:UIControlStateHighlighted];
        [button addTarget:self
                      action:@selector(touchdown1:)
            forControlEvents:UIControlEventTouchDown];
        [button addTarget:self
                      action:@selector(outSide1:)
            forControlEvents:UIControlEventTouchUpOutside];
      }
      button.frame = CGRectMake(leftSapce + (leftSapce + btnWidth) * (i - 10),
                                topSpaceFirst + (topSpace + btnHeight) * 2,
                                btnWidth, btnHeight);
    } else if (i < 17) {
      button.frame = CGRectMake(leftSapce + (leftSapce + btnWidth) * (i - 15),
                                topSpaceFirst + (topSpace + btnHeight) * 3,
                                btnWidth, btnHeight);
    } else if (i == 17) {
      button.backgroundColor = [Globle colorFromHexRGB:@"#fcfcfc"];
      [button setTitleColor:[Globle colorFromHexRGB:@"#0c0c0c"]
                   forState:UIControlStateNormal];
      [button setTitleColor:[UIColor whiteColor]
                   forState:UIControlStateHighlighted];
      [button addTarget:self
                    action:@selector(touchdown:)
          forControlEvents:UIControlEventTouchDown];
      [button addTarget:self
                    action:@selector(outSide:)
          forControlEvents:UIControlEventTouchUpOutside];
      button.frame = CGRectMake(leftSapce + (leftSapce + btnWidth) * 2,
                                topSpaceFirst + (topSpace + btnHeight) * 3,
                                bacBtnWidth, btnHeight);
    } else if (i == 18) {
      button.frame = CGRectMake(leftSapce + (leftSapce + btnWidth) * 4,
                                topSpaceFirst + (topSpace + btnHeight) * 3,
                                btnWidth, btnHeight);
      button.backgroundColor = [Globle colorFromHexRGB:@"#c4c6ca"];
      [button setTitleColor:[Globle colorFromHexRGB:@"#0c0c0c"]
                   forState:UIControlStateNormal];
      [button setTitleColor:[UIColor whiteColor]
                   forState:UIControlStateHighlighted];
      [button addTarget:self
                    action:@selector(touchdown1:)
          forControlEvents:UIControlEventTouchDown];
      [button addTarget:self
                    action:@selector(outSide1:)
          forControlEvents:UIControlEventTouchUpOutside];
    }
    i++;
  }
}
//按钮点击效果
- (void)touchdown:(UIButton *)btn {
  btn.backgroundColor = [Globle colorFromHexRGB:@"#0493fd"];
}
- (void)outSide:(UIButton *)btn {
  btn.backgroundColor = [Globle colorFromHexRGB:@"#fcfcfc"];
}
//按钮点击效果
- (void)touchdown1:(UIButton *)btn {
  btn.backgroundColor = [Globle colorFromHexRGB:@"#a0a1a3"];
}
- (void)outSide1:(UIButton *)btn {
  btn.backgroundColor = [Globle colorFromHexRGB:@"#c4c6ca"];
}
//按钮点击
- (void)buttonpress:(UIButton *)button {
  if (button.tag == 4 || button.tag == 9 || button.tag == 14 ||
      button.tag == 18) {
    button.backgroundColor = [Globle colorFromHexRGB:@"#c4c6ca"];
  } else {
    button.backgroundColor = [Globle colorFromHexRGB:@"#fcfcfc"];
  }

  if (button.tag != 18) {
    [_delegate keyButtonDown:button];
  } else {
    // abc 点击
    [self changKeyBoardType:YES];
  }
}
//字母键盘按钮点击
- (void)charButtonPress:(UIButton *)button {
  if (button.tag == 19 || button.tag == 27 || button.tag == 28 ||
      button.tag == 30) {
    button.backgroundColor = [Globle colorFromHexRGB:@"#c4c6ca"];
  } else {
    button.backgroundColor = [Globle colorFromHexRGB:@"#fcfcfc"];
  }
  if (button.tag != 30) {
    if (button.tag == 19) {

      //      skbv_siShiftDown = !skbv_siShiftDown;
    }
    [_delegate keyButtonCharDown:button];
  } else {
    // 123数字键
    [self changKeyBoardType:NO];
  }
}
//切换字母键盘和数字键盘
- (void)changKeyBoardType:(BOOL)isToCharKeyBoard {
  if (isToCharKeyBoard == YES) {
    // 切换到字母键盘
    skbv_charKeyBaseView.hidden = NO;
    skbv_NumberKeyBaseView.hidden = YES;
  } else {
    //切换到数字键盘
    skbv_charKeyBaseView.hidden = YES;
    skbv_NumberKeyBaseView.hidden = NO;
  }
}

@end

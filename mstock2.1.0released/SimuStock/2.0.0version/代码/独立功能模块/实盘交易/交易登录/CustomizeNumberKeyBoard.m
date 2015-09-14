//
//  CustomizeNumberKeyBoard.m
//  SimuStock
//
//  Created by jhss on 14-9-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "CustomizeNumberKeyBoard.h"
#import "SimuUtil.h"
#import "UIImage+ColorTransformToImage.h"

@implementation CustomizeNumberKeyBoard
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self createBackView];
  }
  return self;
}
//创建各个按钮图片
- (void)createBackView {
  UIView *keyboardBGView =
      [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width,
                                               self.bounds.size.height)];
  keyboardBGView.backgroundColor = [Globle colorFromHexRGB:@"#424451"];
  [self addSubview:keyboardBGView];
  //提示标题
  UILabel *tipLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(0, 0, self.frame.size.width, 34)];
  tipLabel.backgroundColor = [UIColor clearColor];
  tipLabel.textAlignment = NSTextAlignmentLeft;
  tipLabel.textColor = [Globle colorFromHexRGB:@"#b1b2b7"];
  tipLabel.text = @"  您正在使用密码安全键盘";
  tipLabel.font = [UIFont boldSystemFontOfSize:15.0];
  [keyboardBGView addSubview:tipLabel];
  //分割线
  UIView *upView = [[UIView alloc]
      initWithFrame:CGRectMake(0, 34, self.frame.size.width, 1)];
  upView.backgroundColor = [Globle colorFromHexRGB:@"#30313b"];
  UIView *downView = [[UIView alloc]
      initWithFrame:CGRectMake(0, 35, self.frame.size.width, 1)];
  downView.backgroundColor = [Globle colorFromHexRGB:@"#515363"];
  [keyboardBGView addSubview:upView];
  //创建数字键盘
  [self createNumberKeyBoard];
}
/**
 *创建数字键盘
 */
- (void)createKeyBoardButton {
  int n, m, t, a[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
  for (int i = 0; i < 10; i++) {
    n = (arc4random() % 10);
    m = (arc4random() % 10);
    if (n == m) {
      continue;
    } else {
      //打乱数组
      t = a[n];
      a[n] = a[m];
      a[m] = t;
    }
  }

  int i = 0;
  int j = 0;
  for (i = 0; i < 3; i++) {
    for (j = 0; j < 3; j++) {
      UIButton *keyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      //设置间隔
      if (i == 0 && j == 0) {
        keyBtn.frame =
            CGRectMake(3 + keyboard_width * j, 35 + 9 + i * keyboard_height,
                       keyboard_width, keyboard_height);
      } else {
        keyBtn.frame = CGRectMake(3 + j * (keyboard_width + 6),
                                  35 + 9 + i * (keyboard_height + 6),
                                  keyboard_width, keyboard_height);
      }
      NSString *str = [NSString stringWithFormat:@"%d", a[i * 3 + j]];
      [keyBtn setTag:a[i * 3 + j]];
      [keyBtn.layer setMasksToBounds:YES];
      [keyBtn.layer setCornerRadius:5.0];
      [keyBtn setTitle:str forState:UIControlStateNormal];
      [keyBtn setTitleColor:[Globle colorFromHexRGB:Color_Text_Common]
                   forState:UIControlStateNormal];
      [keyBtn setTitleColor:[UIColor whiteColor]
                   forState:UIControlStateHighlighted];
      keyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:30.0];
      [keyBtn setBackgroundColor:[Globle colorFromHexRGB:@"#f9f9f9"]];
      UIImage *highlightBtnImage =
          [UIImage imageFromView:keyBtn
              withBackgroundColor:[Globle colorFromHexRGB:Color_Blue_but]];
      [keyBtn setBackgroundImage:highlightBtnImage
                        forState:UIControlStateHighlighted];
      [keyBtn addTarget:self
                    action:@selector(touchUpInSide:)
          forControlEvents:UIControlEventTouchUpInside];
      [numberKeyBaseView addSubview:keyBtn];
    }
  }
  //特殊键
  //设定删除键的前景和背景
  UIImage *delete_front_Image_up = [UIImage imageNamed:@"keyboard_delete_down"];
  UIImage *delete_front_Image_down = [UIImage imageNamed:@"keyboard_delete"];
  UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  deleteBtn.frame = CGRectMake(self.frame.size.width - 3 - keyboard_width, 44,
                               keyboard_width, keyboard_height);
  [deleteBtn setTag:10];
  [deleteBtn.layer setMasksToBounds:YES];
  [deleteBtn.layer setCornerRadius:5.0];
  [deleteBtn setBackgroundColor:[Globle colorFromHexRGB:@"#c9cbd8"]];
  UIImage *highlightBtnImage =
      [UIImage imageFromView:deleteBtn
          withBackgroundColor:[Globle colorFromHexRGB:Color_Blue_but]];
  [deleteBtn setBackgroundImage:highlightBtnImage
                       forState:UIControlStateHighlighted];
  [deleteBtn setImage:delete_front_Image_down forState:UIControlStateNormal];
  [deleteBtn setImage:delete_front_Image_up forState:UIControlStateHighlighted];
  [deleteBtn addTarget:self
                action:@selector(touchUpInSide:)
      forControlEvents:UIControlEventTouchUpInside];
  [numberKeyBaseView addSubview:deleteBtn];
  //剩余数字键
  UIButton *otherNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  otherNumBtn.frame =
      CGRectMake(self.frame.size.width - 3 - keyboard_width,
                 44 + (keyboard_height + 6), keyboard_width, keyboard_height);
  NSString *otherStr = [NSString stringWithFormat:@"%d", a[9]];
  [otherNumBtn setTag:a[9]];
  [otherNumBtn.layer setMasksToBounds:YES];
  [otherNumBtn.layer setCornerRadius:5.0];
  [otherNumBtn setTitle:otherStr forState:UIControlStateNormal];
  [otherNumBtn setTitleColor:[Globle colorFromHexRGB:Color_Text_Common]
                    forState:UIControlStateNormal];
  [otherNumBtn setTitleColor:[UIColor whiteColor]
                    forState:UIControlStateHighlighted];
  otherNumBtn.titleLabel.font = [UIFont boldSystemFontOfSize:30.0];
  [otherNumBtn setBackgroundColor:[Globle colorFromHexRGB:@"#f9f9f9"]];
  [otherNumBtn setBackgroundImage:highlightBtnImage
                         forState:UIControlStateHighlighted];
  [otherNumBtn addTarget:self
                  action:@selector(touchUpInSide:)
        forControlEvents:UIControlEventTouchUpInside];
  [numberKeyBaseView addSubview:otherNumBtn];
  //确定键
  UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  confirmBtn.frame = CGRectMake(self.frame.size.width - 3 - keyboard_width,
                                44 + (keyboard_height + 6) * 2, keyboard_width,
                                keyboard_height);
  [confirmBtn setTag:11];
  [confirmBtn.layer setMasksToBounds:YES];
  [confirmBtn.layer setCornerRadius:5.0];
  [confirmBtn setBackgroundColor:[Globle colorFromHexRGB:@"#c9cbd8"]];
  [confirmBtn setTitleColor:[Globle colorFromHexRGB:Color_Text_Common]
                   forState:UIControlStateNormal];
  [confirmBtn setTitleColor:[UIColor whiteColor]
                   forState:UIControlStateHighlighted];
  confirmBtn.titleLabel.font = [UIFont boldSystemFontOfSize:25.0];
  [confirmBtn setBackgroundImage:highlightBtnImage
                        forState:UIControlStateHighlighted];
  [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
  [confirmBtn addTarget:self
                 action:@selector(touchUpInSide:)
       forControlEvents:UIControlEventTouchUpInside];
  [numberKeyBaseView addSubview:confirmBtn];
}
- (void)createNumberKeyBoard {
  //数字键盘承载视图
  numberKeyBaseView = [[UIView alloc] initWithFrame:self.bounds];
  numberKeyBaseView.backgroundColor = [UIColor clearColor];
  [self addSubview:numberKeyBaseView];
  [self createKeyBoardButton];
}
- (void)touchUpInSide:(UIButton *)button {
  NSString *strMsg = @"0";
  int btnTag = (int)button.tag;
  switch (btnTag) {
  case 0:
    strMsg = @"0";
    break;
  case 1:
    strMsg = @"1";
    break;
  case 2:
    strMsg = @"2";
    break;
  case 3:
    strMsg = @"3";
    break;
  case 4:
    strMsg = @"4";
    break;
  case 5:
    strMsg = @"5";
    break;
  case 6:
    strMsg = @"6";
    break;
  case 7:
    strMsg = @"7";
    break;
  case 8:
    strMsg = @"8";
    break;
  case 9:
    strMsg = @"9";
    break;
  case 10:
    strMsg = @"clear";
    break;
  case 11:
    strMsg = @"enter";
    break;
  default:
    break;
  }
  NSLog(@"%@", strMsg);
  [self.delegate selectRandomMethod:strMsg];
}
@end

//
//  InvitationCodeView.m
//  SimuStock
//
//  Created by moulin wang on 14-7-15.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "InvitationCodeView.h"
#import "SimuUtil.h"

@implementation NoCursorTextField

- (CGRect)caretRectForPosition:(UITextPosition *)position {
  return CGRectZero;
}

@end

@implementation InvitationCodeView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self creatingInvitationCodeView];
  }
  return self;
}
- (void)layoutSubviews {
  [super layoutSubviews];
}

//创建邀请码视图
- (void)creatingInvitationCodeView {
  //阴影
  _shadowView =
      [[UIView alloc] initWithFrame:CGRectMake((self.bounds.size.width - 250) / 2 - 2.5f,
                                               (self.bounds.size.height - 185) / 2 - 2.5f, 250 + 5.0f, 185 + 5.0f)];
  _shadowView.backgroundColor = [Globle colorFromHexRGB:Color_Black alpha:0.3];
  _shadowView.layer.cornerRadius = 7; //
  [self addSubview:_shadowView];

  //白底
  _whiteView = [[UIView alloc] initWithFrame:CGRectMake((self.bounds.size.width - 250) / 2,
                                                        (self.bounds.size.height - 185) / 2, 250, 185)];
  _whiteView.backgroundColor = [UIColor whiteColor];
  CALayer *layer = _whiteView.layer;
  [layer setMasksToBounds:YES];
  [layer setCornerRadius:5];
  [self addSubview:_whiteView];
  //"请输入4位比赛邀请码"
  UILabel *upLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 15, 160, 20)];
  upLabel.backgroundColor = [UIColor clearColor];
  upLabel.font = [UIFont systemFontOfSize:Font_Height_16_0];
  upLabel.textAlignment = NSTextAlignmentCenter;
  upLabel.text = @"请输入4位比赛验证码";
  upLabel.textColor = [UIColor blackColor];
  [_whiteView addSubview:upLabel];
  //绿色分割线
  UILabel *greenLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 41, 250, 2)];
  greenLine.backgroundColor = [Globle colorFromHexRGB:@"3cc1cb"];
  [_whiteView addSubview:greenLine];

  labArray = [[NSMutableArray alloc] init];
  _ssv_searchTextField =
      [[NoCursorTextField alloc] initWithFrame:CGRectMake((_whiteView.bounds.size.width - 44 * 4) / 2,
                                                          (82.0 + 33.0 + 3.0) / 2, 44 * 4, 39.0)];
  _ssv_searchTextField.delegate = self;
  if ([[[UIDevice currentDevice] systemVersion] intValue] >= 7) {
    [_ssv_searchTextField setTintColor:[UIColor clearColor]];
    _ssv_searchTextField.textColor = [Globle colorFromHexRGB:@"#ededed"];
  } else {
  }
  _ssv_searchTextField.backgroundColor = [Globle colorFromHexRGB:@"#ededed"];
  //_ssv_searchTextField.userInteractionEnabled = NO;
  _ssv_searchTextField.textAlignment = NSTextAlignmentLeft;
  _ssv_searchTextField.textColor = [UIColor clearColor];
  //_ssv_searchTextField.font = [UIFont systemFontOfSize:0.0];
  _ssv_searchTextField.layer.borderColor = [Globle colorFromHexRGB:@"#b5b5b5"].CGColor;
  _ssv_searchTextField.layer.borderWidth = 0.5f;
  [_whiteView addSubview:_ssv_searchTextField];
  //透明按钮
  UIButton *_ssv_searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
  _ssv_searchButton.frame = _ssv_searchTextField.frame;
  _ssv_searchButton.userInteractionEnabled = YES;
  _ssv_searchButton.backgroundColor = [UIColor clearColor];
  [_ssv_searchButton addTarget:self
                        action:@selector(textfieldBecomeFirstRespond)
              forControlEvents:UIControlEventTouchUpInside];
  [_whiteView addSubview:_ssv_searchButton];
  for (int i = 1; i < 5; i++) {
    UILabel *searchLabel = [[UILabel alloc] initWithFrame:CGRectMake((i - 1) * 44.0, 0.0, 44, 39.0)];
    searchLabel.backgroundColor = [UIColor clearColor];
    searchLabel.text = @"";
    searchLabel.textColor = [Globle colorFromHexRGB:@"#f79100"];
    searchLabel.textAlignment = NSTextAlignmentCenter;
    searchLabel.font = [UIFont systemFontOfSize:22];
    [_ssv_searchTextField addSubview:searchLabel];
    [labArray addObject:searchLabel];
    if (i == 4) {
      break;
    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(i * 44.0, 0.0, 0.5, 39.0)];
    lineView.backgroundColor = [Globle colorFromHexRGB:@"#b5b5b5"];
    [_ssv_searchTextField addSubview:lineView];
  }
  //验证码请求提示 showInfo
  _showLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 105, 130, 12)];
  _showLabel.backgroundColor = [UIColor clearColor];
  _showLabel.font = [UIFont systemFontOfSize:Font_Height_10_0];
  _showLabel.text = @"";
  _showLabel.textAlignment = NSTextAlignmentCenter;
  _showLabel.textColor = [UIColor redColor];
  [_whiteView addSubview:_showLabel];

  //按钮背景
  UIView *btnBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 125, 250, 60)];
  btnBGView.backgroundColor = [Globle colorFromHexRGB:@"d1d1d1"];
  [_whiteView addSubview:btnBGView];
  //返回按钮
  UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
  backButton.frame = CGRectMake(15, 136, 100, 34);
  backButton.backgroundColor = [Globle colorFromHexRGB:@"afb3b5"];
  [backButton setTitle:@"返回" forState:UIControlStateNormal];
  CALayer *backButtonLayer = backButton.layer;
  [backButtonLayer setMasksToBounds:YES];
  [backButtonLayer setCornerRadius:17];
  backButton.titleLabel.font = [UIFont boldSystemFontOfSize:Font_Height_16_0];
  [backButton addTarget:self
                 action:@selector(touchdown1:)
       forControlEvents:UIControlEventTouchDown];
  [backButton addTarget:self
                 action:@selector(outSide1:)
       forControlEvents:UIControlEventTouchUpOutside];
  [backButton addTarget:self
                 action:@selector(backPreviousPage:)
       forControlEvents:UIControlEventTouchUpInside];
  [_whiteView addSubview:backButton];
  //确认按钮
  _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
  _confirmButton.frame = CGRectMake(250 - 115, 136, 100, 34);
  [_confirmButton setBackgroundColor:[Globle colorFromHexRGB:@"31bce9"]];
  [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
  CALayer *confirmButtonLayer = _confirmButton.layer;
  [confirmButtonLayer setMasksToBounds:YES];
  [confirmButtonLayer setCornerRadius:17];
  [_confirmButton addTarget:self
                     action:@selector(touchdown2:)
           forControlEvents:UIControlEventTouchDown];
  [_confirmButton addTarget:self
                     action:@selector(outSide2:)
           forControlEvents:UIControlEventTouchUpOutside];
  [_confirmButton addTarget:self
                     action:@selector(changePage:)
           forControlEvents:UIControlEventTouchUpInside];
  _confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:Font_Height_16_0];
  [_whiteView addSubview:_confirmButton];
  [self keyBoardViewCreate];
  [_ssv_searchTextField becomeFirstResponder];
}
#pragma mark
#pragma mark-------textViewDelegate-----
- (void)textfieldBecomeFirstRespond {
  //隐藏键盘按钮
  [_ssv_searchTextField becomeFirstResponder];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
  //输入框高度变化
  CGRect frame = self.frame;
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.3];
  _whiteView.frame = CGRectMake((frame.size.width - 250) / 2, (frame.size.height - 185) / 2 - 80, 250, 185);
  _shadowView.frame = CGRectMake((frame.size.width - 250) / 2 - 2.5f,
                                 (frame.size.height - 185) / 2 - 80 - 2.5f, 250 + 5.0f, 185 + 5.0f);
  [UIView commitAnimations];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
  //输入框高度变化
  CGRect frame = self.frame;
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.3];
  _whiteView.frame = CGRectMake((frame.size.width - 250) / 2, (frame.size.height - 185) / 2, 250, 185);
  _shadowView.frame = CGRectMake((frame.size.width - 250) / 2 - 2.5f,
                                 (frame.size.height - 185) / 2 - 2.5f, 250 + 5.0f, 185 + 5.0f);
  [UIView commitAnimations];
}
- (void)touchdown1:(UIButton *)button {
  [button setBackgroundColor:[Globle colorFromHexRGB:@"83888b"]];
}
- (void)outSide1:(UIButton *)button {
  [button setBackgroundColor:[Globle colorFromHexRGB:@"afb3b5"]];
}
//取消（返回)
- (void)backPreviousPage:(UIButton *)button {
  _showLabel = nil;
  [button setBackgroundColor:[Globle colorFromHexRGB:@"afb3b5"]];
  //取消
  [self removeFromSuperview];
}
- (void)touchdown2:(UIButton *)button {
  [button setBackgroundColor:[Globle colorFromHexRGB:@"086dae"]];
}
- (void)outSide2:(UIButton *)button {
  [button setBackgroundColor:[Globle colorFromHexRGB:@"31bce9"]];
}
//切换到单项比赛页(确定按钮)
- (void)changePage:(UIButton *)button {
  //验证邀请码
  [button setBackgroundColor:[Globle colorFromHexRGB:@"31bce9"]];

  [self stitchingPassedInvitationCode];
}

//邀请码拼接传递
- (void)stitchingPassedInvitationCode {
  if ([_confirmButton.titleLabel.text isEqualToString:@"重新输入"]) {
    [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    _showLabel.text = @"";
    _ssv_searchTextField.text = @"";
    for (UILabel *lab in labArray) {
      lab.text = @"";
    }
    return;
  }
  UILabel *lab = labArray[0];
  UILabel *lab1 = labArray[1];
  UILabel *lab2 = labArray[2];
  UILabel *lab3 = labArray[3];
  //拼接邀请码
  self.codeStr = [NSString stringWithFormat:@"%@%@%@%@", lab.text, lab1.text, lab2.text, lab3.text];
  NSLog(@"self.codeStr:%@", self.codeStr);
  if (self.codeStr.length == 4) {
    [_delegate invitationCode:self.codeStr];
  } else {
    return;
  }
}
//键盘
- (void)keyBoardViewCreate {
  //创建自定义键盘
  ssv_keyboardView =
      [[CompetionKeyBoardView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 218, self.bounds.size.width, 218)];
  _ssv_searchTextField.inputView = ssv_keyboardView;
  ssv_keyboardView.delegate = self;
}

#pragma mark
#pragma mark SimuKeyBoardViewDelegate
- (void)keyButtonDown:(UIButton *)index {
  [self textfieldChangeWithSelfButtonPress:index];
}

- (void)keyButtonCharDown:(UIButton *)index {
  [self textfieldChangeWithCharButtonPress:index];
}

//点击自定义键盘，修改编辑框数据
- (void)textfieldChangeWithSelfButtonPress:(UIButton *)button {
  if (button == nil || _ssv_searchTextField == nil)
    return;
  if (button.tag == 3) {
    //删除按钮
    NSString *text = _ssv_searchTextField.text;
    NSInteger lenth = [text length] - 1;
    if (lenth > -1) {
      text = [text substringToIndex:[text length] - 1];
      switch (lenth) {
      case 0: {
        UILabel *lab = labArray[0];
        lab.text = @"";
      } break;
      case 1: {
        UILabel *lab = labArray[1];
        lab.text = @"";
      } break;
      case 2: {
        UILabel *lab = labArray[2];
        lab.text = @"";
      } break;
      case 3: {
        UILabel *lab = labArray[3];
        lab.text = @"";
      } break;

      default:
        break;
      }
      _ssv_searchTextField.text = text;
      _showLabel.text = @"";
      [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    }
  } else if (button.tag == 7) {
    //隐藏键盘按钮
    [_ssv_searchTextField resignFirstResponder];
    _showLabel.text = @"";
    [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    return;
  } else if (button.tag == 11) {
    //清空按钮
    _ssv_searchTextField.text = @"";
    for (UILabel *lab in labArray) {
      lab.text = @"";
    }
    _showLabel.text = @"";
    [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
  } else if (button.tag == 14) {
    // abc按钮
  } else if (button.tag == 13) //确定
  {
    [self stitchingPassedInvitationCode];
  } else {
    //普通数字输入按钮
    [self customKeyboardOtherboard:button];
  }
}

//字母键盘，修改编辑框数据
- (void)textfieldChangeWithCharButtonPress:(UIButton *)button {
  if (button == nil || _ssv_searchTextField == nil)
    return;
  if (button.tag == 27) {
    //删除按钮
    NSString *text = _ssv_searchTextField.text;
    NSInteger lenth = [text length] - 1;
    if (lenth > -1) {
      text = [text substringToIndex:[text length] - 1];
      switch (lenth) {
      case 0: {
        UILabel *lab = labArray[0];
        lab.text = @"";
      } break;
      case 1: {
        UILabel *lab = labArray[1];
        lab.text = @"";
      } break;
      case 2: {
        UILabel *lab = labArray[2];
        lab.text = @"";
      } break;
      case 3: {
        UILabel *lab = labArray[3];
        lab.text = @"";
      } break;

      default:
        break;
      }
      _ssv_searchTextField.text = text;
      _showLabel.text = @"";
      [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    }

  } else if (button.tag == 19) {
    //清除
    _ssv_searchTextField.text = @"";
    for (UILabel *lab in labArray) {
      lab.text = @"";
    }
    _showLabel.text = @"";
    [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
  } else if (button.tag == 30) {

  } else if (button.tag == 28) {
    //隐藏
    if (_ssv_searchTextField) {
      [_ssv_searchTextField resignFirstResponder];
    }
    _showLabel.text = @"";
    [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
  } else if (button.tag == 29) {
    [self stitchingPassedInvitationCode];
  } else {
    //普通字母输入按钮
    [self customKeyboardOtherboard:button];
  }
}
- (void)customKeyboardOtherboard:(UIButton *)button {
  //普通字母输入按钮
  NSString *allcontent = [_ssv_searchTextField.text stringByAppendingString:button.titleLabel.text];
  NSInteger lenth = [allcontent length];
  if (lenth > 4) {
    return;
  }
  _ssv_searchTextField.text = [_ssv_searchTextField.text stringByAppendingString:button.titleLabel.text];
  UILabel *lab = nil;
  switch (_ssv_searchTextField.text.length) {
  case 1: {
    lab = labArray[0];
    lab.text = button.titleLabel.text;
  } break;
  case 2: {
    lab = labArray[1];
    lab.text = button.titleLabel.text;
  } break;
  case 3: {
    lab = labArray[2];
    lab.text = button.titleLabel.text;
  } break;
  case 4: {
    lab = labArray[3];
    lab.text = button.titleLabel.text;
  } break;

  default:
    break;
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

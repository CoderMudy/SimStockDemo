//
//  WeiBoToolTip.m
//  SimuStock
//
//  Created by Yuemeng on 15/1/15.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WeiBoToolTip.h"
#import "SimuUtil.h"
#import "NewShowLabel.h"
#import "ExchangeDiamondView.h"

#define WIDTH_OF_TOOLTIP 247.0f

@interface WeiboToolTip ()

/** 提示内容的行间距 */
@property(assign, nonatomic) CGFloat lineSpacing;
/** 提示内容距上部蓝线的间距 */
@property(assign, nonatomic) CGFloat contentTopSpacing;
/** 提示内容距下部灰线的间距 */
@property(assign, nonatomic) CGFloat contentBottomSpacing;

@end

@implementation WeiboToolTip

///确认框
+ (void)showMakeSureWithTitle:(NSString *)title sureblock:(sureButtonClickBlock)sureblock {
  WeiboToolTip *tooltip = [[WeiboToolTip alloc] initWithTitle:title
                                                  placeholder:nil
                                              sureButtonTitle:nil
                                                        style:WeiboToolTipStyleMakeSure];
  tooltip.sureButtonClickBlock = sureblock;
  [WINDOW addSubview:tooltip];
}

///带内容确认框
+ (void)showMakeSureWithTitle:(NSString *)title
                      content:(NSString *)content
                    sureblock:(sureButtonClickBlock)sureblock {
  WeiboToolTip *tooltip = [[WeiboToolTip alloc] initWithTitle:title
                                                  placeholder:content
                                              sureButtonTitle:nil
                                                        style:WeiboToolTipStyleMakeSureWithLargeContent];
  tooltip.sureButtonClickBlock = sureblock;
  [WINDOW addSubview:tooltip];
}

///带内容，指定确定按钮内容的确认框
+ (void)showMakeSureWithTitle:(NSString *)title
                      content:(NSString *)content
              sureButtonTitle:(NSString *)sureButtonTitle
                    sureblock:(sureButtonClickBlock)sureblock {
  WeiboToolTip *tooltip = [[WeiboToolTip alloc] initWithTitle:title
                                                  placeholder:content
                                              sureButtonTitle:sureButtonTitle
                                                        style:WeiboToolTipStyleMakeSureWithContent];
  tooltip.sureButtonClickBlock = sureblock;
  [WINDOW addSubview:tooltip];
}

+ (void)showMakeSureWithTitle:(NSString *)title
                      content:(NSString *)content
              sureButtonTitle:(NSString *)sureButtonTitle
                    sureblock:(sureButtonClickBlock)sureblock
                  cancleblock:(cancleButtonClickBlock)cancleblock {
  WeiboToolTip *tooltip = [[WeiboToolTip alloc] initWithTitle:title
                                                  placeholder:content
                                              sureButtonTitle:sureButtonTitle
                                                        style:WeiboToolTipStyleMakeSureWithContent];
  tooltip.sureButtonClickBlock = sureblock;
  tooltip.cancleButtonClickBlock = cancleblock;
  [WINDOW addSubview:tooltip];
}

///带较多内容，指定确定按钮内容的确认框
+ (void)showMakeSureWithTitle:(NSString *)title
                 largeContent:(NSString *)content
                  lineSpacing:(CGFloat)lineSpacing
            contentTopSpacing:(CGFloat)contentTopSpacing
         contentBottomSpacing:(CGFloat)contentBottomSpacing
              sureButtonTitle:(NSString *)sureButtonTitle
            cancelButtonTitle:(NSString *)cancelButtonTitle
                    sureblock:(sureButtonClickBlock)sureblock
                  cancleblock:(cancleButtonClickBlock)cancleblock {
  WeiboToolTip *tooltip = [[WeiboToolTip alloc] initWithTitle:title
                                                  placeholder:content
                                                  lineSpacing:lineSpacing
                                            contentTopSpacing:contentTopSpacing
                                         contentBottomSpacing:contentBottomSpacing
                                              sureButtonTitle:sureButtonTitle
                                            cancelButtonTitle:cancelButtonTitle
                                                        style:WeiboToolTipStyleMakeSureWithLargeContent];
  tooltip.sureButtonClickBlock = sureblock;
  tooltip.cancleButtonClickBlock = cancleblock;
  [WINDOW addSubview:tooltip];
}

///输入框
+ (void)showInputViewWithTitle:(NSString *)title
                   placeholder:(NSString *)placeholder
                   finishblock:(finishButtonClickBlock)finishblock {
  WeiboToolTip *tooltip = [[WeiboToolTip alloc] initWithTitle:title
                                                  placeholder:placeholder
                                              sureButtonTitle:nil
                                                        style:WeiboToolTipStyleInputView];
  tooltip.finishButtonClickBlock = finishblock;
  [WINDOW addSubview:tooltip];
}

///钻石兑换框
+ (void)showExchangeDiamondViewWithRatio:(NSString *)ratio
                                maxValue:(NSString *)maxValue
                               Sureblock:(sureButtonClickBlockWithDiamond)sureblock {
  WeiboToolTip *tooltip = [[WeiboToolTip alloc] initWithTitle:@"兑换钻石"
                                                  placeholder:ratio
                                              sureButtonTitle:maxValue
                                                        style:WeiboToolTipStyleExchangeDiamond];
  tooltip.sureButtonClickBlockWithDiamond = sureblock;
  [WINDOW addSubview:tooltip];
}

///说明框
+ (void)showWithdrawIntroduction {
  WeiboToolTip *tooltip = [[WeiboToolTip alloc] initWithTitle:@"说明"
                                                  placeholder:nil
                                              sureButtonTitle:nil
                                                        style:WeiboToolTipStyleWithdrawIntroduction];
  [WINDOW addSubview:tooltip];
}

- (instancetype)initWithTitle:(NSString *)title
                  placeholder:(NSString *)placeholder
              sureButtonTitle:(NSString *)sureButtonTitle
                        style:(WeiboToolTipStyle)style {
  self = [super initWithFrame:[[UIApplication sharedApplication].delegate.window bounds]];
  if (self) {
    _placeHolder = placeholder;
    _sureButtonTitle = sureButtonTitle;
    self.userInteractionEnabled = YES;
    self.backgroundColor = [Globle colorFromHexRGB:Color_Black alpha:0.5];
    [self createUIWithTitle:title style:style];
  }
  return self;
}

- (instancetype)initWithTitle:(NSString *)title
                  placeholder:(NSString *)placeholder
                  lineSpacing:(CGFloat)lineSpacing
            contentTopSpacing:(CGFloat)contentTopSpacing
         contentBottomSpacing:(CGFloat)contentBottomSpacing
              sureButtonTitle:(NSString *)sureButtonTitle
            cancelButtonTitle:(NSString *)cancelButtonTitle
                        style:(WeiboToolTipStyle)style {
  self = [super initWithFrame:[[UIApplication sharedApplication].delegate.window bounds]];
  if (self) {
    _placeHolder = placeholder;
    _sureButtonTitle = sureButtonTitle;
    _cancelButtonTitle = cancelButtonTitle;
    self.lineSpacing = lineSpacing;
    self.contentTopSpacing = contentTopSpacing;
    self.contentBottomSpacing = contentBottomSpacing;
    self.userInteractionEnabled = YES;
    self.backgroundColor = [Globle colorFromHexRGB:Color_Black alpha:0.5];
    [self createUIWithTitle:title style:style];
  }
  return self;
}

- (void)createUIWithTitle:(NSString *)title style:(WeiboToolTipStyle)style {
  //根据样式调整
  _style = style;
  switch (style) {
  //普通确认框
  case WeiboToolTipStyleMakeSure: {
    [self createMakeSureStyleWithTitle:title];
  } break;
  //带内容确认框
  case WeiboToolTipStyleMakeSureWithContent: {
    [self createInputViewStyleWithTitle:title];
  } break;
  case WeiboToolTipStyleMakeSureWithLargeContent: {
    [self createInputViewStyleWithTitle:title];
  } break;
  case WeiboToolTipStyleInputView: {
    [self createInputViewStyleWithTitle:title];
  } break;
  //钻石提示框
  case WeiboToolTipStyleExchangeDiamond: {
    [self createInputViewStyleWithTitle:title];
    [self createDiamondContentView];
  } break;
  //提现说明
  case WeiboToolTipStyleWithdrawIntroduction: {
    [self createInputViewStyleWithTitle:title];
    [self createWithdrawIntroductionUI];
  } break;

  default:
    break;
  }
}

#pragma mark 确认提示框
- (void)createMakeSureStyleWithTitle:(NSString *)title {
  //阴影
  UIView *shadowView =
      [[UIView alloc] initWithFrame:CGRectMake((WIDTH_OF_VIEW - 252) / 2.0f, (HEIGHT_OF_VIEW - 169) / 2.0f, 252, 169)];
  shadowView.backgroundColor = [Globle colorFromHexRGB:Color_Black alpha:0.3];
  shadowView.layer.cornerRadius = 7; //
  [self addSubview:shadowView];

  //主窗体 494*328
  _windowView =
      [[UIView alloc] initWithFrame:CGRectMake((WIDTH_OF_VIEW - WIDTH_OF_TOOLTIP) / 2.0f,
                                               (HEIGHT_OF_VIEW - 164) / 2.0f, WIDTH_OF_TOOLTIP, 164)];
  _windowView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  _windowView.layer.cornerRadius = 5; //
  _windowView.userInteractionEnabled = YES;
  _windowView.clipsToBounds = YES;
  [self addSubview:_windowView];

  //灰色分割线
  UIView *grayLine = [[UIView alloc] initWithFrame:CGRectMake(0, 103, WIDTH_OF_TOOLTIP, 0.5f)];
  grayLine.backgroundColor = [Globle colorFromHexRGB:@"#D1D1D1"];
  [_windowView addSubview:grayLine];

  //底部灰框 206 207 h121
  UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 103.5f, WIDTH_OF_TOOLTIP, 60.5f)];
  bottomView.backgroundColor = [Globle colorFromHexRGB:@"#EDEDED"];
  [_windowView addSubview:bottomView];

  //标题
  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, WIDTH_OF_TOOLTIP, Font_Height_18_0)];
  titleLabel.text = title;
  titleLabel.font = [UIFont boldSystemFontOfSize:Font_Height_18_0];
  titleLabel.textAlignment = NSTextAlignmentCenter;
  titleLabel.backgroundColor = [UIColor clearColor];
  [_windowView addSubview:titleLabel];

  //取消按钮 先添加到bottomview 中心，再左移
  _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
  _cancelButton.frame = CGRectMake(0, 0, 100, 35);
  [_cancelButton setTitle:(_cancelButtonTitle ? _cancelButtonTitle : @"取消")
                 forState:UIControlStateNormal];
  [_cancelButton setBackgroundImage:[SimuUtil imageFromColor:Color_TooltipCancelButton]
                           forState:UIControlStateNormal];
  [_cancelButton setBackgroundImage:[SimuUtil imageFromColor:Color_Gray_but]
                           forState:UIControlStateHighlighted];
  _cancelButton.layer.cornerRadius = 35 / 2;
  _cancelButton.clipsToBounds = YES;
  _cancelButton.center = bottomView.center;
  CGRect frameCancel = _cancelButton.frame;
  frameCancel.origin.x = 15; //
  _cancelButton.frame = frameCancel;
  [_windowView addSubview:_cancelButton];

  //确定按钮
  _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
  _sureButton.frame = CGRectMake(0, 0, 100, 35);
  [_sureButton setTitle:(_sureButtonTitle ? _sureButtonTitle : @"确定")
               forState:UIControlStateNormal];
  [_sureButton setBackgroundImage:[SimuUtil imageFromColor:Color_TooltipSureButton]
                         forState:UIControlStateNormal];
  [_sureButton setBackgroundImage:[SimuUtil imageFromColor:Color_Blue_but]
                         forState:UIControlStateHighlighted];

  _sureButton.layer.cornerRadius = 35 / 2;
  _sureButton.clipsToBounds = YES;
  _sureButton.center = bottomView.center;
  CGRect frameSure = _sureButton.frame;
  frameSure.origin.x = 127; //
  _sureButton.frame = frameSure;
  [_windowView addSubview:_sureButton];

  //按钮事件
  [_cancelButton addTarget:self
                    action:@selector(cancelButtonClick)
          forControlEvents:UIControlEventTouchUpInside];
  [_sureButton addTarget:self
                  action:@selector(sureButtonClick)
        forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark 输入提示框
- (void)createInputViewStyleWithTitle:(NSString *)title {

  //阴影
  UIView *shadowView =
      [[UIView alloc] initWithFrame:CGRectMake((WIDTH_OF_VIEW - 252) / 2.0f, (HEIGHT_OF_VIEW - 214) / 2.0f, 252, 214)];
  shadowView.backgroundColor = [Globle colorFromHexRGB:Color_Black alpha:0.3];
  shadowView.layer.cornerRadius = 7; //
  [self addSubview:shadowView];

  //主窗体 494*328
  _windowView =
      [[UIView alloc] initWithFrame:CGRectMake((WIDTH_OF_VIEW - WIDTH_OF_TOOLTIP) / 2.0f,
                                               (HEIGHT_OF_VIEW - 209) / 2.0f, WIDTH_OF_TOOLTIP, 209)];
  _windowView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  _windowView.layer.cornerRadius = 5; //
  _windowView.userInteractionEnabled = YES;
  _windowView.clipsToBounds = YES;
  [self addSubview:_windowView];

  //灰色分割线
  UIView *grayLine = [[UIView alloc] initWithFrame:CGRectMake(0, 148.5f, WIDTH_OF_TOOLTIP, 0.5f)];
  grayLine.backgroundColor = [Globle colorFromHexRGB:@"#D1D1D1"];
  [_windowView addSubview:grayLine];

  //底部灰框 206 207 h121
  UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 149, WIDTH_OF_TOOLTIP, 60.5f)];
  bottomView.backgroundColor = [Globle colorFromHexRGB:@"#EDEDED"];
  [_windowView addSubview:bottomView];

  //标题
  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, WIDTH_OF_TOOLTIP, Font_Height_18_0)];
  titleLabel.text = title;
  titleLabel.font = [UIFont boldSystemFontOfSize:Font_Height_18_0];
  titleLabel.textAlignment = NSTextAlignmentCenter;
  titleLabel.backgroundColor = [UIColor clearColor];
  [_windowView addSubview:titleLabel];

  //蓝线
  UIView *blueLine = [[UIView alloc] initWithFrame:CGRectMake(0, 44, WIDTH_OF_TOOLTIP, 1.5)];
  blueLine.backgroundColor = [Globle colorFromHexRGB:@"#31bce9"];
  [_windowView addSubview:blueLine];

  //输入框
  _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 63, 220, 68)];
  _textView.text = _placeHolder;

  _textView.delegate = self;
  [_windowView addSubview:_textView];

  //输入框样式
  if (_style == WeiboToolTipStyleInputView) {
    _textView.textColor = [Globle colorFromHexRGB:Color_Gray];
    _textView.font = [UIFont systemFontOfSize:Font_Height_13_0];
    _textView.layer.cornerRadius = 3;
    _textView.layer.borderColor = [[Globle colorFromHexRGB:@"D1D1D1"] CGColor];
    _textView.layer.borderWidth = 0.5;
    _textView.backgroundColor = [UIColor whiteColor];

    //钻石框需要调整位置
  } else if (_style == WeiboToolTipStyleExchangeDiamond) {
    [_textView removeFromSuperview];
    _textView = nil;
    //带内容确认框样式
  } else {
    if (_style == WeiboToolTipStyleMakeSureWithLargeContent) {
      _textView.text = @"";
      NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
      paragraphStyle.lineSpacing = self.lineSpacing;
      NSDictionary *attributes = @{
        NSFontAttributeName : [UIFont systemFontOfSize:Font_Height_14_0],
        NSParagraphStyleAttributeName : paragraphStyle
      };
      _textView.attributedText =
          [[NSAttributedString alloc] initWithString:_placeHolder attributes:attributes];

//      _textView.textContainerInset =
//          UIEdgeInsetsMake(self.contentTopSpacing, 0, self.contentBottomSpacing, 0);

     CGSize size = [SimuUtil labelContentSizeWithContent:_placeHolder withFont:Font_Height_14_0 withSize:CGSizeMake(CGRectGetWidth(_textView.bounds), 9999)];
      _textView.height = size.height + 3.0f;
      CGRect tempFrame = _textView.frame;
      tempFrame.origin.y = blueLine.origin.y + blueLine.size.height + self.contentTopSpacing;
//      [_textView.layoutManager ensureLayoutForTextContainer:_textView.textContainer];
//      CGRect textBounds = [_textView.layoutManager usedRectForTextContainer:_textView.textContainer];
//      tempFrame.size.height = textBounds.size.height + self.contentTopSpacing + self.contentBottomSpacing;
      _textView.frame = tempFrame;
      _textView.contentSize = CGSizeMake(tempFrame.size.width, tempFrame.size.height);

      CGRect windowFrame = _windowView.frame;
      CGRect shadowFrame = shadowView.frame;
      CGRect grayLineFrame = grayLine.frame;
      CGRect bottomFrame = bottomView.frame;

      grayLineFrame.origin.y = tempFrame.origin.y + tempFrame.size.height + self.contentBottomSpacing;
      bottomFrame.origin.y = grayLineFrame.origin.y + grayLineFrame.size.height;
      windowFrame.size.height = bottomFrame.origin.y + bottomFrame.size.height;
      windowFrame.origin.y = (HEIGHT_OF_VIEW - windowFrame.size.height) / 2.0f;
      shadowFrame.size.height = windowFrame.size.height + 5;
      shadowFrame.origin.y = (HEIGHT_OF_VIEW - shadowFrame.size.height) / 2.0f;

      _windowView.frame = windowFrame;
      shadowView.frame = shadowFrame;
      grayLine.frame = grayLineFrame;
      bottomView.frame = bottomFrame;
    }
    _textView.font = [UIFont systemFontOfSize:Font_Height_14_0];
    _textView.userInteractionEnabled = NO;
    _textView.backgroundColor = [UIColor clearColor];
  }

  //取消按钮 先添加到bottomview 中心，再左移
  _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
  _cancelButton.frame = CGRectMake(0, 0, 100, 35);
  [_cancelButton setBackgroundImage:[SimuUtil imageFromColor:Color_TooltipCancelButton]
                           forState:UIControlStateNormal];
  [_cancelButton setBackgroundImage:[SimuUtil imageFromColor:Color_Gray_butDown]
                           forState:UIControlStateHighlighted];

  _cancelButton.layer.cornerRadius = 35 / 2;
  _cancelButton.clipsToBounds = YES;
  _cancelButton.center = bottomView.center;
  CGRect frameCancel = _cancelButton.frame;
  frameCancel.origin.x = 15; //
  _cancelButton.frame = frameCancel;
  [_windowView addSubview:_cancelButton];

  //确定按钮
  _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
  _sureButton.frame = CGRectMake(0, 0, 100, 35);
  [_sureButton setBackgroundImage:[SimuUtil imageFromColor:Color_TooltipSureButton]
                         forState:UIControlStateNormal];
  [_sureButton setBackgroundImage:[SimuUtil imageFromColor:Color_Blue_but]
                         forState:UIControlStateHighlighted];
  //  _sureButton.titleLabel.font = [UIFont systemFontOfSize:1];
  _sureButton.layer.cornerRadius = 35 / 2;
  _sureButton.clipsToBounds = YES;
  _sureButton.center = bottomView.center;
  CGRect frameSure = _sureButton.frame;
  frameSure.origin.x = 127; //
  _sureButton.frame = frameSure;
  [_windowView addSubview:_sureButton];

  if (_style == WeiboToolTipStyleInputView) {
    [_cancelButton setTitle:@"返回" forState:UIControlStateNormal];
    [_sureButton setTitle:@"完成" forState:UIControlStateNormal];
  } else if (_style == WeiboToolTipStyleMakeSureWithContent || _style == WeiboToolTipStyleMakeSureWithLargeContent) {
    [_sureButton setTitle:(_sureButtonTitle ? _sureButtonTitle : @"确定")
                 forState:UIControlStateNormal];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
  } else {
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
  }
  //按钮事件
  [_cancelButton addTarget:self
                    action:@selector(cancelButtonClick)
          forControlEvents:UIControlEventTouchUpInside];

  [_sureButton addTarget:self
                  action:@selector(sureButtonClick)
        forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark 取消按钮回调
- (void)cancelButtonClick {
  if (_cancleButtonClickBlock) {
    _cancleButtonClickBlock();
  }
  [self removeFromSuperview];
}

#pragma mark 确定按钮回调
- (void)sureButtonClick {
  if (_sureButtonClickBlock) {
    _sureButtonClickBlock();
  } else if (_finishButtonClickBlock) {
    //对文字进行去首位空格处理
    NSString *text = _textView.text;
    if ([text isEqualToString:_placeHolder] || [SimuUtil isBlankString:text]) {
      [NewShowLabel setMessageContent:@"标题不能为空"];
      return;
    }
    _finishButtonClickBlock(_textView.text);

    //兑换钻石
  } else if (_sureButtonClickBlockWithDiamond) {
    if ([SimuUtil isBlankString:_diamondView.diamondNumTextField.text]) {
      [NewShowLabel setMessageContent:@"请输入兑换数量"];
      return;
    } else if ([_diamondView.diamondNumTextField.text isEqualToString:@"0"]) {
      [NewShowLabel setMessageContent:@"兑换钻石数量不能为0"];
      return;
    }
    _sureButtonClickBlockWithDiamond(_diamondView.diamondNumTextField.text);
  }
  [self removeFromSuperview];
}

#pragma mark - textView代理
- (void)textViewDidBeginEditing:(UITextView *)textView {
  //向上移动，避开键盘
  [UIView animateWithDuration:0.25
                   animations:^{
                     CGRect frame = self.frame;
                     frame.origin.y = -98.5f;
                     self.frame = frame;
                   }];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
  //当前inputview收回时向下移动
  [UIView animateWithDuration:0.25
                   animations:^{
                     CGRect frame = self.frame;
                     frame.origin.y = 0;
                     self.frame = frame;
                   }];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
  if ([textView.text isEqualToString:_placeHolder]) {
    textView.text = @"";
    textView.textColor = [Globle colorFromHexRGB:Color_Icon_Title];
  }
  return YES;
}

- (BOOL)textView:(UITextView *)textView
    shouldChangeTextInRange:(NSRange)range
            replacementText:(NSString *)text {
  if ([text isEqualToString:@"\n"]) {
    return NO;
  }

  if ([textView.text isEqualToString:_placeHolder]) {
    textView.text = @"";
    textView.textColor = [Globle colorFromHexRGB:Color_Icon_Title];
  }

  if (text.length == 0)
    return YES;

  NSInteger existedLength = textView.text.length;
  NSInteger selectedLength = range.length;
  NSInteger replaceLength = text.length;
  if (existedLength - selectedLength + replaceLength > 20) {
    [NewShowLabel setMessageContent:@"标题不能超过20个字"];
    return NO;
  }

  return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
  if ([textView.text isEqualToString:@""]) {
    textView.text = _placeHolder;
    textView.textColor = [Globle colorFromHexRGB:Color_Gray];
    textView.selectedRange = NSMakeRange(0, 0);
  }

  UITextRange *selectedRange = [textView markedTextRange];
  //获取高亮部分
  UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
  //不是联想输入状态
  if (!position) {
    if (textView.text.length > 20) {
      textView.text = [textView.text substringToIndex:20];
    }
  }
}

#pragma mark - 创建钻石相关视图
- (void)createDiamondContentView {
  //兑换比例
  _diamondView = [[[NSBundle mainBundle] loadNibNamed:@"ExchangeDiamondView"
                                                owner:self
                                              options:nil] firstObject];
  _diamondView.frame = CGRectMake(0, 45.5f, 247, 102);

  _diamondView.ratioLabel.text = _placeHolder;        //兑换比例
  _diamondView.maxValueLabel.text = _sureButtonTitle; //最大数量
  _diamondView.weiboToolTip = self;
  [_windowView addSubview:_diamondView];
}

#pragma mark - 提现说明
- (void)createWithdrawIntroductionUI {
  [_cancelButton removeFromSuperview];
  _cancelButton = nil;
  _sureButton.left = 73.5f;

  UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 56, _windowView.width, 13)];
  subTitleLabel.text = @"提现金额超过802元时征收个人所得税";
  subTitleLabel.textAlignment = NSTextAlignmentCenter;
  subTitleLabel.textColor = [Globle colorFromHexRGB:Color_Gray];
  subTitleLabel.font = [UIFont systemFontOfSize:Font_Height_13_0];
  [_windowView addSubview:subTitleLabel];

  UILabel *contentLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(21.5f, 78, _windowView.width - 21.5f * 2, 61)];
  contentLabel.text = @"实际提现金额=提现金额-手续费（2元）-" @"个"
                                                                              @"人所得税（提现金额"
                                                                              @"-2-800）× 20%";
  contentLabel.textAlignment = NSTextAlignmentLeft;
  contentLabel.textColor = [Globle colorFromHexRGB:Color_Icon_Title];
  contentLabel.font = [UIFont systemFontOfSize:Font_Height_16_0];
  contentLabel.numberOfLines = 0;
  [_windowView addSubview:contentLabel];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

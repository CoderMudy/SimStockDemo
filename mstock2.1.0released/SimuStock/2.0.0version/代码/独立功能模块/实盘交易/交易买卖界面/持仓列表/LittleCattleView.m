//
//  LittleCattleView.m
//  SimuStock
//
//  Created by Yuemeng on 14-10-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "LittleCattleView.h"
#import "Globle.h"
#import "TopAndBottomAlignmentLabel.h"
#import "FTCoreTextView.h"
#import <CoreText/CoreText.h>
#import "UIButton+Block.h"
#import "SimuUtil.h"

#define SIDE_LENGTH 80.0  //图片为160×160
#define LABEL_HEIGHT 34.0 //刚好容下两行文字

static const CGFloat refreshButtonWidth = 146.0f;

@interface LittleCattleView () {
  //小牛图
  UIImageView *_imageView;
  //小牛下面文字
  TopAndBottomAlignmentLabel *_label;

  ///提示信息的进一步信息，例如：消息中心无数据提示下的“关注牛人”的提示
  FTCoreTextView *_detailInfo;
  ///临时存储的文字
  NSString *_tipInformation;
  ///临时存储的文字
  NSString *_detailInformation;
  //当前是否是哭牛（无网络）
  BOOL _isCry;

  /** 可变文字 */
  NSMutableAttributedString *_attributedString;

  /** 字号多大 */
  CGFloat _textFontFloat;

  /** 无网络时 可点击的button */
  UIButton *_refreshButton;
}

@end

@implementation LittleCattleView

- (id)initWithFrame:(CGRect)frame information:(NSString *)information {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    self.userInteractionEnabled = NO; //点击穿透
    self.backgroundColor = [UIColor clearColor];
    _textFontFloat = Font_Height_14_0;
    //创建可变字符串
    [self createAttributedCryString];
    //创建小牛
    [self createViewWithinformation:information];
    //创建刷新Button
    [self createRefreshButton];
    self.hidden = YES;
  }
  return self;
}

/** 创建哭牛 文本 */
- (void)createAttributedCryString {
  NSMutableParagraphStyle *paragrapStyle = [[NSMutableParagraphStyle alloc] init];
  paragrapStyle.alignment = NSTextAlignmentCenter;
  NSDictionary *attributes = @{NSParagraphStyleAttributeName : paragrapStyle};
  _attributedString =
      [[NSMutableAttributedString alloc] initWithString:@"网络不给力," @"请点击重试"
                                             attributes:attributes];
  /** 要改变颜色的文本位置 */
  [_attributedString setAttributes:@{
    NSForegroundColorAttributeName : [Globle colorFromHexRGB:@"f89234"],
    NSFontAttributeName : [UIFont systemFontOfSize:_textFontFloat],
  } range:NSMakeRange(7, 2)];
}

/** 创建刷新按钮  */
- (void)createRefreshButton {
  _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
  _refreshButton.backgroundColor = [UIColor clearColor];
  //  CGSize size = [SimuUtil labelContentSizeWithContent:@"网络不给力,请点击重试"
  //                                             withFont:_textFontFloat
  //                                             withSize:CGSizeMake(_label.width, _label.height)];
  CGRect frame = CGRectMake((self.bounds.size.width - refreshButtonWidth) * 0.5, CGRectGetMinY(_imageView.frame),
                            refreshButtonWidth, CGRectGetMaxY(_label.frame) - CGRectGetMinY(_imageView.frame));
  _refreshButton.frame = frame;
  _refreshButton.backgroundColor = [UIColor clearColor];
  _refreshButton.hidden = YES;
  [self addSubview:_refreshButton];
  
  __weak LittleCattleView *weakSelf = self;
  [_refreshButton setOnButtonPressedHandler:^{
    LittleCattleView *strongSelf = weakSelf;
    if (strongSelf) {
      //对外 提供 Block
      NSLog(@"点击了 哭牛 请求刷新数据");
      if (strongSelf.cryRefreshBlock) {
        strongSelf.cryRefreshBlock();
      }
    }
  }];
}

//双图合一方法
- (void)createViewWithinformation:(NSString *)information {
  _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"laughCattle"]];
  _imageView.frame = CGRectMake((self.bounds.size.width - SIDE_LENGTH) / 2,
                                (self.bounds.size.height - SIDE_LENGTH - LABEL_HEIGHT / 2 - 5) / 2,
                                SIDE_LENGTH, SIDE_LENGTH);

  _label = [[TopAndBottomAlignmentLabel alloc]
      initWithFrame:CGRectMake(0.0, _imageView.frame.origin.y + SIDE_LENGTH + 5.0, self.bounds.size.width, LABEL_HEIGHT)];
  _label.backgroundColor = [UIColor clearColor];
  [_label setTextAlignment:NSTextAlignmentCenter];
  _label.verticalAlignment = VerticalAlignmentTop;
  _label.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  _label.font = [UIFont systemFontOfSize:_textFontFloat];
  _label.numberOfLines = 0;

  _detailInfo =
      [[FTCoreTextView alloc] initWithFrame:CGRectMake(20.0, _imageView.frame.origin.y + SIDE_LENGTH + 20.0,
                                                       self.bounds.size.width - 20, LABEL_HEIGHT)];
  FTCoreTextStyle *defaultStyle = [[FTCoreTextStyle alloc] init];
  defaultStyle.name = FTCoreTextTagDefault;
  defaultStyle.textAlignment = FTCoreTextAlignementCenter;
  defaultStyle.font = [UIFont systemFontOfSize:_textFontFloat];
  [_detailInfo addStyle:defaultStyle];

  //如果指定了信息，则使用指定的，没有的话就创建默认的
  if (information) {
    _label.text = information;
    _tipInformation = information;
  } else {
    _label.text = @"暂无持仓数据";
  }

  [self addSubview:_imageView];
  [self addSubview:_label];
  [self addSubview:_detailInfo];
}

//切换视图
- (void)isCry:(BOOL)isCry {
  //如果是哭牛，则使用哭得图片并替换文字
  if (isCry) {
    _imageView.image = [UIImage imageNamed:@"cryCattle"];
    [_label setAttributedText:_attributedString];
    _refreshButton.hidden = NO;
    _detailInfo.hidden = YES;
    self.userInteractionEnabled = YES;
  } else {
    self.userInteractionEnabled = NO;
    _refreshButton.hidden = YES;
    _imageView.image = [UIImage imageNamed:@"laughCattle"];
    //若有自定义文字，使用自定义文字，否则使用默认文字
    _tipInformation ? (_label.text = _tipInformation) : (_label.text = @"暂无持仓数据");
    _detailInfo.hidden = _detailInformation ? NO : YES;
  }

  _isCry = isCry;
  self.hidden = NO;
  [self.superview bringSubviewToFront:self];
}
- (void)isNOData:(NSString *)noData {
  _imageView.image = [UIImage imageNamed:@"laughCattle"];
  _tipInformation = noData;
  self.hidden = NO;
  [self.superview bringSubviewToFront:self];
}
- (void)showCryCattleWithContent:(NSString *)content {
  //如果是哭牛，则使用哭得图片并替换文字
  _imageView.image = [UIImage imageNamed:@"cryCattle"];
  _label.text = content;
  _imageView.hidden = NO;
  [self.superview bringSubviewToFront:self];
}
//设置笑牛文字信息
- (void)setInformation:(NSString *)information {
  [self setInformation:information detailInfo:nil];
}

- (void)setInformation:(NSString *)information detailInfo:(NSString *)detailInfo {
  if (_isCry) {
    //哭牛状态文字不能改变
    return;
  } else {
    _label.text = information;
    _tipInformation = information;
    _detailInformation = detailInfo;
    if (detailInfo) {
      _detailInfo.text = detailInfo;
      [_detailInfo fitToSuggestedHeight];
      _detailInfo.hidden = NO;
    } else {
      _detailInfo.hidden = YES;
    }
  }
}

//重设位置
- (void)resetFrame:(CGRect)frame {
  self.frame = frame;
  _imageView.frame = CGRectMake((self.bounds.size.width - SIDE_LENGTH) / 2,
                                (self.bounds.size.height - SIDE_LENGTH - LABEL_HEIGHT / 2 - 5) / 2,
                                SIDE_LENGTH, SIDE_LENGTH);
  _label.frame =
      CGRectMake(0.0, _imageView.frame.origin.y + SIDE_LENGTH + 5.0, self.bounds.size.width, LABEL_HEIGHT);
}

/** 从新设置 小牛和文字位置 */
- (void)resetCryInformationFrame {
  _imageView.centerY = self.height * 0.5 - _imageView.height * 0.5;
  _label.centerY = self.height * 0.5 + _label.height * 0.5 + 18.0f;
}

//重设高度
- (void)resetOffsetY:(CGFloat)offsetY {
  CGRect frame = self.frame;
  frame.origin.y += offsetY;
  self.frame = frame;
}

@end

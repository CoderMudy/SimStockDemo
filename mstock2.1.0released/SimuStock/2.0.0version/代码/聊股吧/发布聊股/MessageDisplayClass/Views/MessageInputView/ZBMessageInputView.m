//
//  ZBMessageInputView.m
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-10.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

#import "ZBMessageInputView.h"
#import "Globle.h"

@interface ZBMessageInputView () <UITextViewDelegate>

@property(nonatomic, copy) NSString *inputedText;

@end

@implementation ZBMessageInputView

- (void)dealloc {

  _Camera_pic_Button = nil;
  _Stock_codingButton = nil;
  _faceSendButton = nil;
  _Share_ObjectsButton = nil;
}

#pragma mark - Action

- (void)messageStyleButtonClicked:(YLClickButton *)sender {
  
  if (_delegate && [self.delegate respondsToSelector:@selector(messageStyleButtonClicked:)])
  {
    [self.delegate messageStyleButtonClicked:sender];
  }
}

#pragma end

#pragma mark - 添加控件
- (void)setupMessageInputViewBarWithStyle:(ZBMessageInputViewStyle)style {
  // 配置输入工具条的样式和布局

  /// 获取图片
  self.Camera_pic_Button = (YLClickButton *)[YLClickButton buttonWithType:UIButtonTypeCustom];
  [self.Camera_pic_Button addimage:[UIImage imageNamed:@"相机小图标.png"] andImageWithFrame:CGRectMake((self.frame.size.width / 4 - 28) / 2, 12, 28, 26) andColor:nil andHighlightedColor:[Globle colorFromHexRGB:@"c2c5ca"] forState:UIControlStateHighlighted];
  [self.bottomView addSubview:self.Camera_pic_Button];
  self.Camera_pic_Button.tag = 0;
  [self.Camera_pic_Button addTarget:self
                             action:@selector(messageStyleButtonClicked:)
                   forControlEvents:UIControlEventTouchUpInside];
  self.Camera_pic_Button.frame =
      CGRectMake(0, 0, self.frame.size.width / 4, 50);

  /// Emotion 表情// 发送表情
  self.faceSendButton = (YLClickButton *)[YLClickButton buttonWithType:UIButtonTypeCustom];
  [self.faceSendButton addimage:[UIImage imageNamed:@"插入表情小图标.png"] andImageWithFrame:CGRectMake((self.frame.size.width / 4 - 28) / 2, 12, 28, 26) andColor:nil andHighlightedColor:[Globle colorFromHexRGB:@"c2c5ca"] forState:UIControlStateHighlighted];
  [self.faceSendButton addTarget:self
                          action:@selector(messageStyleButtonClicked:)
                forControlEvents:UIControlEventTouchUpInside];
  self.faceSendButton.tag = 1;
  [self.bottomView addSubview:self.faceSendButton];
  self.faceSendButton.frame =
      CGRectMake(self.frame.size.width / 4, 0, self.frame.size.width / 4, 50);

  ///股票代码 分享
  self.Stock_codingButton = (YLClickButton *)[YLClickButton buttonWithType:UIButtonTypeCustom];
  [self.Stock_codingButton addimage:[UIImage imageNamed:@"插入聊股小图标.png"] andImageWithFrame:CGRectMake((self.frame.size.width / 4 - 28) / 2, 12, 28, 26) andColor:nil andHighlightedColor:[Globle colorFromHexRGB:@"c2c5ca"] forState:UIControlStateHighlighted];
  [self.Stock_codingButton addTarget:self
                              action:@selector(messageStyleButtonClicked:)
                    forControlEvents:UIControlEventTouchUpInside];
  self.Stock_codingButton.tag = 2;
  [self.bottomView addSubview:self.Stock_codingButton];
  self.Stock_codingButton.frame =
      CGRectMake(self.frame.size.width / 2, 0, self.frame.size.width / 4, 50);

  ///@对象
  self.Share_ObjectsButton = (YLClickButton *)[YLClickButton buttonWithType:UIButtonTypeCustom];
  [self.Share_ObjectsButton addimage:[UIImage imageNamed:@"@小图标.png"] andImageWithFrame:CGRectMake((self.frame.size.width / 4 - 28) / 2, 12, 28, 26) andColor:nil andHighlightedColor:[Globle colorFromHexRGB:@"c2c5ca"] forState:UIControlStateHighlighted];
  [self.Share_ObjectsButton addTarget:self
                               action:@selector(messageStyleButtonClicked:)
                     forControlEvents:UIControlEventTouchUpInside];
  self.Share_ObjectsButton.tag = 3;
  [self.bottomView addSubview:self.Share_ObjectsButton];
  self.Share_ObjectsButton.frame = CGRectMake(self.frame.size.width * 3 / 4, 0,
                                              self.frame.size.width / 4, 50);
   ///分割线
  UIView * bottomline=[[UIView alloc]initWithFrame:CGRectMake(0, self.height-1, self.width, 1)];
  bottomline.backgroundColor=[Globle colorFromHexRGB:Color_Gray_Edge];
  bottomline.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
  [self addSubview:bottomline];
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self setup];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame
        andDelegate:(id<ZBMessageInputViewDelegate>)delegatekey {
  self = [super initWithFrame:frame];
  if (self) {
    self.delegate = delegatekey;
    [self setup];
  }
  return self;
}
- (id)initWithFrame:(CGRect)frame andHeight:(BOOL)isHeight
        andDelegate:(id<ZBMessageInputViewDelegate>)delegatekey {
  self = [super initWithFrame:frame];
  if (self) {
    self.isHeight=isHeight;
    self.delegate = delegatekey;
    [self setup];
  }
  return self;
}
#pragma end

- (void)setup {
  // 配置自适应
  self.autoresizingMask =
      (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
  self.opaque = YES;
  // 由于继承UIImageView，所以需要这个属性设置
  self.userInteractionEnabled = YES;

  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    _messageInputViewStyle = ZBMessageInputViewStyleDefault;
  } else {
    _messageInputViewStyle = ZBMessageInputViewStyleQuasiphysical;
  }
  
  if (self.isHeight)
  {
    UIView *viewtop =
    [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 20)];
    viewtop.backgroundColor = [UIColor whiteColor];
    [self addSubview:viewtop];
    if ([self.delegate
         respondsToSelector:@selector(addViewInMessageBottonView:)]) {
      [self.delegate addViewInMessageBottonView:viewtop];
    }
    
    _bottomView =
    [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.width, 50)];
    _bottomView.backgroundColor = [Globle colorFromHexRGB:@"E1E3EB"];
    [self addSubview:_bottomView];
  }
  else
  {
    _bottomView =
    [[UIView alloc] initWithFrame:CGRectMake(0,0, self.width, 50)];
    _bottomView.backgroundColor = [Globle colorFromHexRGB:@"E1E3EB"];
    [self addSubview:_bottomView];
  }

  [self setupMessageInputViewBarWithStyle:_messageInputViewStyle];
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

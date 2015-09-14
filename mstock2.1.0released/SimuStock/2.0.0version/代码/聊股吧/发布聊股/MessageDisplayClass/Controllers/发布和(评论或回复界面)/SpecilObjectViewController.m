//
//  SpecilObjectViewController.m
//  SimuStock
//
//  Created by Mac on 15/1/28.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SpecilObjectViewController.h"

@implementation SpecilObjectViewController

/// barid 所属股吧ID，发布成功后返回数据方便回调  @xxxx人，多传入一个@对象
- (void)StartAndName:(NSString *)name
     andObjectUserid:(NSString *)userid
         andCallBack:(OnReturnObject)callback {
  self.is_addHeight = NO;

  if (!_yl_Object) {
    self.yl_Object = [[YLDistributObject alloc] initWithnickName:name andUid:userid];
  }

  NSString *nameObject = [NSString stringWithFormat:@"@%@ ", name];
  self.Str_Content = nameObject;
  //
  //    [self setup];
  //
  // 发布聊股 回调函数
  OnReturnObjectCallback = callback;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [_topToolBar setTitleCenter:@"发聊股"];
  // Do any additional setup after loading the view.
  [self setup];
}

///重写父类函数
- (void)setup {

  self.messageDisplayView =
      [[YLTextView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, WIDTH_OF_SCREEN,
                                                   self.messageToolView.top -
                                                       (self.view.bottom - self.clientView.bottom))
                               andTitle:YES
                             andContent:self.Str_Content
                            andNickName:self.yl_Object.nickName
                              andUserid:self.yl_Object.UserID];

  self.messageDisplayView.YL_delegate = self;
  self.messageDisplayView.yl_Object = self.yl_Object;
  self.messageDisplayView.backgroundColor = [UIColor whiteColor];
  [self.clientView addSubview:self.messageDisplayView];

  [self.messageDisplayView Remaining];
}
- (void)ModifyKeyboardState {
  [super ModifyKeyboardState];
}

///右边按钮按下  delegate代理
- (void)rightButtonPress {

  if (([self.messageDisplayView.Text_contentView.text length] > 0 &&
       ![SimuUtil isBlankString:self.messageDisplayView.Text_contentView.text]) ||
      self.messageDisplayView.Share_imageView.image != nil) {
    ///发布的时候清空，文本和标题的缓存
    NSString *resultStr =
        [self.messageDisplayView getXMLfromstring:self.messageDisplayView.Text_contentView.text];

    NSString *title = self.messageDisplayView.Title_textField.text;
    if (title && [SimuUtil isBlankString:title]) {
      title = @"";
    };

    [self EditandComments:resultStr
                 andTitle:title
                 andImage:self.messageDisplayView.Share_imageView.image];

  } else {
    [NewShowLabel setMessageContent:@"请输入聊股内容"];
  }
}

/// 取消当前界面 按钮触发事件
- (void)leftButtonPress {
  [super leftButtonPress];
}

///正式发布聊股
- (void)EditandComments:(NSString *)string
               andTitle:(NSString *)title
               andImage:(UIImage *)shareImage {
  /// barID:1415943612555480
  NSString *url = [istock_address stringByAppendingString:@"istock/newTalkStock/pubimgtstock"];
  NSDictionary *dic = [self getDataWithDictionary_StockBar:nil
                                               andSourceID:nil
                                               andComments:string
                                                  andTitle:title
                                                  andImage:shareImage];
  [self Edit_PathUrl:url andDic:dic];

  ///网络请求进入队栈，tweetlistitem，直接返回
  TweetListItem *tweetlistItem = [[TweetListItem alloc] initWithDistributeStockBarID:nil
                                                                            andTitle:title
                                                                          andContext:string
                                                                            andImage:shareImage];
  NSLog(@"测试对象：%@", tweetlistItem);

  OnReturnObjectCallback(tweetlistItem);

  self.messageDisplayView.Text_contentView.text = @"";
  self.messageDisplayView.Share_imageView.image = nil;
  [self.navigationController popViewControllerAnimated:YES];
}

@end

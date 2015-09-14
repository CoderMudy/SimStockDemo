//
//  SpecilStockViewController.m
//  SimuStock
//
//  Created by Mac on 15/1/28.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SpecilStockViewController.h"

@implementation SpecilStockViewController {
  ///股票代码
  NSString *_stockCode;
  ///股票名称
  NSString *_stockName;
}

/// barid 所属股吧ID，发布成功后返回数据方便回调  $个股详情页
- (id)initWithStockCode:(NSString *)stockCode
          withStockName:(NSString *)stockName
  withFadeWeiboCallBack:(OnReturnObject)callback {
  if (self = [super init]) {
    self.is_addHeight = NO;
    self.Str_Content = [NSString stringWithFormat:@"$%@(%@)$ ", stockName, stockCode];
    _stockCode = stockCode;
    _stockName = stockName;

    // 发布聊股 回调函数
    OnReturnObjectCallback = callback;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [_topToolBar setTitleCenter:@"发聊股"];
  [self setup];
}

///重写父类函数
- (void)setup {
  self.messageDisplayView =
      [[YLTextView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, WIDTH_OF_SCREEN,
                                                   self.messageToolView.top - (self.view.bottom - self.clientView.bottom))
                               andTitle:YES
                                andType:YLSepcilNone];
  self.messageDisplayView.YL_delegate = self;
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
      self.messageDisplayView.Share_imageView.image) {

    self.messageDisplayView.Text_contentView.text =
        [self.Str_Content stringByAppendingString:self.messageDisplayView.Text_contentView.text];
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
  [self.navigationController popViewControllerAnimated:YES];

  NSString *stockCode = _stockCode ? _stockCode : @"";
  NSDictionary *userInfo = @{ @"stockCode" : stockCode, @"operation" : @"1" };
  [[NSNotificationCenter defaultCenter] postNotificationName:StockBarWeiboSumChangeNotification
                                                      object:self
                                                    userInfo:userInfo];
}

@end

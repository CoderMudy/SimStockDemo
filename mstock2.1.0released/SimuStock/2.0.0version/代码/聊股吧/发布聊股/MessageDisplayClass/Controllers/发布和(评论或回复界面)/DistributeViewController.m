//
//  DistributeViewController.m
//  SimuStock
//
//  Created by Mac on 14/12/25.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "DistributeViewController.h"


@implementation DistributeViewController

- (id)initWithBarID:(NSString *)barid andCallBack:(OnReturnObject)callback {

  if (self = [super init]) {
    self.is_addHeight = NO;
    self.barID = barid;
    // 发布聊股 回调函数
    OnReturnObjectCallback = callback;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [_topToolBar setTitleCenter:@"发聊股"];
  // Do any additional setup after loading the view.
  [self setup];
}

///重写父类函数
- (void)setup {

  self.messageDisplayView = [[YLTextView alloc]
      initWithFrame:CGRectMake(0.0f, 0.0f, WIDTH_OF_SCREEN,
                               self.messageToolView.top -
                                   (self.view.bottom - self.clientView.bottom))
           andTitle:YES
            andType:YLDisVCTextView];
  self.messageDisplayView.YL_delegate = self;
  self.messageDisplayView.backgroundColor = [UIColor whiteColor];
//  self.messageDisplayView.autoresizingMask = UIViewAutoresizingFlexibleWidth |UIViewAutoresizingFlexibleHeight;
  [self.clientView addSubview:self.messageDisplayView];

  [self.messageDisplayView Remaining];
}
- (void)ModifyKeyboardState {
  [super ModifyKeyboardState];
}

///右边按钮按下  delegate代理
- (void)rightButtonPress
{
  NSString *contentStr = self.messageDisplayView.Text_contentView.text;
  UIImage *shareImage = self.messageDisplayView.Share_imageView.image;
  NSString *title = self.messageDisplayView.Title_textField.text;
  
  if (([contentStr length] > 0 && ![SimuUtil isBlankString:contentStr]) ||
      shareImage) {
    ///发布的时候清空，文本和标题的缓存
    NSString *UserID = [SimuUtil getUserID];
    NSString *Key = [NSString stringWithFormat:@"YLDistributeVC_%@", UserID];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:Key];

    NSString *resultStr = [self.messageDisplayView getXMLfromstring:contentStr];

    if (title && [SimuUtil isBlankString:title]) {
      title = @"";
    };

    [self Edit_StockBar:self.barID
            andComments:resultStr
               andTitle:title
               andImage:shareImage];

  } else {
    [NewShowLabel setMessageContent:@"请输入聊股内容"];
  }
}

/// 取消当前界面 按钮触发事件
- (void)leftButtonPress {
  NSDictionary *dic = [self saveDataWithDic];
  NSString *UserID = [SimuUtil getUserID];
  NSString *Key = [NSString stringWithFormat:@"YLDistributeVC_%@", UserID];
  [[NSUserDefaults standardUserDefaults] setObject:dic forKey:Key];

  [super leftButtonPress];
}

///正式发布聊股
- (void)Edit_StockBar:(NSString *)barid
          andComments:(NSString *)string
             andTitle:(NSString *)title
             andImage:(UIImage *)shareImage {
  /// barID:1415943612555480
  NSString *url = [istock_address
      stringByAppendingString:@"istock/newTalkStock/pubimgtstock"];
  NSDictionary *dic = [self getDataWithDictionary_StockBar:barid
                                               andSourceID:nil
                                               andComments:string
                                                  andTitle:title
                                                  andImage:shareImage];
  [self Edit_PathUrl:url andDic:dic];

  ///网络请求进入队栈，tweetlistitem，直接返回
  TweetListItem *tweetlistItem =
      [[TweetListItem alloc] initWithDistributeStockBarID:barid
                                                 andTitle:title
                                               andContext:string
                                                 andImage:shareImage];
  NSLog(@"测试对象：%@", tweetlistItem);

  OnReturnObjectCallback(tweetlistItem);

  [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

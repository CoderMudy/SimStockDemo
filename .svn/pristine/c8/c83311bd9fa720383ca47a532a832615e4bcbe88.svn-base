//
//  ReplyViewController.m
//  SimuStock
//
//  Created by Mac on 14/12/25.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "ReplyViewController.h"

@implementation ReplyViewController

- (id)initWithTstockID:(NSString *)stockID andCallBack:(OnReturnObject)callback {

  if (self = [super init]) {
    self.is_addHeight = YES;
    self.stockID = stockID;
    // 评论聊股 回调函数
    OnReturnObjectCallback = callback;
  }

  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [_topToolBar setTitleCenter:@"评论"];
  [self setup];
}

///重写父类函数
- (void)setup {
  self.messageDisplayView =
      [[YLTextView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, WIDTH_OF_SCREEN,
                                                   self.messageToolView.top - (self.view.bottom - self.clientView.bottom))
                               andTitle:NO
                                andType:YLReplyVCTextView];
  self.messageDisplayView.Max_textView = 300;
  self.messageDisplayView.YL_delegate = self;
  self.messageDisplayView.backgroundColor = [UIColor whiteColor];
  [self.clientView addSubview:self.messageDisplayView];
  self.messageDisplayView.Text_contentView.placeHolder = @"写评论...";
  [self.messageDisplayView Remaining];
}

- (void)YLTextViewDidChange:(NSInteger)length {
  _numTextLabel.text = [NSString stringWithFormat:@"%ld字", (long)(300 - length)];
}
- (void)ModifyKeyboardState {
  [super ModifyKeyboardState];
}

///右边按钮按下  delegate代理
- (void)rightButtonPress {
  NSString *contentStr = self.messageDisplayView.Text_contentView.text;
  UIImage *shareImage = self.messageDisplayView.Share_imageView.image;

  if (([contentStr length] > 0 && ![SimuUtil isBlankString:contentStr]) || shareImage != nil) {
    ///发布的时候清空，文本和标题的缓存
    ///如果标题有内容,做一个数据存储
    NSString *UserID = [SimuUtil getUserID];
    NSString *Key = [NSString stringWithFormat:@"YLReplyVC_%@", UserID];
    [[NSUserDefaults standardUserDefaults] setValue:nil forKey:Key];

    NSString *resultStr = [self.messageDisplayView getXMLfromstring:contentStr];

    [self Edit_StockComments:resultStr andImage:shareImage];
  } else {

    [NewShowLabel setMessageContent:@"请输入评论内容"];
  }
}
/// 取消当前界面 按钮触发事件
- (void)leftButtonPress {
  NSDictionary *dic = [self saveDataWithDic];
  NSString *UserID = [SimuUtil getUserID];
  NSString *Key = [NSString stringWithFormat:@"YLReplyVC_%@", UserID];
  [[NSUserDefaults standardUserDefaults] setObject:dic forKey:Key];

  [super leftButtonPress];
}

///正式评论聊股
- (void)Edit_StockComments:(NSString *)string andImage:(UIImage *)shareImage {

  NSString *url =
      [NSString stringWithFormat:@"%@istock/talkstock/pubcomment/%@/%@/%@/%@/%d", istock_address, [SimuUtil getAK],
                                 [SimuUtil getSesionID], [SimuUtil getUserID], self.stockID, self.isForwarding];
  NSDictionary *dic = [self getDataWithDictionary_StockBar:nil
                                               andSourceID:nil
                                               andComments:string ? string : @""
                                                  andTitle:nil
                                                  andImage:shareImage];
  [self Edit_PathUrl:url andDic:dic];

  [NetLoadingWaitView stopAnimating];
  ///返回对象
  TweetListItem *tweetlistItem = [[TweetListItem alloc] initWithReplyStocktalkId:_stockID
                                                                      andContext:string
                                                                        andImage:shareImage];
  
  /**
   *  发送通知
   */
  
  [[NSNotificationCenter defaultCenter] postNotificationName:@"评论通知中心" object:nil];

  OnReturnObjectCallback(tweetlistItem);

  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ZBMessageFaceViewDelegate
/**
 *  在键盘的导航条上再加上一个uiview，比例，位置坐标
 */
- (void)addViewInMessageBottonView:(UIView *)view {
  UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
  btn.frame = CGRectMake(0, 0, 180, 20);
  [btn addTarget:self
                action:@selector(radioButtonClick:)
      forControlEvents:UIControlEventTouchUpInside];
  [view addSubview:btn];

  ///圈圈
  UIView *qq_view = [[UIView alloc] initWithFrame:CGRectMake(8, 5, 12, 12)];
  qq_view.tag = 1000;
  qq_view.layer.cornerRadius = 6;
  qq_view.userInteractionEnabled = NO;
  [[qq_view layer] setBorderWidth:1.0f];
  [qq_view.layer setBorderColor:[Globle colorFromHexRGB:Color_Gray].CGColor];
  [btn addSubview:qq_view];

  UIImageView *qq_image = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, 6, 6)];
  qq_image.tag = 2000;
  qq_image.layer.cornerRadius = 3;
  [qq_view addSubview:qq_image];

  ///标签
  UILabel *dis_lable = [[UILabel alloc] initWithFrame:CGRectMake(26, 5, 134, 12)];
  dis_lable.font = [UIFont systemFontOfSize:13];
  dis_lable.text = @"转发到我的聊股";
  dis_lable.textColor = [UIColor blackColor];
  [btn addSubview:dis_lable];

  ///剩余字数
  _numTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width - 50, 0, 50, 15)];
  _numTextLabel.text = @"300字";
  _numTextLabel.textColor = [Globle colorFromHexRGB:Color_Blue_but];
  _numTextLabel.backgroundColor = [UIColor clearColor];
  _numTextLabel.font = [UIFont systemFontOfSize:13];
  [view addSubview:_numTextLabel];
}
- (void)radioButtonClick:(UIButton *)sender {
  [sender setSelected:!sender.selected];
  if (sender.selected) {
    UIView *qq_view = [sender viewWithTag:1000];
    [qq_view.layer setBorderColor:[Globle colorFromHexRGB:Color_Blue_but].CGColor];
    UIImageView *imageView = (UIImageView *)[qq_view viewWithTag:2000];
    imageView.image = [UIImage imageNamed:@"转发对号小图标.png"];
  } else {
    UIView *qq_view = [sender viewWithTag:1000];
    [qq_view.layer setBorderColor:[Globle colorFromHexRGB:Color_Gray].CGColor];
    UIImageView *imageView = (UIImageView *)[qq_view viewWithTag:2000];
    imageView.image = nil;
  }
  self.isForwarding = sender.selected;
}

@end

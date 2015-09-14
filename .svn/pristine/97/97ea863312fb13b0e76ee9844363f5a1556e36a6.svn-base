//
//  FirstDistributeViewController.m
//  SimuStock
//
//  Created by Mac on 15/2/3.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "FirstDistributeViewController.h"
#import "HotStockBarViewController.h"
#import "FirstComeView.h"
@interface FirstDistributeViewController () <UITextViewDelegate> {
  //聊股吧标题
  UILabel *qq_lable;
}
@property(strong, nonatomic) FirstComeView *firstcomeView;
@property(copy, nonatomic) NSString *firstCome;
@end

@implementation FirstDistributeViewController

- (id)initWithCallBack:(OnReturnObject)callback {
  self = [super init];
  if (self) {
    self.is_addHeight = YES;
    // 发布聊股 回调函数
    OnReturnObjectCallback = callback;
    _indicatorView.hidden = YES;
  }

  return self;
}

//获取键盘的高度
- (void)keyboardWasShown:(NSNotification *)notification {

  if ([self.firstCome intValue] == 1) {
    [[NSNotificationCenter defaultCenter]
        removeObserver:self
                  name:UITextViewTextDidChangeNotification
                object:nil];

    [[NSNotificationCenter defaultCenter]
        removeObserver:self
                  name:UIKeyboardDidChangeFrameNotification
                object:nil];
  }

  [self.view layoutIfNeeded];
  if (!self.firstcomeView) {
    self.firstcomeView = [[FirstComeView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.firstcomeView];
  }
  NSDictionary *info = [notification userInfo];
  //键盘高度
  CGSize kbSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
  NSLog(@"键盘高度 = %f", kbSize.height);
  self.firstcomeView.keyboardHeight = kbSize.height;
  [self.firstcomeView CreatFirstView];

  [[NSUserDefaults standardUserDefaults] setObject:@"1"
                                            forKey:@"isFirstWriteWeibo"];
  self.firstCome = @"1";
  [[NSUserDefaults standardUserDefaults] synchronize];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(keyboardWasShown:)
             name:UIKeyboardDidChangeFrameNotification
           object:nil];
}
- (void)keyboardChangeFrame:(NSNotification *)notification {
  if (_firstcomeView) {
    NSDictionary *info = [notification userInfo];
    //键盘高度
    CGSize kbSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSLog(@"键盘高度 = %f", kbSize.height);
    self.firstcomeView.keyboardHeight = kbSize.height;
    [self.firstcomeView CreatFirstView];
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.firstCome =
      [[NSUserDefaults standardUserDefaults] objectForKey:@"isFirstWriteWeibo"];
  if ([self.firstCome intValue] == 0) {
    //注册键盘高度通知
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(keyboardWasShown:)
               name:UIKeyboardDidShowNotification
             object:nil];
    //注册个textView内容变化的通知
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(textViewDidChange:)
               name:UITextViewTextDidChangeNotification
             object:nil];
  }
  [_topToolBar setTitleCenter:@"发聊股"];
  [self setup];
}

- (void)textViewDidChange:(NSNotification *)notification {
  [[NSNotificationCenter defaultCenter]
      removeObserver:self
                name:UITextViewTextDidChangeNotification
              object:nil];
  if ([self.firstcomeView superview]) {
    [self.firstcomeView removeFromSuperview];
  }
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
  [self.clientView addSubview:self.messageDisplayView];

  [self.messageDisplayView Remaining];
}
- (void)ModifyKeyboardState {
  [super ModifyKeyboardState];
}

///右边按钮按下  delegate代理
- (void)rightButtonPress {

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

#pragma mark - ZBMessageFaceViewDelegate
/**
 *  在键盘的导航条上再加上一个uiview，比例，位置坐标
 */
- (void)addViewInMessageBottonView:(UIView *)view {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.frame = CGRectMake(0, 0, 180, 20);
  [button addTarget:self
                action:@selector(touchdown:)
      forControlEvents:UIControlEventTouchDown];
  [button addTarget:self
                action:@selector(outSide:)
      forControlEvents:UIControlEventTouchUpOutside];
  [button addTarget:self
                action:@selector(radioButtonClick:)
      forControlEvents:UIControlEventTouchUpInside];
  [view addSubview:button];

  //标签
  qq_lable = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 70, 16)];
  qq_lable.layer.cornerRadius = 8;
  qq_lable.clipsToBounds = YES;
  qq_lable.layer.borderWidth = 0.5f;
  qq_lable.layer.borderColor = [Globle colorFromHexRGB:@"086DAE"].CGColor;
  qq_lable.backgroundColor = [UIColor clearColor];
  qq_lable.font = [UIFont systemFontOfSize:11];
  NSString *barName = [[NSUserDefaults standardUserDefaults]
      objectForKey:@"YL_StockTalkbarName"];
  if ([barName length] > 0) {
    CGFloat width = [barName sizeWithFont:qq_lable.font
                        constrainedToSize:CGSizeMake(300, 16)
                            lineBreakMode:NSLineBreakByWordWrapping].width +
                    10;
    qq_lable.width = width;
    qq_lable.text = barName;
    self.barID = [[NSUserDefaults standardUserDefaults]
        objectForKey:@"YL_StockTalkBarID"];
  } else {
    qq_lable.text = @"优顾大家谈";
  }
  qq_lable.textColor = [Globle colorFromHexRGB:@"086DAE"];
  qq_lable.userInteractionEnabled = NO;
  qq_lable.textAlignment = NSTextAlignmentCenter;
  [button addSubview:qq_lable];
}
//按钮点击效果
- (void)touchdown:(UIButton *)btn {
  qq_lable.backgroundColor = [Globle colorFromHexRGB:@"cecece"];
}
- (void)outSide:(UIButton *)btn {
  qq_lable.backgroundColor = [UIColor clearColor];
}

- (void)radioButtonClick:(UIButton *)sender {
  qq_lable.backgroundColor = [UIColor clearColor];
  HotStockBarViewController *hotViewController = [
      [HotStockBarViewController alloc]
      initWithReturnBarIDCallBack:^(NSNumber *barID, NSString *barName) {
        [[NSUserDefaults standardUserDefaults] setObject:[barID stringValue]
                                                  forKey:@"YL_StockTalkBarID"];
        [[NSUserDefaults standardUserDefaults]
            setObject:barName
               forKey:@"YL_StockTalkbarName"];
        self.barID = [barID stringValue];
        if ([barName length] > 0) {
          CGFloat width =
              [barName sizeWithFont:qq_lable.font
                  constrainedToSize:CGSizeMake(300, 16)
                      lineBreakMode:NSLineBreakByWordWrapping].width +
              10;
          qq_lable.width = width;
          qq_lable.text = barName;
        }
      }];
  [AppDelegate pushViewControllerFromRight:hotViewController];
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

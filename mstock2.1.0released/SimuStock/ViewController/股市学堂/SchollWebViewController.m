//
//  SchollWebViewController.m
//  SimuStock
//
//  Created by moulin wang on 14-4-21.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SchollWebViewController.h"
#import "NewShowLabel.h"
#import "YouguuSchema.h"
#import "CutomerServiceButton.h"
#import "MakingShareAction.h"
#import "MakingScreenShot.h"
#import "Globle.h"

@interface SchollWebViewController () {
  UIAlertView *alert;
}
/** 实盘交易 直接退出按钮 */
@property(assign, nonatomic) BOOL directSignOutBool;

@end

@implementation SchollWebViewController

- (id)initWithNameTitle:(NSString *)title andPath:(NSString *)path {

  if (self = [super init]) {
    self.textName = title;
    self.textUrl = path;
    self.brokerAccountLogonBool = NO;
    self.pressButtonBool = NO;
    self.directSignOutBool = YES;
  }
  return self;
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [self.view endEditing:YES];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  networkBool = NO;

  //创建上方工具栏
  [_topToolBar resetContentAndFlage:self.textName Mode:TTBM_Mode_Leveltwo];

  //创建客服电话
  [[CutomerServiceButton shareDataCenter] establisthCustomerServiceTelephonetopToolBar:_topToolBar
                                                                         indicatorView:_indicatorView
                                                                                  hide:NO];
  [CutomerServiceButton shareDataCenter].hidden = ![_textName isEqualToString:@"配资攻略"];

  if ([self.textName isEqualToString:@"牛人计划分享"] ||
      [self.textName isEqualToString:@"网页链接"] || [self.matchType isEqualToString:@"978"]) {
    [self createShareControl];
  }

  //  在实盘界面 创建退出按钮
//  if (self.brokerOpenLogin == BrokerLoginStock) {
//    [self exitButton];
//  }
  //取得网络数据
  [_indicatorView startAnimating];
  [self creatWebView:self.textUrl];
}

//实盘界面的 退出按钮
- (void)exitButton {
  BGColorUIButton *button =
      [[BGColorUIButton alloc] initWithFrame:CGRectMake(WIDTH_OF_SCREEN - 40 - 5, CGRectGetMinY(_indicatorView.frame),
                                                        40, CGRectGetHeight(_indicatorView.bounds))];
  [button setTitle:@"退出" forState:UIControlStateNormal];
  button.normalBGColor = [UIColor clearColor];
  [button setTitleColor:[Globle colorFromHexRGB:@"4dfdff"] forState:UIControlStateNormal];
  [button setBackgroundImage:[UIImage imageNamed:@"return_touch_down.png"]
                    forState:UIControlStateHighlighted];
  //背景色
  __weak SchollWebViewController *weakSelf = self;
  [button setOnButtonPressedHandler:^{
    SchollWebViewController *stongSelf = weakSelf;
    if (stongSelf) {
      [stongSelf directSignOutAlertView];
    }
  }];
  [_topToolBar addSubview:button];
  _indicatorView.left = CGRectGetMinX(button.frame) - _indicatorView.width;
}

// lq分享控件
- (void)createShareControl {
  CGRect frame = self.view.frame;
  UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
  shareButton.frame = CGRectMake(frame.size.width - 40, _topToolBar.bounds.size.height - 45, 40, 45);
  UIImage *shareImage = [UIImage imageNamed:@"分享.png"];
  [shareButton setImage:shareImage forState:UIControlStateNormal];
  [shareButton setImage:shareImage forState:UIControlStateHighlighted];
  //按钮选中中视图
  UIImage *mtvc_centerImage =
      [[UIImage imageNamed:@"return_touch_down"] resizableImageWithCapInsets:UIEdgeInsetsMake(14, 14, 14, 14)];
  [shareButton setBackgroundImage:mtvc_centerImage forState:UIControlStateHighlighted];
  [shareButton addTarget:self
                  action:@selector(shareUserInfo:)
        forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:shareButton];
  if (self.indicatorView) {
    CGFloat allWidth = _topToolBar.frame.size.width;
    self.indicatorView.left = allWidth - 80;
    self.topToolBar.sbv_nameLable.width = allWidth - self.topToolBar.sbv_nameLable.left - 84;
  }
}

- (void)logonSuccessShareUserInfo {
  //已登录
  NSString *selfUserID = [SimuUtil getUserID];

  //截屏
  MakingScreenShot *makingScreenShot = [[MakingScreenShot alloc] init];
  //分享
  CGRect frame = CGRectMake(0, HEIGHT_OF_NAVIGATIONBAR, self.view.width, self.view.height - HEIGHT_OF_NAVIGATIONBAR);
  UIImage *shareImage = [makingScreenShot makingScreenShotWithFrame:frame
                                                           withView:self.view
                                                           withType:MakingScreenShotType_HomePage];

  MakingShareAction *shareAction = [[MakingShareAction alloc] init];
  shareAction.shareModuleType = ShareModuleTypeStaticWap;
  shareAction.shareUserID = selfUserID;
  [shareAction shareTitle:self.textName
                  content:[NSString stringWithFormat:@"#优顾炒股#【%@】%@ (分享自@优顾炒股官方)", self.textName, self.textUrl]
                    image:shareImage
           withOtherImage:nil
             withShareUrl:self.textUrl
            withOtherInfo:[NSString stringWithFormat:@"#优顾炒股#【%@】%@", self.textName, self.textUrl]];
}

- (void)shareUserInfo:(id)sender {
  [self logonSuccessShareUserInfo];
}

- (void)dialSevicesTelephoneNumber {
  //操作表
  NSString *number = @"01053599702";
  NSURL *backURL = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", number]];
  [[UIApplication sharedApplication] openURL:backURL];
}
#pragma mark
#pragma mark 无网络

//创建捏指浏览器
- (void)creatWebView:(NSString *)loadUrl {
  _webView =
      [[UIWebView alloc] initWithFrame:CGRectMake(0, _topToolBar.bounds.size.height, self.view.bounds.size.width,
                                                  self.view.bounds.size.height - (_topToolBar.bounds.size.height))];
  _webView.delegate = self;
  //滑动速率
  _webView.scrollView.decelerationRate = 1.0;
  _webView.opaque = NO;
  _webView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  UIScrollView *scroller = _webView.subviews[0];

  if (scroller) {
    for (UIView *v in [scroller subviews]) {
      if ([v isKindOfClass:[UIImageView class]]) {
        [v removeFromSuperview];
      }
    }
  }
  [_webView setUserInteractionEnabled:YES];
  [self.view addSubview:_webView];
  ////添加UserAgent
  [SimuUtil WebViewUserAgent:_webView];

  //有无网络显示
  if (![SimuUtil isExistNetwork]) {
    [_littleCattleView isCry:YES];
    [_indicatorView stopAnimating];
    [NewShowLabel showNoNetworkTip];
  } else {
    _littleCattleView.hidden = YES;
    [self textUrl:loadUrl];
  }
  mtvc_isViewWillCancell = NO;
}
#pragma mark
#pragma mark-----------对外接口-----------------------------------

- (void)textUrl:(NSString *)loadUrl {
  if (loadUrl == nil || [loadUrl length] == 0 || _webView == nil)
    return;
  NSURL *url = [NSURL URLWithString:loadUrl];
  NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
  [_webView loadRequest:request];
}

#pragma UIWebView 代理方法
- (void)webViewDidStartLoad:(UIWebView *)webView {
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
  networkBool = YES;
  _littleCattleView.hidden = YES;
  [_indicatorView stopAnimating];
  if ([self.matchType isEqualToString:@"978"]) {
    _indicatorView.hidden = YES;
  }
  //无标题，取网站标题
  if (!_textName) {
    self.textName = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [_topToolBar resetContentAndFlage:self.textName Mode:TTBM_Mode_Leveltwo];
  }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  [_indicatorView stopAnimating];
  if ([self.matchType isEqualToString:@"978"]) {
    _indicatorView.hidden = YES;
  }
  if (mtvc_isViewWillCancell == NO) {
    if (!networkBool) {
      [_littleCattleView isCry:YES];
    }
    [NewShowLabel showNoNetworkTip];
  }
}

#pragma mark
#pragma mark-------SimuIndicatorDelegate-----------
- (void)refreshButtonPressDown {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  [_indicatorView startAnimating];
  if (_webView) {
    [self textUrl:self.textUrl];
  } else {
    [self creatWebView:self.textUrl];
  }
}

#pragma mark
#pragma mark SimTopBannerViewDelegate

- (void)leftButtonPress {

  if (_brokerAccountLogonBool) {
    //实盘
    //不是实盘 直接退出
    if (_pressButtonBool) {
      [self showAlertView];
    }else{
      mtvc_isViewWillCancell = YES;
      [_webView stopLoading];
      [super leftButtonPress];
    }
  }else{
    if (_webView && [_webView canGoBack] == YES) {
      //层层退
      [_webView goBack];
    }else{
      //不是实盘 直接退出
      mtvc_isViewWillCancell = YES;
      [_webView stopLoading];
      [super leftButtonPress];
    }
  }
  
//  if (self.directSignOutBool) {
//    if (_webView && [_webView canGoBack] == YES) {
//      //层层退
//      [_webView goBack];
//    } else {
//      //最后一次 退出 判断 是否是 实盘
//      if (_pressButtonBool) {
//        if (_brokerAccountLogonBool) {
//          //实盘 调这个方法
//          [self showAlertView];
//        }
//      } else {
//        //不是实盘 直接退出
//        mtvc_isViewWillCancell = YES;
//        [_webView stopLoading];
//        [super leftButtonPress];
//      }
//    }
//  } else {
//    //不是实盘 直接退出
//    mtvc_isViewWillCancell = YES;
//    [_webView stopLoading];
//    [super leftButtonPress];
//  }
}

//提示框 后退按钮 提示框
- (void)showAlertView {
  NSString *content = [NSString stringWithFormat:@"是否退出%@?", self.contentBroketName];
  if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:@"温馨提示"
                                            message:content
                                     preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action){

                                                         }];

    [alertController addAction:cancelAction];
    __weak SchollWebViewController *weakSelf = self;
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action){
                                                        weakSelf.pressButtonBool = NO;
                                                        [weakSelf leftButtonPress];
                                                      }];

    [alertController addAction:yesAction];
    [self presentViewController:alertController animated:YES completion:nil];
  } else {
    alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                       message:content
                                      delegate:self
                             cancelButtonTitle:@"取消"
                             otherButtonTitles:@"确定", nil];
    alert.tag = 200;
    [alert show];
  }
}

//退出按钮
- (void)directSignOutAlertView {
  NSString *content = [NSString stringWithFormat:@"是否退出%@?", self.contentBroketName];
  if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
    UIAlertController *alertController =
    [UIAlertController alertControllerWithTitle:@"温馨提示"
                                        message:content
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *action){
                                                           
                                                         }];
    
    [alertController addAction:cancelAction];
    __weak SchollWebViewController *weakSelf = self;
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action){
                                                        weakSelf.directSignOutBool = NO;
                                                        [weakSelf leftButtonPress];
                                                      }];
    
    [alertController addAction:yesAction];
    [self presentViewController:alertController animated:YES completion:nil];
  } else {
    alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                       message:content
                                      delegate:self
                             cancelButtonTitle:@"取消"
                             otherButtonTitles:@"确定", nil];
    alert.tag = 1001;
    [alert show];
  }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) {
    //确定
    if (alertView.tag == 200) {
      _pressButtonBool = NO;
    } else if (alertView.tag == 1001) {
      _directSignOutBool = NO;
    } else {
    }
    [self leftButtonPress];
  } else {
    //取消
  }
}

#pragma mark webview每次加载之前都会调用这个方法
// 如果返回NO，代表不允许加载这个请求
- (BOOL)webView:(UIWebView *)webView
    shouldStartLoadWithRequest:(NSURLRequest *)request
                navigationType:(UIWebViewNavigationType)navigationType {
  // 说明协议头是ios
  if ([@"youguu" isEqualToString:request.URL.scheme]) {
    //跳转页面
    [YouguuSchema handleYouguuUrl:request.URL];
    return NO;
  } else if ([@"tel" isEqualToString:request.URL.scheme]) {
    [[UIApplication sharedApplication] openURL:request.URL];
    return NO;
  } else if ([request.URL.absoluteString hasPrefix:@"http"]) {
    [_indicatorView stopAnimating];
  }
  return YES;
}

/** 普通web端创建 */
+ (void)startWithTitle:(NSString *)title withUrl:(NSString *)url {

  SchollWebViewController *webviewController = [[SchollWebViewController alloc] init];
  webviewController.textName = title;
  webviewController.textUrl = url;
  webviewController.brokerAccountLogonBool = NO;
  webviewController.pressButtonBool = NO;
  webviewController.directSignOutBool = YES;
  [AppDelegate pushViewControllerFromRight:webviewController];
}

/** 高校比赛 专用 创建WEB端方法 */
+ (void)startWithTitle:(NSString *)title
               withUrl:(NSString *)url
         withMatchType:(NSString *)matchType {
  SchollWebViewController *webviewController = [[SchollWebViewController alloc] init];
  webviewController.textName = title;
  webviewController.textUrl = url;
  webviewController.brokerAccountLogonBool = NO;
  webviewController.pressButtonBool = NO;
  webviewController.matchType = matchType;
  webviewController.directSignOutBool = YES;
  [AppDelegate pushViewControllerFromRight:webviewController];
}

/** 启动网页 实盘界面的 */
+ (void)startWithTitle:(NSString *)title
               withUrl:(NSString *)url
   withBrokerLogonBool:(BOOL)logonBool
        withBrokerType:(BrokerOpenLogin)openLogin {
  SchollWebViewController *webviewController = [[SchollWebViewController alloc] init];
  webviewController.textName = title;
  webviewController.contentBroketName = title;
  webviewController.textUrl = url;
  webviewController.brokerAccountLogonBool = logonBool;
  webviewController.pressButtonBool = logonBool;
  webviewController.directSignOutBool = YES;
  webviewController.brokerOpenLogin = openLogin;
  [AppDelegate pushViewControllerFromRight:webviewController];
}

@end

//
//  BaseWebViewController.m
//  SimuStock
//
//  Created by Mac on 15/5/25.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseWebViewController.h"
#import "NewShowLabel.h"
#import "YouguuSchema.h"

@implementation BaseWebViewController

- (id)initWithFrame:(CGRect)frame withNameTitle:(NSString *)title andPath:(NSString *)path {

  if (self = [super initWithFrame:frame]) {
    self.textName = title;
    self.textUrl = path;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.dataBinded = NO;

  /** 哭泣的小牛 点击刷新操作 */
  __weak BaseWebViewController *weakSelf = self;
  self.littleCattleView.cryRefreshBlock = ^() {
    BaseWebViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf refreshButtonPressDown];
    }
  };

  [self creatWebView:self.textUrl];
}

#pragma mark
#pragma mark 无网络

//创建捏指浏览器
- (void)creatWebView:(NSString *)loadUrl {
  _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
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
    [self.littleCattleView isCry:YES];
    [self endRefreshLoading];

    [NewShowLabel showNoNetworkTip];
  } else {
    self.littleCattleView.hidden = YES;
    [self textUrl:loadUrl];
  }
  mtvc_isViewWillCancell = NO;
}

- (void)endRefreshLoading {
  if (self.endRefreshCallBack) {
    self.endRefreshCallBack();
  }
}
#pragma mark
#pragma mark-----------对外接口-----------------------------------

- (void)textUrl:(NSString *)loadUrl {
  if (loadUrl == nil || [loadUrl length] == 0 || _webView == nil)
    return;
  NSURL *url = [NSURL URLWithString:loadUrl];
  NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
  [_webView loadRequest:request];
  NSLog(@"webview request url:%@", url);
}

#pragma UIWebView 代理方法
- (void)webViewDidStartLoad:(UIWebView *)webView {
  NSLog(@"webViewDidStartLoad: %@", [webView request].URL);
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
  self.dataBinded = YES;
  self.littleCattleView.hidden = YES;
  [self endRefreshLoading];

  //无标题，取网站标题
  if (!_textName) {
    self.textName = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (self.onTitleReady) {
      self.onTitleReady(self.textName);
    }
  }

  NSLog(@"webViewDidFinishLoad: %@", [webView request].URL);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  [self endRefreshLoading];
  if (!mtvc_isViewWillCancell) {
    if (!self.dataBinded) {
      [self.littleCattleView isCry:YES];
    }
    [NewShowLabel showNoNetworkTip];
  }
  NSLog(@"webView didFailLoadWithError: %@, \\n%@", [webView request].URL, error);
}

#pragma mark
#pragma mark-------SimuIndicatorDelegate-----------
- (void)refreshButtonPressDown {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  if (self.beginRefreshCallBack) {
    self.beginRefreshCallBack();
  }
  if (_webView) {
    [self textUrl:self.textUrl];
  } else {
    [self creatWebView:self.textUrl];
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
  }
  return YES;
}

@end

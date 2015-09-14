//
//  StockInformationWebViewController.m
//  SimuStock
//
//  Created by moulin wang on 14-8-13.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "StockInformationWebViewController.h"
#import "MakingShareAction.h"
#import "NewShowLabel.h"

@implementation StockInformationWebViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  dataBinded = NO;

  [self creatTopToolBar:self.textName];
  [self creatShareView];
  //取得网络数据
  [self resetIndicatorView];
  [_indicatorView startAnimating];

  [self creatWebView:self.textUrl];
}

- (void)dealloc {
  [mpvc_webview stopLoading];
  mpvc_webview = nil;
}

//创建联网指示器和分享按钮
- (void)resetIndicatorView {
  if (_indicatorView) {
    _indicatorView.frame = CGRectMake(self.view.bounds.size.width - 80,
                                      _topToolBar.frame.size.height - 45,
                                      self.view.bounds.size.width - 280, 45);
    [_indicatorView setButonIsVisible:NO];
  }
}
//创建分享视图
- (void)creatShareView {
  UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  shareBtn.frame = CGRectMake(_topToolBar.bounds.size.width - 40,
                              _topToolBar.bounds.size.height - 45, 40, 45.0);
  shareBtn.backgroundColor = [UIColor clearColor];
  [shareBtn setImage:[UIImage imageNamed:@"分享.png"]
            forState:UIControlStateNormal];
  [shareBtn setBackgroundImage:[UIImage imageNamed:@"return_touch_down.png"]
                      forState:UIControlStateHighlighted];
  [shareBtn addTarget:self
                action:@selector(shareButtonTriggeringMethod:)
      forControlEvents:UIControlEventTouchUpInside];
  [_topToolBar addSubview:shareBtn];
}
- (void)shareButtonTriggeringMethod:(UIButton *)btn {
  [self logonSuccessShareUserInfo];
}
- (void)logonSuccessShareUserInfo {
  //已登录
  NSString *selfUserID = [SimuUtil getUserID];
  MakingShareAction *shareAction = [[MakingShareAction alloc] init];
  shareAction.shareModuleType = ShareModuleTypeStaticWap;
  shareAction.shareUserID = selfUserID;
  [shareAction shareTitle:_infoTitle
                  content:[NSString stringWithFormat:@"#优顾炒股#【%@】%@ "
                                                     @"(分享自@优顾炒股官方)",
                                                     _infoTitle, self.textUrl]
                    image:[UIImage imageNamed:@"shareIcon"]
           withOtherImage:nil
             withShareUrl:self.textUrl
            withOtherInfo:_infoTitle];
}

#pragma mark
#pragma mark 无网络

//创建捏指浏览器
- (void)creatWebView:(NSString *)loadUrl {
  mpvc_webview = [[UIWebView alloc]
      initWithFrame:CGRectMake(0, _topToolBar.bounds.size.height,
                               self.view.bounds.size.width,
                               self.view.bounds.size.height -
                                   (_topToolBar.bounds.size.height))];
  mpvc_webview.dataDetectorTypes = UIDataDetectorTypeNone;
  mpvc_webview.delegate = self;
  //滑动速率
  mpvc_webview.scrollView.decelerationRate = 1.0;
  mpvc_webview.opaque = NO;
  mpvc_webview.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  UIScrollView *scroller = mpvc_webview.subviews[0];
  if (scroller) {
    for (UIView *v in [scroller subviews]) {
      if ([v isKindOfClass:[UIImageView class]]) {
        [v removeFromSuperview];
      }
    }
  }
  [mpvc_webview setUserInteractionEnabled:YES];
  [self.view addSubview:mpvc_webview];
  
  ////添加UserAgent
  [SimuUtil WebViewUserAgent:mpvc_webview];

  [self loadUrlOnWebView:loadUrl];
}
#pragma mark
#pragma mark-----------对外接口-----------------------------------

- (void)loadUrlOnWebView:(NSString *)loadUrl {
  if (loadUrl == nil || [loadUrl length] == 0 || mpvc_webview == nil)
    return;
  NSURL *url = [NSURL URLWithString:loadUrl];
  NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
  [mpvc_webview loadRequest:request];
}

#pragma UIWebView 代理方法
- (void)webViewDidStartLoad:(UIWebView *)webView {
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
  dataBinded = YES;
  _littleCattleView.hidden = YES;
  [_indicatorView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  [_indicatorView stopAnimating];
  if (!dataBinded) {
    [_littleCattleView isCry:YES];
  }
  [NewShowLabel showNoNetworkTip];
}
#pragma mark
#pragma mark---------------创建常用控件-----------------------
//创建上方控件
- (void)creatTopToolBar:(NSString *)title {
  if (_topToolBar) {
    [_topToolBar resetContentAndFlage:title Mode:TTBM_Mode_Leveltwo];
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
  if (mpvc_webview) {
    [self loadUrlOnWebView:self.textUrl];
  } else {
    [self creatWebView:self.textUrl];
  }
}

#pragma mark
#pragma mark SimTopBannerViewDelegate

- (void)leftButtonPress {
  if (mpvc_webview && [mpvc_webview canGoBack]) {
    [mpvc_webview goBack];
  } else {
    [mpvc_webview stopLoading];
    [super leftButtonPress];
  }
}


@end

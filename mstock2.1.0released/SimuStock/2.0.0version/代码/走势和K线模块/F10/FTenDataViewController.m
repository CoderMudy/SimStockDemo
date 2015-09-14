//
//  FTenDataViewController.m
//  SimuStock
//
//  Created by moulin wang on 14-8-13.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "FTenDataViewController.h"
#import "NewShowLabel.h"
#import "YouguuSchema.h"
#import "StockUtil.h"
#import "TrendViewController.h"
#import "NSURL+QueryComponent.h"

#define briefUrl @"/CompanyProfiles.html"
#define financeUrl @"/CompanyFinancials.html"
#define shareholdersUrl @"/CompanyStockHolders.html"



/** 基金简况 */
static NSString * const fundF10Summary = @"/mobile/wap_found_f10/index.html?id=";

@implementation FTenDataViewController

- (void)_initStockCode:(NSString *)code
             titleName:(NSString *)titleName
                  type:(NSString *)type {
  self.codeStr = code;
  self.titleName = titleName;
  self.firstType = type;

  _isFund = [StockUtil isFund:type];
  markInt = 0;

  for (F10Page *page in pageStatus) {
    page.dataBinded = NO;
    page.noNetwork = NO;
  }
}

- (id)initCode:(NSString *)code
          name:(NSString *)titleName
    controller:(TrendViewController *)trendVC
     firstType:(NSString *)type {
  if (self = [super init]) {

    pageStatus = [[NSMutableArray alloc] init];
    for (int i = 0; i < 3; i++) {
      F10Page *page = [[F10Page alloc] init];
      [pageStatus addObject:page];
    }
    _trendVC = trendVC;

    [self _initStockCode:code titleName:titleName type:type];
  }
  return self;
}
- (void)dealloc {
  for (F10Page *page in pageStatus) {
    [page.webView stopLoading];
    page.webView = nil;
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    isvc_stateBarHeight = 20;
  } else {
    isvc_stateBarHeight = 0;
  }

  self.rect = self.view.bounds;

  [self createSegmentedButtonView];
  [self creatWebView];
  [self callLadIndicator:YES];
  //网络请求
  [self creatNetworkRequest:0];

  CGRect tempFrame = self.view.bounds;
  _littleCattleView = [[LittleCattleView alloc] initWithFrame:tempFrame
                                                  information:@"暂无数据"];
  [self.view addSubview:_littleCattleView];
  _littleCattleView.top -= 100;
}

//创建web对象
- (void)creatWebView {
  for (int i = 0; i < 3; i++) {
    F10Page *page = pageStatus[i];

    CGFloat originalYOfWebView = _isFund ? 0.0f : 38.5f;
    int height =
        self.rect.size.height - originalYOfWebView - 45 * 2 - 34.0 - isvc_stateBarHeight;



    UIWebView *webview = [[UIWebView alloc]
        initWithFrame:CGRectMake(0.0, originalYOfWebView, self.rect.size.width,
                                 height)];

    webview.delegate = self;
    //滑动速率
    webview.scrollView.decelerationRate = 1.0;
    webview.opaque = NO;
    webview.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
    UIScrollView *scroller = webview.subviews[0];
    if (scroller) {
      for (UIView *v in [scroller subviews]) {
        if ([v isKindOfClass:[UIImageView class]]) {
          [v removeFromSuperview];
        }
      }
    }
    [webview setUserInteractionEnabled:YES];
    webview.tag = 4600 + i;
    [self.view addSubview:webview];
    ////添加UserAgent
    [SimuUtil WebViewUserAgent:webview];

    page.webView = webview;

    webview.hidden = YES;
  }

  ((F10Page *)pageStatus[0]).webView.hidden = NO;
}
//分段按钮
- (void)createSegmentedButtonView {
  //边框
  UIView *borderView = [[UIView alloc]
      initWithFrame:CGRectMake(15.0, 13.0 / 2,
                               self.view.bounds.size.width - 30.0, 64.0 / 2)];
  borderView.backgroundColor = [Globle colorFromHexRGB:Color_Blue_but];
  [self.view addSubview:borderView];

  buttonView = [[UIView alloc]
      initWithFrame:CGRectMake(0.5, 0.5, borderView.bounds.size.width - 1.0,
                               31.0)];
  buttonView.backgroundColor = [UIColor whiteColor];
  [borderView addSubview:buttonView];
  
  //如果是基金则不显示基金F10下方三个栏目
  if (_isFund) {
    borderView.hidden = YES;
  }

  residentView = [[UIView alloc]
      initWithFrame:CGRectMake(0.0, 0.0,
                               (buttonView.bounds.size.width - 1.0) / 3,
                               buttonView.bounds.size.height)];
  residentView.backgroundColor = [Globle colorFromHexRGB:Color_Blue_but];
  [buttonView addSubview:residentView];

  NSArray *nameArr = @[ @"简况", @"财务", @"股东" ];
  for (int i = 0; i < [nameArr count]; i++) {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame =
        CGRectMake(i * (buttonView.bounds.size.width - 1.0) / 3 + i * 0.5, 0.0,
                   (buttonView.bounds.size.width - 1.0) / 3,
                   buttonView.bounds.size.height);
    btn.tag = 4500 + i;
    [btn setTitle:nameArr[i] forState:UIControlStateNormal];
    [btn setTitle:nameArr[i] forState:UIControlStateHighlighted];
    [btn setTitleColor:[Globle colorFromHexRGB:Color_Blue_but]
              forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:Font_Height_12_0];

    [btn setOnButtonPressedHandler:^{ [self buttonSwitchMethod:i]; }];
    [buttonView addSubview:btn];
    if (i != 0) {
      UIView *lineView = [[UIView alloc]
          initWithFrame:CGRectMake(i * (buttonView.bounds.size.width - 1.0) /
                                           3 +
                                       (i - 1) * 0.5,
                                   0.0, 0.5, buttonView.bounds.size.height)];
      lineView.backgroundColor = [Globle colorFromHexRGB:Color_Blue_but];
      [buttonView addSubview:lineView];
    } else {
      [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
  }
}

- (void)buttonSwitchMethod:(int)tabIndex {
  UIWebView *oldWebView = ((F10Page *)pageStatus[markInt]).webView;
  oldWebView.hidden = YES;
  oldWebView.delegate = self;

  markInt = tabIndex;
  [self buttonStatusUpdateTag:markInt];
  F10Page *page = pageStatus[markInt];
  UIWebView *newWebView = page.webView;
  newWebView.delegate = self;
  newWebView.hidden = NO;

  if (page.dataBinded) {
    _littleCattleView.hidden = YES;
    
    [self callLadIndicator:NO];
  } else if (page.noNetwork) {
    _littleCattleView.hidden = NO;
    [self callLadIndicator:NO];
  } else {
    _littleCattleView.hidden = YES;
    [self callLadIndicator:YES];
    [self creatNetworkRequest:markInt];
  }
  
}

//按钮状态更新
- (void)buttonStatusUpdateTag:(NSInteger)tabIndex {
  for (int i = 0; i < 3; i++) {
    UIButton *btn = (UIButton *)[buttonView viewWithTag:i + 4500];
    if (i == tabIndex) {
      [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      residentView.frame =
          CGRectMake(i * (buttonView.bounds.size.width - 1.0) / 3 + i * 0.5,
                     0.0, (buttonView.bounds.size.width - 1.0) / 3,
                     buttonView.bounds.size.height);
    } else {
      [btn setTitleColor:[Globle colorFromHexRGB:Color_Blue_but]
                forState:UIControlStateNormal];
    }
  }
}
#pragma mark
#pragma mark-----------对外接口-----------------------------------
- (void)creatNetworkRequest:(NSInteger)tabIndex {
  NSString *loadUrl = nil;
  if (0 == tabIndex) {
    if (_isFund) {
      loadUrl = [NSString
                 stringWithFormat:@"%@%@%@", wap_address, fundF10Summary, self.codeStr];
    } else {
      loadUrl = [NSString
                 stringWithFormat:@"%@%@%@", URL_address, self.codeStr, briefUrl];
    }
    
    NSLog(@"loadUrl:%@", loadUrl);
  } else if (1 == tabIndex) {
    loadUrl = [NSString
        stringWithFormat:@"%@%@%@", URL_address, self.codeStr, financeUrl];
  } else {
    loadUrl = [NSString
        stringWithFormat:@"%@%@%@", URL_address, self.codeStr, shareholdersUrl];
  }

  NSURLRequest *request =
      [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:loadUrl]];
  [((F10Page *)pageStatus[tabIndex]).webView loadRequest:request];
}

#pragma UIWebView 代理方法
- (void)webViewDidStartLoad:(UIWebView *)webView {
  [self callLadIndicator:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
  [self callLadIndicator:NO];
  _littleCattleView.hidden = YES;
  for (F10Page *page in pageStatus) {
    if (page.webView == webView) {
      page.dataBinded = YES;
      page.noNetwork = NO;
      break;
    }
  }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  for (int i = 0; i < [pageStatus count]; i++) {
    F10Page *page = pageStatus[i];
    if (page.webView == webView) {
      if (i == markInt) {
        [_littleCattleView isCry:YES];
        [NewShowLabel showNoNetworkTip];
        [self callLadIndicator:NO];
      }
      page.dataBinded = NO;
      page.noNetwork = YES;
      break;
    }
  }
}

#pragma mark webview每次加载之前都会调用这个方法
// 如果返回NO，代表不允许加载这个请求
- (BOOL)webView:(UIWebView *)webView
    shouldStartLoadWithRequest:(NSURLRequest *)request
                navigationType:(UIWebViewNavigationType)navigationType {

  // 说明协议头是ios
  if ([@"youguu" isEqualToString:request.URL.scheme]) {
    //如果加载web页成功 确没有数据 显示无数据小牛
    NSString *host = [request.URL host];
    NSDictionary *dict = [request.URL queryComponents];
    if ([host isEqualToString:@"error_show_tip"]) {
      if (dict.count == 0) {
        [_littleCattleView isNOData:@"暂无数据"];
        webView.hidden = YES;
        return NO;
      }
    }
    //跳转页面
    [YouguuSchema handleYouguuUrl:request.URL];
    return NO;
  }
  return YES;
}

#pragma mark----------------------------回拉效果---------------------

- (void)FTenRefresh {
  [self callLadIndicator:YES];
  if (![SimuUtil isExistNetwork]) {
    [self callLadIndicator:NO];
    [NewShowLabel showNoNetworkTip];
    return;
  }else{
    _littleCattleView.hidden = YES;
  }
  
  [self creatNetworkRequest:markInt];
}
//调用加载圈
- (void)callLadIndicator:(BOOL)refresh {
  [_trendVC refreshData:refresh];
}
//调用加载圈
- (void)interfaceSwitchingTriggerLoadIndicator {
  [self callLadIndicator:YES];
}
//页面切换刷新数据
- (void)resetStockCode:(NSString *)code name:(NSString *)titleName firstType:(NSString *)type {

  if (self.codeStr && [self.codeStr isEqualToString:code]) {
    return;
  }
  
  [self _initStockCode:code titleName:titleName type:type];

  NSLog(@"self.view.bounds.size.height455:%f", self.view.bounds.size.height);
  if (pageStatus) {
    for (F10Page *page in pageStatus) {
      [page.webView removeFromSuperview];
      page.webView.delegate = nil;
      page.webView = nil;
      [page reset];
    }

    [self statusResetWebView];
    [self creatWebView];
  }
  [self buttonStatusUpdateTag:0];
  _littleCattleView.hidden = YES;
  [self callLadIndicator:YES];
  //网络请求
  [self creatNetworkRequest:0];
}
//移除视图
- (void)statusResetWebView {
  for (int i = 0; i < 3; i++) {
    [[self.view viewWithTag:4600 + i] removeFromSuperview];
    NSLog(@"self.view.bounds.size.height:%f", self.view.bounds.size.height);
  }
}
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end

@implementation F10Page

- (void)reset {
  self.dataBinded = NO;
  self.webView = nil;
  self.noNetwork = NO;
}

@end

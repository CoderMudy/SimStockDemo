//
//  SchollWebViewController.h
//  SimuStock
//
//  Created by moulin wang on 14-4-21.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimTopBannerView.h"
#import "SimuUtil.h"
#import "SimuIndicatorView.h"
#import "NSStringCategory.h"
#import "BaseViewController.h"
#import "BrokerNameListTableView.h"

@interface SchollWebViewController : BaseViewController <UIWebViewDelegate, UIAlertViewDelegate> {
  ///内置浏览器
  UIWebView *_webView;

  ///是否点击了页面消失按钮
  BOOL mtvc_isViewWillCancell;

  ///用于判断网络
  BOOL networkBool;
}

///文本名称
@property(nonatomic, strong) NSString *textName;
@property(nonatomic, strong) NSString *contentBroketName;
///文本链接
@property(nonatomic, strong) NSString *textUrl;

/** 高校比赛ID */
@property(nonatomic, strong) NSString *matchType;

/** 从实盘过来的 实盘交易 */
@property(nonatomic, assign) BOOL brokerAccountLogonBool;
/** 判断退出 */
@property(nonatomic, assign) BOOL pressButtonBool;

@property(assign, nonatomic) BrokerOpenLogin brokerOpenLogin;

- (id)initWithNameTitle:(NSString *)title andPath:(NSString *)path;
/** 启动网页显示页面 */
+ (void)startWithTitle:(NSString *)title withUrl:(NSString *)url;

/** 启动网页 实盘界面的 */
+ (void)startWithTitle:(NSString *)title
               withUrl:(NSString *)url
   withBrokerLogonBool:(BOOL)logonBool
        withBrokerType:(BrokerOpenLogin)openLogin;

/**
 *  高校比赛 报名web端
 *
 *  @param title     标题
 *  @param url       url
 *  @param matchType 比赛类型
 */
+ (void)startWithTitle:(NSString *)title
               withUrl:(NSString *)url
         withMatchType:(NSString *)matchType;

@end

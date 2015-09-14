//
//  BaseWebViewController.h
//  SimuStock
//
//  Created by Mac on 15/5/25.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseNoTitleViewController.h"
#import "SimuUtil.h"
#import "NSStringCategory.h"

///当能过获取网页的title时，传递的回调函数
typedef void (^OnTitleReadyAction)(NSString *title);

@interface BaseWebViewController
    : BaseNoTitleViewController <UIWebViewDelegate> {

  ///内置浏览器
  UIWebView *_webView;

  ///是否点击了页面消失按钮
  BOOL mtvc_isViewWillCancell;
}

///文本名称
@property(nonatomic, strong) NSString *textName;

///文本链接
@property(nonatomic, strong) NSString *textUrl;

///数据是否绑定
@property(nonatomic, assign) BOOL dataBinded;

/** 开始加载，通知父容器*/
@property(copy, nonatomic) CallBackAction beginRefreshCallBack;

/** 结束加载，通知父容器*/
@property(copy, nonatomic) CallBackAction endRefreshCallBack;

/** 当能过获取网页的title时，通知父容器*/
@property(copy, nonatomic) OnTitleReadyAction onTitleReady;

- (id)initWithFrame:(CGRect)frame
      withNameTitle:(NSString *)title
            andPath:(NSString *)path;

- (void)refreshButtonPressDown;

@end

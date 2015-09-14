//
//  StockInformationWebViewController.h
//  SimuStock
//
//  Created by moulin wang on 14-8-13.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimTopBannerView.h"
#import "SimuUtil.h"
#import "SimuIndicatorView.h"
#import "NSStringCategory.h"

@interface StockInformationWebViewController
    : BaseViewController <UIWebViewDelegate> {
  ///内置浏览器
  UIWebView *mpvc_webview;
  
  ///是否已经数据绑定
  BOOL dataBinded;
}
///文本名称
@property(nonatomic, strong) NSString *textName;
///文本链接
@property(nonatomic, strong) NSString *textUrl;
@property(copy, nonatomic) NSString *infoTitle;

@end

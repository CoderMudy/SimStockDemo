//
//  FTenDataViewController.h
//  SimuStock
//
//  Created by moulin wang on 14-8-13.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimuUtil.h"
#import "NSStringCategory.h"
#import "DataArray.h"



@interface F10Page : NSObject

@property(nonatomic, assign) BOOL dataBinded;

@property(nonatomic, strong) UIWebView *webView;

@property(nonatomic, assign) BOOL noNetwork;

- (void)reset;

@end

@class TrendViewController;

@interface FTenDataViewController : UIViewController <UIWebViewDelegate> {

  //按钮视图
  UIView *buttonView;
  //按钮驻留态
  UIView *residentView;

  //  UIWebView *ftvc_webview;
  //  NSMutableArray *groupArray;

  NSMutableArray *pageStatus;
  // ios 适配高度
  float isvc_stateBarHeight;

  LittleCattleView *_littleCattleView;

  //标记页面
  NSInteger markInt;
  
  ///是否是基金
  BOOL _isFund;
}

@property(nonatomic, strong) NSString *codeStr;
@property(nonatomic, strong) NSString *titleName;
/** 股票类型，见StockUtil.h类型定义 */
@property(nonatomic,strong)NSString *firstType;
@property(nonatomic, weak) TrendViewController *trendVC;
@property(nonatomic, assign) CGRect rect;
- (id)initCode:(NSString *)code
          name:(NSString *)titleName
    controller:(TrendViewController *)trendVC
     firstType:(NSString *)type;
- (void)resetStockCode:(NSString *)code name:(NSString *)titleName firstType:(NSString *)type;
- (void)FTenRefresh;
/**界面切换触发加载指示器*/
- (void)interfaceSwitchingTriggerLoadIndicator;
@end

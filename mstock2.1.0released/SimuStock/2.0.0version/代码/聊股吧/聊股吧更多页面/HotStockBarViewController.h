//
//  HotStockBarViewController.h
//  SimuStock
//
//  Created by Yuemeng on 14/12/23.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "MJRefresh.h"
#import "DataArray.h"

/** 为聊股首页发表返回barID */
typedef void (^returnBarIDBlock)(NSNumber *barID, NSString *barName);

typedef NS_ENUM(NSUInteger, HotStockBarViewStyle) {
  DefaultStyle,    //显示详情页
  ReturnBarIDStyle //为聊股主页发表返回barID
};

/** 主题吧、牛人吧更多页面 */
@interface HotStockBarViewController
    : BaseViewController <UITableViewDataSource, UITableViewDelegate,
                          MJRefreshBaseViewDelegate> {
  UITableView *_tableView;
  DataArray *_hotStockBarList;
  MJRefreshHeaderView *_headerView;
  MJRefreshFooterView *_footerView;
  BOOL _isLoadMore;
  HotStockBarViewStyle _style;

  /** 为主页发表返回barID */
  returnBarIDBlock _returnBarIDBlock;
  /** 请求类型，0主题吧，1牛人吧 */
  NSInteger _type;
}


/** 请求类型，0主题吧，1牛人吧 */
- (id)initWithType:(NSInteger)type;

/** 为聊股首页发表返回barID的专用初始化方法 */
- (id)initWithReturnBarIDCallBack:(returnBarIDBlock)callback;

@end

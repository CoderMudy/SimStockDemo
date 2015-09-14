//
//  WeiboListViewController.h
//  SimuStock
//
//  Created by Mac on 15/4/19.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseNoTitleViewController.h"
#import "MJRefresh.h"
#import "DataArray.h"
#import "TweetListItem.h"
#import "Globle.h"

/** 请求聊股列表回调 */
typedef void (^RequestWeiboListCallBack)(NSNumber *fromId, NSInteger reqnum,
                                         HttpRequestCallBack *callback);

/** 聊股列表开始绑定，通知父容器 */
typedef void (^PreWeiboListBindingAction)(TweetList *tweetList);

@interface WeiboListViewController
    : BaseNoTitleViewController <UITableViewDataSource, UITableViewDelegate,
                                 MJRefreshBaseViewDelegate> {
  /** 下拉刷新控件 */
  MJRefreshHeaderView *_headerView;
  /** 上拉加载更多控件 */
  MJRefreshFooterView *_footerView;

  /** 页面加载更多标记 */
  BOOL _isLoadMore;

  NSString *_containerTitle;
}

/** 是否显示收藏的聊股，对于收藏页面，不显示 */
@property(assign, nonatomic) BOOL showFavorite;

/** 通常起始id = 0，热门页面起始id = -1 */
@property(strong, nonatomic) NSNumber *fromId;

/** 聊股数据 */
@property(strong, nonatomic) DataArray *dataList;

/** 显示数据的表格*/
@property(strong, nonatomic) UITableView *tableView;

/** 开始加载，通知父容器*/
@property(copy, nonatomic) CallBackAction beginRefreshCallBack;

/** 结束加载，通知父容器*/
@property(copy, nonatomic) CallBackAction endRefreshCallBack;

/** 聊股列表开始绑定，通知父容器 */
@property(copy, nonatomic)
    PreWeiboListBindingAction preWeiboListBindingCallBack;

/** 加载微博列表的回调 */
@property(copy, nonatomic) RequestWeiboListCallBack requestWeiboListCallBack;

/** 初始化 */
- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)parentContainerTitle;

/** 刷新数据，供父容器调用*/
- (void)refreshButtonPressDown;

/** 发布聊股，供父容器调用*/
- (void)publishWeibo;

/** 绑定数据列表 */
- (void)bindTweetList:(TweetList *)tweetList withFromId:(NSNumber *)fromId;

@end

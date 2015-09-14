//
//  MasterRankingViewController.h
//  SimuStock
//
//  Created by jhss on 13-11-29.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "SimTopBannerView.h"

#import "MyAttentionInfo.h"
#import "MyAttentionInfoItem.h"
#import "FollowFriendResult.h"
#import "Warning_boxes.h"

#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "SimuIndicatorView.h"
#import "JhssImageCache.h"
#import "DataArray.h"

typedef enum {
  ShareTypeWithTalkStockContentPage = 0,
  ShareTypeWithTradePage,
  ShareTypeWithCreateMatch,
  ShareTypeWithMatchRank,
  ShareTypeWithNews,
  ShareTypeWithHomePage,
  ShareTypeWithMatch,
  ShareTypeWithTrade,
  ShareTypeWithMarket,
} StockShareType;

/** 排行榜通用列表页 */
@interface MasterRankingViewController
    : BaseViewController <UITableViewDataSource, UITableViewDelegate,
                          MJRefreshBaseViewDelegate> {
  //表格
  UITableView *_masterRankingTableView;

  MJRefreshFooterView *_footerView;

  /** 下拉刷新控件 */
  MJRefreshHeaderView *_headerView;
  BOOL _isLoadMore;

  //表格数据
  DataArray *dataArray;

  //是否显示了自己的排名
  BOOL selfInRank;

  NSString *tempOpenRow;
  BOOL isOpenRow;
  //选中的行
  NSInteger tempSelectRow;

  //记录加载行数
  NSString *tempRow;
  //我的关注部分
  NSMutableArray *myAttentionsArray;
  // request成功
  BOOL isRequestSuccess;

  //记录cell位置
  NSIndexPath *previousIndexPath;

  //无数据底图
  UIView *noDataFootView;
  //表格头、尾视图
  UIView *footView;
  //动画类型
  NSString *animationType;

  //记录点击的按钮位置
  NSInteger indicatorIndex;
}
@property(assign, nonatomic) NSInteger stepNumber; // cell的步进值
@property(copy, nonatomic) NSString *rankingTitle;
@property(copy, nonatomic) NSString *rankingSortNumber;
@property(copy, nonatomic) NSString *rankingSortName;

@end

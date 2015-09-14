//
//  StockBarDetailViewController.h
//  SimuStock
//
//  Created by Yuemeng on 14-11-28.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "TopToolBarView.h"
#import "DataArray.h"

@class EliteChatStockTableVC;
@class AllChatStockTableVC;
@class StockBarDetailHeaderView;

/** 返回时更新聊股数 */
typedef void (^updateBarTStock)(NSNumber *barid, BOOL isAdd);

/** 股吧详情页 */
@interface StockBarDetailViewController
    : BaseViewController <TopToolBarViewDelegate, UIScrollViewDelegate> {
  /** 全部 精华 切换按钮 */
  TopToolBarView *_topToolBarView;

  /** 发表按钮 */
  UIButton *_publishButton;

  /** 当前页 */
  BOOL _currentPage;

  /** 两个表格的承载滑动视图 */
  UIScrollView *_scrollView;

  /** 股吧信息头 */
  StockBarDetailHeaderView *_barInfoHeaderView;
}

/** 标题 */
@property(nonatomic, strong) NSString *barTitle;
/** 吧ID */
@property(nonatomic, strong) NSNumber *barId;
/** 是否已关注本吧 */
@property(nonatomic) BOOL isFollowed;
/** 实时更新热门聊股更多页面聊股数 */
@property(nonatomic, copy) updateBarTStock updateBarTStock;

/** “全部”表格 */
@property(nonatomic, strong) AllChatStockTableVC *allChatTableVC;

/** “精华”表格 */
@property(nonatomic, strong) EliteChatStockTableVC *eliteTableVC;

@end

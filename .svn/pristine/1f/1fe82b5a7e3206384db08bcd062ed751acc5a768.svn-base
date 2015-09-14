//
//  HotStockTopicViewController.h
//  SimuStock
//
//  Created by Yuemeng on 14/12/23.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "MJRefresh.h"
#import "DataArray.h"

/** 热门个股吧更多页面 */
@interface HotStockTopicViewController
    : BaseViewController <UITableViewDelegate, UITableViewDataSource,
                          MJRefreshBaseViewDelegate> {
  UITableView *_tableView;
  DataArray *_hotStockTopicList;
  MJRefreshHeaderView *_headerView;
  MJRefreshFooterView *_footerView;
  BOOL _isLoadMore;
}

@end

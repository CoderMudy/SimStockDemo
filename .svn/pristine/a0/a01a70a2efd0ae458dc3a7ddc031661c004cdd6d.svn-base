//
//  HotRecommendStockViewController.h
//  SimuStock
//
//  Created by Yuemeng on 14/12/23.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "MJRefresh.h"
#import "DataArray.h"

/** 🈲热门推荐(已改到主页第三栏显示，目前已废) */
@interface HotRecommendStockViewController
    : BaseViewController <UITableViewDataSource, UITableViewDelegate,
                          MJRefreshBaseViewDelegate> {
  UITableView *_tableView;
  DataArray *_hotStockBarList;
  MJRefreshHeaderView *_headerView;
  MJRefreshFooterView *_footerView;
  BOOL _isLoadMore;
}

@end

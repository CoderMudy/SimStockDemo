//
//  MyFollowListViewController.h
//  SimuStock
//
//  Created by Yuemeng on 14/12/22.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "DataArray.h"
#import "MJRefresh.h"
#import "UserACLData.h"

/** 🈲聊股吧-我的动态（已转到主页显示，已废） */
@interface MyFollowListViewController
    : BaseViewController <MJRefreshBaseViewDelegate, UITableViewDataSource,
                          UITableViewDelegate> {
  /** 表格 */
  UITableView *_tableView;
  /** 关注数据数组 */
  DataArray *_myFollowList;
  /** MJ表头*/
  MJRefreshHeaderView *_headerView;
  /** MJ表尾 */
  MJRefreshFooterView *_footerView;
  BOOL _isLoadMore;
}

@end

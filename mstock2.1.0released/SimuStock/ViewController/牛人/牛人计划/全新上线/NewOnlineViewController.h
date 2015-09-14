//
//  NewOnlineViewController.h
//  SimuStock
//
//  Created by Jhss on 15/7/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseTableViewController.h"

//控制器类
@interface NewOnlineTableAdapter : BaseTableAdapter

@end

@interface NewOnlineViewController : BaseTableViewController

/** 下拉刷新时，通知父容器*/
@property(copy, nonatomic) CallBackAction headerRefreshCallBack;

@end

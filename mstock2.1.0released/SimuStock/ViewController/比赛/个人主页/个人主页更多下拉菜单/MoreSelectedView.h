//
//  MoreSelectedView.h
//  SimuStock
//
//  Created by jhss on 15/6/29.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^sharePressCallBack)();
typedef void (^pushToSuperPlanVCCallBack)();
@interface MoreSelectedView
    : UIView <UITableViewDataSource, UITableViewDelegate>
@property(weak, nonatomic) IBOutlet UITableView *moreSelectedTableView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *cellHeight;
@property(copy, nonatomic) sharePressCallBack sharePressCallBack;
@property(copy, nonatomic) pushToSuperPlanVCCallBack pushToSuperPlanVCCallBack;
/** 是够购买牛人计划 */
@property(assign, nonatomic) BOOL isBuyMasterPlan;
@property(strong, nonatomic) NSMutableArray *moreselectedArr;
- (void)reloadTableViewWithQuerySelfStockData:(BOOL)isMasterPlan;
@end

//
//  MyTranceNewViewController.h
//  SimuStock
//
//  Created by Yuemeng on 15/7/20.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTableViewController.h"
#import "MasterPurchesViewController.h"

@class NoTrancingView;
@class MyTranceTableHeaderView;
@class TrancingTableViewController;
@class TraceItem;

/*
 *
 */
@interface TrancingTableAdapter : BaseTableAdapter

//区分是我的追踪还是他的追踪，用来隐藏cell的取消追踪按钮
@property(nonatomic) BOOL isMyTrance;
@property(nonatomic, weak) TrancingTableViewController *superTableVC;

@end

/*
 *
 */
@interface TrancingTableViewController : BaseTableViewController {
  NSString *_seqID;
}

//区分是我的追踪还是他的追踪，用来隐藏cell的取消追踪按钮
@property(nonatomic) BOOL isMyTrance;
@property(copy, nonatomic) NSString *userID;

- (void)deleteItemAndReloadTable:(TraceItem *)item;

@end

/*
 *  我的追踪、Ta的追踪
 */
@interface TrancingViewController
    : BaseViewController <refreshMyTrancingViewDelegate> {
  NoTrancingView *_noTranceView;
  MyTranceTableHeaderView *_headerView;
  TrancingTableViewController *_tableVC;
  //接收观察者
  id _receiveObser;
  //区分是我的追踪还是他的追踪
  BOOL _isMyTrance;
  //我的追踪期限表头高度
  CGFloat _headViewHeight;
}

/** ⭐️必传参数，用于区分是我的追踪还是Ta的追踪 */
@property(copy, nonatomic) NSString *userID;

@end

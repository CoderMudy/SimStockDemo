//
//  FeedBackViewController.h
//  Settings
//
//  Created by jhss on 13-9-10.
//  Copyright (c) 2013年 jhss. All rights reserved.
//

#import "BaseViewController.h"
#import "SimTopBannerView.h"
#import "MyFeedBackViewController.h"
#import "SimuIndicatorView.h"
#import "SimuIndicatorView.h"
#import "CommonFunc.h"
#import "NewShowLabel.h"
#import "DataArray.h"

@interface FeedBackViewController
    : BaseViewController <UITableViewDataSource, UITableViewDelegate> {
  /** 反馈表格 */
  UITableView *_feedbackTableView;
  /** 反馈数据 */
  DataArray *dataArray;
  /** 需显示的用户数据 */
  NSMutableArray *visibleArray;
  /** 单条信息时间数据存储 */
  NSArray *dateArray;
  /** 伪下拉刷新 */
  BOOL reloading;
  /** 是否有第一个客服信息 */
  BOOL firstRow;
}
/** 反馈列表 */
@property(strong, nonatomic) UITableView *feedbackTableView;

@end

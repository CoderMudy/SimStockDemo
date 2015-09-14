//
//  StockInformationViewController.h
//  SimuStock
//
//  Created by moulin wang on 14-8-12.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJRefresh.h"
#import "SimuIndicatorView.h"
#import "LittleCattleView.h"
#import "DataArray.h"

@interface SubPageStatus : NSObject

// tableView的Y方向偏移量
@property(nonatomic, assign) int tableViewOffsetY;

//数据部分
@property(nonatomic, strong) DataArray *dataArray;

@property(nonatomic, assign) BOOL isLoadMore;

@end

@class TrendViewController;

/**股票行情 资讯*/
@interface StockInformationViewController
    : UIViewController <UITableViewDataSource, UITableViewDelegate,
                        MJRefreshBaseViewDelegate, SimuIndicatorDelegate> {

  //没有数据
  UIView *noDataFootView;
  //边框
  UIView *borderView;
  //按钮视图
  UIView *buttonView;
  //按钮驻留态
  UIView *residentView;
  //表格
  UITableView *newstableView;

  MJRefreshHeaderView *headerView;

  NSArray *pageNames;
  NSMutableArray *pageStatus;
  // ios 适配高度
  float isvc_stateBarHeight;

  LittleCattleView *_littleCattleView;
}

@property(nonatomic, assign) NSInteger markInt;

@property(nonatomic, strong) NSString *codeStr;
@property(nonatomic, strong) NSString *titleName;
@property(nonatomic, strong) NSString *firstType;
@property(nonatomic, weak) TrendViewController *trendVC;
- (id)initWithCode:(NSString *)code
              name:(NSString *)titleName
        controller:(TrendViewController *)trendVC
         firstType:(NSString *)type;
- (void)stockInformationCode:(NSString *)code
                        name:(NSString *)titleName
                   firstType:(NSString *)type;
- (void)refresh;
/**界面切换触发加载指示器*/
- (void)interfaceSwitchingTriggerLoadIndicator;

//清楚tableview数据
- (void)clearTableViewData;
@end

//
//  StockTradeListViewController.h
//  SimuStock
//
//  Created by Mac on 15/4/23.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseNoTitleViewController.h"

#import "SimuUtil.h"
#import "AppDelegate.h"
#import "NetLoadingWaitView.h"
#import "SimuIndicatorView.h"
#import "CommonFunc.h"
#import "MJRefresh.h"

#import "Globle.h"
#import "BaseViewController.h"

#import "MakingScreenShot.h"
#import "MakingShareAction.h"
#import "simuBuyViewController.h"
#import "simuSellViewController.h"
#import "DataArray.h"

#import "TopToolBarView.h"
#import "HomeTradeDeatilTableViewCell.h"

#import "SimuClosedDetailPageData.h"
#import "BaseTableViewController.h"

@class UserListItem;

@interface StockTradeAdaper : BaseTableAdapter <HomeTradeDeatilTableViewCellDelegate> {

  //图片截取成功，做分享
  MakingShareAction *shareAction;
  //分享图片
  UIImage *shareImage;
  /** 显示表格 */
  UITableView *milliontableView;
  //对某一行的操作
  NSInteger tempRow;

  NSInteger selectedIndex;

  NSIndexPath *cellRow;
}

@property(nonatomic, strong) NSString *userName;
@property(nonatomic, copy) NSString *matchId;
@property(nonatomic, assign) BOOL showButtons;
@property(nonatomic, assign) int height;

@end

@interface StockTradeTableViewController : BaseTableViewController
@property(nonatomic, strong) NSString *stockCode;
@property(nonatomic, strong) NSString *userId;
@property(nonatomic, strong) NSString *userName;
@property(nonatomic, copy) NSString *matchId;
- (id)initWithFrame:(CGRect)frame
         withUserId:(NSString *)userid
       withUserName:(NSString *)userName
        withMatckId:(NSString *)matchId;

@end

@interface StockTradeListViewController : BaseNoTitleViewController {

  StockTradeTableViewController *stockTradeTableVC;
  /** 显示表格 */
  UITableView *milliontableView;
  /** 上拉刷新 */
  MJRefreshFooterView *footerView;
  /** 下拉刷新 */
  MJRefreshHeaderView *headerView;
  /** 数据 */
  DataArray *dataArray;
  //没有数据
  UIView *noDataFootView;
  //图片截取成功，做分享
  MakingShareAction *shareAction;
  //对某一行的操作
  NSInteger tempRow;
  //暂无更多数据按钮
  UIButton *noDataFootButton;
}

/** 开始加载，通知父容器*/
@property(copy, nonatomic) CallBackAction beginRefreshCallBack;

/** 结束加载，通知父容器*/
@property(copy, nonatomic) CallBackAction endRefreshCallBack;

@property(nonatomic, strong) NSString *userId;
@property(nonatomic, strong) NSString *userName;
@property(nonatomic, copy) NSString *matchId;
@property(nonatomic, strong) NSString *stockCode;

- (id)initWithFrame:(CGRect)frame
         withUserId:(NSString *)userid
      withStockCode:(NSString *)stockCode
       withUserName:(NSString *)userName
        withMatckId:(NSString *)matchId;

/** 刷新数据，供父容器调用*/
- (void)refreshButtonPressDown;

/** 数据是否已经绑定，供父容器调用*/
//- (BOOL)dataBinded;

@end

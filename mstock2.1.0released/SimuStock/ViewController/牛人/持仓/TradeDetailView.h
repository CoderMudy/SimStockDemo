//
//  TradeDetailView.h
//  SimuStock
//
//  Created by moulin wang on 14-2-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SimuClosedDetailPageData.h"
#import "SimuIndicatorView.h"
#import "TrendViewController.h"
#import "SimuUtil.h"

#import "TradeDetailNewCell.h"

#import "MJRefreshFooterView.h"
#import "SimuPositionPageData.h"
#import "DataArray.h"
#import "SimuRankPositionPageData.h"
#import "SimuRankClosedPositionPageData.h"

@interface TradeDetailAdaper : BaseTableAdapter

/**  股票名称*/
@property(nonatomic, strong) NSString *name;
/** 股票id*/
@property(nonatomic, strong) NSString *macthId;
/**  股票编号*/
@property(nonatomic, strong) NSString *stockCode;

//是否可卖
@property(assign, nonatomic) BOOL canSell;
@property(assign, nonatomic) BOOL showButtons;

@property(nonatomic, assign) NSInteger height;

@end

@interface TradeDetailTableViewController : BaseTableViewController
/**  用户id*/
@property(nonatomic, strong) NSString *userId;
@property(nonatomic, strong) NSString *positionId;
/**  股票id*/
@property(nonatomic, strong) NSString *matchId;
@property(nonatomic) BOOL isPosition;
/**  股票标号*/
@property(copy, nonatomic) NSString *stockCode;
/**  股票名称*/
@property(copy, nonatomic) NSString *stockName;
//是否可卖
@property(assign, nonatomic) BOOL isCansell;

- (id)initWithFrame:(CGRect)frame
         withUserId:(NSString *)userId
     withPositionId:(NSString *)positionId
        withMatchId:(NSString *)matchId
      withStockCode:(NSString *)stockCode
      withStockName:(NSString *)stockName
     withIsPosition:(BOOL)isPosition
      withIsCanSell:(BOOL)canSell;

@end

@interface TradeDetailView : BaseViewController {
  NSInteger detailPageNum;
  UITableView *_tableView;
  //尾部刷新控件
  MJRefreshFooterView *_RefreshFootView;
  DataArray *dataArray;
  TradeDetailTableViewController *tradeDeailTableVC;
  BOOL isLoadMore;
}

@property(copy, nonatomic) NSString *uid;
@property(copy, nonatomic) NSString *matchId;
@property(nonatomic) BOOL isPosition;
//是否可卖
@property(assign, nonatomic) BOOL isCansell;

- (id)initWithUserId:(NSString *)uid
         withMatchId:(NSString *)matchId
    withPositionInfo:(PositionInfo *)positionInfo;

- (id)initWithUserId:(NSString *)uid
               withMatchId:(NSString *)matchId
    withClosedPositionInfo:(ClosedPositionInfo *)closedPositionInfo;

@end

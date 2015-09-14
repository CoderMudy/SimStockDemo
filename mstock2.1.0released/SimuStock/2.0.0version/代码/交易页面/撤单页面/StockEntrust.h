//
//  StockEntrust.h
//  SimuStock
//
//  Created by Mac on 14-10-15.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimuTableView.h"
#import "SimuTableDataResouce.h"
#import "DataArray.h"


#import "DetailViewController.h"

@protocol EntrustItem <NSObject>

/** 委托号 */
- (NSString *)commissionId;

/** 订单状态 */
- (NSString *)status;

/** 证券代码str */
- (NSString *)stockCode;

/** 证券名称str */
- (NSString *)stockName;

/** 委托价格 */
- (NSString *)price;

/** 委托数量str */
- (NSString *)amountString;

/** 委托日期 */
- (NSString *)dateString;

/** 委托时间 */
- (NSString *)timeString;

/** 操作 */
- (NSString *)type;

/** 是否可以选中 */
- (BOOL)canSelected;
@optional
/** 操作类型 市价 限价 止盈 止损 */
- (NSString *)catagoryMarketFiexd;

@end

/**
 撤单页面View
 */
@interface StockEntrustViewHolder : NSObject

/** 表格视图 */
@property(nonatomic, strong) SimuTableView *tableView;

/** 表格数据 */
@property(nonatomic, strong) SimuTableDataResouce *dataSource;
@property(nonatomic,strong)DetailViewController *detailDataSource;




/** 今日委托数据 */
@property(nonatomic, strong) DataArray *dataArray;


/** 使用ViewController中的rootView初始化视图容器 */
- (instancetype)initWithRootView:(UIView *)rootView;

/** 数据绑定 */
- (void)bindEntrustList:(NSMutableArray *)entrustList;

/** 得到选中的委托列表 */
- (NSString *)getSelectedEntrustIDs;

@end

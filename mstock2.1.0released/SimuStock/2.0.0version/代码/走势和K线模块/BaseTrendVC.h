//
//  BaseTrendVC.h
//  SimuStock
//
//  Created by Mac on 15/6/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataArray.h"
#import "Globle.h"
#import "BaseRequester.h"
#import "BaseTableViewController.h"
#import "StockUtil.h"

@interface BaseTrendVC : BaseNoTitleViewController

/** 表格数据，用于数据绑定和小牛判断 */
@property(strong, nonatomic) DataArray *dataArray;

///证券信息
@property(nonatomic, strong) SecuritiesInfo *securitiesInfo;

/** 开始加载，通知父容器*/
@property(copy, nonatomic) CallBackAction beginRefreshCallBack;

/** 结束加载，通知父容器*/
@property(copy, nonatomic) CallBackAction endRefreshCallBack;

/** 数据绑定完毕，通知父容器*/
@property(copy, nonatomic) CallBackAction onDataReadyCallBack;

/** 初始化方法，可指定显示位置和证券信息*/
- (id)initWithFrame:(CGRect)frame
 withSecuritiesInfo:(SecuritiesInfo *)securitiesInfo;

/** 重新设置证券信息 */
- (void)resetWithFrame:(CGRect)frame
    withSecuritiesInfo:(SecuritiesInfo *)securitiesInfo;

/** 请求最新数据，此方法子类必须实现 */
- (void)requestDataListWithRefreshType:(RefreshType)refreshType
                         withDataArray:(DataArray *)existDataList
                          withCallBack:(HttpRequestCallBack *)callback;

/** 获取请求参数 */
- (NSDictionary *)getRequestParamertsWithRefreshType:(RefreshType)refreshType;

- (void)refreshView;

- (void)clearView;

- (BOOL)dataBinded;

///刷新或者加载下一页数据
- (void)requestResponseWithRefreshType:(RefreshType)refreshType;

- (void)startRefreshLoading;

- (void)endRefreshLoading;

- (void)setNoNetWork;

- (void)bindRequestObject:(NSObject<Collectionable> *)latestData
    withRequestParameters:(NSDictionary *)parameters
          withRefreshType:(RefreshType)refreshType;

@end

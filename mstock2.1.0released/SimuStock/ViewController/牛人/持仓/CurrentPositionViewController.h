//
//  CurrentPositionViewController.h
//  SimuStock
//
//  Created by Mac on 15/4/17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseTableViewController.h"
#import "DataArray.h"
#import "Globle.h"
#import "SimuRankPositionPageData.h"

/** 持仓信息加载完成后，通知父容器 */
typedef void (^PositionReadyCallBack)(SimuRankPositionPageData *positionData);

@interface StockPositionAdapter : BaseTableAdapter

@property(strong, nonatomic) NSString *userID;
@property(strong, nonatomic) NSString *matchID;

/** 持仓选择表格记录 */
@property(assign, nonatomic) NSInteger selectedRowIndex;

@property(strong, nonatomic) SimuRankPositionPageData *currentPositionInfo;

@end

/** 持仓股票列表数据 */
@interface CurrentPositionViewController : BaseTableViewController {
  StockPositionAdapter *_stockPositionAdapter;
}

@property(strong, nonatomic) NSString *userID;
@property(strong, nonatomic) NSString *matchID;

/** 持仓信息加载完成后，通知父容器 */
@property(copy, nonatomic) PositionReadyCallBack positionReadyCallBack;

/** 持仓数据模型 */
@property(strong, nonatomic) SimuRankPositionPageData *currentPositionInfo;

/** 初始化*/
- (id)initWithFrame:(CGRect)frame
         withUserId:(NSString *)userid
        withMatckId:(NSString *)matchId;

@end

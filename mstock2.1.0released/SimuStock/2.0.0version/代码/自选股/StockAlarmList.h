//
//  StockAlarmList.h
//  SimuStock
//
//  Created by Mac on 15/4/20.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

/** 股票预警信息 */
@interface StockAlarmList : BaseRequestObject2

///用户id
@property(nonatomic, strong) NSString *uid;

///该用户的股票预警
@property(nonatomic, strong) NSMutableSet *alarms;


+ (StockAlarmList *) stockAlarmListWithUserId:(NSString*) uid;

///加入股票预警
- (void)addSelfStockAlarms:(NSArray *)stockAlarmCodes;

///加入股票预警
- (void)addSelfStockAlarm:(NSString *)stockAlarmCodes;

///删除股价预警
- (void)deleteSelfStockAlarm:(NSString *)stockCode;

///判断是否有设置了股价预警
- (BOOL)isSelfStockAlarm:(NSString *)stockCode;

@end

//
//  StockWarningController.h
//  SimuStock
//
//  Created by Mac on 15/4/19.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StockAlarmEntity.h"
@interface StockWarningController : NSObject
+ (StockWarningController *)sharedManager;

///添加数据
- (void)addCoredataWithUid:(NSString *)uid
                   Withmsg:(NSString *)msg
              WithsendTime:(NSString *)sendtime
             WithfirstType:(NSNumber *)firsttype
              andStockName:(NSString *)stockname
              andStockCode:(NSString *)stockcode;

///获取股票预警的分页数据
- (NSArray *)getStockAlarmsWithStartDate:(NSDate*) date withReqestNum: (NSInteger) requestNum;

///重新启动网络请求时,删除coredata 数据库中的数据
- (void)deleteCoreDataObject:(NSManagedObject *)object;

///删除所有数据
- (void)deleteWithruid:(NSString *)ruid;
@end

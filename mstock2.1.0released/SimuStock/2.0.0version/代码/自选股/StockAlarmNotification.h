//
//  StockAlarmNotification.h
//  SimuStock
//
//  Created by Mac on 15/4/20.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseNotificationObserverMgr.h"

/** 添加自选股预警*/
static NSString *const AC_SelfStockAlarm_Add = @"AC_SelfStockAlarm_Add";

/** 删除自选股预警*/
static NSString *const AC_SelfStockAlarm_Remove = @"AC_SelfStockAlarm_Remove";

/** 添加自选股预警回调，通知父容器 */
typedef void (^OnAddStockAlarm)(NSString *);

/** 删除自选股预警回调，通知父容器 */
typedef void (^OnRemoveStockAlarm)(NSString *);

/** 添加或者删除自选股预警通知回调管理器 */
@interface StockAlarmNotification : BaseNotificationObserverMgr

/** 添加自选股预警回调，通知父容器 */
@property(copy, nonatomic) OnAddStockAlarm onAddStockAlarm;

/** 删除自选股预警回调，通知父容器 */
@property(copy, nonatomic) OnRemoveStockAlarm onRemoveStockAlarm;

@end

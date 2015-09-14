//
//  SelfStockUtil.h
//  SimuStock
//
//  Created by Mac on 15/5/27.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseNotificationObserverMgr.h"

#pragma SelfStockChangeNotification

static NSString *const SelfStockChangeNotificationName =
    @"SelfStockChangeNotificationName";

/** 自选股变更后回调 */
typedef void (^OnSelfStockChangeAction)();

@interface SelfStockChangeNotification : BaseNotificationObserverMgr

/** 自选股变更后回调 */
@property(copy, nonatomic) OnSelfStockChangeAction onSelfStockChange;

@end



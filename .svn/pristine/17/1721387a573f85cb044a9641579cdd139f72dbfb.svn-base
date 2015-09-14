//
//  RealTradeFundTransferHistory.h
//  SimuStock
//
//  Created by Mac on 14-9-22.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

@interface RealTradeFundTransferHistoryItem : NSObject

/**银行 */
@property(nonatomic, strong) NSString *bank;

/**日期 */
@property(nonatomic, strong) NSString *date;

/**时间 */
@property(nonatomic, strong) NSString *time;

/**金额 */
@property(nonatomic, strong) NSString *moneyAmount;

/**转账方向 */
@property(nonatomic, strong) NSString *transferDirection;

/**状态 */
@property(nonatomic, strong) NSString *status;

@end

@interface RealTradeFundTransferHistory : JsonRequestObject

/**转入转出历史列表 */
@property(nonatomic, strong) NSMutableArray *history;

/**加载转入转出历史列表 */
+ (void)loadFundTransferHistoryWithCallback:(HttpRequestCallBack *)callback;

@end

//
//  ActualQuotationMoneyShiftToOrRolloffData.h
//  SimuStock
//
//  Created by moulin wang on 15/3/10.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
@class HttpRequestCallBack;

@interface ActualQuotationMoneyShiftToOrRolloffData : JsonRequestObject

//实盘界面 统计资金转入转出接口 brokerTpey 1 = 顶点柜台 2 = 恒生柜台
+ (void)requestActualQuotationMoneyShiftToOrRolloff:(NSString *)money
                                            andType:(BOOL)type
                                     withBrokerType:(NSInteger)brokerTpey
                                        andCallBack:
                                            (HttpRequestCallBack *)callback;
@end

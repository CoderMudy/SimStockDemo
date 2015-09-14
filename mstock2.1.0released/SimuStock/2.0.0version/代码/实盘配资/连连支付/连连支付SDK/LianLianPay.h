//
//  LianLianPay.h
//  SimuStock
//
//  Created by jhss_wyz on 15/5/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WFGetLianLianPaymentOrder;

@interface LianLianPay : NSObject

/** 生成连连支付订单参数 */
+ (NSDictionary *)createLianLianOrderWithParameter:(WFGetLianLianPaymentOrder *)parameter;

@end

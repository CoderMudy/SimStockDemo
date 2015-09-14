//
//  RealTradeSpecifiedTransaction.h
//  SimuStock
//
//  Created by Mac on 14-9-22.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

@interface RealTradeSpecifiedTransaction : JsonRequestObject

/**股东姓名 */
@property(nonatomic, strong) NSString *stockholderName;

/**股东代码 */
@property(nonatomic, strong) NSString *stockholderCode;

/**市场类别 */
@property(nonatomic, strong) NSString *marketType;

/**加载指定交易 */
+ (void)loadSpecifiedTransactionWithCallback:(HttpRequestCallBack *)callback;

@end

@interface RealTradeDoSpecifiedTransaction : JsonRequestObject

/**委托单 */
@property(nonatomic, assign) int entrustorder;

/**发起指定交易 */
+ (void)doSpecifiedTransactionWithCallback:(HttpRequestCallBack *)callback;

@end

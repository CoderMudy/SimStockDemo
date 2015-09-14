//
//  MarketHomeWrapper.h
//  SimuStock
//
//  Created by Mac on 14-11-14.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequestObject.h"
#import "Globle.h"

#import "NSStringCategory.h"

@class HttpRequestCallBack;

@interface MarketHomeWrapper : BaseRequestObject <ParseCompressPointPacket, Collectionable>

/** 多条上涨股票 */
@property(strong, nonatomic) NSMutableArray *dataArray;

/**
 * 获取行情主页的信息列表
 */
+ (void)requestMarketHomeWithCallback:(HttpRequestCallBack *)callback;

@end

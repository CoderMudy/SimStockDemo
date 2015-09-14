//
//  SelfStockCodes.h
//  SimuStock
//
//  Created by Mac on 14-9-10.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "JsonFormatRequester.h"

typedef void (^OnEndUpdateSelfStockAction)();

@class HttpRequestCallBack;

/**
 *  （旧版，⚠️需要被替换）
 */
@interface SelfStockCodesUploadResult : JsonRequestObject

@property(copy, nonatomic) NSString *version;

/**
 更新自选股信息
 */
+ (void)uploadSelfStocks;

@end

@interface SelfStockCodes : JsonRequestObject

@property(copy, nonatomic) NSString *portfolio;
@property(copy, nonatomic) NSString *version;

/**
 获取最新的自选股信息（旧版，⚠️需要被替换）
 */
+ (void)requestSelfStocksWithOnEndUpdate:
    (OnEndUpdateSelfStockAction)onEndUpdata;

@end

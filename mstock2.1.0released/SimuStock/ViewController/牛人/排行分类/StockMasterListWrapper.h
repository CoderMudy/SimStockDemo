//
//  StockMasterListWrapper.h
//  SimuStock
//
//  Created by moulin wang on 14-11-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequestObject.h"
@class HttpRequestCallBack;

#pragma mark-----RuleGet数据获取部分(判断用户是否有跟踪权限)-----
@interface StockMasterRuleGetListWrapper : JsonRequestObject

@property(copy, nonatomic) NSString *isShowDeadlineStr;
@property(copy, nonatomic) NSString *isDeadlineStr;
/**rule/get部分*/
@property(strong, nonatomic) NSMutableArray *dataArrayRule;
+ (void)requestStockMastrbackListRuleGetWithCallback:
    (HttpRequestCallBack *)callback;
@end

#pragma mark-----Highest数据获取部分(用户利率最高值)-----
@interface StockMasterHighestListWrapper : JsonRequestObject
@property(copy, nonatomic) NSString *total;
@property(copy, nonatomic) NSString *suc;
@property(copy, nonatomic) NSString *month;
@property(copy, nonatomic) NSString *week;
/**highest部分*/
+ (void)requestStockMastrbackListHighestWithCallback:
    (HttpRequestCallBack *)callback;
@end
//
//  ModifySelfStockData.h
//  SimuStock
//
//  Created by Yuemeng on 15/6/17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

/*
 *  修改自选股【分组版】
 */
@interface ModifySelfStockData : JsonRequestObject

///版本号
@property(nonatomic, strong) NSString *ver;
///用户自选股代码列表
@property(nonatomic, strong) NSArray *portfolio;
///全部分组信息
@property(nonatomic, strong) NSMutableArray *dataArray;

+ (void)requestModifySelfStockDataWithParams:(NSDictionary *)dic
                                    callback:(HttpRequestCallBack *)callback;
@end

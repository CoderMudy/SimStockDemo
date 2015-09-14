//
//  CowThanBearData.h
//  SimuStock
//
//  Created by Yuemeng on 15/5/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "JsonFormatRequester.h"

/*
 *  牛熊比接口
 */
@interface CowThanBearData : JsonRequestObject

@property(nonatomic, strong) NSMutableArray *dataArray;

+ (void)requsetCowThanBearData:(HttpRequestCallBack *)callback;

@end

/*
 *  牛熊比数据
 */
@interface CowThanBearDataItem : NSObject
///上证指数
@property(nonatomic, strong) NSNumber *szzs;
///时间
@property(nonatomic, strong) NSString *time;
///投票比值
@property(nonatomic, strong) NSNumber *vote;

- (instancetype)initWithDic:(NSDictionary *)dic;

@end

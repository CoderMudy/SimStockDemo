//
//  SimuCompetitionMillionCycleData.h
//  SimuStock
//
//  Created by Yuemeng on 14-11-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

@interface SimuCompetitionMillionCycleData : JsonRequestObject

/** 到期日 */
@property(copy, nonatomic) NSString *date;
/** 钻石余额 */
@property(assign, nonatomic) NSInteger myDiamond;
/** 剩余有效天数 */
@property(assign, nonatomic) NSInteger days;
/** 周期列表 */
@property(strong, nonatomic) NSMutableArray *list;

@property(strong, nonatomic) NSMutableArray *dataArray;

+ (void)requestSimuCompetitionMillionCycleDataWithMid:
            (NSString *)mid withCallback:(HttpRequestCallBack *)callback;

@end

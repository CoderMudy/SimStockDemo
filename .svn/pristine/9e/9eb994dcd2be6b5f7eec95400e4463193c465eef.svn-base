//
//  FundNetWorthList.h
//  SimuStock
//
//  Created by Mac on 15/5/29.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

@interface FundNav : BaseRequestObject2 <ParseJson>

/** 结束日期 */
@property(nonatomic, assign) long long endDate;

/** 单位净值（扩大1000倍） */
@property(nonatomic, assign) long long fundUnitNav;

/// 年月日
@property(nonatomic, strong) NSString *dateStr;

///年月
@property(nonatomic, strong) NSString *monthStr;

///年月日
@property(nonatomic, strong) NSString *dateWindow;

/** 单位净值, 保留4位有效数字 */
@property(nonatomic, strong) NSString *fundUnitNavStr;

@end

@interface FundNetWorthList : BaseRequestObject <Collectionable>

/** 基金净值信息列表 */
@property(nonatomic, strong) NSMutableArray *fundInfoList;

+ (void)requestFundCurStatusWithParameters:(NSDictionary *)dic
                              withCallback:(HttpRequestCallBack *)callback;

@end

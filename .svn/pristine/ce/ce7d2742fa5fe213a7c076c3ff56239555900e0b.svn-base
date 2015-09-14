//
//  CPYieldCurve.h
//  SimuStock
//
//  Created by jhss_wyz on 15/7/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonFormatRequester.h"

@interface CPYieldCurveData : JsonRequestObject

/** 牛人计划收益率数组 */
@property(strong, nonatomic) NSMutableArray *planYCArrayM;
/** 上证指数涨幅 */
@property(strong, nonatomic) NSMutableArray *sseGainArrayM;
/** 上证指数 */
@property(strong, nonatomic) NSMutableArray *sseArrayM;
/** 时间 */
@property(strong, nonatomic) NSMutableArray *dateArrayM;
/** 收益曲线纵轴最大坐标 */
@property(assign, nonatomic) CGFloat maxOrdinate;
/** 收益曲线纵轴最大坐标是否改变（默认：10.00%） */
@property(assign, nonatomic) BOOL isChanged;
/** 计算上证指数涨幅的基准 */
@property(assign, nonatomic) CGFloat baseSSE;

/** 总交易日天数 */
@property(assign, nonatomic) NSInteger tradeDays;
/** 最后结束的交易日 */
@property(strong, nonatomic) NSString *endDate;

/** 是否已经绑定曲线信息，即是否可以绘制曲线 */
@property(assign, nonatomic) BOOL isBind;

@end

@interface CPYieldCurve : NSObject

+ (void)getCPYieldCurveDataWithPlanID:(NSString *)planID
                         andTargetUID:(NSString *)targetUID
                          andCallback:(HttpRequestCallBack *)callback;

@end

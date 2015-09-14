//
//  SimuMatchData.h
//  SimuStock
//
//  Created by Yuemeng on 14-11-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

/** 比赛数据模型 */
@interface SimuMatchTemplateData : JsonRequestObject

///创建费(单位：钻石)
@property(copy, nonatomic) NSString *mCreateFee;
///是否是钻石创建的比赛
@property(copy, nonatomic) NSString *mCreateFlag;
///模板ID
@property(copy, nonatomic) NSString *mTemplateID;
///模板名称
@property(copy, nonatomic) NSString *mTemplateName;
///排序，数字越小越靠前显示
@property(copy, nonatomic) NSString *mTemplateRank;
///参赛费(单位：钻石)
@property(copy, nonatomic) NSString *mSignupFee;
///是否需要钻石参赛
@property(copy, nonatomic) NSString *mSignupFlag;

/** 比赛数据数组*/
@property(strong, nonatomic) NSMutableArray *dataArray;

+ (void)requestSimuMatchTemplateDataWithCallback:
    (HttpRequestCallBack *)callback;

@end

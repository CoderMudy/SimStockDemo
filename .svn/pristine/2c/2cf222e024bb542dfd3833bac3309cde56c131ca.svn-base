//
//  FindWindVaneData.h
//  SimuStock
//
//  Created by Yuemeng on 15/5/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "JsonFormatRequester.h"

/*
 *  风向标相关接口
 */
@interface FindWindVaneData : JsonRequestObject
///投跌数量
@property(nonatomic, strong) NSString *down;
///投跌百分比
@property(nonatomic, strong) NSString *downstr;
///投涨数量
@property(nonatomic, strong) NSString *up;
///投涨百分比
@property(nonatomic, strong) NSString *upstr;
///用户是否投票了 1: 已投 2：未投
@property(nonatomic, strong) NSString *userStatus;
///是否为投票时间 1：禁投时间  2：可投时间
@property(nonatomic, strong) NSString *voteStatus;

+ (void)requsetFindWindVaneData:(HttpRequestCallBack *)callback;

@end

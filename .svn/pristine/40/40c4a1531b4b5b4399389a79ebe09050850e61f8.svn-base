//
//  WFCancellationCapitalData.h
//  SimuStock
//
//  Created by moulin wang on 15/4/19.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonFormatRequester.h"

@class HttpRequestCallBack;

//优顾实盘配资 查询委托数据模型
@interface WFCapitalCancellData : NSObject
//查询当日委托数据
/** 恒生用户编号 */
@property(copy, nonatomic) NSString *hsUserId;
/** HOMS主账号 */
@property(copy, nonatomic) NSString *homsFundAccount;
/** HOMS子账号 */
@property(copy, nonatomic) NSString *homsCombineId;

@end

//保存 数据模型类
@interface WFcancellData : JsonRequestObject

//保存 WFCapitalCancellData
@property(strong, nonatomic) NSMutableArray *capitalCancellList;

//保存 RealTradeTodayEntrustItem
@property(strong, nonatomic) NSMutableArray *tradeTodayEntrustItemArray;

@end

//撤单数据模型类
@interface WFEvacuateBillData : JsonRequestObject

//创建变量
/** 成功 还是 失败 */
@property(copy, nonatomic) NSString *data;

@end

@interface WFCancellationCapitalData : NSObject

/** 查询当日委托 */
+ (void)requestCancellationCapitalWithHsUserid:(NSString *)hsUserID
                           withHomsFundAccount:(NSString *)homsFundAccount
                             withHomsCombineld:(NSString *)homsCombineld
                             withEntrustStatus:(NSString *)entrustStatus
                                  withCallBack:(HttpRequestCallBack *)callback;

/** 查询委托 */
+ (void)requestCancellationCapitalData:(HttpRequestCallBack *)callback;

/** 撤单请求 */
+ (void)requestCapitalEvacuateBillWithHsUserid:(NSString *)hsUserID
                           withHomsFundAccount:(NSString *)homsFundAccount
                             withHomsCombineld:(NSString *)homsCombineld
                                 withEntrustNo:(NSString *)entrustNo
                                  withCallBack:(HttpRequestCallBack *)callback;
+ (void)requestCapitalEvacuateBillWithEntrustNo:(NSString *)entrustNo
                                   withCallback:(HttpRequestCallBack *)callback;

@end

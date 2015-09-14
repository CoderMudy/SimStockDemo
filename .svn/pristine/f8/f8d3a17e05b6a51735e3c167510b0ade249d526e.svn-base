//
//  ActualQuotationUserPinlessData.h
//  SimuStock
//
//  Created by moulin wang on 15/3/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//  优顾客户和实盘客户绑定 Class

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

//登录实盘后 请求客户信息类
@interface ActualQuotationUserInfoData : JsonRequestObject

/** 客户姓名 */
@property(nonatomic, copy) NSString *khxm;

/** 身份证号 */
@property(nonatomic, copy) NSString *sfzh;
/** 手机 */
@property(nonatomic, copy) NSString *phone;
/** 上海股东号 */
@property(nonatomic, copy) NSString *shgdh;
/** 深圳股东号 */
@property(nonatomic, copy) NSString *szgdh;
/** 营业部 */
@property(nonatomic, copy) NSString *yyb;

@property(nonatomic, strong) NSMutableArray *arrayActualQuotationUserInfo;

/** 请求客户信息资料 */

+ (void)requestUserInfoWithCallback:(HttpRequestCallBack *)callback
                      andCustomerId:(NSString *)customer
                     withBrokerType:(NSInteger)brokerType ;

@end

//实盘用户绑定
@interface ActualQuotationUserPinlessData : JsonRequestObject

+ (void)
requestYuuguUserAndActualQuotationUserWithUserInfo:
    (NSArray *)userInfoArray andWithCallback:(HttpRequestCallBack *)callback
                                       andBrokerId:(NSString *)brokerUserId
                                        withBrokerType:(NSInteger)brokerType;

@end

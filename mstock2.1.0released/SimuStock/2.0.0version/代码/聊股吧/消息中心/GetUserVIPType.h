//
//  GetUserVIPType.h
//  SimuStock
//
//  Created by jhss on 15/7/10.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "BaseRequester.h"

@interface GetUserVIPType : JsonRequestObject
/** vip等级 [int] -1 未开通 1 vip 2.svip 3.过期 */
@property(assign, nonatomic) UserVipType vipType;

+ (void)getUserVipTypeWithCallback:(HttpRequestCallBack *)callback;
@end

//
//  CPBuyCattlePlanData.h
//  SimuStock
//
//  Created by jhss_wyz on 15/7/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "JsonFormatRequester.h"

@interface CPBuyCattlePlanData : JsonRequestObject

+ (void)buyCattlePlanWithAccountID:(NSString *)accountID
                      andTargetUID:(NSString *)targetUID
                       andCallBack:(HttpRequestCallBack *)callback;

@end

//
//  GetUserBandPhoneNumber.h
//  SimuStock
//
//  Created by Mac on 15/4/28.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "BaseRequester.h"
#import "WFProductContract.h"
#import "WithCapitalHome.h"

@interface WFRealUserRNA : JsonRequestObject

@end

@interface GetUserBandPhoneNumber : JsonRequestObject

@property(nonatomic, copy) NSString *phoneNumber;

+ (void)checkUserBindPhonerWithCallback:(HttpRequestCallBack *)callback;

@end

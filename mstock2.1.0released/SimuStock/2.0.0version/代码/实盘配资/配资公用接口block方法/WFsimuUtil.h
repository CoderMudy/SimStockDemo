//
//  WFsimuUtil.h
//  SimuStock
//
//  Created by Mac on 15/5/18.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "WFAccountInterface.h"

@interface WFRealUserIsRNA : JsonRequestObject
///用户实名
@property(nonatomic, strong) NSString *realName;

///用户身份证号
@property(nonatomic, strong) NSString *certNo;

@end

@interface WFinquireIsAuthRNA : JsonRequestObject

////用户身份验证
+ (void)authUserIdentityWithCallback:(HttpRequestCallBack *)callback;
@end
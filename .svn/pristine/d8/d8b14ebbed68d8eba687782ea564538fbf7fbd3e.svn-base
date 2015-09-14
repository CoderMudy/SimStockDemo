//
//  RealTradeRequester.h
//  SimuStock
//
//  Created by Mac on 14-9-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequester.h"
#import "RealTradeLoginResponse.h"
#import "JsonFormatRequester.h"
#import "RealTradeUrls.h"

@interface RealTradeAuthInfo : NSObject

@property(nonatomic, strong) NSString *cookie;

@property(nonatomic, strong) RealTradeLoginResponse *loginInfo;

@property(nonatomic, strong) id<RealTradeUrlFactory> urlFactory;


+ (RealTradeAuthInfo *)singleInstance;

@end

@interface RealTradeRequester : JsonFormatRequester <UIAlertViewDelegate>

@end

@interface RealTradeCaptchaImageRequester : BaseRequester

@end

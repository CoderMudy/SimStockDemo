//
//  CPInquireCattleNumData.h
//  SimuStock
//
//  Created by jhss_wyz on 15/7/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "JsonFormatRequester.h"

@interface CPInquireCattleNumData : JsonRequestObject

/** 道具ID(这里指送牛道具ID) */
@property(strong, nonatomic) NSString *propId;
/** 剩余牛数 */
@property(assign, nonatomic) NSInteger cowNum;

@end

@interface CPInquireCattleNumRequest : NSObject

+ (void)requestCPSendCattleWithCallback:(HttpRequestCallBack *)callback;

@end

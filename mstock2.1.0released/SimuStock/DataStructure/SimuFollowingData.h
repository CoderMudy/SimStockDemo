//
//  SimuFollowingData.h
//  SimuStock
//
//  Created by Yuemeng on 14-11-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

/** 关注，取消关注请求类 */
@interface SimuFollowingData : JsonRequestObject

+ (void)requestFollowingWithUserId:(NSString *)userId
                       withMatchId:(NSString *)matchId
                         withIsAdd:(BOOL)isAdd
                      withCallback:(HttpRequestCallBack *)callback;

@end

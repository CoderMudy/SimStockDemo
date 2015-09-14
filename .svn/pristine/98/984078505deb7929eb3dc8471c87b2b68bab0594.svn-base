//
//  SimuValidateMatchData.h
//  SimuStock
//
//  Created by Yuemeng on 14-11-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;
@class MatchCreateMatchInfo;

/** 比赛验证码 */
@interface SimuValidateMatchData : JsonRequestObject

/** 创建邀请码错误返回数据 */
@property(nonatomic, strong) NSDictionary *errorDictionary;

+ (void)requestSimuValidateMatchDataWtihMatchName:(NSString *)matchName
                                    withStartTime:(NSString *)startTime
                                      withEndTime:(NSString *)endTime
                           withTempInvitationCode:(NSString *)tempInvitationCode
                                   withTemplateID:(NSString *)templateID
                                     withCallback:
                                         (HttpRequestCallBack *)callback;

+ (void)
requestSimuValidateMatchDataWtihMatchInfo:(MatchCreateMatchInfo *)matchInfo
                             withCallback:(HttpRequestCallBack *)callback;

@end

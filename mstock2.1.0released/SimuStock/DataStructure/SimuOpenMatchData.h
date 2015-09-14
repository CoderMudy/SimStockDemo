//
//  SimuOpenMatchData.h
//  SimuStock
//
//  Created by Yuemeng on 14-11-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

/** 比赛创建：比赛信息 */
@interface MatchCreateMatchInfo : NSObject
/** 用户名 */
@property(copy, nonatomic) NSString *userName;
/** 比赛名称 */
@property(copy, nonatomic) NSString *matchName;
/** 比赛描述 */
@property(copy, nonatomic) NSString *matchDescp;
/** 开始时间 yyyy-MM-dd */
@property(copy, nonatomic) NSString *openTime;
/** 结束时间 yyyy-MM-dd */
@property(copy, nonatomic) NSString *closeTime;
/** 邀请码 */
@property(copy, nonatomic) NSString *inviteCode;
/** 创建的比赛是否有邀请码 */
@property(assign, nonatomic) BOOL hasInviteCode;
/** 比赛模版 */
@property(copy, nonatomic) NSString *templateId;
@end

/** 比赛创建：高校 */
@interface MatchCreateUniversityInfo : NSObject
/** 是否是高校赛 */
@property(copy, nonatomic) NSString *isSenior;
/** 用途 */
@property(copy, nonatomic) NSString *purpose;
/** 高校 */
@property(copy, nonatomic) NSString *seniorSchool;
@end

/** 比赛创建：有奖信息 */
@interface MatchCreateAwardInfo : NSObject
/** 是否是有奖赛 0 1 */
@property(copy, nonatomic) NSString *isReward;
/** 奖品，以,分割 */
@property(copy, nonatomic) NSString *reward;
@end

/** 提交比赛 */
@interface SimuOpenMatchData : JsonRequestObject

@property(nonatomic, strong) NSMutableArray *dataArray;

+ (void)requestSimuOpenMatchDataWithUsername:(NSString *)username
                               withMatchName:(NSString *)matchName
                        withMatchDescription:(NSString *)matchDestciption
                               withStartTime:(NSString *)startTime
                                 withEndTime:(NSString *)endTime
                      withTempInvitationCode:(NSString *)tempInvitationCode
                              withTemplateId:(NSString *)templateId
                                withCallback:(HttpRequestCallBack *)callback;

+ (void)requestMatchCreateWithMatchInfo:(MatchCreateMatchInfo *)matchInfo
                         universityInfo:(MatchCreateUniversityInfo *)universityInfo
                              awardInfo:(MatchCreateAwardInfo *)awardInfo
                           withCallback:(HttpRequestCallBack *)callback;

@end

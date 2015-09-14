//
//  SimuJoinMatchData.h
//  SimuStock
//
//  Created by Yuemeng on 14-11-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;
/** 参加比赛数据 */
@interface SimuJoinMatchData : JsonRequestObject

@property(nonatomic, strong) NSString *userId;
@property(nonatomic, strong) NSString *matchId;
@property(nonatomic, strong) NSString *matchName;

+ (void)requestSimuJoinMatchDataWithNickName:(NSString *)nickName
                                 withMatchId:(NSString *)matchId
                                withCallback:(HttpRequestCallBack *)callback;

+ (void)requestSimuJoinMatchDataWithNickName:(NSString *)nickName
                              withInviteCode:(NSString *)inviteCode
                                 withMatchID:(NSString *)matchID
                                withCallback:(HttpRequestCallBack *)callback;

@end

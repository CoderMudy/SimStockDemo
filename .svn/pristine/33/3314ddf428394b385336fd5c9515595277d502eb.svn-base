//
//  SimuHomeMatchData.m
//  SimuStock
//
//  Created by Yuemeng on 14-11-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuHomeMatchData.h"
#import "JsonFormatRequester.h"
#import "UserListItem.h"

@implementation SimuHomeMatchData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];

  self.dataArray = [[NSMutableArray alloc] init];

  SimuHomeMatchData *matchData = [[SimuHomeMatchData alloc] init];
  NSString *sad_matchDescp = dic[@"matchDescp"];
  //比赛说明
  matchData.matchDescp = [SimuUtil changeIDtoStr:sad_matchDescp];
  // userId
  matchData.userId = [NSString stringWithFormat:@"%@", dic[@"userId"]];
  //图片网址
  NSString *sad_backgroundUrl = dic[@"background"];
  matchData.backgroundUrl = [SimuUtil changeIDtoStr:sad_backgroundUrl];
  // matchId
  matchData.matchID = [NSString stringWithFormat:@"%@", dic[@"matchId"]];
  //参赛状态
  matchData.state = [NSString stringWithFormat:@"%@", dic[@"state"]];
  //详细链接
  NSString *detailUrl = dic[@"detailUrl"];
  matchData.detailUrl = [SimuUtil changeIDtoStr:detailUrl];
  //比赛名称
  NSString *sad_matchName = dic[@"matchName"];
  matchData.matchName = [SimuUtil changeIDtoStr:sad_matchName];
  //比赛时间
  NSString *sad_matchTime = [SimuUtil changeIDtoStr:dic[@"matchTime"]];
  if (sad_matchTime.length > 0) {
    NSString *matchTime = [sad_matchTime stringByReplacingOccurrencesOfString:@" " withString:@""];
    matchTime = [matchTime stringByReplacingOccurrencesOfString:@"至" withString:@"\n至"];
    matchData.matchTime = [matchTime copy];
  }
  //创建人昵称
  NSString *sad_creator = dic[@"creator"];
  matchData.creator = [SimuUtil changeIDtoStr:sad_creator];
  //创建人vipType
  matchData.vipType = [dic[@"vipType"] integerValue];
  //是否显示比赛详情
  matchData.isShowDesFlag = [dic[@"showDesFlag"] boolValue];
  //是否显示比赛说明
  matchData.isShowDetailFlag = [dic[@"showDetail"] boolValue];
  //是否邀请码参赛
  matchData.inviteFlag = [dic[@"inviteFlag"] boolValue];
  //是否显示月排名
  matchData.showMonthRank = [dic[@"showMonthRank"] boolValue];
  //是否需要钻石参赛
  matchData.signupFlag = [dic[@"signupFlag"] integerValue];
  //参赛费(单位：钻石)
  matchData.signupFee = [dic[@"signupFee"] integerValue];
  // 1:显示奖池数，0:不显示
  matchData.rewardFlag = [dic[@"rewardFlag"] integerValue];
  // 有奖比赛标志
  matchData.isReward = [NSString stringWithFormat:@"%@", dic[@"isReward"]];
  // 比赛跳转WAP页标志
  matchData.wapJump = [NSString stringWithFormat:@"%@", dic[@"isWapJump"]];
  // 有奖比赛跳转URL
  matchData.mainURL = [NSString stringWithFormat:@"%@", dic[@"mainUrl"]];
  // 比赛类型，Type（974:用户创建的比赛,976:已结束比赛,977:待开赛比赛,978:团队比赛）
  matchData.matchType = [NSString stringWithFormat:@"%@", dic[@"type"]];
  if (matchData.rewardFlag) {
    //奖池数
    NSString *sad_rewardPool = dic[@"rewardPool"];
    matchData.rewardPool = [SimuUtil changeIDtoStr:sad_rewardPool];
  }
  //邀请码
  NSString *sad_invitecode = dic[@"inviteCode"];
  if (sad_invitecode) {
    matchData.invitecode = [SimuUtil changeIDtoStr:sad_invitecode];
  } else {
    matchData.invitecode = @"";
  }

  matchData.userListItem = [[UserListItem alloc] init];
  matchData.userListItem.rating = dic[@"rating"];
  matchData.userListItem.vipType = [dic[@"vipType"] intValue];
  matchData.userListItem.stockFirmFlag = [SimuUtil changeIDtoStr:dic[@"stockFirmFlag"]];
  matchData.userListItem.nickName = matchData.creator;
  matchData.userListItem.userId = @([matchData.userId longLongValue]);
  [self.dataArray addObject:matchData];
}

+ (void)requestSimuHomeMatchDataWithMid:(NSString *)mid
                           withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [data_address stringByAppendingFormat:@"youguu/match/homeMatch?matchId=%@", mid];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[SimuHomeMatchData class]
             withHttpRequestCallBack:callback];
}

@end

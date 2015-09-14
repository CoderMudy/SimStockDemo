//
//  SimuHomeMatchData.h
//  SimuStock
//
//  Created by Yuemeng on 14-11-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class UserListItem;
@class HttpRequestCallBack;

/** 比赛详情 */
@interface SimuHomeMatchData : JsonRequestObject

/** 比赛id */
@property(copy, nonatomic) NSString *matchID;
/** 比赛名称 */
@property(copy, nonatomic) NSString *matchName;
/** 比赛说明 */
@property(copy, nonatomic) NSString *matchDescp;
/** 比赛时间 */
@property(copy, nonatomic) NSString *matchTime;
/** 背景图地址 */
@property(copy, nonatomic) NSString *backgroundUrl;
/** 创建人ID */
@property(copy, nonatomic) NSString *userId;
/** 创建人昵称 */
@property(copy, nonatomic) NSString *creator;
/** vipType */
@property(nonatomic) NSInteger vipType;
/** 邀请码 */
@property(copy, nonatomic) NSString *invitecode;
/** 比赛类型 */
//按钮权限控制,用户未登录时显示”参与比赛”。
// 1：参与比赛
// 2：等待比赛开始
// 3：进入比赛
// 4：比赛结束
// 5：续费(百万，千万赛)
@property(copy, nonatomic) NSString *state;
/** 详情链接 */
@property(copy, nonatomic) NSString *detailUrl;
/** 是否显示详细说明 */
@property(assign, nonatomic) BOOL isShowDesFlag;
/** 是否显示详情按钮 */
@property(assign, nonatomic) BOOL isShowDetailFlag;
/** 是否需要邀请码参赛 */
@property(nonatomic) BOOL inviteFlag;
/** 月排行榜显示判断 */
@property(nonatomic) BOOL showMonthRank;
/** 是否需要钻石参赛 */
@property(assign, nonatomic) NSInteger signupFlag;
/** 参赛费 */
@property(assign, nonatomic) NSInteger signupFee;
/**  1:显示奖池数，0:不显示 */
@property(assign, nonatomic) NSInteger rewardFlag;
/** 奖池数 */
@property(copy, nonatomic) NSString *rewardPool;
/** 是否是有奖比赛：@“1”是有奖比赛，@“0”不是有奖比赛 */
@property(copy, nonatomic) NSString *isReward;
/** 是否跳转web页 */
@property(copy, nonatomic) NSString *wapJump;
/** 有奖比赛的跳转URL */
@property(copy, nonatomic) NSString *mainURL;
/** 比赛类型，Type（974:用户创建的比赛,976:已结束比赛,977:待开赛比赛,978:团队比赛） */
@property(copy, nonatomic) NSString *matchType;

/** 用户评级控件数据 */
@property(nonatomic, strong) UserListItem *userListItem;
@property(nonatomic, strong) NSMutableArray *dataArray;

+ (void)requestSimuHomeMatchDataWithMid:(NSString *)mid
                           withCallback:(HttpRequestCallBack *)callback;

@end

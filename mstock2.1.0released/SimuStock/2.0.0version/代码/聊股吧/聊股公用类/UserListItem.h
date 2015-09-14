//
//  UserListItem.h
//  SimuStock
//  Created by jhss on 14-11-21.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "UserConst.h"

@class HttpRequestCallBack;

@interface UserListItem : BaseRequestObject2 <ParseJson>

/** 列表页用户头像 */
@property(copy, nonatomic) NSString *headPic;
/** 用户昵称 */
@property(copy, nonatomic) NSString *nickName;
/** 评级 */
@property(copy, nonatomic) NSString *rating;
/** 签名 */
@property(copy, nonatomic) NSString *signature;
/** 用户id */
@property(strong, nonatomic) NSNumber *userId;
/** 用户名 */
@property(copy, nonatomic) NSString *userName;
/** vip等级 [int] -1 未开通 1 vip 2.svip 3.过期 */
@property(assign, nonatomic) UserVipType vipType;
/** stockFirmFlag	实盘标识 */
@property(strong, nonatomic) NSString *stockFirmFlag;

/** 返回是否有实盘账号 */
- (BOOL)hasRealTradeAccount;

/** 返回vip用户的红色，非vip用户返回蓝色 */
+ (UIColor *)colorWithVIPType:(UserVipType)vipType;
/** 可指定默认颜色 */
+ (UIColor *)colorWithVIPType:(UserVipType)vipType
                 defaultColor:(UIColor *)color;
@end

/** 比赛用户数据 */
@interface UserListItemMatch : UserListItem <Collectionable>

/** 用户id */
@property(copy, nonatomic) NSString *userID;
/** 用户排名 */
@property(copy, nonatomic) NSString *userRank;
/** 用户盈利率 */
@property(copy, nonatomic) NSString *userProfitability;
/** 团队id */
@property(copy, nonatomic) NSString *teamId;
/** 团队名 */
@property(copy, nonatomic) NSString *teamName;

@property(nonatomic, strong) NSMutableArray *dataArray;

/** 比赛盈利榜 */
+ (void)requestUserListItemMatchWithParameter:(NSDictionary *)dic
                                    withmType:(NSString *)mtype
                                     withType:(NSString *)type
                                 withCallback:(HttpRequestCallBack *)callback;
@end

@interface UserListWrapper : NSObject

@property(nonatomic, strong) NSMutableDictionary *mappings;

/** 将json格式内容转回为<uid, user>的key-value对 */
- (void)jsonToMap:(NSArray *)array;

/** 查询指定的uid对应的user */
- (UserListItem *)getUserById:(NSString *)uid;

@end

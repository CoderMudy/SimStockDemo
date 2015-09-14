//
//  SimuMatchInfo.h
//  SimuStock
//
//  Created by jhss on 15/8/11.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonFormatRequester.h"

@interface SimuMatchInfo : NSObject

#pragma mark 个人排行
/** 个人排行 */
+ (void)getGroupMatchWithInput:(NSDictionary *)dic
                 withMatchType:(NSString *)type
                  withCallback:(HttpRequestCallBack *)callback;
/**   学校内部排名*/
+ (void)getSchoolMatchWithInput:(NSDictionary *)dic
                  withMatchType:(NSString *)type
                   withCallback:(HttpRequestCallBack *)callback;
@end


#pragma mark 个人排行
/** 个人排行 */
@interface PersionMatchListResult : JsonRequestObject <Collectionable>

/// 排行列表
@property(copy, nonatomic) NSArray *matchList;

@end


@interface SimuPersionMatchItem : NSObject
/**  姓名*/
@property(nonatomic,strong)NSString *nameLabel;
/**  班级名称*/
@property(nonatomic,strong)NSString *classNameLabel;
/**  盈利率*/
@property(nonatomic,strong)NSString *profitLabel;
/**  比赛排名*/
@property(nonatomic,strong)NSString *rankNum;
/**   团队名称*/
@property(nonatomic,strong)NSString *teamName;
/**  团队id*/
@property(nonatomic,strong)NSString *teamId;

+ (instancetype)withGroupMatchInfoWithDictionary:(NSDictionary *)dic;
@end


#pragma mark 学校内部排行
/** 个人排行 */
@interface SchoolMatchListResult : JsonRequestObject <Collectionable>

/// 排行列表
@property(copy, nonatomic) NSArray *matchList;

@end


@interface SimuSchoolMatchItem : NSObject
/**  姓名*/
@property(nonatomic,strong)NSString *nameLabel;
/**  班级名称*/
@property(nonatomic,strong)NSString *classNameLabel;
/**  盈利率*/
@property(nonatomic,strong)NSString *profitLabel;
/**  比赛排名*/
@property(nonatomic,strong)NSString *rankNum;
/**   个人名称*/
@property(nonatomic,strong)NSString *personalName;
/**  团队id*/
@property(nonatomic,strong)NSString *teamId;
/**  个人uid*/
@property(nonatomic,strong)NSString *uid;

+ (instancetype)withSchoolMatchInfoWithDictionary:(NSDictionary *)dic;
@end





//
//  ShowBarInfoData.h
//  SimuStock
//
//  Created by Yuemeng on 14-12-1.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

/** 版主信息 */
@interface ModeratorInfoData : JsonRequestObject

/** 吧主id */
@property(nonatomic, strong) NSNumber *uid;
/** 吧主昵称 */
@property(nonatomic, strong) NSString *nickname;

@end

/** 获取股吧信息数据类 */
@interface ShowBarInfoData : JsonRequestObject
/** 吧名称 */
@property(nonatomic, strong) NSString *name;
/** 吧简介 */
@property(nonatomic, strong) NSString *des;
/** 吧logo */
@property(nonatomic, strong) NSString *logo;
/** 关注数 */
@property(nonatomic, strong) NSNumber *followers;
/** 股聊数 */
@property(nonatomic, strong) NSNumber *postNum;

/** 吧主数据数组 */
@property(nonatomic, strong) NSMutableArray *moderators;

/** 股吧信息 */
+ (void)requestShowBarInfoDataWithBarId:(NSNumber *)barId
                           withCallback:(HttpRequestCallBack *)callback;

@end

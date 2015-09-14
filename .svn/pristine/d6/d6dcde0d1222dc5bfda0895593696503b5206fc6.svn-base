//
//  GetBarTopListData.h
//  SimuStock
//
//  Created by Yuemeng on 14-12-2.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

/** 股吧置顶股聊单条数据 */
@interface BarTopTweetData : JsonRequestObject

/** 所属股吧id */
@property(nonatomic, strong) NSNumber *barId;
/** 股聊ID */
@property(nonatomic, strong) NSNumber *tstockid;
/** 标题 */
@property(nonatomic, strong) NSString *title;
/** 是否加精（1.精华帖，0或null非精华帖） */
@property(nonatomic) NSInteger elite;
/** 置顶类型（1.吧内置顶，2.全局置顶） */
@property(nonatomic) NSInteger topType;

/****************** 自定义数据 ******************/
/** 是否本地收藏 */
@property(nonatomic) BOOL isCollected;
/** cell高度 */
@property(nonatomic) CGFloat cellHeight;

@end

/** 获取股吧置顶区聊股列表 */
@interface GetBarTopListData : JsonRequestObject

/** 股聊数据数组 */
@property(nonatomic, strong) NSMutableArray *dataArray;

/** 请求置顶股聊数据 */
+ (void)requestGetBarTopListDataWithBarId:(NSNumber *)barId
                             withCallback:(HttpRequestCallBack *)callback;

@end

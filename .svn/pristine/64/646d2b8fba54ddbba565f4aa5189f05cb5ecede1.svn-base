//
//  HotRecommendListData.h
//  SimuStock
//
//  Created by Yuemeng on 14-11-24.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "UserListItem.h"

@class HttpRequestCallBack;

/** 🚫（暂时无用）股聊列表数据模型 */
@interface TweetListData : JsonRequestObject
///** 股聊ID */
//@property(nonatomic, strong) NSNumber *tstockid;
///** 股聊标题 */
//@property(nonatomic, strong) NSString *title;
///** 作者 */
//@property(nonatomic, strong) UserListItem *writer;
///** 赞数 */
//@property(nonatomic, strong) NSNumber *praise;
///** 评论数 */
//@property(nonatomic, strong) NSNumber *comment;
///** userID */
//@property(nonatomic) NSInteger uid;

///新接口//
//* 跑马灯标题*/
@property(nonatomic,strong) NSString * TitleName;
//*了解*/
@property(nonatomic,strong) NSString * PathUrl;
@end

/** 热门推荐数据模型 */
@interface HotRecommendListData : JsonRequestObject

/** 股聊列表 */
@property(nonatomic, strong) NSMutableArray *tweetList;

+ (void)requestHotRecommendListDataWithCallback:(HttpRequestCallBack *)callback;

@end

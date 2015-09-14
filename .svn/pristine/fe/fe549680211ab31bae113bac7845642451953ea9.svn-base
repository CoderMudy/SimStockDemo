//
//  BaseWeiboItem.h
//  SimuStock
//
//  Created by Mac on 14/11/27.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "UserListItem.h"

/** 置顶项类型*/
typedef NS_ENUM(NSUInteger, BarTopType) {
  /** 股吧内置顶*/
  TopInBar = 1,

  /** 全局置顶*/
  TopInAllBar = 2
};

/** 聊股基类：提供基本信息 */
@interface BaseWeiboItem : JsonRequestObject

/** 加精 */
@property(nonatomic, assign) BOOL elite;

/** 聊股吧ID */
@property(nonatomic, assign) int64_t barId;

/** 置顶项类型（1 股吧内置顶，2全局置顶） */
@property(nonatomic, assign) BarTopType topType;

/** 发帖人uid */
@property(nonatomic, assign) int64_t uid;

/** 收藏时间 */
@property(nonatomic, assign) int64_t favourteTime;

@end

/** 微博内容信息：作者、内容 */
@interface WeiboContent : NSObject <ParseJson>

/** 发帖人 */
@property(nonatomic, strong) UserListItem *writer;

/** 聊股ID */
@property(nonatomic, assign) int64_t tstockid;

/** 用于时间顺序加载更多时使用 */
@property(nonatomic, assign) int64_t timelineid;

/** 发帖时间 */
@property(nonatomic, assign) int64_t ctime;

/** 标题 */
@property(nonatomic, strong) NSString *title;

/** 聊股内容 */
@property(nonatomic, strong) NSString *content;

/** 位置信息 */
@property(nonatomic, strong) NSString *position;

/** 聊股的类型 */
@property(nonatomic, assign) int type;

/** 聊股的类型 */
@property(nonatomic, assign) int stype;

/** 图片 */
@property(nonatomic, strong) NSArray *imgs;

/** 语音 */
@property(nonatomic, strong) NSObject *sound;

@end

/** 转发微博的原内容信息：作者、内容 */
@interface SourceWeiboContent : WeiboContent

@end

/** 聊股列表中单条聊股 */
@interface WeiboItemInList : BaseWeiboItem

/** 赞的数量 */
@property(nonatomic, assign) int praise;

/** 是否被自己赞过：通过本地缓存判断 */
@property(nonatomic, assign) BOOL isPraised;

/** 分享的数量 */
@property(nonatomic, assign) int share;

/** 评论数量 */
@property(nonatomic, assign) int comment;

/** 收藏数量 */
@property(nonatomic, assign) int collect;

/** 楼号 */
@property(nonatomic, assign) int floor;

/** 被收藏数量 */
@property(nonatomic, assign) int collectNum;

/** 赞的数量 */
@property(nonatomic, assign) int praiseNum;

/** 聊股内容 */
@property(nonatomic, strong) WeiboContent *content;

/** 被转发的聊股内容 */
@property(nonatomic, strong) SourceWeiboContent *sourceContent;

/** 股票代码 */
@property(nonatomic, strong) NSString *stockCode;

/** 比赛Id */
@property(nonatomic, assign) int matchId;

@end

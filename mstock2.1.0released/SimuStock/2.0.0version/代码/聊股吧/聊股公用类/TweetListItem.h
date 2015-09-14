//
//  TweetListItem.h
//  SimuStock
//
//  Created by jhss on 14-11-28.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonFormatRequester.h"
#import "UserListItem.h"
#import "BaseViewController.h"

static NSString *const HeightCacheKeyAll = @"all";
static NSString *const HeightCacheKeyTitle = @"title";
static NSString *const HeightCacheKeyContent = @"content";
static NSString *const HeightCacheKeySourceContent = @"o_content";
static NSString *const HeightCacheKeySourceAll = @"reply_block";
/**
 * 聊股类型：1：原创 2：转发 3：评论 4：回复 6：赞 7：收藏 8：分享
 * 9：关注 10：交易 13：系统消息 14:抓栈,-2：置顶区
 */
typedef NS_ENUM(NSInteger, WeiboType) {
  WeiboTypeOrigianl = 1,
  WeiboTypeForward = 2,
  WeiboTypeComment = 3,
  WeiboTypeReply = 4,
  WeiboTypePaise = 6,
  WeiboTypeCollect = 7,
  WeiboTypeShare = 8,
  WeiboTypeAttention = 9,
  WeiboTypeTrade = 10,
  WeiboTypeSystem = 13,
  WeiboTypeCaptureMessage = 14,
  WeiboTypeBottom = -1,
  WeiboTypeTopSection = -2
};
/**
 * 子类型 1：文字 2：图片 4：语音 8：买 16: 卖 32: 分红
 */
typedef NS_ENUM(NSInteger, WeiboSubType) {
  WeiboSubTypeText = 1,
  WeiboSubTypePic = 2,
  WeiboSubTypeVoice = 4,
  WeiboSubTypeBuy = 8,
  WeiboSubTypeSell = 16,
  WeiboSubTypeDividend = 32,
  WeiboSubTypeNodata = 0
};

@class FTCoreTextView;

/** 股聊信息列表类，包含用户信息，股聊信息。通用于热门推荐，我的股吧，热门股吧
 */
@interface TweetListItem : NSObject <ParseJson>

//@property(nonatomic,strong)NSString *content;

/** 发帖人信息 */
@property(strong, nonatomic) UserListItem *userListItem;

//聊股内容部分
/** 聊股类型
 1：原创
 2：转发
 3：评论
 4：回复
 6：赞
 7：收藏
 8：分享
 9：关注
 10：交易
 13：系统通知 */
@property(nonatomic) NSInteger type;

/** 聊股子类型 1：文字
 2：图片
 4：语音
 8：买
 16：卖
 32:除权除息
 */
@property(nonatomic) NSInteger stype;
/** [int]加精 null或0 普通帖  1 加精贴 */
@property(nonatomic) NSInteger elite;
/** 楼层_position */
@property(nonatomic) NSInteger floor;
/** 转发次数 */
@property(nonatomic) NSInteger repost;

//统计数据
/** 分享条数 */
@property(nonatomic) NSInteger share;
/** 赞的数量 */
@property(nonatomic) NSInteger praise;
/** 评论数量 */
@property(nonatomic) NSInteger comment;
/** 收藏数量 */
@property(nonatomic) NSInteger collect;

/** 图片集 */
@property(strong, nonatomic) NSArray *imgs;

/** 吧名 */
@property(copy, nonatomic) NSString *barName;
/** 位置 */
@property(copy, nonatomic) NSString *position;
/** 此聊股涉及的一些话题stirng数组 */
@property(strong, nonatomic) NSArray *subject;
/** 聊股内容 */
@property(copy, nonatomic) NSString *content;
/** talkTitle */
@property(copy, nonatomic) NSString *title;
/** [long]时间轴ID   参数中的maxID来源这个字段 */
@property(strong, nonatomic) NSNumber *timelineid;
/** 评论源聊股id */
@property(strong, nonatomic) NSNumber *tweetId;
/** 聊股id */
@property(strong, nonatomic) NSNumber *tstockid;
/** 大赛id */
@property(strong, nonatomic) NSNumber *matchid;
/** barID */
@property(strong, nonatomic) NSNumber *barId;
/** 发帖人id */
@property(strong, nonatomic) NSNumber *uid;
/** 发帖时间 long型毫秒数*/
@property(strong, nonatomic) NSNumber *ctime;
/** 原股聊信息（数据需要拆分） */
@property(strong, nonatomic) NSDictionary *source;
/** 语音(暂时没有) */
@property(strong, nonatomic) NSDictionary *sound;

/** 大赛matchid */
@property(copy, nonatomic) NSString *matchId;

//转发部分
/** 转发聊股类型 */
@property(nonatomic) NSInteger o_type;
/** 转发聊股子类型 */
@property(nonatomic) NSInteger o_stype;
/** 转发层 */
@property(nonatomic) NSInteger o_floor;
/** 转发位置 */
@property(copy, nonatomic) NSString *o_position;
/** 发帖人nickName */
@property(copy, nonatomic) NSString *o_nick;
/** 转发聊股正文 */
@property(copy, nonatomic) NSString *o_content;
/** 聊股内容页的回复，无昵称 */
@property(copy, nonatomic) NSString *o_content2;
/** 转发聊股id */
@property(strong, nonatomic) NSNumber *o_tstockid;
/** 转发聊股的发表时间 */
@property(strong, nonatomic) NSNumber *o_ctime;
/** 发帖人uid */
@property(strong, nonatomic) NSNumber *o_uid;
/** 转发聊股图片 */
@property(strong, nonatomic) NSArray *o_imgs;

/** 转发聊股语音 */
@property(strong, nonatomic) NSDictionary *o_sound;

@property(strong, nonatomic) NSMutableArray *contentArr;
/** 本地化图片存储 */
@property(strong, nonatomic) UIImage *image;
@property(strong, nonatomic) UIImage *o_image;

/** 高度缓存：图片以地址为key，富文本以内容为key，整体的key为all */
@property(strong, nonatomic) NSMutableDictionary *heightCache;

/** 是否已本地加赞 */
@property(nonatomic) BOOL isPraised;
/** 是否已本地收藏 */
@property(nonatomic) BOOL isCollected;

#pragma mark(YuLing)(发聊股，评论，回复)三个返回对象的初始化函数
///发聊股
- (id)initWithDistributeStockBarID:(NSString *)barId
                          andTitle:(NSString *)title
                        andContext:(NSString *)context
                          andImage:(UIImage *)image;

///评论
- (id)initWithReplyStocktalkId:(NSString *)talkId
                    andContext:(NSString *)context
                      andImage:(UIImage *)image;

///回复
- (id)initWithReviewStocktalkId:(NSString *)talkId
                     andContext:(NSString *)context
                       andImage:(UIImage *)image
                    andReviewID:(NSString *)reviewid
                 andTweetObject:(TweetListItem *)tweetObject;

///返回可点击的股吧名
- (NSString *)clickableBarName;

@end

@interface TweetList : JsonRequestObject <Collectionable>

//*************自定义数据部分*************
/** 股聊列表数据数组 */
@property(strong, nonatomic) NSMutableArray *tweetListArray;

/** 获得聊股首条内容详情页 */
+ (void)getTalkStockInitialContentWithTalkWeetId:(NSString *)talkID
                                    withCallback:(HttpRequestCallBack *)callback;
/** 获得聊股列表页 */
+ (void)getTalkStockListsContentWithTweetdic:(NSDictionary *)dic
                                withCallback:(HttpRequestCallBack *)callback;

/** 获取股聊列表，股聊吧 */
+ (void)requestGetBarNewTweetListDataWithBarId:(NSNumber *)barId
                                    withFromId:(NSNumber *)fromId
                                    withReqNum:(NSInteger)reqNum
                                  withCallback:(HttpRequestCallBack *)callback;

/** 获取加精列表(热门推荐详情页) */
+ (void)requestGetEliteListDataWithBarId:(NSNumber *)barId
                              withFromId:(NSNumber *)fromId
                              withReqNum:(NSInteger)reqNum
                            withCallback:(HttpRequestCallBack *)callback;

///收藏聊股分页
+ (void)requestGetFaverateTweetListWithFromId:(NSNumber *)fromId
                                   withReqNum:(NSInteger)reqNum
                                 withCallback:(HttpRequestCallBack *)callback;

/** 我的动态列表 */
+ (void)requestGetMyFollowListWithFromId:(NSNumber *)fromId
                              withReqNum:(NSInteger)reqNum
                            withCallback:(HttpRequestCallBack *)callback;

/** 行情聊股分页,fromId 为 0从头开始 */
+ (void)requestGetStockTopicTweetListWithParams:(NSDictionary *)dic
                                   withCallback:(HttpRequestCallBack *)callback;

/** 比赛聊股分页，fromId
 起始聊股ID；为0时  从头开始
 */
+ (void)requestGetSubjectTweetListWithParams:(NSDictionary *)dic
                                withCallback:(HttpRequestCallBack *)callback;

/** 热门分页数据请求, -1从头开始 */
+ (void)requestHotListWithFormId:(NSNumber *)fromId
                      withReqNum:(NSInteger)reqNum
                    withCallback:(HttpRequestCallBack *)callback;

/** 聊股 只看楼主 */
+ (void)justLookAtTheBuildingLordListsContentWithTweetDic:(NSDictionary *)dic
                                             withCallback:(HttpRequestCallBack *)callback;

@end

@interface WeiboContentWrapper : JsonRequestObject
/** 获得数据 */
@property(strong, nonatomic) TweetListItem *weibo;

/** 获得聊股首条内容详情页 */
+ (void)getTalkStockInitialContentWithTalkWeetId:(NSString *)talkID
                                    withCallback:(HttpRequestCallBack *)callback;

@end
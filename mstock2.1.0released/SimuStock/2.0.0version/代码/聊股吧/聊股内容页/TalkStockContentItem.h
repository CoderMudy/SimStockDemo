//
//  TalkStockContentItem.h
//  SimuStock
//
//  Created by jhss on 14-11-21.
//  Copyright (c) 2014年 Mac. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "JsonFormatRequester.h"
#import "UserListItem.h"

@class HttpRequestCallBack;
@interface TalkStockContentItem : JsonRequestObject
/** 获得数据 */
@property(strong, nonatomic) NSMutableArray *dataArray;

/** 获得聊股首条内容详情页 */
+ (void)getTalkStockInitialContentWithTalkWeetId:
            (NSString *)talkID withCallback:(HttpRequestCallBack *)callback;

/** 股吧id */
@property(strong, nonatomic) NSNumber *barId;
/** 聊股id */
@property(strong, nonatomic) NSNumber *tstockid;
/** 聊股吧名 */
@property(strong, nonatomic) NSString *barName;
/** 加精 */
@property(strong, nonatomic) NSString *elite;
/** 发布时间 */
@property(strong, nonatomic) NSNumber *ctime;
/** 聊股详情 */
@property(strong, nonatomic) NSString *content;
/** 聊股类型 */
@property(nonatomic) NSInteger type;
/** 赞的数量 */
@property(nonatomic) NSInteger praise;
/** 赞的状态 */
@property(nonatomic) BOOL isPraise;
/** 收藏数 */
@property(nonatomic) NSInteger collect;
/** 收藏状态 */
@property(nonatomic) BOOL isCollect;
/** 评论数量 */
@property(nonatomic) NSInteger comment;
/** 位置 */
@property(strong, nonatomic) NSString *position;
/** 聊股图片 */
@property(strong, nonatomic) NSArray *imgs;
/** 评论图片大小 */
@property(nonatomic) CGSize commentImgSize;
/** 转发 */
@property(nonatomic) NSInteger repost;
/** 分享 */
@property(nonatomic) NSInteger share;
/** stype聊股子类型 */
@property(nonatomic) NSInteger stype;
/** 头title */
@property(strong, nonatomic) NSString *title;

/** 作者 */
@property(strong, nonatomic) UserListItem *writer;

// source
/** 转发聊股id */
@property(strong, nonatomic) NSNumber *o_tstockid;
/** 转发人id */
@property(strong, nonatomic) NSNumber *o_uid;
/** 转发聊股正文 */
@property(strong, nonatomic) NSString *o_content;
/** 转发聊股类型 */
@property(nonatomic) NSInteger o_type;
/** 转发聊股子类型 */
@property(nonatomic) NSInteger o_stype;
/** 转发时间 */
@property(strong, nonatomic) NSString *o_ctime;
/** 转发图片 */
@property(strong, nonatomic) NSArray *o_imgs;
/** 转发图片大小 */
@property(nonatomic) CGSize o_imgSize;
/** 昵称 */
@property(strong, nonatomic) NSString *o_nick;
/** 楼层 */
@property(strong, nonatomic) NSString *o_floor;

@end

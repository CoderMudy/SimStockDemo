//
//  NewsChannelList.h
//  SimuStock
//
//  Created by Mac on 15/5/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

/** 单个频道信息 */
@interface NewsChannelItem : BaseRequestObject2

/** 频道Id */
@property(nonatomic, strong) NSString* channleID;

/** 频道名称 */
@property(nonatomic, strong) NSString* name;

/** 是否可编辑 */
@property(nonatomic, assign) BOOL isEditable;

/** 是否可见 */
@property(nonatomic, assign) BOOL isVisible;
@end

/** 频道列表 */
@interface NewsChannelList : JsonRequestObject<Collectionable>

/** 频道列表 */
@property(nonatomic, strong) NSMutableArray* channels;

/** 获取频道列表 */
+ (void)requestChannelListWithCallBack:(HttpRequestCallBack*)callback;

@end

/** 单个频道信息 */
@interface NewsInChannelItem : BaseRequestObject2

/** 新闻id */
@property(nonatomic, assign) long long id2;

/** 新闻发布时间 */
@property(nonatomic, assign) long long publishTime;

/** 新闻标题 */
@property(nonatomic, strong) NSString* title;

/** 新闻url */
@property(nonatomic, strong) NSString* url;
@end

/** 频道列表 */
@interface NewsListInChannel : JsonRequestObject<Collectionable>

/** 频道列表 */
@property(nonatomic, strong) NSMutableArray* newsList;

/** 获取频道的新闻列表 */
+ (void)requestNewsListWithInputParmeters:(NSDictionary*)dic
                             withCallBack:(HttpRequestCallBack*)callback;

@end
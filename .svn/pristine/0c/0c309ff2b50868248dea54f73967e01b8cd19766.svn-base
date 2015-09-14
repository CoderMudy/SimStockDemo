//
//  FileStoreUtil.h
//  SimuStock
//
//  Created by Mac on 15/5/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsChannelList.h"
#import "CacheUtil.h"
#import "UserBpushInformationNum.h"
#import "UniversityInfoData.h"

@interface FileStoreUtil : NSObject

/** 以指定的key保存数据 */
+ (void)saveCacheData:(id)data withKey:(NSString *)key;

/** 以指定的key加载数据 */
+ (id)loadCacheWithKey:(NSString *)key withClassType:(Class)cls;

///存储股市内参我的频道
+ (void)saveMyNewsChannelList:(NewsChannelList *)data;

///加载股市内参我的频道
+ (NewsChannelList *)loadMyNewsChannelList;

///存储股市内参其他的频道
+ (void)saveMoreNewsChannelList:(NewsChannelList *)data;

///加载股市内参其他的频道
+ (NewsChannelList *)loadMoreNewsChannelList;

///存储消息中心未读数统计数据
+ (void)saveUserBpushInformationNum:(UserBpushInformationNum *)data;

///加载消息中心未读数统计数据
+ (UserBpushInformationNum *)loadUserBpushInformationNum;

///存储搜索高校列表
+ (void)saveMatchUniversityNameList:(UniversityInfoData *)data;
///加载高校列表
+ (UniversityInfoData *)loadMatchUniversityNameList;

@end

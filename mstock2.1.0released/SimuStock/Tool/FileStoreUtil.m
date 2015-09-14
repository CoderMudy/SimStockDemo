//
//  FileStoreUtil.m
//  SimuStock
//
//  Created by Mac on 15/5/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "FileStoreUtil.h"
#import "ObjectJsonMappingUtil.h"
#import "FTWCache.h"

///选择的频道
static NSString *const CACHE_MY_NEWSChannels = @"my_news_channel_list";
///未选中的频道
static NSString *const CACHE_More_NEWSChannels = @"more_news_channel_list";

///消息中心未读数统计数据
static NSString *const CACHE_UnReadMessageNum =
    @"CACHE_UserBpushInformationNum";

///选择高校，高校名称列表
static NSString *const CACHE_MATCH_UNIVERSITY_NAME = @"match_university_name_list";

@implementation FileStoreUtil

+ (void)saveCacheData:(id)data withKey:(NSString *)key {
  if (key == nil) {
    return;
  }
  NSDictionary *dicData = [ObjectJsonMappingUtil getObjectData:data];
  NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:dicData];
  [FTWCache setObject:myData forKey:key];
}

+ (id)loadCacheWithKey:(NSString *)key withClassType:(Class)cls {
  if (key == nil) {
    return nil;
  }

  @try {
    NSData *data =
        [FTWCache objectForKey:key withTimeOutSecond:60 * 60 * 24 * 100000];
    if (data) {
      NSDictionary *dic =
          (NSDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
      return [[cls alloc] initWithDictionary:dic];
    }
  } @catch (NSException *exception) {
    NSLog(@"%@", exception);
    [FTWCache removeKeyOfObjcet:key];
  }
  return nil;
}
///加载股市内参我选择的频道
+ (void)saveMyNewsChannelList:(NewsChannelList *)data {
  [FileStoreUtil saveCacheData:data withKey:CACHE_MY_NEWSChannels];
}
+ (void)saveMoreNewsChannelList:(NewsChannelList *)data {
  [FileStoreUtil saveCacheData:data withKey:CACHE_More_NEWSChannels];
}

+ (NewsChannelList *)loadMyNewsChannelList {
  return [FileStoreUtil loadCacheWithKey:CACHE_MY_NEWSChannels
                           withClassType:[NewsChannelList class]];
}
///加载股市内参其他的频道
+ (NewsChannelList *)loadMoreNewsChannelList {
  return [FileStoreUtil loadCacheWithKey:CACHE_More_NEWSChannels
                           withClassType:[NewsChannelList class]];
}

///存储消息中心未读数统计数据
+ (void)saveUserBpushInformationNum:(UserBpushInformationNum *)data {
  NSString *key = [CacheUtil getUserKey:CACHE_UnReadMessageNum];
  [FileStoreUtil saveCacheData:data withKey:key];
  ///刷新 推送各类型的个数
  [[NSNotificationCenter defaultCenter]
      postNotificationName:MessageCenterNotification
                    object:nil];
}

///加载消息中心未读数统计数据
+ (UserBpushInformationNum *)loadUserBpushInformationNum {
  NSString *key = [CacheUtil getUserKey:CACHE_UnReadMessageNum];
  return [FileStoreUtil loadCacheWithKey:key
                           withClassType:[UserBpushInformationNum class]];
}
///存储搜索高校列表
+ (void)saveMatchUniversityNameList:(UniversityInfoData *)data{
[FileStoreUtil saveCacheData:data withKey:CACHE_MATCH_UNIVERSITY_NAME];
}
///加载高校列表
+ (UniversityInfoData *)loadMatchUniversityNameList{
  return [FileStoreUtil loadCacheWithKey:CACHE_MATCH_UNIVERSITY_NAME
                           withClassType:[UniversityInfoData class]];
}

@end

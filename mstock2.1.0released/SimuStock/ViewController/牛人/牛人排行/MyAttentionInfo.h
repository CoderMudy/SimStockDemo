//
//  MyAttentionInfo.h
//  SimuStock
//
//  Created by jhss on 13-12-16.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyAttentionInfoItem.h"

@interface MyAttentionInfo : NSObject {
  NSString *attentionUrl;
}

@property(strong, nonatomic) MyAttentionList *myAttentionsArray;

/// 单例
+ (MyAttentionInfo *)sharedInstance;

/// 解析
- (void)startGetAttentionInfo;

/// 通过用户的名称获取，用户的userID
- (NSString *)isKindOfMyContactWithuserID:(NSString *)nickName;

/// 取消关注
- (void)deleteItemFromAttentionArray:(NSString *)userId;

/// 关注
- (void)addItemToAttentionArray:(MyAttentionInfoItem *)item;

- (NSMutableArray *)getAttentionArray;

- (BOOL)isAttentionWithUserId:(NSString *)userId;

@end

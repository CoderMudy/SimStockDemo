//
//  MessageCenterCoreDataUtil.h
//  SimuStock
//
//  Created by moulin wang on 14-12-26.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MessageTypeUnReadNum.h"
#import "AppDelegate.h"

typedef NS_ENUM(NSUInteger, MessageType) {
  MessageTypeAtMe = 2,
  MessageTypeComment = 1,
  MessageTypeAttention = 3,
  MessageTypePraise = 4,
  MessageSystemType = 5,
  MessageTypeStockWarning = 6,
  MessageTypeVip = 7,
//  MessageTypeMasterPlan = 8,
};

@interface MessageCenterCoreDataUtil : NSObject

/** 查询指定类型的消息的未读数信息 */
+ (MessageTypeUnReadNum *)findMessageTypeUnReadNumWithUid:(NSString *)uid
                                          withMessageType:(MessageType)type;

/** 修改指定类型的消息的未读数，clear = YES, 将未读数修改为0； 否则未读数加1 */
+ (void)changeMessageTypeUnReadNumWithUid:(NSString *)uid
                                 withType:(MessageType)type
                                  isClear:(BOOL)clear;

@end

//
//  MesCallMeCoreDataUtil.h
//  SimuStock
//
//  Created by moulin wang on 14-12-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MessageUnReadStatus.h"
#import "SimuUtil.h"
#import "AppDelegate.h"
#import "MessageCenterListWrapper.h"

/**类说明：@我的CoreData数据类*/
@interface MesCallMeCoreDataUtil : NSObject

/** 初始化消息的未读状态 */
+ (void)initMessageStatus:(MessageListItem *)message withType:(NSString *)type;

/** 清除消息的未读状态 */
+ (void)clearUnReadStatusWithUid:(NSString *)uid
                       messageId:(NSString *)msgid
                            type:(NSString *)type;

/**查（CallMe返回，uid用户，msgid信息，type层级）*/
+ (MessageUnReadStatus *)findMessageStatusWithUid:(NSString *)uid
                              withMessageId:(NSString *)msgid
                                   withType:(NSString *)type;

@end

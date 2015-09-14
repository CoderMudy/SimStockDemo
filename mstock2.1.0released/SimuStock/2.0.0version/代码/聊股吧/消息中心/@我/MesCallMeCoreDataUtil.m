//
//  MesCallMeCoreDataUtil.m
//  SimuStock
//
//  Created by moulin wang on 14-12-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "MesCallMeCoreDataUtil.h"

@implementation MesCallMeCoreDataUtil

+ (NSString *)tableName {
  return NSStringFromClass(MessageUnReadStatus.class);
}

#pragma mark---------------CoreData（增）---------------

+ (void)initMessageStatus:(MessageListItem *)message withType:(NSString *)type {
  NSString *dotUid = [NSString stringWithFormat:@"%d", [message.uid intValue]];
  NSString *dotMsgId = [NSString stringWithFormat:@"%@", message.msgid];
  MessageUnReadStatus *callMe =
      [MesCallMeCoreDataUtil findMessageStatusWithUid:dotUid
                                        withMessageId:dotMsgId
                                             withType:type];
  if (callMe) {
    message.read = callMe.read;
  } else {
    message.read = NO;

    NSManagedObjectContext *context = [AppDelegate getManagedObjectContext];

    callMe = (MessageUnReadStatus *)
        [NSEntityDescription insertNewObjectForEntityForName:self.tableName
                                      inManagedObjectContext:context];
    callMe.uid = dotUid;
    callMe.msgId = dotMsgId;
    callMe.read = NO;
    callMe.type = type;
    //保存插入数据
    NSError *error;
    if ([context save:&error]) {
      NSLog(@"消息中心二级界面数据保存成功");
    } else {
      NSLog(@"%@", error);
    }
  }
}

#pragma mark---------------CoreData（改）---------------

+ (void)clearUnReadStatusWithUid:(NSString *)uid
                       messageId:(NSString *)msgid
                            type:(NSString *)type {
  //获取context
  NSManagedObjectContext *context = [AppDelegate getManagedObjectContext];

  MessageUnReadStatus *info =
      [self findMessageStatusWithUid:uid withMessageId:msgid withType:type];
  if (info) {
    info.read = YES;
    //保存
    NSError *error;
    if ([context save:&error]) {
      NSLog(@"更新成功");
    }
  }
}

#pragma mark---------------CoreData（查）---------------
+ (MessageUnReadStatus *)findMessageStatusWithUid:(NSString *)uid
                              withMessageId:(NSString *)msgid
                                   withType:(NSString *)type {
  //获取context
  NSManagedObjectContext *context = [AppDelegate getManagedObjectContext];
  //获取实体描述（sqlite获取表明）
  NSEntityDescription *entityDescription =
      [NSEntityDescription entityForName:self.tableName
                  inManagedObjectContext:context];
  //生成查询请求
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:entityDescription];
  [fetchRequest setFetchLimit:1];
  //查询条件
  NSPredicate *predicate = [NSPredicate
      predicateWithFormat:@"(uid == %@) AND (msgId == %@) AND (type == %@)",
                          uid, msgid, type];
  [fetchRequest setPredicate:predicate];
  //执行查询
  NSError *error;
  NSArray *fetchedObjects =
      [context executeFetchRequest:fetchRequest error:&error];

  if (fetchedObjects && [fetchedObjects count] >= 1) {
    return fetchedObjects[0];
  }
  return nil;
}

@end

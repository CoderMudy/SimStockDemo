//
//  MessageCenterCoreDataUtil.m
//  SimuStock
//
//  Created by moulin wang on 14-12-26.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "MessageCenterCoreDataUtil.h"

@implementation MessageCenterCoreDataUtil

+ (MessageTypeUnReadNum *)findMessageTypeUnReadNumWithUid:(NSString *)uid
                                          withMessageType:(MessageType)type {
  //获取context
  NSManagedObjectContext *context = [AppDelegate getManagedObjectContext];
  //获取实体描述（sqlite获取表明）
  NSEntityDescription *entityDescription = [NSEntityDescription
               entityForName:NSStringFromClass(MessageTypeUnReadNum.class)
      inManagedObjectContext:context];
  //生成查询请求
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:entityDescription];
  //查询条件
  NSPredicate *predicate =
      [NSPredicate predicateWithFormat:@"(uid == %@ and type == %@)", uid,
                                       [NSString stringWithFormat:@"%ld", (long)type]];
  [fetchRequest setPredicate:predicate];
  //执行查询
  NSError *error;
  NSArray *fetchedObjects =
      [context executeFetchRequest:fetchRequest error:&error];

  if (fetchedObjects && [fetchedObjects count] > 1) {
    return fetchedObjects[0];
  }
  return nil;
}

+ (void)changeMessageTypeUnReadNumWithUid:(NSString *)uid
                                 withType:(MessageType)type
                                  isClear:(BOOL)clear {
  //已经存入过红点，就不再储存
  MessageTypeUnReadNum *mesCenter =
      [self findMessageTypeUnReadNumWithUid:uid withMessageType:type];
  //获取context
  NSManagedObjectContext *context = [AppDelegate getManagedObjectContext];
  if (mesCenter == nil) {
    //插入对象
    mesCenter = (MessageTypeUnReadNum *)[NSEntityDescription
        insertNewObjectForEntityForName:NSStringFromClass(
                                            MessageTypeUnReadNum.class)
                 inManagedObjectContext:context];
    mesCenter.uid = uid;
    mesCenter.type = [NSString stringWithFormat:@"%ld", (long)type];
    if (clear) {
      mesCenter.unReadNum = 0;
    } else {
      mesCenter.unReadNum = 1;
    }

  } else {
    if (clear) {
      mesCenter.unReadNum = 0;
    } else {
      mesCenter.unReadNum = mesCenter.unReadNum + 1;
    }
  }
  //保存插入数据
  NSError *error;
  if ([context save:&error]) {
    NSLog(@"save praised tid success");
  } else {
    NSLog(@"%@", error);
  }
}

@end

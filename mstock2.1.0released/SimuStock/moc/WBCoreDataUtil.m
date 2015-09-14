//
//  WBCoreDataUtil.m
//  SimuStock
//
//  Created by Yuemeng on 14/12/17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "WBCoreDataUtil.h"
#import <CoreData/CoreData.h>
#import "SimuUtil.h"

#import "PraiseEntity.h"
#import "CollectEntity.h"
#import "MyBarsEntity.h"

@implementation WBCoreDataUtil


#pragma mark - 赞
//插入已赞聊股
+ (void)insertPraiseTid:(NSNumber *)tid {
  //先查询是否存在，如果存在则return
  if ([self fetchPraiseTid:tid]) {
    return;
  }
  //获取Context
  NSManagedObjectContext *context = [AppDelegate getManagedObjectContext];
  //插入对象
  PraiseEntity *praise = (PraiseEntity *)
      [NSEntityDescription insertNewObjectForEntityForName:@"PraiseEntity"
                                    inManagedObjectContext:context];
  //设置属性
  praise.tid = tid;
  praise.uid = [SimuUtil getUserID];
  //保存插入数据
  NSError *error;
  if ([context save:&error]) {
    NSLog(@"save praised tid success");
  } else {
    NSLog(@"error:%@", error);
  }
  //  NSLog(@"存储赞股聊：%@", [tid stringValue]);
}

//查聊股
+ (BOOL)fetchPraiseTid:(NSNumber *)tid {

  //获取context
  NSManagedObjectContext *context = [AppDelegate getManagedObjectContext];
  //获取实体描述
  NSEntityDescription *entityDescription =
      [NSEntityDescription entityForName:@"PraiseEntity"
                  inManagedObjectContext:context];
  //生成查询请求
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:entityDescription];
  //设置查询条件
  NSPredicate *predicate =
      [NSPredicate predicateWithFormat:@"(uid == %@) AND (tid == %@)",
                                       [SimuUtil getUserID], tid];
  [fetchRequest setPredicate:predicate];
  //执行查询
  NSError *error;
  //  NSLog(@"查询赞股聊：%@", [tid stringValue]);

//  NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
//  if (results.count > 0) {
//    return YES;
//  } else {
//    NSLog(@"error:%@", error);
//    return NO;
//  }
  return [context executeFetchRequest:fetchRequest error:&error].count > 0;
}

//删除赞聊股
+ (void)deletePraiseTid:(NSNumber *)tid {
  NSManagedObjectContext *context = [AppDelegate getManagedObjectContext];
  NSEntityDescription *entityDescription =
      [NSEntityDescription entityForName:@"PraiseEntity"
                  inManagedObjectContext:context];
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:entityDescription];
  [fetchRequest
      setPredicate:[NSPredicate predicateWithFormat:
                                    [NSString stringWithFormat:@"%@ = %@",
                                                               @"tid", tid]]];
  NSError *error;
  NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
  if (results.count > 0) {
    [context deleteObject:results[0]];
  } else {
    NSLog(@"赞股聊%@不存在! 无法删除", [tid stringValue]);
  }
  //存储改变
  if ([context save:&error]) {
    NSLog(@"delete praised tid success");
  } else {
    NSLog(@"error:%@", error);
  }
  //  NSLog(@"删除赞股聊：%@", [tid stringValue]);
}

#pragma mark - 收藏
+ (void)insertCollectTid:(NSNumber *)tid {
  if ([self fetchCollectTid:tid]) {
    return;
  }
  //获取Context
  NSManagedObjectContext *context = [AppDelegate getManagedObjectContext];
  //插入对象
  CollectEntity *praise = (CollectEntity *)
      [NSEntityDescription insertNewObjectForEntityForName:@"CollectEntity"
                                    inManagedObjectContext:context];
  //设置属性
  praise.tid = tid;
  praise.uid = [SimuUtil getUserID];
  //保存插入数据
  NSError *error;
  if ([context save:&error]) {
    NSLog(@"save collect tid success");
  } else {
    NSLog(@"error:%@", error);
  }
}

+ (BOOL)fetchCollectTid:(NSNumber *)tid {
  //获取context
  NSManagedObjectContext *context = [AppDelegate getManagedObjectContext];
  //获取实体描述
  NSEntityDescription *entityDescription =
      [NSEntityDescription entityForName:@"CollectEntity"
                  inManagedObjectContext:context];
  //生成查询请求
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:entityDescription];
  //设置查询条件
  NSPredicate *predicate =
      [NSPredicate predicateWithFormat:@"(uid == %@) AND (tid == %@)",
                                       [SimuUtil getUserID], tid];
  [fetchRequest setPredicate:predicate];
  //执行查询
  NSError *error;
  //  NSLog(@"查询赞股聊：%@", [tid stringValue]);

  return [context executeFetchRequest:fetchRequest error:&error].count > 0;
}

+ (void)deleteCollectTid:(NSNumber *)tid {
  NSManagedObjectContext *context = [AppDelegate getManagedObjectContext];
  NSEntityDescription *entityDescription =
      [NSEntityDescription entityForName:@"CollectEntity"
                  inManagedObjectContext:context];
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:entityDescription];
  [fetchRequest
      setPredicate:[NSPredicate predicateWithFormat:
                                    [NSString stringWithFormat:@"%@ = %@",
                                                               @"tid", tid]]];
  NSError *error;
  NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
  if (results.count > 0) {
    [context deleteObject:results[0]];
  } else {
    NSLog(@"收藏股聊%@不存在! 无法删除", [tid stringValue]);
  }
  //存储改变
  if ([context save:&error]) {
    NSLog(@"delete collect tid success");
  } else {
    NSLog(@"error:%@", error);
  }
}

#pragma mark - 加入的吧
+ (void)insertBarId:(NSNumber *)barid {
  //先查询是否存在，如果存在则return
  if ([self fetchBarId:barid]) {
    NSLog(@"已本地存储%@,不再存储", barid);
    return;
  }
  //获取Context
  NSManagedObjectContext *context = [AppDelegate getManagedObjectContext];
  //插入对象
  MyBarsEntity *myBars = (MyBarsEntity *)
      [NSEntityDescription insertNewObjectForEntityForName:@"MyBarsEntity"
                                    inManagedObjectContext:context];
  //设置属性
  myBars.barid = barid;
  myBars.uid = [SimuUtil getUserID];
  //保存插入数据
  NSError *error;
  if ([context save:&error]) {
    NSLog(@"存储 barid 成功！");
  } else {
    NSLog(@"error:%@", error);
  }
}

+ (BOOL)fetchBarId:(NSNumber *)barid {
  //获取context
  NSManagedObjectContext *context = [AppDelegate getManagedObjectContext];
  //获取实体描述
  NSEntityDescription *entityDescription =
      [NSEntityDescription entityForName:@"MyBarsEntity"
                  inManagedObjectContext:context];
  //生成查询请求
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:entityDescription];
  //设置查询条件
  NSPredicate *predicate =
      [NSPredicate predicateWithFormat:@"(uid == %@) AND (barid == %@)",
                                       [SimuUtil getUserID], barid];
  [fetchRequest setPredicate:predicate];
  //执行查询
  NSError *error;
  NSLog(@"查询barid：%@", [barid stringValue]);

  return [context executeFetchRequest:fetchRequest error:&error].count > 0;
}

+ (void)deleteBarId:(NSNumber *)barid {
  NSManagedObjectContext *context = [AppDelegate getManagedObjectContext];
  NSEntityDescription *entityDescription =
      [NSEntityDescription entityForName:@"MyBarsEntity"
                  inManagedObjectContext:context];
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:entityDescription];
  [fetchRequest
      setPredicate:[NSPredicate
                       predicateWithFormat:@"(uid == %@) AND (barid == %@)",
                                           [SimuUtil getUserID], barid]];
  NSError *error;
  NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
  if (results.count > 0) {
    [context deleteObject:results[0]];
    NSLog(@"已删除barid：%@", [barid stringValue]);
  } else {
    NSLog(@"barid%@不存在! 无法删除", [barid stringValue]);
  }
  
  if ([context save:&error]) {
    NSLog(@"数据库同步成功！");
  } else {
    NSLog(@"error:%@", error);
  }
}

  //清空用户所有barIds
+ (void)clearBarIds
{
  NSManagedObjectContext *context = [AppDelegate getManagedObjectContext];
  NSEntityDescription *entityDescription =
  [NSEntityDescription entityForName:@"MyBarsEntity"
              inManagedObjectContext:context];
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:entityDescription];
  [fetchRequest
   setPredicate:[NSPredicate
                 predicateWithFormat:@"uid = %@",
                 [SimuUtil getUserID]]];
  NSError *error;
  NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
  if (results.count > 0) {
    for (NSManagedObject *obj in results) {
      [context deleteObject:obj];
    }
    NSLog(@"删除本地存储聊股吧");
  } else {
    NSLog(@"我的聊股吧为空，清除本地barid失败");
  }
  
  if ([context save:&error]) {
    NSLog(@"数据库同步成功！");
  } else {
    NSLog(@"error:%@", error);
  }

}

@end

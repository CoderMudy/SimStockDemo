//
//  StockWarningController.m
//  SimuStock
//
//  Created by Mac on 15/4/19.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "StockWarningController.h"
#import "AppDelegate.h"
#import "SimuUtil.h"
#import "NSString+MD5Addition.h"


@implementation StockWarningController


+ (StockWarningController *)sharedManager {

  static StockWarningController *sharedStockAlarmManager = nil;
  
  static dispatch_once_t predicate; dispatch_once(&predicate, ^{
    sharedStockAlarmManager = [[self alloc] init];
  });

  return sharedStockAlarmManager;
}

- (NSString *)tableName {
  return NSStringFromClass(StockAlarmEntity.class);
}

///添加数据
- (void)addCoredataWithUid:(NSString *)uid
                   Withmsg:(NSString *)msg
              WithsendTime:(NSString *)sendtime
             WithfirstType:(NSNumber *)firstType
              andStockName:(NSString *)stockName
              andStockCode:(NSString *)stockCode {
  if (!uid || [uid length] == 0 || [uid isEqualToString:@"-1"]) {
    return;
  }
  NSString* md5= [[NSString stringWithFormat:@"%@%@%@%@%@%@",uid,msg,stockCode,stockName,sendtime,firstType] stringFromMD5];
  [self deleteWithMd5:md5];

  //获取Context
  NSManagedObjectContext *context = [AppDelegate getManagedObjectContext];
  //插入对象
  StockAlarmEntity *entry = (StockAlarmEntity *)
      [NSEntityDescription insertNewObjectForEntityForName:self.tableName
                                    inManagedObjectContext:context];

  entry.ruid = uid;
  entry.msg = msg;
  entry.stockcode = stockCode;
  entry.stockname = stockName;
  entry.sendTime = sendtime;
  entry.firstType = firstType;
  entry.ctime = [NSDate date];
  entry.md5 = md5;
  //保存插入数据
  NSError *error;
  if ([context save:&error]) {
    NSLog(@"save YL_NetworkQueue_Data success");
  } else {
    NSLog(@"error:%@", error);
  }
}

///获取股票预警的剩余所有数据
- (NSArray *)getStockAlarmsWithStartDate:(NSDate*) date withReqestNum: (NSInteger) requestNum {
  //获取context
  NSManagedObjectContext *context = [AppDelegate getManagedObjectContext];
  NSEntityDescription *entityDescription =
      [NSEntityDescription entityForName:self.tableName
                  inManagedObjectContext:context];
  //生成查询请求
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:entityDescription];
  //设置查询条件
  NSPredicate *predicate =
  [NSPredicate predicateWithFormat:@"(ruid == %@) and (ctime < %@)", [SimuUtil getUserID], date?date:[NSDate date]];
  [fetchRequest setPredicate:predicate];
  
  //设置排序条件
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ctime"
                                                                 ascending:NO];
  NSArray *sortDescriptors = @[sortDescriptor];
  [fetchRequest setSortDescriptors:sortDescriptors];
  //设置查询数
  [fetchRequest setFetchLimit:requestNum];
  
  NSError *error;
  NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
  if (results.count > 0) {
  } else {
    NSLog(@"当前用户,没有未完成的网络请求队栈");
  }
  return results;
}

///重新启动网络请求时,删除coredata 数据库中的数据
- (void)deleteCoreDataObject:(NSManagedObject *)object {
  NSManagedObjectContext *context = [AppDelegate getManagedObjectContext];
  if (object) {
    [context deleteObject:object];
  }
}

///删除所有数据
- (void)deleteWithMd5:(NSString *)md5 {
  NSManagedObjectContext *context = [AppDelegate getManagedObjectContext];
  NSEntityDescription *entityDescription =
  [NSEntityDescription entityForName:self.tableName
              inManagedObjectContext:context];
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:entityDescription];
  [fetchRequest
   setPredicate:[NSPredicate predicateWithFormat:@"(md5 == %@)", md5]];
  NSError *error;
  NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
  if (results.count > 0) {
    for (NSManagedObject *obj in results) {
      [context deleteObject:obj];
    }
  } else {
    NSLog(@"删除网络请求队栈失败:%@", error);
  }
  
  if ([context save:&error]) {
    NSLog(@"数据库同步成功！");
  } else {
    NSLog(@"error:%@", error);
  }
}

///删除所有数据
- (void)deleteWithruid:(NSString *)ruid {
  NSManagedObjectContext *context = [AppDelegate getManagedObjectContext];
  NSEntityDescription *entityDescription =
      [NSEntityDescription entityForName:self.tableName
                  inManagedObjectContext:context];
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:entityDescription];
  [fetchRequest
      setPredicate:[NSPredicate predicateWithFormat:@"(ruid == %@)", ruid]];
  NSError *error;
  NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
  if (results.count > 0) {
    for (NSManagedObject *obj in results) {
      [context deleteObject:obj];
    }
    NSLog(@"发表成功，删除成功");
  } else {
    NSLog(@"删除网络请求队栈失败:%@", error);
  }

  if ([context save:&error]) {
    NSLog(@"数据库同步成功！");
  } else {
    NSLog(@"error:%@", error);
  }
}

@end

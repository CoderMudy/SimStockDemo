//
//  YL_NetworkQueue_Single.m
//  SimuStock
//
//  Created by Mac on 15/1/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "UploadRequestController.h"

@implementation UploadRequestObject

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
}

@end

static UploadRequestController *_sharedManager = nil;

@implementation UploadRequestController

+ (UploadRequestController *)sharedManager {
  @synchronized([UploadRequestController class]) {
    if (!_sharedManager)
      _sharedManager = [[self alloc] init];
    return _sharedManager;
  }
  return nil;
}

+ (id)alloc {
  @synchronized([UploadRequestController class]) {
    NSAssert(_sharedManager == nil, @"Attempted to allocated a second instance");
    _sharedManager = [super alloc];
    return _sharedManager;
  }
  return nil;
}

- (void)NetworkQueue_returnBlock:(NSString *)url
                       andMethod:(NSString *)requestMethod
                          andDic:(NSMutableDictionary *)dicionary {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  JsonFormatRequester *requester = [[JsonFormatRequester alloc] init];

  callback.onSuccess = ^(NSObject *object) {
    NSLog(@"聊股，发布成功");
    [[UploadRequestController sharedManager] deletePathUrl:url
                                                 andMethod:requestMethod
                                                    andDic:[dicionary JSONString]];
  };
  callback.onError = ^(BaseRequestObject *error, NSException *ex) {
  };
  callback.onFailed = ^{
  };
  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:requestMethod
                 withRequestParameters:dicionary
                withRequestObjectClass:[UploadRequestObject class]
               withHttpRequestCallBack:callback];
}

- (void)addCoredata:(NSString *)url andMethod:(NSString *)requestMethod andDic:(NSDictionary *)dic {
  //获取Context
  NSManagedObjectContext *context = [AppDelegate getManagedObjectContext];
  //插入对象
  UploadRequestData *NetworkQueue =
      (UploadRequestData *)[NSEntityDescription insertNewObjectForEntityForName:self.tableName
                                                         inManagedObjectContext:context];

  NetworkQueue.uid = [SimuUtil getUserID];
  NetworkQueue.pathUrl = url;
  NetworkQueue.type = requestMethod;
  NetworkQueue.image = nil;
  /// dic 转化成 json数据字符串
  NetworkQueue.context = [dic JSONString];

  //保存插入数据
  NSError *error;
  if ([context save:&error]) {
    NSLog(@"save YL_NetworkQueue_Data success");
  } else {
    NSLog(@"error:%@", error);
  }
}
//获取，网络队栈中的剩余数据
- (NSArray *)get_All_NetworkQueueData {
  //获取context
  NSManagedObjectContext *context = [AppDelegate getManagedObjectContext];
  NSEntityDescription *entityDescription =
      [NSEntityDescription entityForName:self.tableName inManagedObjectContext:context];
  //生成查询请求
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:entityDescription];
  //设置查询条件
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(uid == %@)", [SimuUtil getUserID]];
  [fetchRequest setPredicate:predicate];
  NSError *error;
  NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
  if (results.count > 0) {
  } else {
    NSLog(@"当前用户,没有未完成的网络请求队栈");
  }
  //存储改变(没有改变，为何存储--Yuemeng)
  //  if ([context save:&error]) {
  //    NSLog(@"获取 uid=%@ success", [SimuUtil getUserID]);
  //  } else {
  //    NSLog(@"error:%@", error);
  //  }
  return results;
}

///重新启动网络请求时,删除coredata 数据库中的数据
- (void)deleteCoreDataObject:(NSManagedObject *)object {
  NSManagedObjectContext *context = [AppDelegate getManagedObjectContext];
  if (object) {
    [context deleteObject:object];
  }
}

///删除已经请求成功的，数据
- (void)deletePathUrl:(NSString *)url andMethod:(NSString *)method andDic:(NSString *)dic {
  NSManagedObjectContext *context = [AppDelegate getManagedObjectContext];
  NSEntityDescription *entityDescription =
      [NSEntityDescription entityForName:self.tableName inManagedObjectContext:context];
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:entityDescription];
  [fetchRequest
      setPredicate:[NSPredicate
                       predicateWithFormat:@"(uid == %@) AND (pathUrl " @"== %@) AND (type == %@) " @"AND (context == %@)",
                                           [SimuUtil getUserID], url, method, dic]];
  NSError *error;
  NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
  if (results.count > 0) {
    [context deleteObject:results[0]];
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

- (NSString *)tableName {
  return NSStringFromClass(UploadRequestData.class);
}

///重启，当前用户所有被关闭的网络线程
- (void)RestartNetworkQueue {
  NSArray *array = [[UploadRequestController sharedManager] get_All_NetworkQueueData];
  if (array.count > 0) {
    for (int i = 0; i < array.count; i++) {
      UploadRequestData *tt = (UploadRequestData *)array[i];
      [[UploadRequestController sharedManager] NetworkQueue_returnBlock:tt.pathUrl
                                                              andMethod:tt.type
                                                                 andDic:[tt.context objectFromJSONString]];
    }
  }
}

@end

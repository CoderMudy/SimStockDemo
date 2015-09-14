//
//  YL_NetworkQueue_Single.h
//  SimuStock
//
//  Created by Mac on 15/1/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadRequestData.h"
#import "JsonFormatRequester.h"
///发表聊股的共同（父类）
@interface UploadRequestObject : JsonRequestObject

@end

@interface UploadRequestController : NSObject

///单例对象（从新启动网络请求单例对象）
+ (UploadRequestController *)sharedManager;

///重新启动（被关闭）网络请求
- (void)NetworkQueue_returnBlock:(NSString *)url
                       andMethod:(NSString *)requestMethod
                          andDic:(NSMutableDictionary *)dicionary;

///添加，网络请求对象，到 coredata数据库中
- (void)addCoredata:(NSString *)url
          andMethod:(NSString *)requestMethod
             andDic:(NSDictionary *)dic;

//获取，网络队栈中的(当前用户uid)剩余数据,用于后面从新启动网络请求
- (NSArray *)get_All_NetworkQueueData;

///重新启动网络请求时,删除coredata 数据库中的数据
- (void)deleteCoreDataObject:(NSManagedObject *)object;

///删除已经请求成功的，数据
- (void)deletePathUrl:(NSString *)url
            andMethod:(NSString *)method
               andDic:(NSString *)dic;

///重启，当前用户所有被关闭的网络线程
- (void)RestartNetworkQueue;
@end

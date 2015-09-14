//
//  CoreDataController.h
//  SimuStock
//
//  Created by Mac on 15/1/26.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

static NSString *const CoreDataDatabaseName = @"MocModel.sqlite";

@interface CoreDataController : NSObject

/** 返回单例 */
+ (CoreDataController *)sharedInstance;

/** 是否需要迁移数据 */
- (BOOL)isMigrationNeeded;

/** 迁移数据 */
- (BOOL)migrate:(NSError *__autoreleasing *)error;

/** 数据库存储路径 */
- (NSURL *)sourceStoreURL;

- (BOOL)prepare;

- (void)importSecuritiesDataWithContext:(NSManagedObjectContext *)context;

- (void)removeCoreDataFile;

@property(nonatomic, readonly, strong) NSManagedObjectModel *managedObjectModel;

@property(nonatomic, readonly, strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, readonly, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property(nonatomic, readonly, strong) NSManagedObjectContext *childThreadManagedObjectContext;

@end

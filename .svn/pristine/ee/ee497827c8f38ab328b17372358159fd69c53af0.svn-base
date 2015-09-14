//
//  CoreDataController.m
//  SimuStock
//
//  Created by Mac on 15/1/26.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "CoreDataController.h"
#import "StockFunds.h"
#import "StockUpdataItem.h"

@interface CoreDataController ()

@property(nonatomic, readwrite, strong) NSManagedObjectModel *managedObjectModel;
@property(nonatomic, readwrite, strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, readwrite, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property(nonatomic, readwrite, strong) NSManagedObjectContext *childThreadManagedObjectContext;
@end

@implementation CoreDataController

+ (CoreDataController *)sharedInstance {
  static CoreDataController *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[CoreDataController alloc] init];
  });
  return sharedInstance;
}

/** 获取Core data上下文 */
- (NSManagedObjectContext *)managedObjectContext {
  if (_managedObjectContext) {
    return _managedObjectContext;
  }

  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  _managedObjectContext = [[NSManagedObjectContext alloc] init];
  _managedObjectContext.persistentStoreCoordinator = coordinator;

  return _managedObjectContext;
}

/** 获取数据模型 */
- (NSManagedObjectModel *)managedObjectModel {
  if (_managedObjectModel) {
    return _managedObjectModel;
  }

  NSString *momPath = [[NSBundle mainBundle] pathForResource:@"MocModel" ofType:@"momd"];

  if (!momPath) {
    momPath = [[NSBundle mainBundle] pathForResource:@"MocModel" ofType:@"mom"];
  }

  NSURL *url = [NSURL fileURLWithPath:momPath];
  _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
  return _managedObjectModel;
}

/** 获取存储协调器 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
  if (_persistentStoreCoordinator) {
    return _persistentStoreCoordinator;
  }

  NSError *error = nil;

  NSDictionary *options = nil;
  if ([self isMigrationNeeded]) {
    options = @{
      NSMigratePersistentStoresAutomaticallyOption : @YES,
      NSInferMappingModelAutomaticallyOption : @YES,
      NSSQLitePragmasOption : @{@"journal_mode" : @"DELETE"}
    };
  } else {
    options = @{
      NSMigratePersistentStoresAutomaticallyOption : @YES,
      NSInferMappingModelAutomaticallyOption : @YES,
      NSSQLitePragmasOption : @{@"journal_mode" : @"WAL"}
    };
  }

  NSManagedObjectModel *mom = [self managedObjectModel];

  _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];

  if (![_persistentStoreCoordinator addPersistentStoreWithType:[self sourceStoreType]
                                                 configuration:nil
                                                           URL:[self sourceStoreURL]
                                                       options:options
                                                         error:&error]) {

    NSLog(@"error: %@", error);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[self sourceStoreURL].path error:nil];

    [[[UIAlertView alloc] initWithTitle:@"Ouch"
                                message:error.localizedDescription
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
  }

  return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)childThreadManagedObjectContext {
  if (_childThreadManagedObjectContext) {
    return _childThreadManagedObjectContext;
  }

  NSError *error = nil;

  NSDictionary *options = @{
    NSMigratePersistentStoresAutomaticallyOption : @YES,
    NSInferMappingModelAutomaticallyOption : @YES,
    NSSQLitePragmasOption : @{@"journal_mode" : @"DELETE"}
  };
  NSManagedObjectModel *mom = [self managedObjectModel];

  NSPersistentStoreCoordinator *coordinator =
      [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];

  if (![coordinator addPersistentStoreWithType:[self sourceStoreType]
                                 configuration:nil
                                           URL:[self sourceStoreURL]
                                       options:options
                                         error:&error]) {

    NSLog(@"error: %@", error);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:[self sourceStoreURL].path error:nil];

    [[[UIAlertView alloc] initWithTitle:@"Ouch"
                                message:error.localizedDescription
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
  }

  _childThreadManagedObjectContext =
      [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
  _childThreadManagedObjectContext.persistentStoreCoordinator = coordinator;

  return _childThreadManagedObjectContext;
}

- (NSURL *)sourceStoreURL {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = paths[0];
  NSString *filePath = [documentsDirectory stringByAppendingPathComponent:CoreDataDatabaseName];
  return [NSURL fileURLWithPath:filePath isDirectory:NO];
}

- (NSString *)sourceStoreType {
  return NSSQLiteStoreType;
}

- (NSDictionary *)sourceMetadata:(NSError **)error {
  return [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:[self sourceStoreType]
                                                                    URL:[self sourceStoreURL]
                                                                  error:error];
}

- (BOOL)isMigrationNeeded {

  NSError *error = nil;

  // Check if we need to migrate
  NSDictionary *sourceMetadata = [self sourceMetadata:&error];
  if (!sourceMetadata) {
    return NO;
  }
  BOOL isMigrationNeeded = NO;

  if (sourceMetadata) {
    NSManagedObjectModel *destinationModel = [self managedObjectModel];
    // Migration is needed if destinationModel is NOT compatible
    isMigrationNeeded =
        ![destinationModel isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata];
  }
  NSLog(@"isMigrationNeeded: %d", isMigrationNeeded);
  return isMigrationNeeded;
}

- (BOOL)migrate:(NSError *__autoreleasing *)error {
  // Enable migrations to run even while user exits app
  __block UIBackgroundTaskIdentifier bgTask;
  bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
    [[UIApplication sharedApplication] endBackgroundTask:bgTask];
    bgTask = UIBackgroundTaskInvalid;
  }];
  BOOL OK = YES;

  [self removeCoreDataFile];
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
    NSManagedObjectContext *context = [self childThreadManagedObjectContext];
    [context performBlock:^{
      [self importSecuritiesDataWithContext:context];
    }];
  });

  //  MHWMigrationManager *migrationManager = [MHWMigrationManager new];
  //  migrationManager.delegate = self;
  //
  //  BOOL OK = [migrationManager progressivelyMigrateURL:[self
  //  sourceStoreURL]
  //                                               ofType:[self
  //                                               sourceStoreType]
  //                                              toModel:[self
  //                                              managedObjectModel]
  //                                                error:error];
  if (OK) {
    NSLog(@"migration complete");
  }

  // Mark it as invalid
  [[UIApplication sharedApplication] endBackgroundTask:bgTask];
  bgTask = UIBackgroundTaskInvalid;
  return OK;
}

- (NSString *)documentPath {
  // Get our document path.
  NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  return searchPaths[0];
}

#pragma mark
#pragma mark 数据库拷贝到document 文件夹下

//- (BOOL)copyDatabaseToDocument {
//  __block UIBackgroundTaskIdentifier bgTask;
//  bgTask = [[UIApplication sharedApplication]
//      beginBackgroundTaskWithExpirationHandler:^{
//        [[UIApplication sharedApplication] endBackgroundTask:bgTask];
//        bgTask = UIBackgroundTaskInvalid;
//      }];
//
//  BOOL copySucceeded = NO;
//
//  // Get the full path to our file.
//  NSString *filePath =
//      [self.documentPath stringByAppendingPathComponent:CoreDataDatabaseName];
//
//  NSLog(@"copyFromBundle - checking for presence of \"%@\"...", filePath);
//
//  // Get a file manager
//  NSFileManager *fileManager = [NSFileManager defaultManager];
//  // Does the database already exist? (If not, copy it from our bundle)
//  if (![fileManager fileExistsAtPath:filePath]) {
//    TICK;
//    // Get the bundle location
//    NSString *bundleDBPath = [[[NSBundle mainBundle] resourcePath]
//        stringByAppendingPathComponent:CoreDataDatabaseName];
//    NSError *error;
//    // Copy the DB to our document directory.
//    copySucceeded =
//        [fileManager copyItemAtPath:bundleDBPath toPath:filePath
//        error:&error];
//
//    if (copySucceeded) {
//      NSLog(
//          @"copyFromBundle - Succesfully copied \"%@\" to document
//          directory.",
//          CoreDataDatabaseName);
//    } else {
//      NSLog(@"copyFromBundle - Unable to copy \"%@\" to document directory. "
//            @"reason: %@",
//            CoreDataDatabaseName, [error localizedDescription]);
//    }
//    TOCK;
//  }
//
//  // Mark it as invalid
//  [[UIApplication sharedApplication] endBackgroundTask:bgTask];
//  bgTask = UIBackgroundTaskInvalid;
//  return copySucceeded;
//}

- (BOOL)prepare {
  NSError *error = nil;
  NSDictionary *sourceMetadata = [self sourceMetadata:&error];
  if (!sourceMetadata) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
      NSManagedObjectContext *context = [self childThreadManagedObjectContext];
      [context performBlock:^{
        [self importSecuritiesDataWithContext:context];
      }];
    });
    return YES;
  }
  return NO;
}

- (void)removeCoreDataFile {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = paths[0];
  NSString *path = [documentsDirectory stringByAppendingPathComponent:CoreDataDatabaseName];
  //每次导入前，删除数据库
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSError *deleteFileError;
  NSLog(@"Path to file: %@", path);
  NSLog(@"File exists: %d", [fileManager fileExistsAtPath:path]);
  NSLog(@"Is deletable file at path: %d", [fileManager isDeletableFileAtPath:path]);
  BOOL fileExists = [fileManager fileExistsAtPath:path];
  if (fileExists) {
    NSString *prefix = [path lastPathComponent];
    NSString *parentPath = [path stringByDeletingLastPathComponent];
    NSLog(@"prefix = %@, \n parent= %@", prefix, parentPath);
    NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:parentPath];
    NSString *childFilePath;
    while ((childFilePath = enumerator.nextObject)) {
      NSLog(@"child file: %@", childFilePath);
      if (![[childFilePath lastPathComponent] hasPrefix:prefix]) {
        continue;
      }
      NSLog(@"remove file %@", [parentPath stringByAppendingPathComponent:childFilePath]);
      BOOL success = [fileManager removeItemAtPath:[parentPath stringByAppendingPathComponent:childFilePath]
                                             error:&deleteFileError];
      if (!success) {
        NSLog(@"Error: %@", [deleteFileError localizedDescription]);
      }
    }
  }
}

/** 导入证券数据 */
- (void)importSecuritiesDataWithContext:(NSManagedObjectContext *)context {

  // Custom code here...
  // Save the managed object context
  NSError *error = nil;
  if (![context save:&error]) {
    NSLog(@"Error while saving %@", [error localizedDescription] ? [error localizedDescription] : @"Unknown Error");
    exit(1);
  }

  NSLog(@"began to import");
  NSError *err = nil;
  NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"stock_data" ofType:@"txt"];
  NSString *content =
      [NSString stringWithContentsOfFile:dataPath encoding:NSUTF8StringEncoding error:&err];
  NSArray *array = [content componentsSeparatedByString:@"\n"];

  NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
  [formatter setNumberStyle:NSNumberFormatterDecimalStyle];

  NSMutableArray *stockArray = [[NSMutableArray alloc] init];

  [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    NSString *line = obj;
    NSArray *columns = [line componentsSeparatedByString:@","];
    if ([columns count] < 11) {
      return;
    }
    StockFunds *stockOrFund = [NSEntityDescription insertNewObjectForEntityForName:@"StockFunds"
                                                            inManagedObjectContext:context];

    stockOrFund.code = columns[0];
    stockOrFund.stockCode = columns[1];
    if ([@"" isEqualToString:stockOrFund.stockCode]) {
      stockOrFund.stockCode =
          [stockOrFund.code length] == 6 ? stockOrFund.code : [stockOrFund.code substringFromIndex:2];
    }
    stockOrFund.name = columns[2];
    stockOrFund.marketId = [formatter numberFromString:columns[3]];
    stockOrFund.firstType = [formatter numberFromString:columns[4]];
    stockOrFund.secondType = [formatter numberFromString:columns[5]];
    stockOrFund.decimalDigits = [formatter numberFromString:columns[6]];
    stockOrFund.pyjc = columns[7];
    stockOrFund.openDate = [NSDate dateWithTimeIntervalSince1970:[columns[8] doubleValue] / 1000.0];
    stockOrFund.closeDate = [NSDate dateWithTimeIntervalSince1970:[columns[9] doubleValue] / 1000.0];
    stockOrFund.modifyTime = [NSDate dateWithTimeIntervalSince1970:[columns[10] doubleValue] / 1000.0];
    [stockArray addObject:stockOrFund];
  }];
  //    NSError *error;
  if (![context save:&error]) {
    NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
  }

  NSLog(@"finished to import");
  [StockUpdateItemListWrapper incrementUpdateStockInfo];
}

@end

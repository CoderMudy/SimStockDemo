//
//  YL_NetworkQueue_Data.h
//  SimuStock
//
//  Created by Mac on 15/1/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UploadRequestData : NSManagedObject

@property (nonatomic, retain) NSString * pathUrl;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * context;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * uid;

@end

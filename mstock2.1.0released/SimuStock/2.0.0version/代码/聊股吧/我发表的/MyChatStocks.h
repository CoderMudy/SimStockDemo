//
//  MyChatStocks.h
//  SimuStock
//
//  Created by moulin wang on 15/1/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface MyChatStocks : NSManagedObject

@property(nonatomic, retain) NSNumber *uid;
@property(nonatomic, retain) NSNumber *tstockid;
@property(nonatomic, retain) NSNumber *praise;

@end

//
//  PraiseItem.h
//  SimuStock
//
//  Created by Mac on 14/12/11.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PraiseItem : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSNumber * praisedObjId;
@property (nonatomic, retain) NSString * praisedUserId;

@end

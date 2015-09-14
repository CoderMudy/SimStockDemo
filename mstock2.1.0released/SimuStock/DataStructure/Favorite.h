//
//  Favorite.h
//  SimuStock
//
//  Created by Mac on 14/12/11.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Favorite : NSManagedObject

@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSNumber * favoriteObjectid;
@property (nonatomic, retain) NSDate * favoriteTime;
@property (nonatomic, retain) NSNumber * favoriteObjectType;

@end

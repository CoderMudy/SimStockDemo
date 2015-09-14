//
//  MsgReadState.h
//  SimuStock
//
//  Created by Mac on 14/12/11.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MsgReadState : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSNumber * msgId;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSNumber * readState;

@end

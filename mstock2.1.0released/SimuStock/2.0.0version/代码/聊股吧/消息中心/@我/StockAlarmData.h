//
//  StockAlarmData.h
//  SimuStock
//
//  Created by jhss on 15/7/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequestObject.h"

@interface StockAlarmData : NSObject<Collectionable>
@property(nonatomic, strong) NSArray *dataArray;
@end

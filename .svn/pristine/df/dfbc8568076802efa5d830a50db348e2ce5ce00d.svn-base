//
//  WFDataSharingCenter.m
//  SimuStock
//
//  Created by moulin wang on 15/4/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WFDataSharingCenter.h"
static WFDataSharingCenter *_dataSharingCenter = nil;
@implementation WFDataSharingCenter
//单利
+(WFDataSharingCenter *)shareDataCenter
{
  static dispatch_once_t onceToKen;
  dispatch_once(&onceToKen, ^{
    _dataSharingCenter = [[super allocWithZone:NULL] init];
  });
  return _dataSharingCenter;
}
+(id)allocWithZone:(struct _NSZone *)zone
{
  return [WFDataSharingCenter shareDataCenter];
}
-(id)copyWithZone:(struct _NSZone *)zone
{
  return [WFDataSharingCenter shareDataCenter];
}

-(NSMutableArray *)positionArray
{
  if (!_positionArray) {
    _positionArray = [[NSMutableArray alloc] init];
  }
  return _positionArray;
}


-(void)saveDataWithDataArray:(NSMutableArray *)mutableArray
{
  if (!mutableArray) {
    return;
  }
  [self.positionArray removeAllObjects];
  [self.positionArray addObjectsFromArray:mutableArray];
}


@end

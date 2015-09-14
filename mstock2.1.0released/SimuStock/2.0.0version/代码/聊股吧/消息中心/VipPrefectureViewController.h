//
//  VipPrefectureViewController.h
//  SimuStock
//
//  Created by jhss on 15/5/15.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseTableViewController.h"
#import "GameAdvertisingViewController.h"
/**VIP专区tableAdapter*/
@interface VipPrefectureTableAdapter : BaseTableAdapter

@property(nonatomic, strong) NSDictionary *dataMap;

@end
/**VIP专区tableViewController*/
@interface VipPrefectureViewController
    : BaseTableViewController <GameAdvertisingDelegate> {
  /** 广告对象 */
  GameAdvertisingViewController *advViewVC;
}
@end

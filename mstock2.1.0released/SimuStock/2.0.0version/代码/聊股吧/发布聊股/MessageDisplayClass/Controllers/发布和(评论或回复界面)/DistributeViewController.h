//
//  DistributeViewController.h
//  SimuStock
//
//  Created by Mac on 14/12/25.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "MessageDisplayDetailViewController.h"
@interface DistributeViewController : MessageDisplayDetailViewController

///发布聊股，（用所属股吧ID）来区分在不同股吧发布聊股
@property(nonatomic, strong) NSString *barID;

/// barid 所属股吧ID，发布成功后返回数据方便回调
- (id)initWithBarID:(NSString *)barid andCallBack:(OnReturnObject)callback;

@end

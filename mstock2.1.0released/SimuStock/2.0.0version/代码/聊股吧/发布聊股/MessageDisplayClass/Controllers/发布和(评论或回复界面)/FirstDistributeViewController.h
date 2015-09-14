//
//  FirstDistributeViewController.h
//  SimuStock
//
//  Created by Mac on 15/2/3.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MessageDisplayDetailViewController.h"

@interface FirstDistributeViewController : MessageDisplayDetailViewController

///发布聊股，（用所属股吧ID）来区分在不同股吧发布聊股
@property(nonatomic, strong) NSString *barID;

/// barid 所属股吧ID，发布成功后返回数据方便回调
- (id)initWithCallBack:(OnReturnObject)callback;

@end

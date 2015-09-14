//
//  InfomationDisplayData.h
//  SimuStock
//
//  Created by moulin wang on 15/4/1.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequester.h"
@class HttpRequestCallBack;

@interface InfomationDisplayData : NSObject

/** 浮动盈亏 */
@property(copy, nonatomic) NSString *FloatingProfitLoss;

/** 当前资产 */
@property(copy, nonatomic) NSString *CurrentAssets;

/** 可用资产 */
@property(copy, nonatomic) NSString *AvailableAssets;

/** 保证金 */
@property(copy, nonatomic) NSString *BondLabel;

/** 警戒线资产 */
@property(copy, nonatomic) NSString *CordonAssets;

/** 平仓线资产 */
@property(copy, nonatomic) NSString *OpenLineAssets;

@end

//请求类
@interface InfomationDisplayRequest : JsonRequestObject

@property(strong, nonatomic) NSMutableArray *infomationDisplayArray;

//请求实盘信息
+ (void)updateInfomationDisplay:(HttpRequestCallBack *)callback;

@end

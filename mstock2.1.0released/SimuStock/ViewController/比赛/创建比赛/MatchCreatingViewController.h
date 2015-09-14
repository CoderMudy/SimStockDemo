//
//  MatchCreatingNewViewController.h
//  SimuStock
//
//  Created by Yuemeng on 15/7/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "StoreUtil.h"
#import "CompetitionCycleView.h"

@interface MatchCreatingViewController : BaseViewController <CompetitionCycleViewDelegate>
/** 商城兑换、支付工具类 */
@property (nonatomic, strong) StoreUtil *storeUtil;
@end

//
//  MoreShareExplainRefreshView.h
//  SimuStock
//
//  Created by 刘小龙 on 15/7/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpertPlanConst.h"
#import "StockUtil.h"

/**牛人计划首页分享回调*/
typedef void (^SharePressCallBack)();
/**牛人计划首页说明回调*/
typedef void (^ExplanationCallBack)();
/**牛人计划首页操作协议回调*/
typedef void (^OperatingAgreementCallBack)();
/**牛人计划首页提前终止回调*/
typedef void (^EarlyTerminationCallBack)();

typedef NS_ENUM(NSInteger, MoreType) {
  MoreExplainType = 1,           //说明
  MoreShareType = 2,             //分享
  MoreOperationProtocolType = 3, //牛人视角 操作协议
  MoreAdvanceStopType = 4,       //提前终止
};

@interface MoreShareExplainRefreshView
    : UIView <UITableViewDataSource, UITableViewDelegate>
@property(copy, nonatomic) SharePressCallBack sharePressCallBack;
@property(copy, nonatomic) ExplanationCallBack explanationCallBack;
@property(copy, nonatomic)
    OperatingAgreementCallBack operatingAgreementCallBack;
@property(copy, nonatomic) EarlyTerminationCallBack earlyTerminationCallBack;

@property(weak, nonatomic) IBOutlet UITableView *moreShareTableView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property(strong, nonatomic) NSMutableArray *moreLableTitleArray;

//根据 牛人视角 还是 用户视角 计划运行 或者 未运行
- (void)expertOrUser:(NSDictionary *)dic;

@end

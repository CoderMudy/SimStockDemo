//
//  EPPexpertPlanViewController.h
//  SimuStock
//
//  Created by 刘小龙 on 15/7/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globle.h"
#import "ExpertPlanData.h"
@class SimuRTBottomToolBar;
@class ExpertPlanViewController;
@class simuBuyViewController;
@class simuSellViewController;
@class simuCancellationViewController;

/** 牛人主页计划 基类 只有 底部导航栏 */
@interface EPPexpertPlanViewController : UIViewController {

  //查委托
  simuCancellationViewController *_stockCancellationVC;
}
///判断状态的bool
@property(nonatomic, assign) BOOL planStateBool;
//牛人计划主页 账户页面
@property(nonatomic, strong) ExpertPlanViewController *mainExpertPlanVC;
//数据
@property(nonatomic, strong) ExpertPlanData *planData;
//买入页面
@property(nonatomic, strong) simuBuyViewController *stockBuyVC;
//卖出页面
@property(nonatomic, strong) simuSellViewController *stockSellVC;
//底部导航栏
@property(nonatomic, strong) SimuRTBottomToolBar *expertBottomToolBar;
/** 公用的返回处理 */
@property(nonatomic, copy) onBackButtonPressed commonBackHandler;
- (id)initAccountId:(NSString *)accounId
      withTargetUid:(NSString *)targetUid
      withTitleName:(NSString *)titleName;

@end

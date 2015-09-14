//
//  ExpertScreenViewController.h
//  SimuStock
//
//  Created by jhss_wyz on 15/8/31.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"

@class ExpertOneScreenView;
@class ExpertScreenConditionData;
@class ExpertFilterCondition;

@interface ExpertScreenViewController : BaseViewController

/** 右上角说明按钮 */
@property(strong, nonatomic) UIButton *instructionBtn;

/** 页面滚动视图 */
@property(strong, nonatomic) UIScrollView *scrollView;

/** 牛人筛选页面主视图 */
@property(strong, nonatomic) UIView *mainView;

/** 筛选条件View数组 */
@property(strong, nonatomic) IBOutletCollection(ExpertOneScreenView) NSArray *conditionViewarray;

/** 盈利能力 */
/** 超越同期上证指数View */
@property(weak, nonatomic) IBOutlet ExpertOneScreenView *largeThanStockIndexView;
/** 年化收益View */
@property(weak, nonatomic) IBOutlet ExpertOneScreenView *annualizedReturnView;
/** 月均收益View */
@property(weak, nonatomic) IBOutlet ExpertOneScreenView *monthAvgProfitRateView;

/** 抗风险能力 */
/** 最大回撤比例小于等于View */
@property(weak, nonatomic) IBOutlet ExpertOneScreenView *retracementRadioView;
/** 回撤时间占比小于等于View */
@property(weak, nonatomic) IBOutlet ExpertOneScreenView *retracementTimeView;

/** 选股能力 */
/** 盈利天数占比大于等于View */
@property(weak, nonatomic) IBOutlet ExpertOneScreenView *profitableDaysLabel;
/** 成功率大于等于View */
@property(weak, nonatomic) IBOutlet ExpertOneScreenView *successRateView;
/** 平均持股天数小于等于View */
@property(weak, nonatomic) IBOutlet ExpertOneScreenView *holdDaysView;

/** 数据准确性 */
/** 交易笔数大于等于View */
@property(weak, nonatomic) IBOutlet ExpertOneScreenView *transactionNumberView;

/** 确认按钮所在视图 */
@property(strong, nonatomic) IBOutlet UIView *confirmView;
/** 确认按钮 */
@property(weak, nonatomic) IBOutlet BGColorUIButton *confirmBtn;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewHeight;

/** 确认按钮 */
@property(strong, nonatomic) ExpertScreenConditionData *conditionData;

/** 筛选条件数组 */
@property(strong, nonatomic) __block ExpertFilterCondition *filterCondition;

@end

//
//  ProfitAndStopView.h
//  SimuStock
//
//  Created by tanxuming on 15/5/25.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimuTradeBaseData.h"
/**止盈止损页面上半部分View*/
@interface ProfitAndStopView : UIView {
  /** 卖出数据 */
  SimuTradeBaseData *simuSellQueryData;
}
@property(strong, nonatomic) IBOutlet UILabel *stockInfoDefaultLab;
/**成本价*/
@property(strong, nonatomic) IBOutlet UILabel *costLabel;
/**滑块*/
@property(strong, nonatomic) IBOutlet UISlider *sliderView;
/**滑块显示最小值*/
@property(strong, nonatomic) IBOutlet UILabel *sliderMinValueLab;
/**滑块显示最大值*/
@property(strong, nonatomic) IBOutlet UILabel *sliderMaxValueLab;
/**当前盈亏率*/
@property(strong, nonatomic) IBOutlet UILabel *currentProfitAndLossLab;
/**止盈价*/
@property(strong, nonatomic) IBOutlet UITextField *stopWinPriceTF;
/**止盈比例*/
@property(strong, nonatomic) IBOutlet UITextField *stopWinRateTF;
/**止盈开关*/
@property(strong, nonatomic) IBOutlet UISwitch *stopWinSwitch;
/**止损价*/
@property(strong, nonatomic) IBOutlet UITextField *stopLosePriceTF;
/**止损比例*/
@property(strong, nonatomic) IBOutlet UITextField *stopLoseRateTF;
/**止损开关*/
@property(strong, nonatomic) IBOutlet UISwitch *stopLoseSwitch;
/**卖出按钮*/
@property(strong, nonatomic) IBOutlet UIButton *sellBtn;
/**最小数*/
@property(strong, nonatomic) IBOutlet UILabel *miniLabel;
/**最大数*/
@property(strong, nonatomic) IBOutlet UILabel *maxLabel;
/**股票代码*/
@property(strong, nonatomic) IBOutlet UILabel *stockCodeLabel;
/**股票名称*/
@property(strong, nonatomic) IBOutlet UILabel *stockNameLabel;
/**卖出股票数量*/
@property(strong, nonatomic) IBOutlet UITextField *stockSellNumTF;
/**股票信息视图*/
@property(strong, nonatomic) IBOutlet UIView *stockInfoView;
/**止盈价背景图*/
@property(strong, nonatomic) IBOutlet UIView *stopWinPriBackgrounView;
/**止盈比例背景图*/
@property(strong, nonatomic) IBOutlet UIView *stopWinRateBackgrounView;
/**止损价背景图*/
@property(strong, nonatomic) IBOutlet UIView *stopLosePriBackgroundView;
/**止损比例背景图*/
@property(strong, nonatomic) IBOutlet UIView *stopLoseRateBackgroundView;
/**卖出股票数量*/
@property(strong, nonatomic) IBOutlet UIView *stockSellNumView;
/**有效的止盈价格*/
- (BOOL)validateStopWinPrice;
/**有效的止损价格*/
- (BOOL)validateStopLosePrice;
/**重置页面数据*/
- (void)resetView;
@end

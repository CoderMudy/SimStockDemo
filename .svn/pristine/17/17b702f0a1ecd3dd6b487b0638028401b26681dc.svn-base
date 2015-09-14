//
//  EPPlanPositionView.h
//  SimuStock
//
//  Created by 刘小龙 on 15/7/10.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpertPlanData.h"
#import "EPexpertPositionData.h"

@interface EPPlanPositionView : UIView
/** 当前持仓率 */
@property(weak, nonatomic) IBOutlet UILabel *currentPositionRateLabel;
/** 查看交易记录 */
- (IBAction)seeTradingRecordButtonAction:(UIButton *)sender;

@property(nonatomic, strong) ExpertPlanData *dataPlan;
@property(nonatomic, strong) EPexpertPositionData *dataPosition;

+ (EPPlanPositionView *)createEPPlanPositionView;

///数据绑定
- (void)bindDataForPositionView:(EPexpertPositionData *)data;

@end

//
//  SimulationViewCell.h
//  SimuStock
//
//  Created by Mac on 15/4/12.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserAccountPageData.h"
#import "SimuleftImagButtonView.h"
#import "UIButton+Block.h"
/*
 *类说明：模拟帐户cell
 */
@class SimuleftImagButtonView;
@class SimuUserConterViewController;

@protocol SimulationViewCellDelegate <NSObject>

//加入资金和帐户充值按钮点击
- (void)ButtonPressUp:(NSInteger)index;

@end
@interface SimulationViewCell : UITableViewCell<SimuleftButtonDelegate>

@property(weak,nonatomic) id<SimulationViewCellDelegate> delegate;

///总盈利率
@property (weak, nonatomic) IBOutlet UILabel *Profitrate;
///总资产
@property (weak, nonatomic) IBOutlet UILabel *TotalAssets;
///可用资金
@property (weak, nonatomic) IBOutlet UILabel *FundBalance;
///股票市值
@property (weak, nonatomic) IBOutlet UILabel *PositionValue;
///浮动盈亏
@property (weak, nonatomic) IBOutlet UILabel *FloatProfit;

///刷新按钮
@property (weak, nonatomic) IBOutlet UIButton *RefrashBtn;
//菊花
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;


///买入
@property (weak, nonatomic) IBOutlet BGColorUIButton *SimulationBuybtn;
///卖出
@property (weak, nonatomic) IBOutlet BGColorUIButton *SimulationSellbtn;
///查委托/撤单
@property (weak, nonatomic) IBOutlet BGColorUIButton *SimulationEntrustbtn;


@property(weak, nonatomic) SimuUserConterViewController *parentVC;
@property(nonatomic, strong) SimuleftImagButtonView *resetCountBut;

//设置控件数据
- (void)resetData:(UserAccountPageData *)pagedata;
-(void)Start_parentVC;
@end

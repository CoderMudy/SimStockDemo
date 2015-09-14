//
//  BaseFundNetValueVC.h
//  SimuStock
//
//  Created by Mac on 15/6/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseTrendVC.h"
#import "FundNetValueView.h"
#import "StockUtil+view.h"
#import "Globle.h"

@interface FloatWindowViewForFund : UIView

///日期
@property(weak, nonatomic) IBOutlet UILabel *dateLabel;

///净值
@property(weak, nonatomic) IBOutlet UILabel *netvalueLabel;

- (void)bindFundNav:(FundNav *)fundNav;

@end

@interface BaseFundNetValueVC : BaseTrendVC

///基金净值趋势图
@property(nonatomic, strong) FundNetValueView *fundNetValueView;
///查看基金信息的浮窗
@property(nonatomic, strong) FloatWindowViewForFund *floatWindowView;

@end

/** 竖屏情况下使用的基金净值图控制器 */
@interface PortaitFundNetValueVC : BaseFundNetValueVC

@end

/** 横屏情况下使用的基金净值图控制器 */
@interface HorizontalFundNetValueVC : BaseFundNetValueVC

@end

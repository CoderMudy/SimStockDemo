//
//  RealTradeCancllationViewController.h
//  SimuStock
//
//  Created by Mac on 14-9-27.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "RealTradeTodayEntrust.h"
#import "NetLoadingWaitView.h"
#import "DataArray.h"

/**JavaForOSX.pkg
 实盘撤单页面
 */
@interface RTCancleEntrustVC : BaseViewController

/** 撤单按钮 */
@property(nonatomic, strong) UIButton *btnCancleEntrust;

/** 视图容器 */
@property(nonatomic, strong) StockEntrustViewHolder *tableViewHolder;
//重写init
- (id)initWithFrame:(CGRect)frame withFirmOrCapital:(BOOL)firmOrCapital;
- (void)refreshButtonPressDown;
@end

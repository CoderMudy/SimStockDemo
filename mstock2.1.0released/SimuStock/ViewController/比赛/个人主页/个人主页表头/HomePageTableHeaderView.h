//
//  HomePageTableHeaderView.h
//  SimuStock
//
//  Created by Jhss on 15/7/23.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageProfitSuperView.h"
#import "HomePageUserInfoView.h"
#import "HomeAtSuperView.h"
#import "HomeAssetInfoSuperView.h"
#import "HomeUserTradeGradeWidgetView.h"

@interface HomePageTableHeaderView : UIView

/** 用户信息以及头像 1 */
@property(weak, nonatomic) IBOutlet HomePageUserInfoView *userInfoView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *userInfoViewHeight;

/** 追踪以及@Ta按钮视图 2 */
@property(weak, nonatomic) IBOutlet HomeAtSuperView *followAndAttentionView;
@property(weak, nonatomic)
    IBOutlet NSLayoutConstraint *followAndAttentionHeight;

/** 交易评级控件 */
@property(weak, nonatomic)
    IBOutlet HomeUserTradeGradeWidgetView *tradeGradeWidgetView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *tradeGradeWidgetHeight;

/** 盈利曲线 */
@property(weak, nonatomic) IBOutlet HomePageProfitSuperView *profitCurveView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *profitCurveHeight;

/** 资产列表 */
@property(weak, nonatomic) IBOutlet HomeAssetInfoSuperView *userAssetsView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *userAssetsHeight;

@end

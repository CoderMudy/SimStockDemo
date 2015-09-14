//
//  SelectMatchInitialFundSingle.h
//  SimuStock
//
//  Created by jhss_wyz on 15/8/17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimuBlockDefine.h"

@class SimuMatchTemplateData;

@interface SelectMatchInitialFundSingle : NSObject

/** 比赛模版数据 */
@property(strong, nonatomic) SimuMatchTemplateData *matchData;

/** 当前用户拥有的金币数 */
@property(copy, nonatomic) NSString *ownGoldCoin;

/** 选择的比赛模版 */
@property(copy, nonatomic) NSString *templateId;

/** 数据是否已经绑定 */
@property(assign, nonatomic) BOOL isDataBinded;

/** 弹框是否已经弹出 */
@property(assign, nonatomic) BOOL isTipShown;

/** 开始加载，通知父容器 */
@property(copy, nonatomic) CallBackBlock beginRefreshCallBack;

/** 结束加载，通知父容器 */
@property(copy, nonatomic) CallBackBlock endRefreshCallBack;

/** 创建比赛：选择比赛模板回调 */
@property(copy, nonatomic) SelectMatchInitialFundBlock selectMatchInitialFundBlock;

/** 获取SelectMatchInitialFundSingle单例 */
+ (instancetype)shared;

/** 弹出比赛初始金额选择框 */
- (void)showSelectTip;

@end

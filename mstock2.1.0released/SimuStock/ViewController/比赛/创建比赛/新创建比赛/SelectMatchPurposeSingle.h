//
//  SelectMatchPurposeSingle.h
//  SimuStock
//
//  Created by jhss_wyz on 15/8/18.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimuBlockDefine.h"

@class SimuMatchUsesData;

@interface SelectMatchPurposeSingle : NSObject

/** 高校比赛用途数据 */
@property(strong, nonatomic) SimuMatchUsesData *matchUseData;

/** 选择的比赛用途 */
@property(copy, nonatomic) NSString *matchPurpose;

/** 数据是否已经绑定 */
@property(assign, nonatomic) BOOL isDataBinded;

/** 弹框是否已经弹出 */
@property(assign, nonatomic) BOOL isTipShown;

/** 开始加载，通知父容器 */
@property(copy, nonatomic) CallBackBlock beginRefreshCallBack;

/** 结束加载，通知父容器 */
@property(copy, nonatomic) CallBackBlock endRefreshCallBack;

/** 创建比赛：选择比赛模板回调 */
@property(copy, nonatomic) SelectMatchPurposeBlock selectMatchPurposeBlock;

/** 获取SelectMatchPurposeSingle单例 */
+ (instancetype)shared;

/** 弹出高校比赛用途选择框 */
- (void)showSelectTip;

@end

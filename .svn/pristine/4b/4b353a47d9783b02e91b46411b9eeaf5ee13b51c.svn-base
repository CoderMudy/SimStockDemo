//
//  EPTableViewHeaderViewController.h
//  SimuStock
//
//  Created by 刘小龙 on 15/7/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
//头
#import "EPPlanTableHeader.h"
//数据类
#import "ExpertPlanData.h"
#import "ExpertPlanConst.h"

typedef void (^BackExpertPlanData)(ExpertPlanData *);

/** tableview Haeder 控制器 */
@interface EPTableViewHeaderViewController : UIViewController

/** 头里的view */
@property(strong, nonatomic) EPPlanTableHeader *ep_tableViewHeaeder;

@property(copy, nonatomic) BackExpertPlanData backExpertPlan;

//初始化
- (id)initExpertPlanData:(ExpertPlanData *)expertPlanData
           withAccountId:(NSString *)accountId
           withTargetUid:(NSString *)targetUid;

@end

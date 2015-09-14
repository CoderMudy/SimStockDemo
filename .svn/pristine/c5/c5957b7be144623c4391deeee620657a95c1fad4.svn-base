//
//  ExpertFilterViewController.h
//  SimuStock
//
//  Created by jhss on 15/8/31.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseTableViewController.h"
@class ExpertFilterCondition;

@interface ExpertFilterTableAdapter : BaseTableAdapter
/**选中的cell数组*/
@property(nonatomic, strong) NSMutableArray *cellSelected;
@end

@interface ExpertFilterTableVC : BaseTableViewController
/**筛选条件*/
@property(nonatomic, strong) ExpertFilterCondition *conditions;
@property(strong, nonatomic) ExpertFilterTableAdapter *expertPlanAdapter;
/**初始化ExpertFilterTableVC传入筛选条件对象*/
- (id)initWithFrame:(CGRect)frame withExpertFilterCondition:(ExpertFilterCondition *)conditions;
@end

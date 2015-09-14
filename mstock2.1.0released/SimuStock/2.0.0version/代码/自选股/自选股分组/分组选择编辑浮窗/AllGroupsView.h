//
//  AllGroupsView.h
//  SimuStock
//
//  Created by Yuemeng on 15/6/18.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuerySelfStockData.h"

typedef void (^choiceGroupBlock)(NSString *groupName, NSString *groupId);

/*
 *  全部分组弹出框，随自选股页面创建
 */
@interface AllGroupsView : UIView <UITableViewDataSource, UITableViewDelegate>
{
  QuerySelfStockData *_data;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upArrowTopCons;

@property (weak, nonatomic) IBOutlet UIImageView *upArrowImageView;

@property(strong, nonatomic) IBOutlet UITableView *allGroupTableView;

@property(nonatomic, copy) choiceGroupBlock choiceGroupBlock;

@property(strong, nonatomic) NSMutableArray *stockNameArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConst;

- (void)reloadTableViewWithQuerySelfStockData:(QuerySelfStockData *)data;

@end

//
//  SelfAddStockGroupViewController.h
//  SimuStock
//
//  Created by jhss on 15/6/18.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "SelfGroupsTableViewController.h"
#import "QuerySelfStockData.h"

/*
 *  编辑分组表格页
 */
@interface ModifySelfGroupViewController : BaseViewController {

  SelfGroupsTableViewController *_selfAddStockGroupVC;
}
@property(nonatomic, strong) QuerySelfStockData *data;
@end

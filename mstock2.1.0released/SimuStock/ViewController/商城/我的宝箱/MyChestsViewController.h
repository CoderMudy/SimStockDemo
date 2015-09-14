//
//  MyChestsListViewController.h
//  SimuStock
//
//  Created by Yuemeng on 15/7/17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTableViewController.h"

@class MyChestsTableHeaderView;
@class MyChestsViewController;

/*
 *  我的宝箱
 */
@interface MyChestsTableAdapter : BaseTableAdapter


@end

@interface MyChestsListViewController : BaseTableViewController

@property(nonatomic, weak) MyChestsViewController *superVC;

@end

@interface MyChestsViewController : BaseViewController
{
  MyChestsListViewController *_tableVC;
}

@property(nonatomic, strong) MyChestsTableHeaderView *chestsHeader;

@end

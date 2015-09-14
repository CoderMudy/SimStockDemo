//
//  MyGoldVC.h
//  SimuStock
//
//  Created by jhss on 15/5/11.
//  Copyright (c) 2015年 Mac. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"
#import "MyGoldTopVC.h"
#import "MyGoldListWrapper.h"
#import "GetGoldWrapper.h"
#import "PersonalSignatureViewController.h"

typedef void (^RefreshPersonalGetGoldBlock)(GetGoldWrapper *getGold);

/**我的金币页面表格控制器*/
@interface MyGoldTableAdapter : BaseTableAdapter {
  MyGoldTopVC *myGoldTopVC;
}
/**刷新表头的用户金币总数*/
@property(copy, nonatomic) RefreshPersonalGetGoldBlock refreshBlock;
@end

@interface MyGoldVC : BaseTableViewController {
  MyGoldTopVC *myGoldTopVC;
  MyGoldTableAdapter *tableView;
  MyGoldListWrapper *data;
}
@end

//
//  MyIncomingViewController.h
//  SimuStock
//
//  Created by Yuemeng on 15/5/17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "MJRefresh.h"
#import "BindingPhoneViewController.h"
#import "BaseTableViewController.h"

@interface MyIncomingTableAdapter : BaseTableAdapter

@end

/*
 *
 */
@interface MyIncomingListViewController : BaseTableViewController

@end

/*
 *  我的收入页面
 */
@interface MyIncomingViewController : BaseViewController <verifyPhoneDelegate> {

  MyIncomingListViewController *_tableVC;

  UIView *_whiteBackView;
  UILabel *_cashLabel;
  UIButton *_cashButton;
  //兑换钻石比例
  int _ratio;
  //兑换钻石最大数
  int _maxValue;
  //提现菊花
  UIActivityIndicatorView *_cashIndicatorView;
}

@end

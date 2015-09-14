//
//  MarketHomeTableViewController.h
//  SimuStock
//
//  Created by Mac on 15/4/26.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseTableViewController.h"
#import "BaseTableAdapter.h"
#import "MarketHomeTableViewCell.h"

@interface MarketHomeTableAdapter
    : BaseTableAdapter <MarketHomeTableViewCellDelegate> {
}

///标题名称
@property(nonatomic, strong) NSArray *titleNameArray;
@property(nonatomic, strong) NSMutableDictionary *dataDic;

@end

@interface MarketHomeTableViewController : BaseTableViewController {

  ///定时器间隔时间
  NSTimeInterval timeinterval;

  ///定时期
  NSTimer *iKLTimer;

  BOOL showBool;
}

@property(nonatomic, assign) NSInteger refreshTime;

- (void)stopMyTimer;

@end

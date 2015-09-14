//
//  StockNewsListTableViewController.h
//  SimuStock
//
//  Created by Mac on 15/5/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseTableViewController.h"
@interface StockNewsListTableAdapter : BaseTableAdapter

@end

@interface StockNewsListTableViewController : BaseTableViewController
{
  UIActivityIndicatorView *indicator;
}
/** 渠道id */
@property(nonatomic, strong) NSString* channalId;
/** 渠道名字 */
@property(nonatomic, strong) NSString* channalName;

/**菊花**/
@property(nonatomic, strong) UIView * nwv_fullbaseView;

- (id)initWithFrame:(CGRect)frame
      withChannelID:(NSString*)channalId
    withChannelName:(NSString*)channalName;

@end

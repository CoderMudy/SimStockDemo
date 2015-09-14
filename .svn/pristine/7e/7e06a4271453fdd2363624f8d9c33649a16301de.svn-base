//
//  MessageCenterView.h
//  SimuStock
//
//  Created by moulin wang on 14-11-24.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "MessageCenterListWrapper.h"

@interface MessageCenterViewController
    : BaseViewController <UITableViewDataSource, UITableViewDelegate> {
  /**表格背景*/
  UITableView *mesCenterTableView;

  /** 通知的keys*/
  NSArray *noticeKeys;
  /** 未读通知的数值*/
  NSMutableDictionary *unReadNoticeNums;
      
  NSArray *rowIndexToMessageType;
}
@property(nonatomic, strong) NSDictionary *dataMap;
/**构建表格所用的数组*/
@property(strong, nonatomic) NSArray *mesCenterArray;
/**网络接口的type值*/
@property(copy, nonatomic) NSString *typeStr;
/**网络接口的fromID值*/
@property(copy, nonatomic) NSString *fromID;
/**网络接口的reqNum值*/
@property(copy, nonatomic) NSString *reqNum;

@end

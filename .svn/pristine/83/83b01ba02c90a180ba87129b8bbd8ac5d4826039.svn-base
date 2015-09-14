//
//  MessageListTableVC.h
//  SimuStock
//
//  Created by jhss on 15/6/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseTableViewController.h"
#import "MessageCenterCoreDataUtil.h"
// ZXCCoreData类
#import "MesCallMeCoreDataUtil.h"
#import "HomepageViewController.h"
#import "MessageCenterCoreDataUtil.h"
@interface MessageListTableAdapter : BaseTableAdapter {
}
@end

@interface MessageListTableVC : BaseTableViewController {
  MessageListTableAdapter *tableView;
}
/** 消息类型，定义见MessageType */
@property(nonatomic, assign) MessageType type;
/** 网络请求时发送的参数类型*/
@property(nonatomic, strong) NSString *requestType;
- (id)initWithFrame:(CGRect)frame
    withMessageType:(MessageType)type
    withRequestType:(NSString *)requestType;
@end

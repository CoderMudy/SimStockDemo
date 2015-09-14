//
//  MessageCallMeViewController.h
//  SimuStock
//
//  Created by moulin wang on 14-11-26.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "MessageListTableVC.h"
#import "MessageCenterCoreDataUtil.h"

/** 消息中心各种消息类型的页面 */
@interface MessageListViewController
    : BaseViewController <SimuIndicatorDelegate> {

  MessageListTableVC *messageListTableVC;

  /** 消息类型，定义见MessageType */
  MessageType _type;

  /** 标题*/
  NSString *title;

  /** 网络请求时发送的参数类型*/
  NSString *requestType;
}

/** 使用指定的类型初始化页面 */
- (id)initWithType:(MessageType)type;

@end

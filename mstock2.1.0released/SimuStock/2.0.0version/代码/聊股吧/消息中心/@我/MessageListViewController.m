//
//  MessageCallMeViewController.m
//  SimuStock
//
//  Created by moulin wang on 14-11-26.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "MessageListViewController.h"

@implementation MessageListViewController
- (id)initWithType:(MessageType)type {
  self = [super init];
  if (self) {
    NSDictionary *titles = @{
      @(MessageTypeAtMe) : @"@我的",
      @(MessageTypeComment) : @"评论了我",
      @(MessageTypeAttention) : @"关注了我",
      @(MessageTypePraise) : @"赞了我"
    };

    _type = type;
    requestType = [NSString stringWithFormat:@"%ld", (long)type];
    title = titles[@(type)];
  }

  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [Globle colorFromHexRGB:@"#F7F7F7"];
  //设置tabbar
  [_topToolBar resetContentAndFlage:title Mode:TTBM_Mode_Leveltwo];
  [self createMessageListTableVC];
}

- (void)createMessageListTableVC {
  if (!messageListTableVC) {
    CGRect frame = CGRectMake(0, 0, self.clientView.bounds.size.width,
                              CGRectGetHeight(self.clientView.bounds));
    messageListTableVC = [[MessageListTableVC alloc] initWithFrame:frame
                                                   withMessageType:_type
                                                   withRequestType:requestType];
  }
  __weak MessageListViewController *weakSelf = self;
  messageListTableVC.showTableFooter = YES;
  messageListTableVC.beginRefreshCallBack = ^{
    [weakSelf.indicatorView startAnimating];
  };
  messageListTableVC.endRefreshCallBack = ^{
    [weakSelf.indicatorView stopAnimating];
  };
  [self.clientView addSubview:messageListTableVC.view];
  [self addChildViewController:messageListTableVC];
  [messageListTableVC refreshButtonPressDown];
}

- (void)refreshButtonPressDown {
  [messageListTableVC refreshButtonPressDown];
}

@end

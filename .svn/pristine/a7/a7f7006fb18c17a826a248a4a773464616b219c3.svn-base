//
//  EPTableViewHeaderViewController.m
//  SimuStock
//
//  Created by 刘小龙 on 15/7/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "EPTableViewHeaderViewController.h"

@interface EPTableViewHeaderViewController ()
{
  ExpertPlanData *_expertPlanData;
}
@property(copy, nonatomic) NSString *accountId;
@property(copy, nonatomic) NSString *targetUid;
@end

@implementation EPTableViewHeaderViewController

- (id)initExpertPlanData:(ExpertPlanData *)expertPlanData
           withAccountId:(NSString *)accountId
           withTargetUid:(NSString *)targetUid {
  self = [super init];
  if (self) {
    _expertPlanData = expertPlanData;
    self.accountId = accountId;
    self.targetUid = targetUid;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self creatTableViewHeader];
}

-(void)creatTableViewHeader
{
  _ep_tableViewHeaeder =
  [[[NSBundle mainBundle] loadNibNamed:@"EPPlanTableHeader"
                                 owner:self
                               options:nil] lastObject];
  CGRect frame = [_ep_tableViewHeaeder ChangeSizeWithState:_expertPlanData.state
                                             withPlanState:_expertPlanData.planState
                                                  withData:_expertPlanData
                                             withAccountId:self.accountId
                                             withTargetUid:self.targetUid];
  _ep_tableViewHeaeder.frame = frame;
  
  self.view.frame =
  CGRectMake(0, 0, self.view.bounds.size.width, frame.size.height);
  [self.view addSubview:_ep_tableViewHeaeder];
}
@end

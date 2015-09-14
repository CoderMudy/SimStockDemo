//
//  NewGroupsTableViewCell.m
//  SimuStock
//
//  Created by jhss on 15/6/18.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "NewGroupsTableViewCell.h"
#import "AddGroupClientVC.h"
#import "AppDelegate.h"

@implementation NewGroupsTableViewCell
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (IBAction)editBtnClick:(UIButton *)sender {
  AddGroupClientVC *addGroupClientVC =
      [[AddGroupClientVC alloc] initWithGroupType:ModifyGroup
                                       andGroupId:self.groupId];
  addGroupClientVC.groupName = _groupNameLabel.text;
  [AppDelegate pushViewControllerFromRight:addGroupClientVC];
}

@end

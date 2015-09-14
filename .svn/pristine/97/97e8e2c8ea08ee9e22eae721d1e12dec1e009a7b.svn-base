//
//  MyAttentionViewController.h
//  SimuStock
//
//  Created by Jhss on 15/6/23.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTableViewController.h"
#import "FollowFriendResult.h"
#import "MyAttentionInfo.h"

@interface MyAttentionTableAdapter : BaseTableAdapter <FriendFollowDelegate>

@end

@interface MyAttentionTableViewController : BaseTableViewController

@property(strong, nonatomic) NSString *userId;

- (id)initWithFrame:(CGRect)frame withUserId:(NSString *)userId;

- (void)refreshAttentionData;

@end

@interface MyAttentionViewController : BaseViewController {
  MyAttentionTableViewController *myAttentionTableVC;
}

@property(strong, nonatomic) NSString *userID;

@end

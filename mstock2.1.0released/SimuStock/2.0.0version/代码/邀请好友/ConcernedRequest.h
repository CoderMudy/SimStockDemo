//
//  ConcernedRequest.h
//  SimuStock
//
//  Created by moulin wang on 14-7-30.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FollowFriendResult.h"

@protocol ConcernedRequestDelegate <NSObject>
//刷新按钮
- (void)refreshButton:(NSInteger)refresh;
@end

@interface ConcernedRequest : NSObject
@property(nonatomic, strong) NSString *userID;
@property(nonatomic, assign) NSInteger statusInt;
@property(nonatomic, weak) id<ConcernedRequestDelegate> delegate;

- (void)shareButtonInviteFriendCallbackUserID:(NSString *)userId
                                       status:(NSInteger)status;
@end

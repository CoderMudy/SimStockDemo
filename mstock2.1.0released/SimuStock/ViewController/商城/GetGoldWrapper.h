//
//  GetGoldWrapper.h
//  SimuStock
//
//  Created by jhss on 15/5/14.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "SimuUtil.h"
@class HttpRequestCallBack;
/**做任务/领取金币/填写邀请码数据类*/
@interface GetGoldWrapper : JsonRequestObject
/**任务编码*/
@property(nonatomic, strong) NSString *taskId;
/**任务状态*/
@property(nonatomic, retain) NSNumber *taskStatus;
/**按钮文字*/
@property(nonatomic, strong) NSString *taskText;
/**完成任务可获得金币数*/
@property(nonatomic, retain) NSNumber *goldNum;
/**个人金币数*/
@property(nonatomic, retain) NSNumber *balance;

///领取金币请求
+ (void)requestGetGoldWithCallback:(HttpRequestCallBack *)callback
                         andTaskId:(NSString *)taskId;
///做任务请求
+ (void)requestDoTaskWithCallback:(HttpRequestCallBack *)callback
                        andTaskId:(NSString *)taskId;
///填写邀请码请求
+ (void)saveInviteCodeWithCallback:(HttpRequestCallBack *)callback
                     andInviteCode:(NSString *)inviteCode;
@end

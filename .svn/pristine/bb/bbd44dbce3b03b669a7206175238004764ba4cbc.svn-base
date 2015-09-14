//
//  UserCommentList.h
//  SimuStock
//
//  Created by jhss_wyz on 15/5/25.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequester.h"
/** 公用userList类 */
#import "UserListItem.h"

/** 类说明：我的聊股：我的发布页面 */
@interface UserCommentList : JsonRequestObject <Collectionable>

/** 请求数据 */
+ (void)requestCommentDataWithCallback:(HttpRequestCallBack *)callback
                         requestUserID:(NSString *)userID
                         requestFromID:(NSString *)fromID
                         requestReqNum:(NSString *)reqNum;

/** 数据数组 */
/** tweetList节点数组 */
@property(strong, nonatomic) NSMutableArray *tweetListArray;
/** userList节点数组 */
@property(strong, nonatomic) NSMutableArray *messageListArray;

@end

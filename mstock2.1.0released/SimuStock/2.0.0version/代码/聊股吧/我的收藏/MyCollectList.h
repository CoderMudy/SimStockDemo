//
//  MyCollectList.h
//  SimuStock
//
//  Created by jhss_wyz on 15/6/3.
//  Copyright (c) 2015年 Mac. All rights reserved.
//
#import "BaseRequester.h"
/** 公用userList类 */
#import "UserListItem.h"

@interface MyCollectList : JsonRequestObject <Collectionable>

/** 请求数据 */
+ (void)requestCollectDataWithCallback:(HttpRequestCallBack *)callback
                         requestFromID:(NSString *)fromID
                         requestReqNum:(NSString *)reqNum;

/** 数据数组 */
/** tweetList节点数组 */
@property(strong, nonatomic) NSMutableArray *tweetListArray;
/** userList节点数组 */
@property(strong, nonatomic) NSMutableArray *messageListArray;

@end

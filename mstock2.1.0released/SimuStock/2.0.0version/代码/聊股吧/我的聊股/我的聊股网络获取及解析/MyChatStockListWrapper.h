//
//  MyChatStockListWrapper.h
//  SimuStock
//
//  Created by moulin wang on 14-12-15.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "BaseRequester.h"
//公用userList类
#import "UserListItem.h"

@class HttpRequestCallBack;



/** 类说明：我的聊股数据页面 */
@interface MyChatStockListWrapper : JsonRequestObject
/** 请求数据 */
+ (void)requestPositionDataWithCallback:(HttpRequestCallBack *)callback
                          requestUserID:(NSString *)userID
                          requestFromID:(NSString *)fromID
                          requestReqNum:(NSString *)reqNum;

/**数据数组*/
/**tweetList节点数组*/
@property(strong, nonatomic) NSMutableArray *tweetListArray;
/**tweetList和userList节点数组（总数组）*/
@property(strong, nonatomic) NSMutableArray *messageListArray;
@end

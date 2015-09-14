//
//  MessageCenterListWrapper.h
//  SimuStock
//
//  Created by moulin wang on 14-11-25.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequester.h"
#import "UserListItem.h"

@class HttpRequestCallBack;

@interface MessageListItem : NSObject <ParseJson>

/**tmcList数据部分*/
@property(copy, nonatomic) NSString *content;
@property(nonatomic) NSNumber *uid;
@property(copy, nonatomic) NSString *des;
@property(retain) NSNumber *msgid; // NSNumber
@property(nonatomic) NSInteger stype;
@property(nonatomic) NSNumber *relateid;
@property(nonatomic) NSInteger type;          // NSInteger
@property(retain) NSNumber *tweetid;          // NSNumber
@property(strong, nonatomic) NSNumber *ctime; // NSNumber
/**重要的数据（从UserListItem解析）*/
@property(strong, nonatomic) UserListItem *writer;

///显示的高度，只计算一次，下次直接复用
@property(nonatomic, strong) NSNumber *height;

///是否已读，只计算一次，下次直接复用
@property(nonatomic, assign) BOOL read;

@end

/** 类说明：消息中心数据页面 */
@interface MessageCenterListWrapper : JsonRequestObject<Collectionable>
/** 请求数据 */
+ (void)requestPositionDataWithInput:(NSDictionary *)dic
                       withCallback:(HttpRequestCallBack *)callback;

// TmacList
@property(strong, nonatomic) NSMutableArray *messageListArray;
@property(strong, nonatomic) NSMutableArray *userListsArray;

@end

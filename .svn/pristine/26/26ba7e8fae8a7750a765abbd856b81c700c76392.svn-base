//
//  InvieFriendListWarpper.h
//  SimuStock
//
//  Created by moulin wang on 14-11-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequestObject.h"

@class HttpRequestCallBack;
/**类说明：邀请好友炒股*/
@interface InvieFriendListWarpper : JsonRequestObject
/** 据数组*/
@property(strong, nonatomic) NSMutableArray *InvieFriendDataArray;
/** 请求数据 */
+ (void)requestPositionDataWithCallback:(HttpRequestCallBack *)callback;

@property(copy, nonatomic) NSString *userId;
@property(copy, nonatomic) NSString *nickName;
@property(copy, nonatomic) NSString *headPic;
@property(nonatomic) BOOL flag;

@end

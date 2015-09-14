//
//  FeedbackListWrapper.h
//  SimuStock
//
//  Created by moulin wang on 14-11-14.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseRequestObject.h"

@class HttpRequestCallBack;

@interface FeedbackListWrapper : JsonRequestObject

/** 反馈列表数组*/
@property(strong, nonatomic) NSMutableArray *dataArray;
/** 请求反馈列表 */
+ (void)requestFeedbackListWithCallback:(HttpRequestCallBack *)callback;

@end
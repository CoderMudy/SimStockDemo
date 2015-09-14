//
//  TalkStockListsRequest.h
//  SimuStock
//
//  Created by jhss on 14-11-21.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;
@interface TalkStockHeadContentRequest : JsonRequestObject

@property (strong, nonatomic)NSMutableArray *dataArray;

/** 获得聊股首条内容详情页 */
+ (void)getTalkStockInitialContentWithTalkWeetId:(NSString *)talkID
                           withCallback:(HttpRequestCallBack *)callback;

@end


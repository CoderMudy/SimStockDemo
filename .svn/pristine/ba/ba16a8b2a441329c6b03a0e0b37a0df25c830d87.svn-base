//
//  SystemMessageList.h
//  SimuStock
//
//  Created by Mac on 14-11-5.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

/*
 *类说明：设置－系统信息数据项
 */
@interface SystemMsgData : NSObject <ParseJson>

/** 消息ID */
@property(nonatomic, strong) NSString *mID;

/** 消息类型 */
@property(nonatomic, strong) NSString *mType;

/** 消息头 */
@property(nonatomic, strong) NSString *mTitle;

/** 消息时间 long型毫秒数 */
@property(nonatomic, assign) int64_t mTime;

/** 消息时间 转化后的字符串格式 */
@property(nonatomic, strong) NSString *mstrTime;

/** 消息内容 */
@property(nonatomic, strong) NSString *mMsgContent;
///显示的高度，只计算一次，下次直接复用
@property(nonatomic, strong) NSNumber *height;
@end

@interface SystemMessageList : JsonRequestObject <Collectionable>

/** 系统消息数组*/
@property(strong, nonatomic) NSMutableArray *dataArray;

/** 请求系统消息列表 */
+ (void)requestMessageListWithDic:(NSDictionary *)dic
                     withCallback:(HttpRequestCallBack *)callback;

@end

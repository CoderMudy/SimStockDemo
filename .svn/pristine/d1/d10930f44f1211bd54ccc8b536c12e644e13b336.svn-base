//
//  SimuClosedDetailPageData.h
//  SimuStock
//
//  Created by moulin wang on 14-2-14.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequestObject.h"



static NSString *const HeightCachKeyAll = @"all";
static NSString *const HeightCachKeyTitle = @"title";
static NSString *const HeightCachKeyContent = @"content";
static NSString *const HeightCachKeySourceContent = @"o_content";
static NSString *const HeightCachKeySourceAll = @"reply_block";


@class HttpRequestCallBack;

//清仓详细信息
@interface ClosedDetailInfo : NSObject <ParseJson>
@property(copy, nonatomic) NSString *seqID;
@property(copy, nonatomic) NSString *type;
@property(copy, nonatomic) NSString *content;
@property(copy, nonatomic) NSString *createTime;

@property(strong, nonatomic) NSNumber *adjustHeight;

- (NSString *)stockCode;

- (NSString *)stockName;

/** 高度缓存：图片以地址为key，富文本以内容为key，整体的key为all */
@property(strong, nonatomic) NSMutableDictionary *heightCache;

@end

@interface SimuClosedDetailPageData : JsonRequestObject <Collectionable>

@property(strong, nonatomic) NSMutableArray *closedDetailList;

+ (void)requestClosedTradeDetailWithDic:(NSDictionary  *)dic
                           withCallback:(HttpRequestCallBack *)callback;

+ (void)requestPositionTradeDetailWithDic:(NSDictionary *)dic withCallback:(HttpRequestCallBack *)callback;

/** 请求牛人计划的交易明细 */
+ (void)requestSuperTradeListWithParams:(NSDictionary *)dic
                           withCallback:(HttpRequestCallBack *)callback;
@end

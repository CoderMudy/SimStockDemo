//
//  GameAdvertisingData.h
//  SimuStock
//
//  Created by Yuemeng on 14-11-14.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

/** 广告数据类 */
@interface GameAdvertisingData : JsonRequestObject
/** 广告ID */
@property(nonatomic, strong) NSString *ADid;
/** 广告标题 */
@property(nonatomic, strong) NSString *title;
/** 广告图地址 */
@property(nonatomic, strong) NSString *adImage;
/** 广告类型，2501：图片广告，2502：文字广告 */
@property(nonatomic, strong) NSString *type;
/** 广告类型，2501：图片广告，2502：文字广告 */
@property(nonatomic, strong) NSString *forwardUrl;
/** 如果type=2502，需显示的广告内容 */
@property(nonatomic, strong) NSString *content;
/** 排序 */
@property(nonatomic, strong) NSString *rank;
/** 数据数据 */
@property(strong, nonatomic) NSMutableArray *dataArray;
/** 开户界面广告请求 */
+ (void)requestNormalAdvertisingDataAdWallWithUrl:(NSString *)url
                                     withCallBack:(HttpRequestCallBack *)callback;
/** AdWall请求 */
+ (void)requestGameAdvertisingDataAdWallWithCallback:
        (HttpRequestCallBack *)callback;
/** PopWindow请求 */
+ (void)requestGameAdvertisingDataPopWindowWithCallback:
        (HttpRequestCallBack *)callback;
/**聊股吧广告请求 */
+ (void)requeststockBarAdvertisingDataAdWallWithCallback:
(HttpRequestCallBack *)callback;
/** 追踪牛人广告图片请求 */
+ (void)requestFollowMasterBannerDataAdWallWithCallback:
(HttpRequestCallBack *)callback;
/** 开户界面广告请求 */
+ (void)requestOpenAccountAdvDataWithCallback:(HttpRequestCallBack *)callback;
/** 引导页广告请求 */
+ (void)requestGameAdvertisingDataLoadingPageWithCallback:
(HttpRequestCallBack *)callback;
/** 高级VIP专区图片请求 */
+ (void)requestAdvanceVIPAdvertisingDataAdWallWithCallback:
(HttpRequestCallBack *)callback;
@end

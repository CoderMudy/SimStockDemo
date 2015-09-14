//
//  MyStockBarListData.h
//  SimuStock
//
//  Created by Yuemeng on 14-11-24.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

///** 我关注的股吧列表 */
//@interface MyBarsData : JsonRequestObject
//
///** 股吧ID */
//@property(nonatomic, strong) NSNumber *barId;
///** 股吧名称 */
//@property(nonatomic, strong) NSString *name;
///** 股吧简介 */
//@property(nonatomic, strong) NSString *des;
///** 股吧logo */
//@property(nonatomic, strong) NSString *logo;
///** 股聊数 */
//@property(nonatomic, strong) NSNumber *postNum;
///** seqId分页排序 */
//@property(nonatomic, strong) NSNumber *seqId;
//@end

/** 我的聊股吧数据模型 */
@interface MyStockBarListData : JsonRequestObject

/** 是否有更新(true:有;false:没) */
@property(nonatomic) BOOL hasNew;
/** 关注的股吧列表 */
@property(nonatomic, strong) NSMutableArray *myBars;

/** tweetId:上次登录时用户关注的股吧的最新的聊股 ID */
+ (void)requestMyStockBarListDataWithCallback:(HttpRequestCallBack *)callback;

@end

//
//  SliderUserCounterWapper.h
//  SimuStock
//
//  Created by Mac on 14-10-30.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;


/*
 *类说明：侧边栏的数据
 */
@interface SliderCounterItem : BaseRequestObject2 <ParseJson>
/** 总数 */
@property(copy, nonatomic) NSString *totalNum;
/** 百分比*/
@property(copy, nonatomic) NSString *percentage;

@end

/*
 *
 */
@interface SliderUserCounterWapper : JsonRequestObject

/** */
@property(strong, nonatomic) SliderCounterItem *mytrace;

/** */
@property(strong, nonatomic) SliderCounterItem *myfollow;

/** */
@property(strong, nonatomic) SliderCounterItem *myfans;

/** */
@property(strong, nonatomic) SliderCounterItem *mytrade;

/** */
@property(strong, nonatomic) SliderCounterItem *myistock;

/** */
@property(strong, nonatomic) SliderCounterItem *mycollect;



/** 请求用户计数信息 */
+ (void)requestUserCounterWithCallback:(HttpRequestCallBack *)callback;

@end

//
//  StockNewsList.h
//  SimuStock
//
//  Created by Mac on 14-11-6.
//  Copyright (c) 2014年 Mac. All rights reserved.
//


#import "BaseRequestObject.h"

@class HttpRequestCallBack;

typedef NS_ENUM(NSUInteger, StockNewsType){
  //股票新闻列表
  StockNews=0,
  //股票公告列表
  StockNewsBull=1,
  /**股票所在行业的新闻列表 */
  StockNewsIndustry=2
};

/*
 *类说明：行情 资讯列表
 */
@interface StockNewsData : NSObject<ParseJson>

//文章id
@property (strong,nonatomic) NSString *newsID;

//文章标题
@property (strong,nonatomic) NSString *newsTitle;

//文章链接地址
@property (strong,nonatomic) NSString *newsUrl;

//文章发表时间
@property (assign,nonatomic) int64_t newsTime;

@end
/** 类说明：股票新闻 */
@interface StockNewsList : JsonRequestObject

/** 持仓数据数组*/
@property(strong, nonatomic) NSMutableArray *dataArray;

/** 请求股票新闻 */
+ (void)requestNewsListWithType:(StockNewsType) type
                  withStockCode:(NSString*) stockCode
                     withFromId:(NSString*) fromId
                      withLimit:(NSString*) limit
                   withCallback:(HttpRequestCallBack *)callback;

@end

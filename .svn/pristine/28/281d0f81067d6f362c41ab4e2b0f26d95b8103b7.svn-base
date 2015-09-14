//
//  CustomPageDada.h
//  SimuStock
//
//  Created by Mac on 13-9-5.
//  Refactored by Yuemeng on 15-4-3.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "SimuPageData.h"
#import "BaseRequestObject.h"
#import "StreamFormatRequester.h"
#import "BaseRequestObject.h"

@class HttpRequestCallBack;

/*
 *类说明：股票信息
 */
@interface StockInfo : NSObject

/** 股票名称 */
@property(nonatomic, copy) NSString *stockname;
/** 基金 */
@property(copy, nonatomic) NSString *firstType;
/** 股票代码 */
@property(nonatomic, copy) NSString *stockCode;
/** 量比 */
@property(nonatomic, copy) NSString *valuePercent;
/** 收盘价 */
@property(nonatomic, copy) NSString *closePrice;
/** 八位股票代码 */
@property(nonatomic, copy) NSString *eightstockCode;
/** 现量 */
@property(nonatomic, copy) NSString *valume;
/** 最新价 */
@property(nonatomic, copy) NSString *cornewPrices;
/** 最高价 */
@property(nonatomic, copy) NSString *hightPrice;
/** 最低价 */
@property(nonatomic, copy) NSString *lowestPrice;
/** 开盘价 */
@property(nonatomic, copy) NSString *openPrice;
/** 日期 */
@property(nonatomic, copy) NSString *Cordate;
/** 总成交量 */
@property(nonatomic, copy) NSString *allVolume;
/** 总成交额 */
@property(nonatomic, copy) NSString *allAutome;
/** 涨幅 */
@property(nonatomic, copy) NSString *gains;
/** 涨跌 */
@property(nonatomic, copy) NSString *updownValue;
/** 振幅 */
@property(nonatomic, copy) NSString *amplitude;
/** 成交总量数字记录 */
@property(nonatomic) int64_t headsAmount;
/** 成交总额 */
@property(nonatomic) double dealsAmount;
/** 涨幅的数字记录 */
@property(nonatomic) CGFloat fgins;
/** 振幅数字版本 */
@property(nonatomic) CGFloat famplitude;
/** 自选股是否选中 （自选股删除专用） */
@property(nonatomic) BOOL isSelected;
//涨跌数字纪录
@property(nonatomic) float updownprice;

@end

/*
 *类说明：股票信息数组
 */
@interface StockInfoArray : BaseRequestObject <ParseStream>
@property(nonatomic, strong) NSMutableArray *stockTable;

///请求多支股票信息
+ (void)requestStocksWithStocks:(NSString *)stocks
                   withCallback:(HttpRequestCallBack *)callback;
@end

/*
 *类说明：我的关注股友交易数据
 */
@interface MFMyAttentionTradeDataItem : NSObject

//判定图标
@property(nonatomic) BOOL judgeview;
// aid
@property(nonatomic, copy) NSString *aid;
// id
@property(nonatomic, copy) NSString *iid;
//回传起始id
@property(nonatomic, strong) NSNumber *tstockid;
//成交时间
@property(nonatomic, copy) NSString *time;
//交易类型 (买入还是卖出)
@property(nonatomic, copy) NSString *tradetype;
//交易数据
@property(nonatomic, copy) NSString *tradetcontent;
//股票名称
@property(nonatomic, copy) NSString *stockname;
//股票代码
@property(nonatomic, copy) NSString *stockcode;
//股票名称
@property(nonatomic, copy) NSString *name;
//记录交易数据项数
@property(nonatomic) NSInteger ceveral;

@end

/*
 *类说明：我的关注数据单项元素
 */
@interface MFMyAttentionItem : NSObject

//昵称
@property(nonatomic, copy) NSString *nickname;
//用户id
@property(nonatomic, copy) NSString *userid;
//总盈利
@property(nonatomic, copy) NSString *totolProfit;
//持仓数
@property(nonatomic, copy) NSString *totolHoldnum;
//交易数
@property(nonatomic, copy) NSString *tradenum;
//解盘数
@property(nonatomic, copy) NSString *Interpretationnum;
//粉丝
@property(nonatomic, copy) NSString *fansnum;
//是否关注
@property(nonatomic, copy) NSString *isattention;
//头像数据
@property(nonatomic, copy) NSString *httpHeadImageURL;

@end

/*
 *类说明：用来存储一些数组数据
 */
@interface CustomPageData : SimuPageData

//数据数组
@property(nonatomic, strong) NSMutableArray *stockTrendArray;
//字典类型数据
@property(nonatomic, strong) NSDictionary *dictionary;
//总记录数（行情页面使用）
@property(nonatomic) NSInteger totalCount;
//个人主页聊股信息使用
@property(nonatomic, copy) NSString *tStockId;

@end

/*
 *类说明：走势数据
 */
@interface TrendDataPage : CustomPageData

//股票名称
@property(nonatomic, copy) NSString *stockname;
//股票代码
@property(nonatomic, copy) NSString *stockcode;

@end

/*
 *股票信息页面
 */
@interface StockTrendItemInfo : BaseRequestObject2

//当前价格
@property(nonatomic) float currentPrice;
//收盘价格
@property(nonatomic) float closePrice;
//最高价格
@property(nonatomic) float highestPrice;
//最低价格
@property(nonatomic) float lowestPrice;
//日期
@property(nonatomic) int64_t date;
//总成交量
@property(nonatomic) int64_t totalvolume;
//总成交额
@property(nonatomic) int64_t totalamount;
//现手
@property(nonatomic) int64_t corhands;
//新的逐点压缩接口使用的数据
//时间
@property(nonatomic) int time;
//收盘价
@property(nonatomic) int price;
//成交量
@property(nonatomic) int64_t amount;
//均价
@property(nonatomic) int avgPrice;

@end

/*
 *k线图数据
 */
@interface KLineDataItem : BaseRequestObject2

//收盘价
@property(nonatomic) float closeprice;
//最高价
@property(nonatomic) float highprice;
//最低价
@property(nonatomic) float lowprice;
//开盘价
@property(nonatomic) float openprice;
//昨收价
@property(nonatomic) float yestodaycloseprice;
//日期
@property(nonatomic) int64_t date;
//结束日期
@property(nonatomic) int64_t endDate;
//成交量
@property(nonatomic) int64_t volume;
//成交额
@property(nonatomic) int64_t amount;

@end

/*
 *类说明：表格field说明
 */
@interface tableFeildItemInfo : NSObject

// feild名称
@property(nonatomic, copy) NSString *name;
//字段名称长度
@property(nonatomic) int namelenth;
// feild是否有注释
@property(nonatomic) BOOL isNotes;
//字段类型
@property(nonatomic, copy) NSString *type;
//字段精度
@property(nonatomic) int precision;
//字段的最大长度
@property(nonatomic) int maxLenth;
//注释长度
@property(nonatomic) int notesLenth;
//注释内容
@property(nonatomic, copy) NSString *notescontent;

@end

/*
 *类说明：表格数据结构
 */
@interface PacketTableData : NSObject

///表格名称
@property(nonatomic, copy) NSString *tableName;
///表格feild信息
@property(nonatomic, strong) NSMutableArray *fieldItemArray;
///数据信息(全部行数据)
@property(nonatomic, strong) NSMutableArray *tableItemDataArray;
///表格列数
@property(nonatomic) int tableConnumber;
///表格行数
@property(nonatomic) int tableLinenumber;

@end

/*
 *类说明：聊股学堂 文章接口单项数据
 */
@interface SchoolArticleData : NSObject <ParseJson>

/** 文章id */
@property(nonatomic, copy) NSString *articleID;
//文章标题
@property(nonatomic, copy) NSString *articleTitle;
//文章链接地址
@property(nonatomic, copy) NSString *articleUrl;

@end

/**
 类说明：文章接口列表
 */
@interface SchoolArticleDataList : JsonRequestObject <Collectionable>

@property(nonatomic, strong) NSMutableArray *schoolDataArray;

/** 文章接口列表 Dictionary */
+ (void)requestPositionDataWithParameters:(NSDictionary *)dic
                             withCallback:(HttpRequestCallBack *)callback;
@end

/*
 *类说明：主页 查询用户账户信息显示数据
 */
@interface HomeIndividualRankingData : NSObject

//周盈利率
@property(nonatomic, copy) NSString *wProfit;
//周排行
@property(nonatomic, copy) NSString *wRank;
//周上升名次
@property(nonatomic, copy) NSString *wRise;
//月盈利率
@property(nonatomic, copy) NSString *mProfit;
//月排行
@property(nonatomic, copy) NSString *mRank;
//月上升名次
@property(nonatomic, copy) NSString *mRise;
//总盈利率
@property(nonatomic, copy) NSString *tProfit;
//总排行
@property(nonatomic, copy) NSString *tRank;
//总上升名次
@property(nonatomic, copy) NSString *tRise;

@end

/*
 *类说明：主页 完整交易统计
 */
@interface TradeStatisticsData : NSObject

//总交易数
@property(nonatomic, copy) NSString *closeNum;
//交易成功数
@property(nonatomic, copy) NSString *sucNum;
//交易成功率
@property(nonatomic, copy) NSString *sucRate;
//平均持仓天数
@property(nonatomic, copy) NSString *avgDays;
//最后一次交易日期
@property(nonatomic, copy) NSString *lastCloseAt;

@end

/*
 *类说明：个人信息 成功邀请好友列表
 */
@interface SuccessfullyInvitedList : NSObject

//被关注人ID
@property(nonatomic, copy) NSString *userId;
//昵称
@property(nonatomic, copy) NSString *nickName;
//头像地址
@property(nonatomic, copy) NSString *headPic;
//是否已关注
@property(nonatomic) BOOL flag;

@end

/*
 *类说明：个股报价信息
 */
@interface stockheadinfoItem : NSObject

//当前价
@property(nonatomic) float curprice;
//涨跌
@property(nonatomic) float change;
//涨跌幅
@property(nonatomic) float changePer;
//开盘
@property(nonatomic) float openprice;
//收盘
@property(nonatomic) float closeprice;
//最高
@property(nonatomic) float hightprice;
//最低
@property(nonatomic) float lowprice;
//成交量
@property(nonatomic) int64_t totolAmount;
//成交额
@property(nonatomic) double totolMoney;
//振幅
@property(nonatomic) float zfper;
//市盈率
@property(nonatomic) float revenue;
//流通市值
@property(nonatomic) int64_t outshare;
//还手率
@property(nonatomic) float hsPer;
//上涨数
@property(nonatomic) int64_t upnum;
//平盘数
@property(nonatomic) int64_t flatnum;
//下跌数
@property(nonatomic) int64_t downnum;

@end

/*
 *类说明：明细数据
 */
@interface StockTradeDetailData : NSObject
///量
@property(nonatomic) int64_t amount;
///额
@property(nonatomic) double money;
///内外盘（F:集合竞价；B:买盘（外盘）；S:卖盘（内盘）；?：未知）
@property(nonatomic, copy) NSString *wind;
///成交笔数
@property(nonatomic) NSInteger tradeCount;
///价格
@property(nonatomic) float price;
///时间
@property(nonatomic) NSInteger time;
///买盘量
@property(nonatomic) int64_t bidAmount;

@end

/*
 *类说明：分价
 */
@interface StockPriceStateData : NSObject
///最新价
@property(nonatomic) float price;
///量
@property(nonatomic) int64_t amount;
///买盘量
@property(nonatomic) int64_t bidAmount;
///成交笔数
@property(nonatomic) int tradeCount;

@end

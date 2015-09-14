//
//  RealTradeUrls.h
//  SimuStock
//
//  Created by Mac on 14-9-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

//枚举 取出已经保存的数据
typedef NS_ENUM(NSInteger, GetBrokerInfoData) {
  GetBrokerUrl = 1, /** 请求url */
  GetBrokerMethod,  /** 请求类型 GET 或者 POST */
  GetBrokerNum,     /** 券商Num号 */
  GetBrokerType     /** 券商柜台类型 1 = 顶点 2 = 恒生 */
};

@protocol RealTradeUrlFactory <NSObject>

/**
 * 登录接口
 */
- (NSString *)getLoginPath;

/**
 * 实时行情
 */
- (NSString *)getPlancountPath;

/**
 * 买卖委托
 */
- (NSString *)getEntrustorderPath;

/**
 * 持仓查询
 */
- (NSString *)getQueryuserstockPath;

/**
 * 今日委托
 */
- (NSString *)getTodayentrustPath;

/**
 * 今日成交
 */
- (NSString *)getTodaytransactionPath;

/**
 * 历史成交
 */
- (NSString *)getHistransactionPath;

/**
 * 撤单
 */
- (NSString *)getRevokePath;

/**
 * 银证转账信息
 */
- (NSString *)getBankSecuInfo;

/**
 * 银行转证券
 */
- (NSString *)getBankToSecu;

/**
 * 证券转银行
 */
- (NSString *)getSecuToBank;

/**
 * 转账查询
 */
- (NSString *)getTransaccountDetail;

/**
 * 指定交易（页面显示）
 */
- (NSString *)getDoSpecifiedTransaction;

/**
 * 指定交易（提交委托）
 */
- (NSString *)getSpecifiedTransaction;

/**
 * 查询用户资料
 */
- (NSString *)getUserInfo;

/**
 * 得到请求 类型 POST 或者 GET
 */
- (NSString *)getBrokerRequstMethod;

/**
 * 得到柜台类型 type  1 = 顶点 2 = 恒生
 */
-(NSInteger)getBrokerFactoryType;

/** 得到 brokerID */
-(NSString *)getFactoryBrokerID;

/** 得到 userCust 客户号 */
-(NSString *)getBrokerUserCust;

@end

/**
 顶点柜台的工厂：提供访问的url列表 type = 1
 */
@interface RealTradeApexSoftUrlFactory : NSObject <RealTradeUrlFactory>
/** 请求类型 获取柜台HTTP发送类型 */
@property(nonatomic, strong) NSString *method;
/** url请求头 柜台请求头 */
@property(nonatomic, strong) NSString *urlHead;
/** 券商id */
@property(nonatomic, strong) NSString *brokerId;
/** 当前券商用户 */
@property(nonatomic, strong) NSString *userCust;
/** 柜台类型 */
@property(assign, nonatomic) NSInteger type;


//下面的方法 是传值
/** 获得 customer 客户号 */
- (void)sendValueCustomer:(NSString *)customer;
/** 获取 URL 头 */
- (void)setUrlPrefix:(NSString *)urlHead;
/** 获取请求方式 */
- (void)sendValueForLongon:(NSString *)method;
/** 获取客户id */
- (void)sendvalueforBrokerID:(NSString *)brokerId;
/** 获取柜台类型 1 = 顶点 2 = 恒生 */
- (void)senDValueBrokerFactoryType:(NSInteger)type;

@end

//单利
@interface RealTradeUrls : NSObject
+ (RealTradeUrls *)singleInstance;
/** 顶点柜台 */
@property(nonatomic, strong) RealTradeApexSoftUrlFactory *apexSoftUrlFactory;
/**
 返回指定类型的实盘请求网址工厂 这里不需要做判断
 */
+(id)getRealTradeUrlFactory;


/*
 *  保存项：
 *  证券类型 type
 *  证券网址 url
 *  证券操作的接口请求方式 method
 *  证券券商号 num
 */
- (void)saveRealTradeUrlFactory:(NSInteger)type;
/** 自动配置实盘信息 */
- (BOOL)autoLoadRealTradeUrlFactory;

/** 取数据 */
- (NSString *)getBrokerStockInfor:(GetBrokerInfoData)getBrokerInfo;

@end

//
//  WFAccountInterface.h
//  SimuStock
//
//  Created by Jhss on 15/4/21.
//  Copyright (c) 2015年 Mac. All rights reserved.
//
/** 优顾账户相关的接口 */
#import <Foundation/Foundation.h>
#import "JsonFormatRequester.h"

@class WFBankInfoOfBindedBankcard;
@class WFAccountBalanceAccountList;
@class WFCashFlowList;
@class WFPayDataList;

#pragma mark
/** 1.1查询优顾账户的资产 */
/** 查询优顾账户的资产 */
@interface WFAccountBalance : JsonRequestObject

///优顾账户id
@property(nonatomic, assign) int yid;
///用户id
@property(nonatomic, assign) int uid;
///资产总额
@property(nonatomic, copy) NSString *amount;
///银行手续费
@property(nonatomic, copy) NSString *BankFee;
@end

#pragma mark
/** 1.2资金明细流水 */
@interface WFCapitalSubsidiary : JsonRequestObject <Collectionable>

///优顾账户id
@property(nonatomic, assign) int yid;
///用户id
@property(nonatomic, assign) int uid;
///资产总额
@property(nonatomic, copy) NSString *amount;

//资金明细列表
@property(nonatomic, copy) NSMutableArray *cash_flow_list;

@end

/** cash_flow_list内部结构 */
@interface WFCashFlowList : NSObject

/// id(上下拉刷新)
@property(nonatomic) NSNumber *NumberId;

/////优顾账户id
@property(nonatomic, assign) int youguuId;
///流水类型
@property(nonatomic, copy) NSString *flowType;
///流水描述
@property(nonatomic, copy) NSString *flowDesc;
///流水发生时间
@property(nonatomic, copy) NSString *flowDatetime;
///流水发生金额
@property(nonatomic, copy) NSString *flowAmount;
///账户余额
@property(nonatomic, copy) NSString *accountBalance;

+ (instancetype)cashFlowListWithDictionary:(NSDictionary *)dic;

@end

#pragma mark
/** 1.3账户充值  给优顾账户充值 */
@interface WFPayAccountResult : JsonRequestObject

///充值订单号
@property(nonatomic, copy) NSString *order_no;

@end

#pragma mark 1.4 查询用户绑定的银行卡出参
/** 1.4.1 优顾渠道：查询用户绑定的银行卡出参 */
@interface WFBindedBankcardYouGuuResult : JsonRequestObject

/** 判断是否有绑定银行卡*/
@property(nonatomic, assign) BOOL isbind;
/** 银行卡的Logo图标 */
@property(nonatomic, copy) NSString *bank_logo;
/** 银行名称 */
@property(nonatomic, copy) NSString *bank_name;
/** 绑定的银行卡尾号（后4位） */
@property(nonatomic, copy) NSString *cardNo;

@property(nonatomic, copy) NSString *acctName;
@property(nonatomic, copy) NSString *bankId;
@property(nonatomic, copy) NSString *cardStatus;
@property(nonatomic, copy) NSString *channel;
@property(nonatomic, copy) NSString *idNo;
@property(nonatomic, copy) NSString *uid;

@end

/** 1.4.2 连连支付渠道：查询用户绑定的银行卡出参 */
@interface WFBindedBankcardLianLianPayResult : JsonRequestObject

/** 判断是否有绑定银行卡*/
@property(nonatomic, assign) BOOL isbind;
/** 银行卡的Logo图标 */
@property(nonatomic, copy) NSString *bank_logo;
/** 银行名称 */
@property(nonatomic, copy) NSString *bank_name;
/** 绑定的手机号 */
@property(nonatomic, copy) NSString *bind_mobile;
/** 绑定的银行卡卡号（尾号） */
@property(nonatomic, copy) NSString *card_no;
/** 银行卡类型：（2：储蓄卡；3：信用卡） */
@property(nonatomic, copy) NSString *card_type;
/** 签订协议号 */
@property(nonatomic, copy) NSString *no_agree;

@property(nonatomic, copy) NSString *acctName;
@property(nonatomic, copy) NSString *bankId;
@property(nonatomic, copy) NSString *cardStatus;
@property(nonatomic, copy) NSString *channel;
@property(nonatomic, copy) NSString *idNo;
@property(nonatomic, copy) NSString *uid;

@end

/** 1.4.3 易宝支付渠道：查询用户绑定的银行卡出参 */
@interface WFBindedBankcardYeePayResult : JsonRequestObject

/** 判断是否有绑定银行卡*/
@property(assign, nonatomic) BOOL isbind;
/** 银行Logo */
@property(copy, nonatomic) NSString *bank_logo;
/** 银行名称 */
@property(copy, nonatomic) NSString *bank_name;
/** 银行卡号码后四位 */
@property(copy, nonatomic) NSString *card_last;
/** 银行卡号码前六位 */
@property(copy, nonatomic) NSString *card_top;
/** 手机号 */
@property(copy, nonatomic) NSString *phone;

@end

/** 绑定的银行卡信息 */
@interface WFBindedBankcardInfo : NSObject

/** 银行字母拼音前缀 */
@property(copy, nonatomic) NSString *bankNameChar;
/** 银行拼音简称 */
@property(copy, nonatomic) NSString *bankNameAbbr;
/** 银行名称 */
@property(copy, nonatomic) NSString *bankName;
/** 银行logo */
@property(copy, nonatomic) NSString *bankLogo;
/** 优顾账户id */
@property(copy, nonatomic) NSString *youguuId;
/** 银行卡尾号4位 */
@property(copy, nonatomic) NSString *card_no_tail;
///** 银行信息 */
//@property(strong, nonatomic) WFBankInfoOfBindedBankcard *bank;

+ (instancetype)bindedBankcardInfoWithDictionary:(NSDictionary *)dic;

@end

///** 绑定的银行卡的银行信息 */
//@interface WFBankInfoOfBindedBankcard : NSObject
//
///** 银行字母拼音前缀 */
//@property(copy, nonatomic) NSString *bankNameChar;
///** 银行拼音简称 */
//@property(copy, nonatomic) NSString *bankNameAbbr;
///** 银行名称 */
//@property(copy, nonatomic) NSString *bankName;
///** 银行logo */
//@property(copy, nonatomic) NSString *bankLogo;
//
//+ (instancetype)bankInfoOfBindedBankcardWithDictionary:(NSDictionary *)dic;
//
//@end

#pragma mark 1.7 申请提现出参
/** 1.7 申请提现出参 */
@interface WFWithdrawResult : JsonRequestObject

@end

#pragma mark 1.8 查询提现明细出参
/** 1.8 查询提现明细出参 */
@interface WFWithdrawListResult : JsonRequestObject <Collectionable>

/// 提现列表
@property(copy, nonatomic) NSArray *withdraw_list;

@end

/** 提现详细信息 */
@interface WFWithdrawDetailInfo : NSObject

/** 提现编号 */
@property(copy, nonatomic) NSString *withdrawNo;
/** 提现时间 */
@property(copy, nonatomic) NSNumber *withdrawDatetime;
/** 提现金额 */
@property(copy, nonatomic) NSString *withdrawAmount;
/** 提现状态 0：正在处理， 1：汇款完成 2：状态异常—关闭 */
@property(copy, nonatomic) NSString *withdrawStatus;

/// id
@property(nonatomic) int NumberId;
/// youguuId
@property(nonatomic, copy) NSString *youguuId;
/// accountBankId
@property(nonatomic, copy) NSString *accountBankId;

+ (instancetype)withdrawDetailInfoWithDictionary:(NSDictionary *)dic;

@end

#pragma mark
/** 1.10获取订单支付参数: */
@interface WFAllInPaymentPayData : JsonRequestObject

/** 1.10.1 获取通联支付订单支付参数 */
//通联支付
@property(nonatomic, copy) NSString *inputCharset;
///
@property(nonatomic, copy) NSString *issuerId;
/// 语言
@property(nonatomic, copy) NSString *language;
/// 商户号
@property(nonatomic, copy) NSString *merchantId;
/// 订单金额
@property(nonatomic, copy) NSString *orderAmount;
///
@property(nonatomic, copy) NSString *orderCurrency;
/// 商户订单提交时间
@property(nonatomic, copy) NSString *orderDatetime;
/// 商户订单号
@property(nonatomic, copy) NSString *orderNo;
/// 支付方式
@property(nonatomic, copy) NSString *payType;
/// 回调URL地址
@property(nonatomic, copy) NSString *pickupUrl;
/// 产品名称
@property(nonatomic, copy) NSString *productName;
/// 服务端支付回调地址
@property(nonatomic, copy) NSString *receiveUrl;
/// 签名
@property(nonatomic, copy) NSString *signMsg;
/// 签名类别
@property(nonatomic, copy) NSString *signType;
/// 网关查询接口版本
@property(nonatomic, copy) NSString *version;

@end
;

/** 1.10.2 获取连连支付订单支付参数 */
@interface WFLianLianPaymentPayData : JsonRequestObject

@property(nonatomic, copy) NSString *name_goods;
@property(nonatomic, copy) NSString *acct_name;
@property(nonatomic, copy) NSString *no_agree;
@property(nonatomic, copy) NSString *busi_partner;
@property(nonatomic, copy) NSString *dt_order;
@property(nonatomic, copy) NSString *money_order;
@property(nonatomic, copy) NSString *no_order;
@property(nonatomic, copy) NSString *notify_url;
@property(nonatomic, copy) NSString *oid_partner;
@property(nonatomic, copy) NSString *risk_item;
@property(nonatomic, copy) NSString *sign;
@property(nonatomic, copy) NSString *sign_type;
@property(nonatomic, copy) NSString *user_id;
@property(nonatomic, copy) NSString *id_no;
@property(nonatomic, copy) NSString *card_no;
@property(nonatomic, copy) NSString *id_type;

@end

/** 1.10.4 获取微信支付订单支付参数 */
@interface WFWeiXinPaymentPayData : JsonRequestObject

@property(nonatomic, copy) NSString *appid;
@property(nonatomic, copy) NSString *noncestr;
@property(nonatomic, copy) NSString *packageValue;
@property(nonatomic, copy) NSString *prepayId;
@property(nonatomic, copy) NSString *partnerid;
@property(nonatomic, copy) NSString *sign;
@property(nonatomic, copy) NSString *timestamp;

@end

#pragma mark
/** 1.11获取账户总额以及明细接口 */
@interface WFAccountAmountAndDetails : JsonRequestObject

///股票账户总额
@property(nonatomic, copy) NSString *totalAsset;
///配资总额
@property(nonatomic, copy) NSString *peiziAmount;
///保证金总额
@property(nonatomic, copy) NSString *cashAmount;
///浮动盈亏
@property(nonatomic, copy) NSString *totalProfit;
///优顾账户总额
@property(nonatomic, copy) NSString *amount;
///账户总额
@property(nonatomic, copy) NSString *totalAmount;

@end

///** 1.12 判断是否绑定银行卡 */
//@interface WFIsBindBankCardRequest : JsonRequestObject
//
///** 判断是否有绑定银行卡*/
//@property(nonatomic) BOOL isbind;
///** 银行卡的Logo图标 */
//@property(nonatomic, copy) NSString *bank_logo;
///** 银行名称 */
//@property(nonatomic, copy) NSString *bank_name;
///** 绑定的手机号 */
//@property(nonatomic, copy) NSString *bind_mobile;
///** 绑定的银行卡卡号（尾号） */
//@property(nonatomic, copy) NSString *card_no;
///** 银行卡类型：（2：储蓄卡；3：信用卡） */
//@property(nonatomic, copy) NSString *card_type;
///** 签订协议号 */
//@property(nonatomic, copy) NSString *no_agree;
//
//@property(nonatomic, copy) NSString *acctName;
//@property(nonatomic, copy) NSString *bankId;
//@property(nonatomic, copy) NSString *cardStatus;
//@property(nonatomic, copy) NSString *channel;
//@property(nonatomic, copy) NSString *idNo;
//@property(nonatomic, copy) NSString *uid;
//
//@end

#pragma mark
#pragma mark 易宝支付相关
/** 1.13 易宝支付绑定银行卡 */
@interface WFYeePayBindCardRequestResult : JsonRequestObject

/** 绑卡请求号 */
@property(nonatomic, copy) NSString *yb_req_id;

@end

/** 易宝支付绑定银行卡请求参数 */
@interface WFYeePayBindCardRequest : NSObject

/** 银行卡号 */
@property(nonatomic, copy) NSString *card_no;
/** 身份证号 */
@property(nonatomic, copy) NSString *id_no;
/** 真实姓名 */
@property(nonatomic, copy) NSString *acct_name;
/** 手机号码 */
@property(nonatomic, copy) NSString *phone;
/** 用户IP */
@property(nonatomic, copy) NSString *user_ip;

@end

/** 1.14 易宝支付token获取 */
@interface WFYeePayGetTokenRequestResult : JsonRequestObject

/** 支付token */
@property(nonatomic, copy) NSString *token;

@end

/** 1.15 易宝支付获取 */
@interface WFYeePaymentRequestResult : JsonRequestObject

@end

/** 1.16 易宝支付结果（短信验证模式） */
@interface WFYeePaymentSMSPayRequestResult : JsonRequestObject

/** 支付订单号 */
@property(nonatomic, copy) NSString *order_no;

@end

/** 易宝支付入參（短信验证模式） */
@interface WFYeePaymentSMSPayRequest : JsonRequestObject

/** 订单号 */
@property(nonatomic, copy) NSString *order_no;
/** 卡号前6位 */
@property(nonatomic, copy) NSString *card_top;
/** 卡号后4位 */
@property(nonatomic, copy) NSString *card_last;
/** 用户ip */
@property(nonatomic, copy) NSString *user_ip;

@end

/** 1.17 短信支付验证码发送 */
@interface WFYeePaymentSMSSendRequestResult : JsonRequestObject

/** 是否已经达到发送次数上限（5次） */
@property(nonatomic, assign) BOOL send_more;

@end

/** 1.18 短信支付短信确认 */
@interface WFYeePaymentSMSPayConfirmRequestResult : JsonRequestObject

@end

/** 1.19 查询cardBin接口 */
@interface WFYeePaymentCardBinRequestResult : JsonRequestObject
/** 银行卡所在银行名称 */
@property(nonatomic, copy) NSString *bankname;
/** 银行卡所在银行Logo */
@property(nonatomic, copy) NSString *bank_logo;
/** 银行卡类型（ 1：储蓄卡， 2：信用卡 ） */
@property(nonatomic, assign) NSInteger cardtype;
/** 银行卡是否可以使用 */
@property(nonatomic, assign) NSInteger isvalid;
/** 易宝支付是否支持该银行卡 */
@property(nonatomic, assign) BOOL support;
@end

/** 1.20 易宝首次支付接口 */
@interface WFYeePaymentBindPayRequestResult : JsonRequestObject

@end

@interface WFYeePaymentBindPayRequest : NSObject
/** 防止二次支付的token */
@property(nonatomic, copy) NSString *token;
/** 订单号 */
@property(nonatomic, copy) NSString *orderNo;
/** 卡号末4位 */
@property(nonatomic, copy) NSString *cardLast;
/** 卡号首6位 */
@property(nonatomic, copy) NSString *cardTop;
/** 用户ip地址 */
@property(nonatomic, copy) NSString *userIp;
/** 绑卡请求id */
@property(nonatomic, copy) NSString *ybReqId;
/** 短信验证码 */
@property(nonatomic, copy) NSString *verifyCode;
/** 签名信息 */
@property(nonatomic, copy) NSString *sign;
@end

@interface WFInquirePayChannelList : JsonRequestObject
/** 支付渠道的所有数据数组*/
@property(strong, nonatomic) NSArray *channelListArray;
@end

@interface WFInquirePayChannel : NSObject
/** 支付通道 */
@property(nonatomic, assign) NSInteger channel;
/** 支付费率 */
@property(nonatomic, assign) NSInteger feeRate;
/** 是否是推荐 */
@property(nonatomic, assign) BOOL isRecommend;
/** 渠道权重 */
@property(nonatomic, assign) NSInteger weight;
/** 定义的类型：目前只有1，配资使用 */
@property(nonatomic, assign) NSInteger type;
/** 小贴士 */
@property(nonatomic, strong) NSString *payTips;
/** 链接地址 */
@property(nonatomic, strong) NSString *openLink;
@end

@interface WFInquirePayChannelListRequest : NSObject
/** 平台类型：1: ios， 3：android */
@property(nonatomic, strong) NSString *os_type;
/** 定义的类型：目前只有1，配资使用 */
@property(nonatomic, strong) NSString *type;
@end

@interface WFAccountInterface : NSObject

/** 1.1查询优顾账户的资产 */
+ (void)WFCheckAccountBalanceWithCallback:(HttpRequestCallBack *)callback;
/** 1.2资金明细流水*/
+ (void)capitalDetailRunningWaterWithInput:(NSDictionary *)dic
                              withCallback:(HttpRequestCallBack *)callback;

/** 1.3账户充值  给优顾账户充值 */
+ (void)accountsPrepaidWithAmount:(NSString *)amount
                       andChannel:(NSString *)channel
                      andCallback:(HttpRequestCallBack *)callback;

#pragma mark 1.4 查询用户绑定的银行卡调用
/** 1.4 查询用户绑定的银行卡 */
+ (void)inquireWFBindedBankcardWithChannel:(NSString *)channel
                              WithCallback:(HttpRequestCallBack *)callback;

#pragma mark 1.7 申请提现调用
/** 1.7 申请提现网络请求 */
+ (void)applyForWFWithdrawWithAmount:(NSString *)amount
                         WithChannel:(NSString *)channel
                         andCallback:(HttpRequestCallBack *)callback;

#pragma mark 1.8 查询提现明细
/** 1.8 查询提现明细 */
+ (void)getWFWithdrawWithInput:(NSDictionary *)dic
                  withCallback:(HttpRequestCallBack *)callback;

#pragma mark 1.10获取订单支付参数
/** 1.10 获取订单支付参数 */
+ (void)getPayOrderParametersWithOrder_no:(NSString *)order_no
                                withId_no:(NSString *)id_no
                             withAgree_no:(NSString *)agree_no
                            withAcct_name:(NSString *)acct_name
                              withCard_no:(NSString *)card_no
                              withChannel:(NSString *)channel
                             withCallback:(HttpRequestCallBack *)callback;
#pragma mark
/** 1.11获取账户总额以及明细接口 */
+ (void)WFGainAccountAmountAndDetailsWithCallback:
    (HttpRequestCallBack *)callback;

//#pragma mark
///** 1.12 判断是否绑定银行卡 */
//+ (void)WFLinLianPayIsBindBankCardWithChannel:(NSString *)channel
//                                 WithCallBack:(HttpRequestCallBack *)callback;

#pragma mark 易宝支付相关请求
/** 1.13 易宝支付绑定银行卡请求 */
+ (void)WFYeePayBindCardWithRequest:(WFYeePayBindCardRequest *)bindCardrequest
                       WithCallBack:(HttpRequestCallBack *)callback;

/** 1.14 易宝支付token获取请求 */
+ (void)WFYeePayGetTokenWithCallBack:(HttpRequestCallBack *)callback;

/** 1.15 易宝支付请求 */
+ (void)WFYeePaymentWithToken:(NSString *)token
                  WithContent:(NSString *)content
                 WithCallBack:(HttpRequestCallBack *)callback;

/** 1.16 易宝支付（短信验证模式） */
+ (void)WFYeePaySMSPayWithRequest:(WFYeePaymentSMSPayRequest *)bindCardrequest
                     WithCallBack:(HttpRequestCallBack *)callback;

/** 1.17 短信支付验证码发送 */
+ (void)WFYeePaymentSMSSendWithOrderNo:(NSString *)orderNo
                          WithCallBack:(HttpRequestCallBack *)callback;

/** 1.18 短信支付短信确认 */
+ (void)WFYeePaymentSMSPayConfirmWithOrderNo:(NSString *)orderNo
                              WithVerifyCode:(NSString *)verifyCode
                                WithCallBack:(HttpRequestCallBack *)callback;

/** 1.19 查询cardBin接口 */
+ (void)WFYeePaymentCardBinWithCardNo:(NSString *)cardNo
                         WithCallBack:(HttpRequestCallBack *)callback;

/** 1.20 易宝首次支付接口 */
+ (void)WFYeePaymentBindPayWithPayParameter:
            (WFYeePaymentBindPayRequest *)payContent
                               WithCallBack:(HttpRequestCallBack *)callback;

/** 1.21 查询支付渠道列表接口 */
+ (void)inquirePaychannelsListWithParameter:
            (WFInquirePayChannelListRequest *)payContent
                               WithCallBack:(HttpRequestCallBack *)callback;

@end

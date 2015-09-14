//
//  PaymentDetailsViewController.h
//  SimuStock
//
//  Created by jhss on 15/6/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"

@class PaymentDetailsClientView;
@class WFYeePaymentCardBinRequestResult;
@class WFYeePayBindCardRequest;
@class WFYeePaymentBindPayRequest;

/**支付详情页*/
@interface PaymentDetailsViewController
    : BaseViewController <UITextFieldDelegate>

@property(weak, nonatomic) UIScrollView *mainScrollView;
@property(weak, nonatomic) PaymentDetailsClientView *mainView;

/** 充值金额（单位：元） */
@property(copy, nonatomic) NSString *amount;
/** 订单号 */
@property(copy, nonatomic) NSString *orderNo;
/** 银行卡号码 */
@property(copy, nonatomic) NSString *bankCardNo;
/** 银行卡信息 */
@property(strong, nonatomic) WFYeePaymentCardBinRequestResult *bankCardInfo;
/** 支付token，防止重复支付 */
@property(copy, nonatomic) NSString *token;

/** 小贴士 */
@property(copy, nonatomic) NSString *payTips;

/** 绑定银行卡请求入參 */
@property(strong, nonatomic) WFYeePayBindCardRequest *bindCardParameter;
/** 易宝首次支付请求入參 */
@property(strong, nonatomic) WFYeePaymentBindPayRequest *bindCardPayParameter;
/** 绑卡请求号 */
@property(copy, nonatomic) NSString *ybReqId;

- (instancetype)initWithAmount:(NSString *)amount
                    andOrderNo:(NSString *)orderNo
                      andToken:(NSString *)token
                 andBankCardNo:(NSString *)bankCardNo
                    andPayTips:(NSString *)payTips
               andBandCardInfo:(WFYeePaymentCardBinRequestResult *)cardInfo;

@end

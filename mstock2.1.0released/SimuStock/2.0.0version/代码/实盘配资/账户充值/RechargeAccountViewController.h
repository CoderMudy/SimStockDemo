//
//  RechargeAccountViewController.h
//  SimuStock
//
//  Created by Jhss on 15/4/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"
@class WFYeePaymentSMSPayRequest;

@class InputTextFieldView;
@class WFInquirePayChannelListRequest;
@class WFInquirePayChannelList;

/** 账户充值页面 */
@interface RechargeAccountViewController : BaseViewController

/** 支付金额（不支持小数点的输入，提示为输入整数） */
@property(weak, nonatomic) IBOutlet InputTextFieldView *payCountTextTF;

/** 容器View，放置支付渠道按钮 */
@property(weak, nonatomic) IBOutlet UIView *containerView;

/** 支付渠道按钮数组 */
@property(strong, nonatomic) IBOutletCollection(UIButton)
    NSArray *payChannelBtnArray;

@property(strong, nonatomic) IBOutletCollection(NSLayoutConstraint)
    NSArray *payBtnTopArray;

/** 支付渠道推荐文字Lable数组 */
@property(strong, nonatomic) IBOutletCollection(UILabel)
    NSArray *recommendLableArray;

/** 存放账户充值的订单号 */
@property(copy, nonatomic) NSString *order_no;
/** 卡号前6位 */
@property(nonatomic, copy) NSString *card_top;
/** 卡号后6位 */
@property(nonatomic, copy) NSString *card_last;
/** 用户ip */
@property(nonatomic, copy) NSString *user_ip;

/** 充值渠道 */
@property(copy, nonatomic) NSString *channel;
/** 易宝支付入參（短信验证模式） */
@property(strong, nonatomic)
    WFYeePaymentSMSPayRequest *bindPaymentSMSPayParameter;
/** 查询支付渠道列表入參 */
@property(strong, nonatomic) WFInquirePayChannelListRequest *payChannelRequest;

/** 支付渠道列表 */
@property(strong, nonatomic) WFInquirePayChannelList *payChannelList;

/** 支付小提示字典，通过渠道号获取对应支付提示（目前只有易宝用到） */
@property(strong, nonatomic) __block NSMutableDictionary *payTipDicM;
/**
 * 支付Web链接地址字典，通过渠道号获取对应支付链接（目前只有支付宝线下支付用到）
 */
@property(strong, nonatomic) __block NSMutableDictionary *openLinkDicM;

@end
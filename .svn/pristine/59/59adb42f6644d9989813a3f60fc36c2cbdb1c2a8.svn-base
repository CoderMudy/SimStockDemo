//
//  LianLianPay.m
//  SimuStock
//
//  Created by jhss_wyz on 15/5/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "LianLianPay.h"
#import "WFAccountInterface.h"

@implementation LianLianPay

+ (NSDictionary *)createLianLianOrderWithParameter:(WFLianLianPaymentPayData *)parameter {
  NSMutableDictionary *param = [NSMutableDictionary dictionary];
  
  [param setDictionary:@{
                         @"sign_type" : parameter.sign_type,
                         @"busi_partner" : parameter.busi_partner,
                         @"dt_order" : parameter.dt_order,
                         @"notify_url" : parameter.notify_url,
                         @"no_order" : parameter.no_order,
                         @"risk_item" : parameter.risk_item,
                         @"money_order" : parameter.money_order,
                         @"oid_partner" : parameter.oid_partner,
                         @"sign" : parameter.sign,
                         @"user_id" : parameter.user_id,
                         @"id_no" : parameter.id_no,
                         @"acct_name" : parameter.acct_name,
                         @"card_no" : parameter.card_no,
                         @"id_no" : parameter.id_no,
                         @"name_goods" : parameter.name_goods
                         }];
  
  if (parameter.id_type) {
    [param setObject:parameter.id_type forKey:@"id_type"];
  }
  
  return param;
}

@end

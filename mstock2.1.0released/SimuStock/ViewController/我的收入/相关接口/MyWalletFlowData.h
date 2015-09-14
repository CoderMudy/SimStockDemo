//
//  MyWalletFlowData.h
//  SimuStock
//
//  Created by Yuemeng on 15/5/25.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "JsonFormatRequester.h"
/*
 *  查询钱包流水信息
 */
@interface MyWalletFlowData : JsonRequestObject<Collectionable>

@property(nonatomic, strong) NSMutableArray *dataArray;

+ (void)requestMyWalletFlowDataWithStart:(NSDictionary *)dic
                            withCallback:(HttpRequestCallBack *)callback;

@end

@interface MyWalletFlowElement : JsonRequestObject
/**交易时间*/
@property(nonatomic, copy) NSString *tradeTime;
/**交易金额*/
@property(nonatomic) double tradeFee;
/*
 *交易类型。
 *0：交易关闭
 *1：正在处理
 *2：交易成功
 *3：兑换成功
 */
@property(nonatomic) int tradeStatus;
/*
 *交易类型。
 *1：申请提现
 *2：兑换钻石
 *3：被追踪收入
 */
@property(nonatomic) int tradeType;

@end

//
//  WithFundingProduct.m
//  SimuStock
//
//  Created by jhss_wyz on 15/4/10.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#pragma mark 配资产品相关响应结果

@implementation WFProductInfoList

- (void)jsonToObject:(NSDictionary *)dic {
  self.prodInfoList = [dic[@"data"][@"orderNo"] string];
}

@end

@implementation WFProdOrderNo

- (void)jsonToObject:(NSDictionary *)dic {
  self.orderNo = [dic[@"data"][@"orderNo"] string];
}

@end

@implementation WFContractExtension

@end

#pragma mark 配资产品相关的调用

@implementation WithFundingProduct






@end

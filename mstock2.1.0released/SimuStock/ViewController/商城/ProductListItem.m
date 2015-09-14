//
//  productListself.m
//  SimuStock
//
//  Created by jhss on 13-9-18.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "ProductListItem.h"
#import "JsonFormatRequester.h"

/*******************************************************************
 *******   追踪卡      **********************************************
 ***************************************/
@implementation TrackCardInfo

- (void)jsonToObject:(NSDictionary *)obj {
  //商品编号
  NSString *producID = obj[@"productId"];
  self.CardID = producID;
  //商品名称
  NSString *producName = obj[@"name"];
  self.CardName = producName;
  //商品价格
  NSNumber *producPrice = obj[@"salePrice"];
  self.CardPrice = [NSString stringWithFormat:@"%ld", (long)producPrice.integerValue];
  //价格单位
  NSString *producUnit = obj[@"priceUnit"];
  self.CardUint = producUnit;
  //支付方式
  NSString *producPayType = obj[@"payTypes"];
  self.CardPayType = producPayType;
  //商品图片
  NSString *producPicUrl = obj[@"productPic"];
  if (producPicUrl == nil) {
    producPicUrl = @"";
  }
  self.CardPicUrl = producPicUrl;
  //商品排序
  NSString *producSqunes = obj[@"sequence"];
  self.sequece = producSqunes;
  //使用说明
  NSString *producdirections = obj[@"directions"];
  self.directions = producdirections;
  //详情
  NSString *productDetail = obj[@"detail"];
  self.detail = productDetail;
  //商品描述
  self.productDescription = obj[@"description"];
  //折扣
  NSString *productDiscount = obj[@"discount"];
  self.discount = productDiscount;
  //折扣前价格
  id nocountPrice = obj[@"costPrice"];
  self.noCountPrice = [SimuUtil changeIDtoStr:nocountPrice];

  //钻石数量
  id diamondscount = obj[@"count"];
  self.DimondsCount = [SimuUtil changeIDtoStr:diamondscount];
}

- (BOOL)isProp {
  return YES;
}

@end

@implementation ProductListItem
- (void)jsonToObject:(NSDictionary *)smallDict {

  //产品描述
  self.mDescription = smallDict[@"description"];
  //详情
  self.mDetail = smallDict[@"detail"];
  //产品名称
  self.mName = smallDict[@"name"];
  self.mPayType = smallDict[@"type"];

  self.mDiscount = smallDict[@"discount"];

  //价值钻石数(折扣后价格)
  NSNumber *id_price = smallDict[@"discountDiamond"];
  self.mPrice = [SimuUtil changeIDtoStr:id_price];
  //商品id
  self.mProductId = smallDict[@"id"];
  //产品图片下载地址
  self.mProductPic = smallDict[@"logo"];
  //折扣前价格
  id notcountprice = smallDict[@"costDiamond"];
  self.mNoCountPrice = [SimuUtil changeIDtoStr:notcountprice];
  //是否打折
  self.mSale = [SimuUtil changeIDtoStr:smallDict[@"sale"]];
  //是否抢购
  self.mFlashSale = [SimuUtil changeIDtoStr:smallDict[@"flashSale"]];
  //排序
  self.mRank = [SimuUtil changeIDtoStr:smallDict[@"rank"]];

  NSLog(@"商品id = %@ ， 商品名称 = %@", self.mProductId, self.mName);
}

- (BOOL)isFundCard {
  return [_mCategoryId isEqualToString:@"D020000"] || [_mCategoryId isEqualToString:@"D010000"];
}

- (BOOL)isProp {
  return [_mCategoryId isEqualToString:@"D030000"] || [_mCategoryId isEqualToString:@"D040000"];
}

@end

@implementation CompetitionPurchaseDisplayData
- (void)jsonToObject:(NSDictionary *)obj {
  //商品名称
  NSString *sad_name = obj[@"name"];
  self.name = [SimuUtil changeIDtoStr:sad_name];
  //商品原价
  self.costPrice = [obj[@"costPrice"] integerValue];
  //支付方式
  NSString *sad_payTypes = obj[@"payTypes"];
  self.payTypes = [SimuUtil changeIDtoStr:sad_payTypes];
  //商品编号productId
  NSString *sad_productId = obj[@"productId"];
  self.productId = [SimuUtil changeIDtoStr:sad_productId];
}
@end

@implementation ProductList

- (NSDictionary *)mappingDictionary {
  return @{ @"dataArray" : NSStringFromClass([ProductListItem class]) };
}

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.dataArray = [[NSMutableArray alloc] init];
  NSArray *array = dic[@"result"];
  for (NSDictionary *subDict in array) {
    NSArray *subArray = subDict[@"data"];
    for (NSDictionary *smallDict in subArray) {
      ProductListItem *item = [[ProductListItem alloc] init];
      //产品类型
      item.mCategoryId = subDict[@"categoryId"];
      [item jsonToObject:smallDict];
      if ([item.mProductId isEqualToString:@"D030100001"]) {
      } else {
        [self.dataArray addObject:item];
      }
    }
  }
}
- (NSArray *)getArray {
  return _dataArray;
}

+ (void)requestProductListWithCatagories:(NSString *)categories
                            withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [NSString stringWithFormat:@"%@pay/shop/propsList?categories=%@&channelId=-1",
                                             mall_address, categories];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];

  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[ProductList class]
             withHttpRequestCallBack:callback];
}

@end

@implementation DiamondList

- (NSDictionary *)mappingDictionary {
  return @{ @"dataArray" : NSStringFromClass([TrackCardInfo class]) };
}

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.dataArray = [[NSMutableArray alloc] init];
  NSArray *array = dic[@"result"];
  for (NSDictionary *dicItem in array) {
    TrackCardInfo *item = [[TrackCardInfo alloc] init];
    [item jsonToObject:dicItem];
    [self.dataArray addObject:item];
  }
}

- (NSArray *)getArray {
  return _dataArray;
}

+ (void)requestDiamondListWithCallback:(HttpRequestCallBack *)callback {

  NSString *url = [mall_address stringByAppendingString:@"pay/shop/productList?paytypes=107"];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];

  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[DiamondList class]
             withHttpRequestCallBack:callback];
}

+ (void)requestTrackCardListWithCallback:(HttpRequestCallBack *)callback {
  NSString *url = [mall_address stringByAppendingString:@"shop/trackCard/{ak}"];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[DiamondList class]
             withHttpRequestCallBack:callback];
}
@end

@implementation PropListForReview

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.dataArray = [[NSMutableArray alloc] init];
  NSArray *array = dic[@"result"];
  for (NSDictionary *dicItem in array) {
    NSArray *propArray = dicItem[@"data"];
    [propArray enumerateObjectsUsingBlock:^(NSDictionary *dicProp, NSUInteger idx, BOOL *stop) {
      TrackCardInfo *item = [[TrackCardInfo alloc] init];
      [item jsonToObject:dicProp];
      [self.dataArray addObject:item];
    }];
  }
}

- (NSArray *)getArray {
  return _dataArray;
}

/**
 *  用于苹果app store review的接口
 *  L130000,L160000： 追踪卡、Vip卡
 *  @param callback 回调
 */
+ (void)requestPropListForAppleReviewWithCallback:(HttpRequestCallBack *)callback {

  NSString *url =
      [mall_address stringByAppendingString:@"pay/shop/iosProductList?categories=L130000,L160000"];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];

  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[PropListForReview class]
             withHttpRequestCallBack:callback];
}

@end

@implementation QueryDiamondList

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.dataArray = [[NSMutableArray alloc] init];
  NSArray *array = dic[@"result"];
  for (NSDictionary *dic in array) {
    CompetitionPurchaseDisplayData *item = [[CompetitionPurchaseDisplayData alloc] init];
    [item jsonToObject:dic];
    [self.dataArray addObject:item];
  }
}

+ (void)requestDiamondListWithCallback:(HttpRequestCallBack *)callback {

  NSString *url = [mall_address stringByAppendingString:@"pay/shop/diamondList?paytypes=107"];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[QueryDiamondList class]
             withHttpRequestCallBack:callback];
}

@end

@implementation ExchangeProps

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.diamond = [dic[@"diamond"] intValue];
}

+ (void)requestExchangePropsWithUserName:(NSString *)userName
                           withProductId:(NSString *)productId
                            withCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [mall_address stringByAppendingString:@"pay/props/"
                    @"buyProps?ak={ak}&userId={userid}&userName={" @"userName}&propsId={propsId}"];
  NSDictionary *dic = @{ @"userName" : userName, @"propsId" : productId };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[ExchangeProps class]
             withHttpRequestCallBack:callback];
}

@end

@implementation productOrderListItem

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  NSDictionary *resultDic = dic[@"result"];
  self.mPayCode = resultDic[@"ios_pay_code"];
  self.mInOrderID = resultDic[@"in_order_id"];
}

+ (void)requestProductOrderByProductId:(NSString *)productedId
                          withCallback:(HttpRequestCallBack *)callback {

  NSString *url = [pay_address
      stringByAppendingString:@"pay/makeorder/{ak}/{userid}/{uname}/{product_id}/{pay_type}"];

  NSDictionary *dic = @{
    //    @"userid" : [SimuUtil getUserID],
    //    @"uname" : [CommonFunc base64StringFromText:[SimuUtil getUserName]],
    @"product_id" : productedId,
    @"pay_type" : @"107"
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[productOrderListItem class]
             withHttpRequestCallBack:callback];
}

@end

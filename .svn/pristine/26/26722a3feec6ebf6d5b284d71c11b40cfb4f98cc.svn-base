//
//  ProductListItem.h
//  SimuStock
//
//  Created by jhss on 13-9-18.
//  strongright (c) 2013年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequestObject.h"

@class HttpRequestCallBack;

/*
 *类说明：追踪卡信息
 */
@interface TrackCardInfo : BaseRequestObject2 <ParseJson>

/** 商品编号 */
@property(strong, nonatomic) NSString *CardID;

/** 商品名称 */
@property(strong, nonatomic) NSString *CardName;

/** 商品价格 */
@property(strong, nonatomic) NSString *CardPrice;

/** 价格单位 */
@property(strong, nonatomic) NSString *CardUint;

/** 支付方式 */
@property(strong, nonatomic) NSString *CardPayType;

/** 商品图片 */
@property(strong, nonatomic) NSString *CardPicUrl;

/** 同类型商品排序（便于显示） */
@property(strong, nonatomic) NSString *sequece;

/** 使用说明 */
@property(strong, nonatomic) NSString *directions;

/** 详情 */
@property(strong, nonatomic) NSString *detail;

/** 商品描述 */
@property(strong, nonatomic) NSString *productDescription;

/** 折扣 */
@property(strong, nonatomic) NSString *discount;

/** 折扣前价格 */
@property(strong, nonatomic) NSString *noCountPrice;

/** 钻石数量 */
@property(strong, nonatomic) NSString *DimondsCount;

- (BOOL)isProp;
@end

@interface ProductListItem : BaseRequestObject2 <ParseJson>
@property(strong, nonatomic) NSString *mMessage;
@property(strong, nonatomic) NSString *mStatus;
@property(strong, nonatomic) NSString *mCategoryId;
@property(strong, nonatomic) NSString *mDescription;
@property(strong, nonatomic) NSString *mDetail;
//@property(strong, nonatomic) NSString *mDirections;
@property(strong, nonatomic) NSString *mName;
@property(strong, nonatomic) NSNumber *mPayType;
@property(strong, nonatomic) NSString *mPrice;
//@property(strong, nonatomic) NSString *mPriceUnit;
@property(strong, nonatomic) NSString *mProductId;
@property(strong, nonatomic) NSString *mProductPic;
//@property(strong, nonatomic) NSString *mSequence;
@property(strong, nonatomic) NSString *mDiscount;     //折扣
@property(strong, nonatomic) NSString *mNoCountPrice; //折扣前价格
@property(strong, nonatomic) NSString *mFlashSale;    //是否限时抢购
@property(strong, nonatomic) NSString *mRank;         //排序
@property(strong, nonatomic) NSString *mSale;         //是否打折

- (BOOL)isFundCard;

- (BOOL)isProp;

@end

/*
 *类说明：比赛 购买钻石弹窗显示数据
 */

@interface CompetitionPurchaseDisplayData : NSObject <ParseJson>

//商品名称
@property(strong, nonatomic) NSString *name;
//商品原价
@property(assign, nonatomic) NSInteger costPrice;
//支付方式
@property(strong, nonatomic) NSString *payTypes;
//商品编号
@property(strong, nonatomic) NSString *productId;
@end

/** 类说明：商品列表 */
@interface ProductList : JsonRequestObject <Collectionable>

/** 商品列表数组*/
@property(strong, nonatomic) NSMutableArray *dataArray;

/** 请求商品列表:D020000 资金卡, D030000 道具, D050000 牛*/
+ (void)requestProductListWithCatagories:(NSString *)categories
                            withCallback:(HttpRequestCallBack *)callback;

@end

@interface DiamondList : JsonRequestObject <Collectionable>

/** 钻石商品列表数组 */
@property(strong, nonatomic) NSMutableArray *dataArray;

/** 请求钻石商品列表 */
+ (void)requestDiamondListWithCallback:(HttpRequestCallBack *)callback;

/** 请求产品列表 */
+ (void)requestTrackCardListWithCallback:(HttpRequestCallBack *)callback;


@end

@interface PropListForReview : JsonRequestObject <Collectionable>

/** 商品列表数组 */
@property(strong, nonatomic) NSMutableArray *dataArray;
/**
 *  用于苹果app store review的接口
 *  L130000,L160000： 追踪卡、Vip卡
 *  @param callback 回调
 */
+ (void)requestPropListForAppleReviewWithCallback:
(HttpRequestCallBack *)callback;

@end

@interface QueryDiamondList : JsonRequestObject

/** 钻石商品列表数组 */
@property(strong, nonatomic) NSMutableArray *dataArray;

/** 请求钻石商品列表 */
+ (void)requestDiamondListWithCallback:(HttpRequestCallBack *)callback;

@end

/** 兑换后结果返回 */
@interface ExchangeProps : JsonRequestObject

/** 兑换后剩余钻石数量 */
@property(assign, nonatomic) int diamond;

/** 请求兑换商品 */
+ (void)requestExchangePropsWithUserName:(NSString *)userName
                           withProductId:(NSString *)productId
                            withCallback:(HttpRequestCallBack *)callback;

@end

//订单数据
@interface productOrderListItem : JsonRequestObject

@property(strong, nonatomic) NSString *mPayCode;
@property(strong, nonatomic) NSString *mInOrderID;
//@property(strong, nonatomic) NSString *mNotifyURL;

/** 请求订单号 */
+ (void)requestProductOrderByProductId:(NSString *)productedId
                          withCallback:(HttpRequestCallBack *)callback;

@end

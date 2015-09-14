//
//  StoreUtil.h
//  SimuStock
//
//  Created by Mac on 14-11-11.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#import "NetLoadingWaitView.h"
#import "CompetitionCycleView.h"
#import "ProductListItem.h"

typedef void (^SuccessCallBack)();

@protocol AfterPurchaseRefreshData <NSObject>

- (void)afterPurchaseRefreshControllerData;

@end


/** 商城工具类 */
@interface StoreUtil : NSObject <UIAlertViewDelegate> {
  CompetitionCycleView *ssvc_alartVeiw;
}

@property(weak, nonatomic) id<AfterPurchaseRefreshData> afterPurchaseDelegate;

@property(nonatomic, weak) BaseViewController *viewController;

@property(nonatomic, copy) SuccessCallBack successCallBack;

- (id)initWithUIViewController:(BaseViewController *)vc;

/** 用钻石兑换道具接口 */
- (void)changeProductWithDiamonds:(NSString *)productID;

/** 用钻石兑换道具接口 */
- (void)changeProductWithDiamonds:(NSString *)productID
               andSuccessCallBack:(SuccessCallBack)successCallBack;

/** 使用钻石购买商品 */
- (void)buyProductWithDiamonds:(ProductListItem *)item;

//移除视图
- (void)removeCompetitionCycleView;

//购买钻石弹窗接口
- (void)showBuyingDiamondView;

//钻石不足视图
- (void)diamondInadequateWarningsView:(NSString *)message
                      withButtonTitle:(NSString *)buttonTitle;
@end

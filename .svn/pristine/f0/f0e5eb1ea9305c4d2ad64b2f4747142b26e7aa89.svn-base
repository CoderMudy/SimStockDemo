//
//  BaseSecuritiesCurStatusVC.h
//  SimuStock
//
//  Created by Mac on 15/6/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseTrendVC.h"
#import "StockUtil+view.h"

#pragma ICurStatusVC

///** 证券行情页面接口 */
//@protocol ICurStatusVC <NSObject>
//
///** 初始化*/
//- (instancetype)initWithFrame:(CGRect)frame
//           withSecuritiesInfo:(SecuritiesInfo *)securitiesInfo;
//
///** 重置证券信息 */
//- (void)resetWithFrame:(CGRect)frame
//    withSecuritiesInfo:(SecuritiesInfo *)securitiesInfo;
//

//
///** 请求证券数据 */
//- (void)refreshSecuritesData;
//
///** 返回行情数据的View用于截屏分享 */
//- (UIView *)curStatusViewForShare;
//
//@end

@interface BaseSecuritiesCurStatusVC : BaseTrendVC

/** 请求证券数据 */
- (void)refreshSecuritesData;

/** 清除证券数据，切换证券后，发起网络请求前，需要清除数据*/
- (void)clearSecuritesData;

/** 返回行情数据的View用于截屏分享 */
- (UIView *)curStatusViewForShare;

///涨跌幅
- (NSString *)riseRate;

///最新价
- (NSString *)curPrice;

@end

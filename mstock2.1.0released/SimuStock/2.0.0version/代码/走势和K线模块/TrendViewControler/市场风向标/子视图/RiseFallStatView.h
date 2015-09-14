//
//  RiseFallStatView.h
//  SimuStock
//
//  Created by Yuemeng on 15/5/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IndexCurpriceData;

/*
 *  涨跌数统计图
 */
@interface RiseFallStatView : UIView {
  IndexCurpriceData *_indexCurpriceData;
}

///对外刷新数据接口
- (void)requestRiseFallStatData;

@end

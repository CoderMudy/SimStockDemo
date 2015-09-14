//
//  StockUtil+view.h
//  SimuStock
//
//  Created by Mac on 15/6/5.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "StockUtil.h"

/** 仅仅封装一个View的控制器应该实现的方法 */
@protocol IViewVC <NSObject>

/** 数据是否已经绑定 */
- (BOOL)dataBinded;

/** 发起网络请求，重新刷新数据 */
- (void)refreshView;

@end

@interface StockUtil (view)

@end

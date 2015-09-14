//
//  StockPriceRemindList.h
//  SimuStock
//
//  Created by jhss on 15-4-19.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockPriceRemindList : NSObject
/** 提醒时间 转化后的字符串格式 */
@property(nonatomic,strong)NSString *remindStrTime;
/** 股票代码 */
@property(nonatomic,strong)NSString *stockCode;
/** 提醒内容 */
@property(nonatomic,strong)NSString *remindContent;
/** 提醒消息数组*/
@property(strong, nonatomic) NSMutableArray *dataArray;
@end

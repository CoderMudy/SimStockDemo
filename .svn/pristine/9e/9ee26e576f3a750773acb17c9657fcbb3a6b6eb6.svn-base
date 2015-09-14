//
//  WeiboUtil.h
//  SimuStock
//
//  Created by Mac on 14/12/9.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FTCoreTextView;



/** 类说明：聊股相关方法：解析，显示
 */
@interface WeiboUtil : NSObject

/** 向富文本显示View添加显示样式 */
+ (void)addTextStylesToTextView:(FTCoreTextView *)coreTextView;

/** 解析聊股内容，生成子元素的数组 */
+ (NSArray *)parseWeiboRichContext:(NSString *)content;
/** 解析牛人交易，生成股票代码和股票名称 */
+ (NSString *)getAttrValueWithSource:(NSString *)source
                         withElement:(NSString *)element
                            withAttr:(NSString *)attr;

@end

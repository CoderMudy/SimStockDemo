//
//  ShareController.h
//  SimuStock
//
//  Created by Mac on 15/2/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TweetListItem.h"

@interface ShareController : NSObject

/** 分享原创和转发的微博 */
- (void)shareWeibo:(TweetListItem *)homeData
    withShareImage:(UIImage *)shareImage;

/** 分享股票买卖微博 */
- (void)shareTradeWithWeibo:(TweetListItem *)homeData;

/** 分享股票分红微博 */
- (void)shareTradeDividendWithWeibo:(TweetListItem *)homeData;

@end

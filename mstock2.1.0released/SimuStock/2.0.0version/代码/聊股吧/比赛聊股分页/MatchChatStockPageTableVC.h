//
//  MatchChatStockPageTableVC.h
//  SimuStock
//
//  Created by jhss_wyz on 15/7/28.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ChatStockPageBaseTVC.h"

@interface MatchChatStockPageTVAdapter : ChatStockPageBaseTableAdapter

@end

@interface MatchChatStockPageTableVC : ChatStockPageBaseTVC

/** 比赛标题 */
@property (copy, nonatomic) NSString *matchTitle;

@end

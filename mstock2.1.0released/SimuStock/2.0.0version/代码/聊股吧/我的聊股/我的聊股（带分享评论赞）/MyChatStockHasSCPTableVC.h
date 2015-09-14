//
//  MyChatStockHasSCPTableVC.h
//  SimuStock
//
//  Created by jhss_wyz on 15/7/20.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MyChatStockTableVC.h"

@interface MyChatStockHasSCPTableAdapter : MyChatStockTableAdapter

+ (CGFloat)bindRPContentAndRPComtentImageAtCell:(MyChatStockTVCell *)cell
                                   andIndexPath:(NSIndexPath *)indexPath
                                   andTableView:(UITableView *)tableView
                               andTopViewBottom:(CGFloat)topViewBottom
                             andHasUserNameView:(BOOL)hasUserNameView;

@end

@interface MyChatStockHasSCPTableVC : MyChatStockTableVC

/** 放置分享弹出框的View */
@property(nonatomic, weak) UIView *clientView;

/** 添加分享、评论、赞的监听 */
- (void)addObservers;

@end

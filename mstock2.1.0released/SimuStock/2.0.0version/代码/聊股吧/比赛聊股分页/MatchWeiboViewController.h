//
//  MatchWeiboViewController.h
//  SimuStock
//
//  Created by Yuemeng on 15/1/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"

@class MatchChatStockPageTableVC;

/** 比赛聊股分页 */
@interface MatchWeiboViewController
    : BaseViewController {
  NSString *_matchTitle;
  UIButton *_publishButton;
}

@property(nonatomic ,strong) MatchChatStockPageTableVC *tableVC;

/** 对外初始化方法 */
- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title;

@end

//
//  NewOnlineViewCell.h
//  SimuStock
//
//  Created by Jhss on 15/6/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//
/** 全新上线 cell样式  */
#import <UIKit/UIKit.h>
#import "UIButton+Block.h"
#import "NewOnlineInfoData.h"
#import "RoundHeadImage.h"
#import "FollowMasterViewController.h"

@interface NewOnlineViewCell : UITableViewCell {
  NewOnlineInfoData *planItem;
}

/** 头像 */
@property(weak, nonatomic) IBOutlet RoundHeadImage *headImageView;
/** 计划名称 */
@property(weak, nonatomic) IBOutlet UILabel *planName;
/** 第一句描述 */
@property(weak, nonatomic) IBOutlet UILabel *descUpLabel;

/** 追踪按钮 */
@property(weak, nonatomic) IBOutlet BGColorUIButton *followButton;
/** 计划期限（月） */
@property(weak, nonatomic) IBOutlet UILabel *goalMonthsLabel;
/** 止损线 */
@property(weak, nonatomic) IBOutlet UILabel *stopLossLineLabel;
/** 目标收益 */
@property(weak, nonatomic) IBOutlet UILabel *goalProfitLabel;
/** 服务费 */
@property(weak, nonatomic) IBOutlet UILabel *serviceCostLabel;
/** 保 图片*/
@property(weak, nonatomic) IBOutlet UIImageView *assureImageView;
/** 截止时间 */
@property(weak, nonatomic) IBOutlet UILabel *stopTimelabel;

@property(strong, nonatomic) NSString *payMoneyCount;
@property(strong, nonatomic) FollowMasterViewController *followMasterVC;
/** 绑定全新上线的数据  */
- (void)bindNewOnlineCellData:(NewOnlineInfoData *)item;

@end

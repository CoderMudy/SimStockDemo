//
//  HotStockTopicCell.h
//  SimuStock
//
//  Created by Yuemeng on 14-11-27.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HotStockTopicData;

/** 热门个股 */
@interface HotStockTopicCell : UITableViewCell{
  /** 标题Label */
  UILabel *_titleLabel;

}
/** 白色底边 */
@property(strong, nonatomic) IBOutlet UIView *whiteView;
/** 股吧logo */
@property(strong, nonatomic) IBOutlet UIImageView *logoImageView;
/** 股吧名称 */
@property(strong, nonatomic) IBOutlet UILabel *nameLabel;
/** 股聊数 */
@property(strong, nonatomic) IBOutlet UILabel *postNumLabel;
/** 最新价 */
@property(strong, nonatomic) IBOutlet UILabel *priceLabel;
/** 涨跌幅 */
@property(strong, nonatomic) IBOutlet UILabel *changeRateLabel;

/** 复用Id */
@property(copy, nonatomic) NSString *reuseId;


/** 对外刷新显示数据方法数据方法 */
- (void)refreshCellInfoWithData:(HotStockTopicData *)hotStockTopicData;

@end

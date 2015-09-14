//
//  SameStockHeroTableViewCell.h
//  SimuStock
//
//  Created by Mac on 15/4/29.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Flowers.h"
#import "SameStockHero.h"
#import "RoundHeadImage.h"
#import "UserGradeView.h"
#import "SeperatorLine.h"
#import "StockUtil.h"

/** 同股牛人列表中牛人信息的TableViewCell */
@interface SameStockHeroTableViewCell : UITableViewCell

/** 用户评级按钮 */
@property(weak, nonatomic) IBOutlet Flowers *btnUserRank;

/** 用户评级按钮提示 */
@property(weak, nonatomic) IBOutlet UILabel *lblTipUserRank;

/** 用户在列表中的排名 */
@property(weak, nonatomic) IBOutlet UILabel *lblListRank;

/** 用户信息：昵称、实盘、vip */
@property(weak, nonatomic) IBOutlet UserGradeView *userNickMark;
/** 用户头像 */
@property(weak, nonatomic) IBOutlet RoundHeadImage *imgUserHeadPic;

/** 盈利率 */
@property(weak, nonatomic) IBOutlet UILabel *valueProfitRate;

/** 成本价 */
@property(weak, nonatomic) IBOutlet UILabel *valueCostPrice;

/** 持股时间 */
@property(weak, nonatomic) IBOutlet UILabel *valueHoldDuration;

/** 分割线 */
@property(weak, nonatomic) IBOutlet HorizontalSeperatorLine *separatorLine;



/** 绑定牛人数据 */
- (void)bindSameStockHero:(SameStockHero *)user
          withPriceFormat:(NSString*)format
            withTableView:(UITableView *)tableView
            withIndexPath:(NSIndexPath *)indexPath;

@end

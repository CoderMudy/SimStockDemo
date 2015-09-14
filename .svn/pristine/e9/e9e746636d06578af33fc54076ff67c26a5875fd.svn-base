//
//  MatchStockCell.h
//  SimuStock
//
//  Created by 刘小龙 on 15/6/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopAndBottomAlignmentLabel.h"
//数据类
#import "StockMatchListItem.h"

@interface MatchStockCell : UITableViewCell
/** 如果是创建人  标示符 显示 创 字  */
@property (weak, nonatomic) IBOutlet UILabel *createMarkLabel;
/** 比赛图标 */
@property (weak, nonatomic) IBOutlet UIImageView *matchIconImageView;
/** 比赛名称 */
@property (weak, nonatomic) IBOutlet UILabel *matchNameLabel;
/** 钻石小图标 */
@property (weak, nonatomic) IBOutlet UIImageView *diamondImageView;
/** 比赛简介 */
@property (weak, nonatomic) IBOutlet UIView *matchView;
/** 参数人数 */
@property (weak, nonatomic) IBOutlet UILabel *joinNumberLable;
/** 比赛创建人 */
@property (weak, nonatomic) IBOutlet UILabel *creatorLabel;
/** 比赛人数 单位  */
@property (weak, nonatomic) IBOutlet UILabel *personNameLabel;
/** 比赛日期 从xxx 到 xxx */
@property (weak, nonatomic) IBOutlet UILabel *matchDeadLineLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *matchNameLabelW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *matchDesViewHeight;

@property(strong, nonatomic) TopAndBottomAlignmentLabel *topLable;
/**有奖标识*/
@property (weak, nonatomic) IBOutlet UILabel *isAwardLabel;

///绑定数据
-(void)bindDataWithStockMatchItem:(StockMatchListItem *)stockMatchItem;

@end

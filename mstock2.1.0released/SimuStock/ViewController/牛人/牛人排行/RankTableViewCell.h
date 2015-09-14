//
//  RankTableViewCell.h
//  SimuStock
//
//  Created by jhss on 15-4-23.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Flowers.h"
#import "NickNameLabel.h"
#import "RankingListItem.h"
#import "UserGradeView.h"
#import "RoundHeadImage.h"

@interface RankTableViewCell : UITableViewCell {
  RankingListItem *_rankingListItem;
}
/**粉丝数按钮*/
@property(weak, nonatomic) IBOutlet UIButton *fansNumBtn;
/**交易数按钮*/
@property(weak, nonatomic) IBOutlet UIButton *tradeNumBtn;
/**成功率按钮*/
@property(weak, nonatomic) IBOutlet UIButton *successRateBtn;
/**当前持仓按钮*/
@property(weak, nonatomic) IBOutlet UIButton *userPositionInfoButton;

/**大红花*/
@property(strong, nonatomic) IBOutlet Flowers *flowerView;
/**交易数*/
@property(weak, nonatomic) IBOutlet UILabel *tradeNumberLabel;
/**成功率*/
@property(weak, nonatomic) IBOutlet UILabel *tradeSuccessRateLabel;
/**粉丝数*/
@property(weak, nonatomic) IBOutlet UILabel *fansNumberLabel;
/**持仓数*/
@property(weak, nonatomic) IBOutlet UILabel *positionNumberLabel;
/** 持仓数 标签*/
@property(weak, nonatomic) IBOutlet UILabel *positionTitleLabel;

/**用户头像*/
@property(weak, nonatomic) IBOutlet RoundHeadImage *headImageView;

/**榜单名称*/
@property(weak, nonatomic) IBOutlet UILabel *rankSortNameLabel;
@property(weak, nonatomic) IBOutlet UILabel *rankSortNumberLabel;
/**楼层数*/
@property(weak, nonatomic) IBOutlet UIView *leftViewSets;
- (void)leftNumberShowView:(UIView *)leftView
             withCellIndex:(NSInteger)cellIndex
                withMyRank:(NSString *)myRank;
/**用户交易评级控件*/
@property(strong, nonatomic) IBOutlet UserGradeView *userGradeView;
/**持仓按钮*/
@property(weak, nonatomic) IBOutlet UIButton *positionBtn;
/**成功率标签*/
@property(weak, nonatomic) IBOutlet UILabel *successLabel;
@property(strong, nonatomic) IBOutlet UIView *upCellLineView;
/**左侧view*/
@property(weak, nonatomic) IBOutlet UIView *leftDownView;
/**右侧view*/
@property(weak, nonatomic) IBOutlet UIView *rightDownView;
/**中间短竖线*/
@property(weak, nonatomic) IBOutlet UIView *centerLineView;

- (void)bindRankingListItem:(RankingListItem *)item
        withRankingSortName:(NSString *)rankingSortName;

@end

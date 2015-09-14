//
//  ExpertScreeningTableViewCell.h
//  SimuStock
//
//  Created by jhss on 15/8/31.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RoundHeadImage;
@class UserGradeView;
@class ExpertFilterListWrapper;
@class ExpertFilterListItem;

static const CGFloat EFTableViewCellFoldHeight = 150.0f;
static const CGFloat EFTableViewCellUnFoldHeight = 235.0f;

@interface ExpertFilterTableViewCell : UITableViewCell
/**用户头像*/
@property(weak, nonatomic) IBOutlet RoundHeadImage *headImageView;

/**用户交易评级控件*/
@property(weak, nonatomic) IBOutlet UserGradeView *userGradeView;

/**总盈利率*/
@property(weak, nonatomic) IBOutlet UILabel *grossProfitRateLab;

/**平均收益*/
@property(weak, nonatomic) IBOutlet UILabel *monthAverageIncomeLab;
/** 展开小三角*/
@property(weak, nonatomic) IBOutlet UIImageView *expandTriangleImgView;

/**成功率*/
@property(weak, nonatomic) IBOutlet UILabel *successRateLab;

/**平均持股数*/
@property(weak, nonatomic) IBOutlet UILabel *averageNumberOfSharesLab;

/**超越上证*/
@property(weak, nonatomic) IBOutlet UILabel *beyondShangHaiIndexLab;

/**年化收益*/
@property(weak, nonatomic) IBOutlet UILabel *annualYieldLab;

/**最大回撤*/
@property(weak, nonatomic) IBOutlet UILabel *maximumRetracementLab;

/**回撤占比*/
@property(weak, nonatomic) IBOutlet UILabel *retracementAccountLab;

/**交易数量*/
@property(weak, nonatomic) IBOutlet UILabel *tradeNumLab;

/**盈利占比*/
@property(weak, nonatomic) IBOutlet UILabel *accountProfitLab;

@property(weak, nonatomic) IBOutlet UIView *filterInfoBottomView;
/**cell分割线*/
@property(weak, nonatomic) IBOutlet UIView *bottomSplitLineView;
/**筛选牛人序号*/
@property(weak, nonatomic) IBOutlet UILabel *sortNumberLab;

///数据绑定
- (void)bindExpertFilterItem:(ExpertFilterListItem *)item withSortNum:(NSNumber *)sortNum withSelected:(BOOL) selected;
/**cell展开收缩*/
- (void)cellFold:(BOOL)fold;
@end

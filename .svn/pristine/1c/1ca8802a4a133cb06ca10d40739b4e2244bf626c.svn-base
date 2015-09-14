//
//  myAttentionsCell.h
//  SimuStock
//
//  Created by jhss on 13-12-18.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserGradeView.h"
#import "FollowFriendResult.h"
#import "MyAttentionInfoItem.h"
#import "RoundHeadImage.h"
#import "CellBottomLinesView.h"

@interface myAttentionsCell : UITableViewCell {
  BOOL isAnimationRun;
}

@property (weak, nonatomic) IBOutlet RoundHeadImage *userHeadImage;
@property(strong, nonatomic) IBOutlet UILabel *profitRateLabel;

@property(strong, nonatomic) IBOutlet UILabel *profitNameLabel;
@property(strong, nonatomic) IBOutlet UIButton *attentionButton;
- (IBAction)attentionSelected:(UIButton *)sender forEvent:(UIEvent *)event;
@property(strong, nonatomic) IBOutlet UIImageView *attentionImageView;

@property (weak, nonatomic) IBOutlet CellBottomLinesView *bottomSplitLineView;

// lq
@property(assign, nonatomic) BOOL isAttention;
@property(weak, nonatomic) id<FriendFollowDelegate> delegate;
@property(assign, nonatomic) NSInteger line_index;
@property(strong, nonatomic) IBOutlet UIImageView *selectImageView;

/** 用户评级控件 */
@property (weak, nonatomic) IBOutlet UserGradeView *userGradeView;

/** 关注 */
- (void)bindMyAttentionInfoItem:(MyAttentionInfoItem *)item
                  withIndexPath:(NSIndexPath *)indexPath;
/** 粉丝 */
- (void)bindMyFansItem:(MyAttentionInfoItem *)item
    WithRowAtIndexPath:(NSIndexPath *)indexPath;

@end

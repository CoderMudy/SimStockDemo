//
//  WBButtomTabBar.h
//  SimuStock
//
//  Created by jhss on 14-12-1.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBButtomTabBar : UIView
/** 赞背景图 */
@property(weak, nonatomic) IBOutlet UIImageView *praiseImageView;
/** 收藏背景图 */
@property(weak, nonatomic) IBOutlet UIImageView *collectImageview;
/** 赞button */
@property(weak, nonatomic) IBOutlet UIButton *praiseButton;
/** 分享button */
@property(weak, nonatomic) IBOutlet UIButton *shareButton;
/** 评论button */
@property(weak, nonatomic) IBOutlet UIButton *commentButton;
/** 收藏button */
@property(weak, nonatomic) IBOutlet UIButton *collectButton;

//事件
/** 赞 */
- (IBAction)praiseTalkingContent:(UIButton *)sender;
/** 分享 */
- (IBAction)shareTalkingContent:(UIButton *)sender;
/** 评论 */
- (IBAction)commentTalkingContent:(UIButton *)sender;
/** 收藏 */
- (IBAction)collectTalkingContent:(UIButton *)sender;

@end

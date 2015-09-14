//
//  WBButtomTabBar.m
//  SimuStock
//
//  Created by jhss on 14-12-1.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "WBButtomTabBar.h"
#import "Globle.h"
#import "SimuUtil.h"

@implementation WBButtomTabBar

- (void)layoutSubviews {
  [super layoutSubviews];

  UIImage *highLightImageOfCommentButton = [SimuUtil imageFromColor:@"#dee0e1"];

  //底部按钮
  [self.praiseButton setBackgroundImage:highLightImageOfCommentButton
                               forState:UIControlStateHighlighted];
  [self.praiseButton setBackgroundImage:highLightImageOfCommentButton
                               forState:UIControlStateHighlighted];
  [self.shareButton setBackgroundImage:highLightImageOfCommentButton
                              forState:UIControlStateHighlighted];
  [self.commentButton setBackgroundImage:highLightImageOfCommentButton
                                forState:UIControlStateHighlighted];
  [self.collectButton setBackgroundImage:highLightImageOfCommentButton
                                forState:UIControlStateHighlighted];
}
- (void)awakeFromNib {

  //评论按钮加按钮边界线
  [_commentButton.layer setBorderWidth:0.5f];
  [_commentButton.layer setBorderColor:[Globle colorFromHexRGB:@"e8e8e8"].CGColor];
}

/** 赞 */
- (IBAction)praiseTalkingContent:(UIButton *)sender {
}
/** 分享 */
- (IBAction)shareTalkingContent:(UIButton *)sender {
}
/** 评论 */
- (IBAction)commentTalkingContent:(UIButton *)sender {
}
/** 收藏 */
- (IBAction)collectTalkingContent:(UIButton *)sender {
}

@end

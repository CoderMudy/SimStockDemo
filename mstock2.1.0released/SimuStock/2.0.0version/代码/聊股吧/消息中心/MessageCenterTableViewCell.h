//
//  MessageCenterTableViewCell.h
//  SimuStock
//
//  Created by jhss on 15/7/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CellBottomLinesView;

@interface MessageCenterTableViewCell : UITableViewCell
/**header图片*/
@property(weak, nonatomic) IBOutlet UIImageView *headerImage;
/**箭头*/
@property(weak, nonatomic) IBOutlet UIImageView *arrowImage;
/**内容*/
@property(weak, nonatomic) IBOutlet UILabel *contentLabel;
/**大红点*/
@property(weak, nonatomic) IBOutlet UIImageView *redDotImage;
/**大红点上的内容*/
@property(weak, nonatomic) IBOutlet UILabel *redDotLabel;
@property (weak, nonatomic) IBOutlet CellBottomLinesView *topLineView;
- (void)setUnReadMessageNum:(NSInteger)unReadMessageNum;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redDotHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redDotWidth;

- (void)setUnReadDot:(NSInteger)unReadMessageNum;
@end

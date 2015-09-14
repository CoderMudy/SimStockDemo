//
//  MessageCenterCell.h
//  SimuStock
//
//  Created by moulin wang on 14-11-24.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCenterCell : UITableViewCell

/**header图片*/   
@property(strong, nonatomic) UIImageView *headerImage;
/**消息图片*/
@property(strong, nonatomic) UIImageView *newsImage;
/**箭头*/
@property(strong, nonatomic) UIImageView *arrowImage;
/**内容*/
@property(strong, nonatomic) UILabel *contentLabel;
/**上线*/
@property(strong, nonatomic) UIView *cellTopLineView;
/**下线*/
@property(strong, nonatomic) UIView *cellDownLineView;
/**大红点*/
@property(strong, nonatomic) UIImageView *redDotImage;
/**大红点上的内容*/
@property(strong, nonatomic) UILabel *redDotLabel;

- (void)setUnReadMessageNum:(NSInteger)unReadMessageNum;

- (void)setUnReadDot:(NSInteger)unReadMessageNum;

@end

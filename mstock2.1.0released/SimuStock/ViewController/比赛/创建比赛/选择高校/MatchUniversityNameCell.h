//
//  MatchUniversityNameCell.h
//  SimuStock
//
//  Created by Jhss on 15/8/12.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchUniversityNameCell : UITableViewCell

///学校名字
@property(weak, nonatomic) IBOutlet UILabel *unversityName;

///下划线
@property(weak, nonatomic) IBOutlet UIView *verticalLine;
///线的高度
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *lineSpaceVertical;

@end

//
//  RealTradeStartPageCell.m
//  SimuStock
//
//  Created by jhss on 14-9-22.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "RealTradeStartPageCell.h"
#import "SimuUtil.h"

@implementation RealTradeStartPageCell
@synthesize mDetailLabel;
@synthesize mLeftImageView;
@synthesize mTitleLabel;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // 72 X 3
    //雪花
    mLeftImageView =
        [[UIImageView alloc] initWithFrame:CGRectMake(67, 17, 15, 15)];
    mLeftImageView.image = [UIImage imageNamed:@"blue_snow"];
    [self addSubview:mLeftImageView];
    //标题
    mTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 16.5, 150, 16)];
    mTitleLabel.backgroundColor = [UIColor clearColor];
    mTitleLabel.textAlignment = NSTextAlignmentLeft;
    mTitleLabel.textColor = [Globle colorFromHexRGB:Color_Text_Common];
    mTitleLabel.font = [UIFont boldSystemFontOfSize:Font_Height_16_0];
    [self addSubview:mTitleLabel];
    //详情
    mDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(67, 45, 200, 13)];
    mDetailLabel.backgroundColor = [UIColor clearColor];
    mDetailLabel.textAlignment = NSTextAlignmentLeft;
    mDetailLabel.textColor = [Globle colorFromHexRGB:Color_Gray];
    mDetailLabel.font = [UIFont boldSystemFontOfSize:Font_Height_13_0];
    [self addSubview:mDetailLabel];
  }
  return self;
}

@end

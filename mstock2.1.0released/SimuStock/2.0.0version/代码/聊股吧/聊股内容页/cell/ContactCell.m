//
//  ContactCell.m
//  SimuStock
//
//  Created by jhss on 14-11-24.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "ContactCell.h"
#import "Globle.h"

@implementation ContactCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.backgroundColor = [UIColor clearColor];
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(6, 9, 42, 42)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [_bgView.layer setMasksToBounds:YES];
    [_bgView.layer setCornerRadius:21];
    [_bgView.layer setBorderWidth:0.5f];
    [_bgView.layer
        setBorderColor:[Globle colorFromHexRGB:Color_Border].CGColor];
    [self addSubview:_bgView];
    
    _mHeadImageView =
        [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 38, 38)];
    _mHeadImageView.backgroundColor = [Globle colorFromHexRGB:Color_Blue_but];
    [_mHeadImageView.layer setMasksToBounds:YES];
    [_mHeadImageView.layer setCornerRadius:19.0f];
    [_bgView addSubview:_mHeadImageView];

    _mTitleLabel = [[NickNameLabel alloc] initWithFrame:CGRectMake(60, 21, 200, 18)];
    _mTitleLabel.backgroundColor = [UIColor clearColor];
    _mTitleLabel.textAlignment = NSTextAlignmentLeft;
    _mTitleLabel.textColor = [Globle colorFromHexRGB:Color_Text_Common];
    _mTitleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self addSubview:_mTitleLabel];

    _mDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 38, 200, 12)];
    _mDetailLabel.backgroundColor = [UIColor clearColor];
    _mDetailLabel.textAlignment = NSTextAlignmentLeft;
    _mDetailLabel.hidden = YES;
    _mDetailLabel.textColor = [Globle colorFromHexRGB:Color_Gray];
    _mDetailLabel.font = [UIFont systemFontOfSize:10.0f];
    [self addSubview:_mDetailLabel];
    //分割线
    //底边灰线
    _uplineView = [[UIView alloc]
        initWithFrame:CGRectMake(0, 0, WIDTH_OF_VIEW, HEIGHT_OF_BOTTOM_LINE)];
    _uplineView.backgroundColor = [Globle colorFromHexRGB:Color_Cell_Line];
    [self addSubview:_uplineView];
    //下(分割线)
    _downlineView = [[UIView alloc]
        initWithFrame:CGRectMake(0, HEIGHT_OF_BOTTOM_LINE, WIDTH_OF_VIEW,
                                 HEIGHT_OF_BOTTOM_LINE)];
    _downlineView.backgroundColor = [Globle colorFromHexRGB:Color_White];
    [self addSubview:_downlineView];
  }
  return self;
}
- (void)dealloc {
  self.bgView = nil;
  self.mHeadImageView = nil;
  self.mTitleLabel = nil;
  self.mDetailLabel = nil;
}
@end

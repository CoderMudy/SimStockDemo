
//
//  StockMatchCell.m
//  SimuStock
//
//  Created by jhss on 14-5-6.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#define DISTANCE_OF_CONTENT 8 //内容与白底之间的距离

@implementation StockMatchCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    CGRect frame = self.frame;
    self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
    frame.size.height = 100.0f;
    //白底
    _whiteBackgroundView =
        [[UIView alloc] initWithFrame:CGRectMake(DISTANCE_OF_CONTENT, DISTANCE_OF_CONTENT, frame.size.width - DISTANCE_OF_CONTENT * 2,
                                                 frame.size.height - DISTANCE_OF_CONTENT)];
    _whiteBackgroundView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_whiteBackgroundView];
    //按钮点击效果
    _rowBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rowBackButton.frame =
        CGRectMake(0, 0, frame.size.width - DISTANCE_OF_CONTENT * 2, frame.size.height - DISTANCE_OF_CONTENT);
    UIImage *rowButtonBackImage =
        [UIImage imageFromView:_rowBackButton
            withBackgroundColor:[Globle colorFromHexRGB:@"#d9ecf2"]];
    rowButtonBackImage = [rowButtonBackImage
        resizableImageWithCapInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [_rowBackButton setBackgroundImage:rowButtonBackImage
                              forState:UIControlStateHighlighted];
    [_rowBackButton setExclusiveTouch:YES];
    [_whiteBackgroundView addSubview:_rowBackButton];
    //比赛图标
    _matchIconImageView =
        [[UIImageView alloc] initWithFrame:CGRectMake(DISTANCE_OF_CONTENT, DISTANCE_OF_CONTENT, 60, 78)];
    //填充满
    _matchIconImageView.contentMode = UIViewContentModeScaleToFill;
    [_whiteBackgroundView addSubview:_matchIconImageView];
    //我创建的比赛标志
    _createMarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 16, 16)];
    _createMarkLabel.center = CGPointMake(_matchIconImageView.frame.origin.x + _matchIconImageView.frame.size.width, _matchIconImageView.frame.origin.y);
    CALayer *newMarkLayer = _createMarkLabel.layer;
    [newMarkLayer setMasksToBounds:YES];
    [newMarkLayer setCornerRadius:8.0f];
    _createMarkLabel.backgroundColor = [Globle colorFromHexRGB:@"f16331"];
    _createMarkLabel.font = [UIFont boldSystemFontOfSize:Font_Height_12_0];
    _createMarkLabel.textAlignment = NSTextAlignmentCenter;
    _createMarkLabel.text = @"创";
    _createMarkLabel.textColor = [UIColor whiteColor];
    [_whiteBackgroundView addSubview:_createMarkLabel];
    //比赛名称
    _matchNameLabel =
        [[UILabel alloc] initWithFrame:CGRectMake(60 + DISTANCE_OF_CONTENT * 2, DISTANCE_OF_CONTENT, 150, 15)];
    _matchNameLabel.numberOfLines = 1;
    _matchNameLabel.textAlignment = NSTextAlignmentLeft;
    _matchNameLabel.backgroundColor = [UIColor clearColor];
    _matchNameLabel.font = [UIFont systemFontOfSize:Font_Height_14_0];
    _matchNameLabel.textColor = [Globle colorFromHexRGB:@"454545"];
    [_whiteBackgroundView addSubview:_matchNameLabel];
    //钻石图标
    _diamondImageView = [[UIImageView alloc]
        initWithFrame:CGRectMake(60 + DISTANCE_OF_CONTENT * 2 + _matchNameLabel.frame.size.width + 10, DISTANCE_OF_CONTENT,
                                 22, 16)];
    _diamondImageView.image = [UIImage imageNamed:@"diamond.png"];
    [_whiteBackgroundView addSubview:_diamondImageView];
    //比赛期限
    _matchDeadLineLabel =
        [[UILabel alloc] initWithFrame:CGRectMake(60 + DISTANCE_OF_CONTENT * 2, 30, 150, 12)];
    _matchDeadLineLabel.backgroundColor = [UIColor clearColor];
    _matchDeadLineLabel.textAlignment = NSTextAlignmentLeft;
    _matchDeadLineLabel.textColor = [Globle colorFromHexRGB:@"939393"];
    _matchDeadLineLabel.font = [UIFont systemFontOfSize:Font_Height_10_0];
    [_whiteBackgroundView addSubview:_matchDeadLineLabel];
    //比赛介绍
    _matchDetailLabel = [[TopAndBottomAlignmentLabel alloc]
        initWithFrame:CGRectMake(60 + DISTANCE_OF_CONTENT * 2, 50, frame.size.width - (60 + DISTANCE_OF_CONTENT * 2) - 25, 32)];
    _matchDetailLabel.backgroundColor = [UIColor clearColor];
    _matchDetailLabel.font = [UIFont systemFontOfSize:Font_Height_13_0];
    _matchDetailLabel.textAlignment = NSTextAlignmentLeft;
    _matchDetailLabel.verticalAlignment = VerticalAlignmentBottom;
    _matchDetailLabel.numberOfLines = 0;
    _matchDetailLabel.textColor = [Globle colorFromHexRGB:@"5a5a5a"];
    [_whiteBackgroundView addSubview:_matchDetailLabel];
    //参加人数
    _joinNumberLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(frame.size.width - 90, 13, 50, 12)];
    _joinNumberLabel.backgroundColor = [UIColor clearColor];
    _joinNumberLabel.textColor = [Globle colorFromHexRGB:@"ee5121"];
    _joinNumberLabel.textAlignment = NSTextAlignmentRight;
    _joinNumberLabel.font = [UIFont systemFontOfSize:Font_Height_12_0];
    [_whiteBackgroundView addSubview:_joinNumberLabel];
    //“人”
    _personNameLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(frame.size.width - 40, 13, 15, 12)];
    _personNameLabel.text = @"人";
    _personNameLabel.backgroundColor = [UIColor clearColor];
    _personNameLabel.textAlignment = NSTextAlignmentCenter;
    _personNameLabel.textColor = [Globle colorFromHexRGB:@"939393"];
    _personNameLabel.font = [UIFont systemFontOfSize:Font_Height_12_0];
    [_whiteBackgroundView addSubview:_personNameLabel];
    //创建人
    _creatorLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(frame.size.width - 130, 28.5, 105, 12)];
    _creatorLabel.backgroundColor = [UIColor clearColor];
    _creatorLabel.textColor = [Globle colorFromHexRGB:@"939393"];
    _creatorLabel.textAlignment = NSTextAlignmentRight;
    _creatorLabel.font = [UIFont systemFontOfSize:Font_Height_10_0];
    [_whiteBackgroundView addSubview:_creatorLabel];
  }
  return self;
}
@end

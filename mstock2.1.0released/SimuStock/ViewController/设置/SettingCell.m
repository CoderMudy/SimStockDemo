//
//  SettingCell.m
//  SimuStock
//
//  Created by jhss on 14-5-22.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SettingCell.h"
#import "Globle.h"

@implementation SettingCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
  }
  return self;
}
- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {

    _settingBackImageView = [[UIImageView alloc]
        initWithFrame:CGRectMake(10, frame.size.height - 48,
                                 frame.size.width - 20, 48)];
    [self addSubview:_settingBackImageView];

    _settingButton =
        [[UIButton alloc] initWithFrame:_settingBackImageView.frame];
    _settingButton.backgroundColor = [UIColor clearColor];
    [self addSubview:_settingButton];

    _iconImageView = [[UIImageView alloc]
        initWithFrame:CGRectMake(22, frame.size.height - 36, 22, 22)];
    [self addSubview:_iconImageView];

    _arrowImageView = [[UIImageView alloc]
        initWithFrame:CGRectMake(frame.size.width - 34, frame.size.height - 30,
                                 9, 14)];
    _arrowImageView.image = [UIImage imageNamed:@"箭头1"];
    [self addSubview:_arrowImageView];

    _refreshLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(frame.size.width - 150, 16, 130, 16)];
    _refreshLabel.backgroundColor = [UIColor clearColor];
    ///保存下刷新数据

    _refreshLabel.textColor = [UIColor lightGrayColor];
    _refreshLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_refreshLabel];

    //    UIImage *textViewBackImage = [UIImage imageNamed:@"输入框"];
    //    textViewBackImage = [textViewBackImage
    //        resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    //    _pushBackImageView = [[UIImageView alloc]
    //        initWithFrame:CGRectMake(frame.size.width - 50, frame.size.height
    //        - 37,
    //                                 27, 27)];
    //    _pushBackImageView.image = textViewBackImage;
    //    [self addSubview:_pushBackImageView];
    //
    //    ///缓存下对号信息
    //    if ([[NSUserDefaults standardUserDefaults]
    //    objectForKey:@"pigeonStatus"] ==
    //        nil) {
    //      [[NSUserDefaults standardUserDefaults]
    //      setObject:@"confirm_invitationcode"
    //                                                forKey:@"pigeonStatus"];
    //      [[NSUserDefaults standardUserDefaults] synchronize];
    //    }
    //    _pigeonImageView =
    //        [[UIImageView alloc] initWithFrame:CGRectMake(5, 6, 16, 14)];
    //    _pigeonImageView.image =
    //        [UIImage imageNamed:[[NSUserDefaults standardUserDefaults]
    //                                objectForKey:@"pigeonStatus"]];
    //    [_pushBackImageView addSubview:_pigeonImageView];
    //    _pushBackImageView.hidden = YES;
    //    _pigeonImageView.hidden = YES;

    //    _isSelectPushButton =
    //        [[UIButton alloc] initWithFrame:_pushBackImageView.frame];
    //    _isSelectPushButton.hidden = YES;
    //    [self addSubview:_isSelectPushButton];

    _settingNameLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(53, frame.size.height - 33, WIDTH_OF_SCREEN - 53, 18)];
    _settingNameLabel.textAlignment = NSTextAlignmentLeft;
    _settingNameLabel.backgroundColor = [UIColor clearColor];
    _settingNameLabel.font = [UIFont systemFontOfSize:Font_Height_16_0];
    _settingNameLabel.textColor = [UIColor blackColor];
    [self addSubview:_settingNameLabel];

    _downView =
        [[UIView alloc] initWithFrame:CGRectMake(12, frame.size.height - 48,
                                                 WIDTH_OF_SCREEN - 24, 0.5)];
    _downView.backgroundColor = [Globle colorFromHexRGB:@"e3e3e3"];
    [self addSubview:_downView];

    _upView =
        [[UIView alloc] initWithFrame:CGRectMake(12, frame.size.height - 47.5,
                                                 WIDTH_OF_SCREEN - 24, 0.5)];
    _upView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_upView];
  }
  return self;
}
@end

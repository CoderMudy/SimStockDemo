//
//  MyInfoCell.m
//  SimuStock
//
//  Created by jhss on 14-7-29.
//  Copyright (c) 2014年 Mac. All rights reserved.
//
#import "MyInfoCell.h"
#import "Globle.h"

#import "JhssImageCache.h"

@implementation MyInfoCell

static const int side_edge_width = 20;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    //用户名
    _rowNameLabel =
        [[UILabel alloc] initWithFrame:CGRectMake(side_edge_width, 18, 80, 16)];
    _rowNameLabel.backgroundColor = [UIColor clearColor];
    _rowNameLabel.textAlignment = NSTextAlignmentLeft;
    _rowNameLabel.font = [UIFont systemFontOfSize:Font_Height_16_0];
    _rowNameLabel.textColor = [Globle colorFromHexRGB:@"454545"];
    [self addSubview:_rowNameLabel];

    //手机号
    _phoneLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(side_edge_width + 60, 18, 120, 14)];
    _phoneLabel.backgroundColor = [UIColor clearColor];
    _phoneLabel.textAlignment = NSTextAlignmentLeft;
    _phoneLabel.font = [UIFont systemFontOfSize:Font_Height_14_0];
    _phoneLabel.textColor = [Globle colorFromHexRGB:@"939393"];
    [self addSubview:_phoneLabel];
    //箭头
    _arrowImageView = [[UIImageView alloc]
        initWithFrame:CGRectMake(WIDTH_OF_SCREEN - side_edge_width, 19.5, 9,
                                 11)];
    _arrowImageView.image = [UIImage imageNamed:@"箭头"];
    [self addSubview:_arrowImageView];
    //头像
    _headImageView = [[UIImageView alloc]
        initWithFrame:CGRectMake(WIDTH_OF_SCREEN - 80, 5, 40, 40)];
    _headImageView.backgroundColor = [Globle colorFromHexRGB:@"87c8f1"];
    [_headImageView.layer setMasksToBounds:YES];
    [_headImageView.layer setCornerRadius:20.0f];
    [_headImageView.layer setBorderWidth:2.0];
    [_headImageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [self addSubview:_headImageView];
    //各项内容170 - 36
    _rowContentLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(WIDTH_OF_SCREEN - 170, 10, 134, 30)];
    _rowContentLabel.textAlignment = NSTextAlignmentRight;
    _rowContentLabel.font = [UIFont systemFontOfSize:Font_Height_14_0];
    _rowContentLabel.numberOfLines = 0;
    _rowContentLabel.textColor = [Globle colorFromHexRGB:@"939393"];
    _rowContentLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_rowContentLabel];
    //上分界线
    //上灰
    _topLine_downView =
        [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, 0.5)];
    _topLine_downView.backgroundColor = [Globle colorFromHexRGB:@"e3e3e3"];
    [self addSubview:_topLine_downView];
    //下白
    _topLine_upView =
        [[UIView alloc] initWithFrame:CGRectMake(0, 0.5, WIDTH_OF_SCREEN, 0.5)];
    _topLine_upView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_topLine_upView];
    //下分界线
    //上灰
    _bottomLine_downView = [[UIView alloc]
        initWithFrame:CGRectMake(0, 50.0 - 1, WIDTH_OF_SCREEN, 0.5)];
    _bottomLine_downView.backgroundColor = [Globle colorFromHexRGB:@"e3e3e3"];
    [self addSubview:_bottomLine_downView];
    //下白
    _bottomLine_upView = [[UIView alloc]
        initWithFrame:CGRectMake(0, 50.0 - 0.5, WIDTH_OF_SCREEN, 0.5)];
    _bottomLine_upView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bottomLine_upView];
  }
  return self;
}

- (void)awakeFromNib {
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (void)bindUserInfo:(MyInfomationItem *)item
           withIndexPath:(NSIndexPath *)indexPath
    withRowToBindTypeDic:(NSDictionary *)rowToBindTypeDic {
  _phoneLabel.hidden = NO;

  BOOL cannotPressed = NO;

  if (indexPath.section == 0) {
    switch (indexPath.row) {
    case 0:
      [self bindUserHeadImage:item.mHeadPic];
      break;
    case 1:
      [self bindUserNickname:item.mNickName];
      break;
    case 2:
      [self bindUserName:item.mUserName];
      cannotPressed = NO; //用户名不可修改
      break;
    case 3:
      [self bindUserSignature:item.mSignature];
      break;
    default:
      break;
    }
  } else {
    NSInteger bindType = [rowToBindTypeDic[@(indexPath.row)] integerValue];

    switch (bindType) {
    case UserLoginTypeWeixin:
      cannotPressed = [item canUnbindWeixin];
      [self bindWeixin:item];
      break;
    case UserLoginTypeQQ:
      cannotPressed = [item canUnbindQQ];
      [self bindQQ:item];
      break;
    case UserLoginTypePhone:
      cannotPressed = NO; //一直可以修改
      [self bindPhone:item];
      break;
    case UserLoginTypeSinaWeibo:
      cannotPressed = [item canUnbindSinaWeibo];
      [self bindSinaWeibo:item];
      break;
    default:
      break;
    }
  }

  if (cannotPressed) {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
  } else {
    UIView *backView = [[UIView alloc] init];
    backView.backgroundColor = [Globle colorFromHexRGB:@"d9ecf2"];
    self.selectedBackgroundView = backView;
  }
}

///头像
- (void)bindUserHeadImage:(NSString *)headPicUrl {
  _rowNameLabel.text = @"头像";
  _rowContentLabel.hidden = YES;
  _headImageView.hidden = NO;
  _arrowImageView.hidden = NO;
  _headImageView.tag = 103;
  [JhssImageCache setImageView:_headImageView
                       withUrl:headPicUrl
          withDefaultImageName:@"用户默认头像"];
}

///绑定用户名
- (void)bindUserName:(NSString *)userName {
  _rowNameLabel.text = @"用户名";
  _rowContentLabel.text = userName;
  _rowContentLabel.hidden = NO;
  _headImageView.hidden = YES;
  _arrowImageView.hidden = YES;
}

///绑定用户名
- (void)bindUserNickname:(NSString *)nickname {
  _rowNameLabel.text = @"昵称";
  _rowContentLabel.text = nickname;
  _rowContentLabel.hidden = NO;
  _headImageView.hidden = YES;
  _arrowImageView.hidden = NO;
}

///绑定用户签名
- (void)bindUserSignature:(NSString *)signature {
  _rowNameLabel.text = @"个性签名";
  _rowContentLabel.hidden = NO;
  _headImageView.hidden = YES;
  _arrowImageView.hidden = NO;
  if ([signature length] == 0) {
    _rowContentLabel.text = @"未填写";
  } else {
    _rowContentLabel.text = signature;
  }
}

- (NSString *)phoneNumberWithStars:(NSString *)phoneNumber {
  if ([phoneNumber length] > 8) {
    return
        [phoneNumber stringByReplacingCharactersInRange:NSMakeRange(3, 4)
                                             withString:@"****"]; // number是6位
  }
  return phoneNumber;
}

///手机号注册
- (void)bindPhone:(MyInfomationItem *)item {
  _rowNameLabel.text = @"手机号";
  _rowContentLabel.hidden = NO;
  _headImageView.hidden = YES;
  _arrowImageView.hidden = NO;

  //手机号绑定
  BindStatus *unBindableStatus =
      item.bindDictionary[@(UserBindTypePhoneRegister)];
  BindStatus *bindableStatus =
      item.bindDictionary[@(UserBindTypeBindPhone2Exist)];
  NSString *phoneNumber;
  if (unBindableStatus || bindableStatus) {
    phoneNumber = unBindableStatus ? unBindableStatus.thirdNickname
                                   : bindableStatus.thirdNickname;
    _phoneLabel.text = [self phoneNumberWithStars:phoneNumber];
    _phoneLabel.hidden = NO;
    _arrowImageView.hidden = NO;
    _rowContentLabel.text = @"更改";
    return;
  }
  _rowContentLabel.text = @"未绑定";
  //  if ( [_rowContentLabel.text  isEqualToString:@"未绑定"]) {
  //    _phoneLabel.text = @"";
  //  }
  _arrowImageView.hidden = NO;
}

///微信号绑定
- (void)bindWeixin:(MyInfomationItem *)item {
  _rowNameLabel.text = @"微信";
  _rowContentLabel.hidden = NO;
  _headImageView.hidden = YES;

  BindStatus *unBindableStatus =
      item.bindDictionary[@(UserBindTypeWeixinRegister)];
  if (unBindableStatus) {
    _rowContentLabel.text = unBindableStatus.thirdNickname;
    _arrowImageView.hidden = YES;
    return;
  }

  BindStatus *bindableStatus =
      item.bindDictionary[@(UserBindTypeBindWeixin2Exist)];
  if (bindableStatus) {
    _rowContentLabel.text = bindableStatus.thirdNickname;
    _arrowImageView.hidden = NO;
    return;
  }

  _rowContentLabel.text = @"未绑定";
  _arrowImageView.hidden = NO;
}

/// QQ号绑定
- (void)bindQQ:(MyInfomationItem *)item {
  _rowNameLabel.text = @"QQ";
  _rowContentLabel.hidden = NO;
  _headImageView.hidden = YES;

  BindStatus *unBindableStatus = item.bindDictionary[@(UserBindTypeQQ)];
  if (unBindableStatus) {
    _rowContentLabel.text = unBindableStatus.thirdNickname;
    _arrowImageView.hidden = YES;
    return;
  }

  BindStatus *bindableStatus = item.bindDictionary[@(UserBindTypeBindQQ2Exist)];
  if (bindableStatus) {
    _rowContentLabel.text = bindableStatus.thirdNickname;
    _arrowImageView.hidden = NO;
    return;
  }

  _rowContentLabel.text = @"未绑定";
  _arrowImageView.hidden = NO;
}

///新浪微博绑定
- (void)bindSinaWeibo:(MyInfomationItem *)item {
  _rowNameLabel.text = @"新浪微博";
  _rowContentLabel.hidden = NO;
  _headImageView.hidden = YES;

  BindStatus *unBindableStatus = item.bindDictionary[@(UserBindTypeSinaWeibo)];
  if (unBindableStatus) {
    _rowContentLabel.text = unBindableStatus.thirdNickname;
    _arrowImageView.hidden = YES;
    return;
  }

  BindStatus *bindableStatus =
      item.bindDictionary[@(UserBindTypeBindSinaWeibo2Exist)];
  if (bindableStatus) {
    _rowContentLabel.text = bindableStatus.thirdNickname;
    _arrowImageView.hidden = NO;
    return;
  }

  _rowContentLabel.text = @"未绑定";
  _arrowImageView.hidden = NO;
}

@end

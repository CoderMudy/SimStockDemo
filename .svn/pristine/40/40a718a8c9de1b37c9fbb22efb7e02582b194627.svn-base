//
//  TrackCardItemView.m
//  SimuStock
//
//  Created by Mac on 14-2-14.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "TrackCardItemView.h"
#import "SimuUtil.h"

@implementation TrackCardItemView

@synthesize isSelected = tciv_IsVasible;
@synthesize delegate = _delegate;
@synthesize productID = tciv_productID;

- (id)initWithFrame:(CGRect)frame WithContentDic:(NSDictionary *)dic {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [Globle colorFromHexRGB:@"#CFCFCF"].CGColor;
    self.backgroundColor = [UIColor whiteColor];
    tciv_IsVasible = YES;
    [self creatViews:dic];
  }
  return self;
}
- (void)creatViews:(NSDictionary *)dic {
  //选中按钮
  tciv_SelectImageView = [[UIImageView alloc]
      initWithImage:[UIImage imageNamed:@"单选_选中图标"]];
  tciv_SelectImageView.center =
      CGPointMake(12 + tciv_SelectImageView.bounds.size.width / 2,
                  self.bounds.size.height / 2);
  [self addSubview:tciv_SelectImageView];
  //未选中按钮
  tciv_NoSelImageView = [[UIImageView alloc]
      initWithImage:[UIImage imageNamed:@"单选_未选中"]];
  tciv_NoSelImageView.center =
      CGPointMake(12 + tciv_SelectImageView.bounds.size.width / 2,
                  self.bounds.size.height / 2);
  [self addSubview:tciv_NoSelImageView];
  //设置选中状态
  NSString *selstate = [dic valueForKey:@"card_isSel"];
  if (selstate && [selstate isEqualToString:@"1"] == YES) {
    tciv_IsVasible = YES;
  } else {
    tciv_IsVasible = NO;
  }
  if (tciv_IsVasible) {
    tciv_SelectImageView.hidden = NO;
    tciv_NoSelImageView.hidden = YES;
  } else {
    tciv_SelectImageView.hidden = YES;
    tciv_NoSelImageView.hidden = NO;
  }
//  NSString *cardindex = [dic valueForKey:@"card_index"];
//  if (cardindex) {
//    tciv_cardindex = [cardindex integerValue];
//  }

  //卡名称
  tciv_NameLable = [[UILabel alloc]
      initWithFrame:CGRectMake(tciv_SelectImageView.frame.origin.x +
                                   tciv_SelectImageView.bounds.size.width + 6,
                               0, 112, self.bounds.size.height)];
  tciv_NameLable.backgroundColor = [UIColor clearColor];
  tciv_NameLable.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  tciv_NameLable.font = [UIFont systemFontOfSize:Font_Height_16_0];
  tciv_NameLable.textAlignment = NSTextAlignmentLeft;
  NSString *cardname = [dic valueForKey:@"card_name"];
  tciv_NameLable.text = cardname;
  [self addSubview:tciv_NameLable];

  //创建钻石图标
  UIImage *diamoundImage = [UIImage imageNamed:@"钻石图标小.png"];
  UIImageView *rc_DiamondsImageView =
      [[UIImageView alloc] initWithImage:diamoundImage];
  rc_DiamondsImageView.frame = CGRectMake(
      tciv_NameLable.frame.origin.x + tciv_NameLable.frame.size.width + 2,
      (self.bounds.size.height - diamoundImage.size.height) / 2,
      diamoundImage.size.width, diamoundImage.size.height);
  [self addSubview:rc_DiamondsImageView];

  //折扣前价格
  tciv_NotCountPirceLable = [[UILabel alloc]
      initWithFrame:CGRectMake(rc_DiamondsImageView.frame.origin.x +
                                   rc_DiamondsImageView.bounds.size.width,
                               0, 55, self.bounds.size.height)];
  tciv_NotCountPirceLable.backgroundColor = [UIColor clearColor];
  tciv_NotCountPirceLable.textColor = [Globle colorFromHexRGB:Color_Gray];
  tciv_NotCountPirceLable.font = [UIFont systemFontOfSize:Font_Height_16_0];
  tciv_NotCountPirceLable.textAlignment = NSTextAlignmentCenter;
  NSString *cardprice2 = @"";
  tciv_NotCountPirceLable.text = cardprice2;
  [self addSubview:tciv_NotCountPirceLable];

  //加入滑线
  UIView *lineView = tciv_lineView = [[UIView alloc]
      initWithFrame:CGRectMake(0,
                               tciv_NotCountPirceLable.bounds.size.height / 2,
                               tciv_NotCountPirceLable.bounds.size.width, 0.5)];
  lineView.backgroundColor = [Globle colorFromHexRGB:Color_Gray];
  [tciv_NotCountPirceLable addSubview:lineView];
  lineView.hidden = YES;

  //卡价格
  tciv_PriceLable = [[UILabel alloc]
      initWithFrame:CGRectMake(tciv_NotCountPirceLable.frame.origin.x +
                                   tciv_NotCountPirceLable.bounds.size.width +
                                   2,
                               0, 95, self.bounds.size.height)];
  tciv_PriceLable.backgroundColor = [UIColor clearColor];
  tciv_PriceLable.textColor = [UIColor redColor];
  tciv_PriceLable.font = [UIFont systemFontOfSize:Font_Height_16_0];
  tciv_NameLable.textAlignment = NSTextAlignmentLeft;
  NSString *cardprice = [dic valueForKey:@"card_price"];
  tciv_PriceLable.text = cardprice;
  [self addSubview:tciv_PriceLable];
  tciv_PriceLable.hidden = YES;

  //折扣图片
  tciv_CountImageView =
      [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"折扣背景"]];
  tciv_CountImageView.center = CGPointMake(
      self.bounds.size.width - tciv_CountImageView.bounds.size.width / 2,
      tciv_CountImageView.bounds.size.height / 2);
  [self addSubview:tciv_CountImageView];

  //折扣文字
  tciv_CountLable = [[UILabel alloc] initWithFrame:CGRectMake(13, 1.6, 30, 13)];
  tciv_CountLable.backgroundColor = [UIColor clearColor];
  tciv_CountLable.textColor = [UIColor whiteColor];
  tciv_CountLable.font = [UIFont boldSystemFontOfSize:9];
  NSString *cardCount = [dic valueForKey:@"card_count"];
  if (cardCount == nil)
    cardCount = @"";
  tciv_CountLable.text = cardCount;
  [tciv_CountImageView addSubview:tciv_CountLable];

  //点击按钮
  tciv_SelButton = [UIButton buttonWithType:UIButtonTypeCustom];
  tciv_SelButton.backgroundColor = [UIColor clearColor];
  tciv_SelButton.frame = self.bounds;
  [tciv_SelButton addTarget:self
                     action:@selector(selectButtonPress:)
           forControlEvents:UIControlEventTouchDown];
  [self addSubview:tciv_SelButton];
}

- (void)resetSelState:(BOOL)isSelected {
  tciv_IsVasible = isSelected;
  if (tciv_IsVasible) {
    tciv_SelectImageView.hidden = NO;
    tciv_NoSelImageView.hidden = YES;
  } else {
    tciv_SelectImageView.hidden = YES;
    tciv_NoSelImageView.hidden = NO;
  }
}
- (void)resetCardContent:(NSDictionary *)dic {
  if (dic == nil)
    return;
  NSString *cardname = dic[@"card_name"];
  if (cardname) {
    tciv_NameLable.text = cardname;
  }
  NSString *cardPrice = dic[@"card_price"];
  if (cardPrice) {
    tciv_PriceLable.text = cardPrice;
  }
  NSString *cardCount = dic[@"card_count"];
  if ([cardCount length] != 0) {
    tciv_CountLable.text = cardCount;
    tciv_CountImageView.hidden = NO;
    tciv_NotCountPirceLable.hidden = NO;
  } else {
    tciv_CountImageView.hidden = YES;
    tciv_NotCountPirceLable.hidden = YES;
  }
  //折扣前价格
  NSString *notCountPrice = dic[@"card_nocountprice"];
  if ([notCountPrice length] > 0) {
    CGSize size =
        [notCountPrice sizeWithFont:[UIFont systemFontOfSize:Font_Height_16_0]];
    tciv_NotCountPirceLable.bounds = CGRectMake(
        0, 0, size.width + 4, tciv_NotCountPirceLable.bounds.size.height);
    tciv_NotCountPirceLable.text = notCountPrice;
    tciv_lineView.frame =
        CGRectMake(0, tciv_NotCountPirceLable.bounds.size.height / 2,
                   tciv_NotCountPirceLable.bounds.size.width, 1);
  } else {
    tciv_lineView.hidden = YES;
  }
}
//钻石对外接口
- (void)resetCardContentForDiamonds:(NSDictionary *)dic {
  if (dic == nil)
    return;
  NSString *cardname = dic[@"card_name"];
  if (cardname) {
    tciv_NameLable.text = cardname;
  }
  NSString *cardPrice = dic[@"card_price"];
  if (cardPrice) {
    tciv_NotCountPirceLable.text = cardPrice;
    tciv_NotCountPirceLable.textColor = [Globle colorFromHexRGB:@"#e17200"];
  }
  tciv_PriceLable.hidden = YES;
  tciv_CountLable.hidden = YES;
  tciv_CountImageView.hidden = YES;
}

- (void)selectButtonPress:(UIButton *)button {
  tciv_IsVasible = !tciv_IsVasible;
  if (tciv_IsVasible) {
    tciv_SelectImageView.hidden = NO;
    tciv_NoSelImageView.hidden = YES;
  } else {
    tciv_SelectImageView.hidden = YES;
    tciv_NoSelImageView.hidden = NO;
  }
  
  if (self.delegate) {
    [self.delegate TrackCardSelStateChange:tciv_IsVasible
                                 CardIndex:_cardIndex];
  }
}

@end

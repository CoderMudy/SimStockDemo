//
//  ShoppingMallListCell.m
//  SimuStock
//
//  Created by jhss on 13-9-18.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "ShoppingMallListCell.h"
#import "Globle.h"
#import "UIImage+ColorTransformToImage.h"
#import "UIImageView+WebCache.h"
#import "CellBottomLinesView.h"

@implementation ShoppingMallListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    // Initialization code
  }
  return self;
}

- (void)resetView {
  //详情,购入按钮
  [CellBottomLinesView addBottomLinesToCell:self];
  //扩展图片
  UIImage *detailButtonBackImage = [UIImage imageFromView:self.cardDetailButton
                                      withBackgroundColor:[Globle colorFromHexRGB:@"b3b5ba"]];
  UIImage *selectedDetailButtonBackImage =
      [UIImage imageFromView:self.cardDetailButton
          withBackgroundColor:[Globle colorFromHexRGB:@"9c9ea2"]];
  self.cardDetailButton.titleLabel.font = [UIFont systemFontOfSize:14];
  [self.cardDetailButton setBackgroundImage:detailButtonBackImage forState:UIControlStateNormal];

  [self.cardDetailButton.layer setMasksToBounds:YES];
  [self.cardDetailButton.layer setCornerRadius:11.0];
  [self.cardDetailButton setBackgroundImage:detailButtonBackImage forState:UIControlStateNormal];
  [self.cardDetailButton setBackgroundImage:selectedDetailButtonBackImage
                                   forState:UIControlStateHighlighted];
  [self.cardDetailButton setTitle:@"详情" forState:UIControlStateNormal];

  //买入//兑换
  UIImage *buyingButtonBackImage = [UIImage imageFromView:self.cardBuyingButton
                                      withBackgroundColor:[Globle colorFromHexRGB:@"31bce9"]];
  UIImage *selectedBuyingButtonBackImage =
      [UIImage imageFromView:self.cardBuyingButton
          withBackgroundColor:[Globle colorFromHexRGB:@"086dae"]];
  [self.cardBuyingButton.layer setMasksToBounds:YES];
  [self.cardBuyingButton.layer setCornerRadius:11];
  self.cardBuyingButton.titleLabel.font = [UIFont systemFontOfSize:14];
  [self.cardBuyingButton setBackgroundImage:buyingButtonBackImage forState:UIControlStateNormal];

  [self.cardBuyingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  self.cardBuyingButton.backgroundColor = [UIColor clearColor];
  [self.cardBuyingButton setBackgroundImage:buyingButtonBackImage forState:UIControlStateNormal];
  [self.cardBuyingButton setBackgroundImage:selectedBuyingButtonBackImage
                                   forState:UIControlStateHighlighted];
  [self.cardBuyingButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7]
                              forState:UIControlStateHighlighted];

  [self.cardBuyingButton setTitle:@"兑换" forState:UIControlStateNormal];
}

- (void)bindProduct:(ProductListItem *)item {
  self.moneyLabel.hidden = YES;
  self.cardPriceLabel.textColor = [Globle colorFromHexRGB:@"#e17200"];
  [self.cardImageView setImageWithURL:[NSURL URLWithString:item.mProductPic]];
  self.cardSortImageView.hidden = YES;
  if ([item.mSale integerValue] == 0) {
    self.cardPriceLabel.text = [NSString stringWithFormat:@"× %@", item.mNoCountPrice];

  } else {
    self.cardPriceLabel.text = [NSString stringWithFormat:@"× %@", item.mPrice];
  }
  self.cardTitleLabel.text = item.mName;
  self.cardTitleLabel.textColor = [Globle colorFromHexRGB:@"2f2e2e"];
  self.cardDetailLabel.textColor = [Globle colorFromHexRGB:@"454545"];
  self.cardDetailLabel.text = item.mDescription;

  //根据商品的类型 更换左下角的图标
  self.diamondImageView1.image = [UIImage imageNamed:@"钻石图标小.png"];
  if ([item.mCategoryId isEqualToString:@"D050000"] && [item.mPayType integerValue] == 2) {
    self.diamondImageView1.image = [UIImage imageNamed:@"金币0.png"];
  }
  if ([item.mProductId isEqualToString:@"D040100005"] ||
      [item.mProductId isEqualToString:@"D040100002"] ||
      [item.mProductId isEqualToString:@"D040100001"]) {
    self.diamondImageView1.image = [UIImage imageNamed:@"金币0.png"];
  }
  //自动调节label大小
  CGSize size = [item.mDescription sizeWithFont:[UIFont systemFontOfSize:Font_Height_12_0]
                              constrainedToSize:CGSizeMake(195, MAXFLOAT)
                                  lineBreakMode:NSLineBreakByCharWrapping];
  self.cardDetailLabel.frame = CGRectMake(110, 36, size.width, size.height);
}

- (void)bindTrackCardInfo:(TrackCardInfo *)item {

  [self.cardImageView setImageWithURL:[NSURL URLWithString:item.CardPicUrl]];
  self.cardSortImageView.hidden = YES;
  self.cardPriceLabel.hidden = YES;

  self.moneyLabel.textColor = [Globle colorFromHexRGB:@"#e17200"];
  self.moneyLabel.text = [NSString stringWithFormat:@"%@元", item.noCountPrice];
  self.moneyLabel.textAlignment = NSTextAlignmentCenter;

  self.cardTitleLabel.text = item.CardName;
  self.cardTitleLabel.textColor = [Globle colorFromHexRGB:@"2f2e2e"];
  self.cardDetailLabel.textColor = [Globle colorFromHexRGB:@"454545"];
  self.cardDetailLabel.text = item.productDescription;
  [self.cardBuyingButton setTitle:@"购买" forState:UIControlStateNormal];

  //根据商品的类型 更换左下角的图标
  self.diamondImageView1.image = nil;
  //自动调节label大小
  CGSize size = [item.productDescription sizeWithFont:[UIFont systemFontOfSize:Font_Height_12_0]
                                    constrainedToSize:CGSizeMake(195, MAXFLOAT)
                                        lineBreakMode:NSLineBreakByCharWrapping];
  self.cardDetailLabel.frame = CGRectMake(110, 36, size.width, size.height);
}
@end

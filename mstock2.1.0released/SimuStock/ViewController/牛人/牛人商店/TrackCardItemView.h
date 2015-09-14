//
//  TrackCardItemView.h
//  SimuStock
//
//  Created by Mac on 14-2-14.
//  Copyright (c) 2014年 Mac. All rights reserved.
//
/*
 *类说明：牛人追踪卡控件页面
 */
#import <UIKit/UIKit.h>

@protocol TrackCardDelegate <NSObject>

//当前卡片选中
- (void)TrackCardSelStateChange:(BOOL)selstate CardIndex:(NSInteger)index;

@end

@interface TrackCardItemView : UIView {
  //选中图片
  UIImageView *tciv_SelectImageView;
  //未选中图片
  UIImageView *tciv_NoSelImageView;
  //名称
  UILabel *tciv_NameLable;
  //价格
  UILabel *tciv_PriceLable;
  //折扣前的价格
  UILabel *tciv_NotCountPirceLable;
  //折扣
  UIImageView *tciv_CountImageView;
  //折扣价格
  UILabel *tciv_CountLable;
  //点击按钮
  UIButton *tciv_SelButton;
  //当前选中状态 yes 选中 no 非选中
  BOOL tciv_IsVasible;
//  //当前卡片编号
//  NSInteger tciv_cardindex;
  //商品id
  NSString *tciv_productID;
  //划线
  UIView *tciv_lineView;
}

@property(assign, nonatomic) BOOL isSelected;
@property(assign, nonatomic) int cardIndex;
@property(weak, nonatomic) id delegate;
@property(copy, nonatomic) NSString *productID;
- (id)initWithFrame:(CGRect)frame WithContentDic:(NSDictionary *)dic;
- (void)resetCardContent:(NSDictionary *)dic;
- (void)resetCardContentForDiamonds:(NSDictionary *)dic;
//重新设定选中状态
- (void)resetSelState:(BOOL)isSelected;

@end

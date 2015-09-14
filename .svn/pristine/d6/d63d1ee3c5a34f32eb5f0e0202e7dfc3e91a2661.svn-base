//
//  DiamondRechargeCell.h
//  SimuStock
//
//  Created by Yuemeng on 15/8/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TrackCardInfo;
@class CellBottomLinesView;

@protocol DiamondRechargeCellDelegate <NSObject>
//购买按钮点击
- (void)buyButtonPressDown:(NSString *)productid;

@end

/*
 *  钻石充值Cell
 */
@interface DiamondRechargeCell : UITableViewCell
{
  //产品id
  NSString *_productId;
  //按钮是否可点击
  BOOL _clickEnable;
}

@property(weak, nonatomic) IBOutlet UILabel *numberLabel;
@property(weak, nonatomic) IBOutlet UIButton *valueButton;
@property (weak, nonatomic) IBOutlet CellBottomLinesView *cellBottomLinesView;

@property(weak, nonatomic) id<DiamondRechargeCellDelegate> delegate;

- (void)setCellData:(TrackCardInfo *)Item;

@end

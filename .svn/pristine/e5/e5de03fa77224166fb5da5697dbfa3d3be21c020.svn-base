//
//  VIPPrefectureTableViewCell.m
//  SimuStock
//
//  Created by jhss on 15/5/15.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "VIPPrefectureTableViewCell.h"
#import "NetShoppingMallBaseViewController.h"
@implementation VIPPrefectureTableViewCell

- (void)awakeFromNib {
  [self hiddenControls];
  _memeberBtn.layer.cornerRadius = _memeberBtn.bounds.size.height / 2;
  [_memeberBtn.layer setMasksToBounds:YES];
  [_memeberBtn setTitleColor:[UIColor whiteColor]
                    forState:UIControlStateNormal];
  [_memeberBtn setTitleColor:[UIColor whiteColor]
                    forState:UIControlStateHighlighted];
  [_memeberBtn addTarget:self
                  action:@selector(showShoppingVC)
        forControlEvents:UIControlEventTouchUpInside];
}

- (void)hiddenControls {
  _serviceLabel.hidden = YES;
  _memeberBtn.hidden = YES;
  _userRemindCellLabel.hidden = YES;
  _arrowImageView.hidden = NO;
  _clickVIPPrefectureName.hidden = YES;
  _topSeparator.hidden = YES;
}

- (void)showShoppingVC {
  ///
  NetShoppingMallBaseViewController *iSimuStockViewController =
      [[NetShoppingMallBaseViewController alloc]
          initWithPageType:Mall_Buy_Props];

  [AppDelegate pushViewControllerFromRight:iSimuStockViewController];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

@end

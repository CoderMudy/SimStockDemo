//
//  TableViewHeaderView.m
//  SimuStock
//
//  Created by Mac on 15/4/10.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "TableViewHeaderView.h"
#import "Globle.h"
#import "UIImage+colorful.h"
#import "SimuUtil.h"
#import "NewShowLabel.h"
@implementation TableViewHeaderView

+ (TableViewHeaderView *)getTableViewHeaderView:(NSString *)bigtitle
                                  andsmallTitle:(NSString *)smalltitle
                                     andRefresh:(BOOL)isExist {
  TableViewHeaderView *headerView =
      [[[NSBundle mainBundle] loadNibNamed:@"TableViewHeaderView"
                                     owner:self
                                   options:nil] lastObject];
  headerView.clipsToBounds = YES;
  if (!smalltitle) {
    headerView.SmallTitle.hidden = YES;
  } else {
    headerView.SmallTitle.text = smalltitle;
  }
  if (!isExist) {
    headerView.ImageView.hidden = YES;
    headerView.RefrashBtn.hidden = YES;
  }
  headerView.BigTitle.text = bigtitle;
  headerView.showRefreshButton = isExist;

  return headerView;
}

- (void)setShowRefreshButton:(BOOL)showRefreshButton {
  _showRefreshButton = showRefreshButton;
  if (_showRefreshButton) {
    _RefrashBtn.hidden = NO;
    _ImageView.hidden = NO;
  } else {
    _RefrashBtn.hidden = YES;
    _ImageView.hidden = YES;
  }
}
- (void)awakeFromNib {
  [self.RefrashBtn
      setBackgroundImage:
          [UIImage imageWithColor:[Globle colorFromHexRGB:Color_Gray_Edge]]
                forState:UIControlStateHighlighted];
}
- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)indicatorViewstartAnimating {
  if (_showRefreshButton) {
    self.RefrashBtn.hidden = YES;
    self.ImageView.hidden = YES;
    [self.indicatorView startAnimating];
  }
}

- (IBAction)RefrashBtn:(UIButton *)sender {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  [self indicatorViewstartAnimating];
  /// block 回调
  self.block();
}

- (void)indicatorViewStopAnimating {
  if (_showRefreshButton) {
    self.RefrashBtn.hidden = NO;
    self.ImageView.hidden = NO;
    [self.indicatorView stopAnimating];
  }
}

@end

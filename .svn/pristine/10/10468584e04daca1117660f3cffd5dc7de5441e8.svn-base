//
//  TableViewHeaderView.h
//  SimuStock
//
//  Created by Mac on 15/4/10.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^WFTableViewHeaderViewBtnBlock)(); //用户认证信息刷新
@interface TableViewHeaderView : UIView
@property(weak, nonatomic) IBOutlet UILabel *BigTitle;
@property(weak, nonatomic) IBOutlet UILabel *SmallTitle;
@property(weak, nonatomic) IBOutlet UIButton *RefrashBtn;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property(weak, nonatomic) IBOutlet UIImageView *ImageView;
@property(nonatomic, copy) WFTableViewHeaderViewBtnBlock block;

@property(nonatomic, assign) BOOL showRefreshButton;

+ (TableViewHeaderView *)getTableViewHeaderView:(NSString *)bigtitle
                                  andsmallTitle:(NSString *)smalltitle
                                     andRefresh:(BOOL)isExist;

- (void)indicatorViewstartAnimating;
- (void)indicatorViewStopAnimating;
@end

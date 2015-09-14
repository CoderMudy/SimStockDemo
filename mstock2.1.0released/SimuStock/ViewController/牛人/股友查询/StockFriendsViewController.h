//
//  StockFriendsViewController.h
//  SimuStock
//
//  Created by jhss on 14-4-16.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "SimTopBannerView.h"
#import "SimuIndicatorView.h"
#import "MJRefreshFooterView.h"
#import "JhssImageCache.h"
#import "DataArray.h"
#import "ExtendedTextField.h"
#import "FollowFriendResult.h"
#import "MyAttentionViewController.h"

#define searchFriend_bar_height 0
#define searchFriend_nav_bar_height 0

@interface StockFriendsTableAdapter : MyAttentionTableAdapter

@end

@interface StockFriendsTableVC : MyAttentionTableViewController

/**搜索框*/
@property(weak, nonatomic) UITextField *searchField;

@property(nonatomic, strong) NSString *nickname;

- (id)initWithFrame:(CGRect)frame withSearchField:(UITextField *)searchField;

@end

/** 股友搜索界面 搜牛人 */
@interface StockFriendsViewController
    : BaseViewController <UITextFieldDelegate> {

  /** 界面 */
  /** 搜索按钮 */
  UIButton *searchButton;

  ExtendedTextField *inputTextField;
  UIView *headView;
  UIView *footView;

  /** 记录刷新的页码 */
  NSInteger pageNumber;

  /** 表格选中行 */
  NSInteger tempSelectRow;
  /**是否刷新当前页*/
  BOOL backAttentionInfo;
  /**所点的关注按钮及状态*/
  BOOL pressAttentionButton;
  NSInteger pressAttentionIndex;
  /**搜索栏*/
  UIView *friendColumnView;

  StockFriendsTableVC *stockFriendsTableVC;
}

@end

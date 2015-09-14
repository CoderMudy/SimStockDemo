
//
//  SelectStocksViewController.m
//  SimuStock
//
//  Created by moulin wang on 14-7-16.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SelectStocksViewController.h"

// used
#import "StockSearchTableVC.h"
#import "FiveDayRiseStocksTableVC.h"
#import "PortfolioStockTableVC.h"
#import "StockDBManager.h"

@interface SelectStocksViewController () <
    UIAlertViewDelegate, UIScrollViewDelegate, UITextFieldDelegate> {

  StockSearchTableVC *stockSearchTableVC;
  FiveDayRiseStocksTableVC *fiveDayRiseStocksTableVC;
  PortfolioStockTableVC *portfolioStockTableVC;

  /** 隐藏自选股页面 */
  BOOL hideSelfStockPage;

  /** 是否过滤指数股 */
  BOOL filterStockIndex;

  //左侧按钮
  UIButton *leftBtn;
  //右侧按钮
  UIButton *rightBtn;

  /**搜索框*/
  UITextField *searchField;
}
/** 判定X是否改变，当前页码 */
@property(nonatomic, assign) NSInteger contentOffsetInt;
@end

@implementation SelectStocksViewController

- (id)initStartPageType:(StartPageType)startPageType
           withCallBack:(OnStockSelected)callback {
  if (self = [super init]) {

    self.buyStr = startPageType;
    //仅买入页面过滤大盘指数
    filterStockIndex =
        (startPageType == BuyStockPage) || (startPageType == InBuyStockPage);

    //仅自选股页面过滤自选股
    hideSelfStockPage = (startPageType == SelfStockPage);

    // tableViewCell 回调函数
    self.onStockSelectedCallback = callback;
  }

  return self;
}

- (int)getTotalPages {
  return hideSelfStockPage ? 2 : 3;
}

- (BOOL)hasPreviousPage:(NSInteger)pageIndex {
  return pageIndex > 0;
}

- (BOOL)hasNextPage:(NSInteger)pageIndex {
  return hideSelfStockPage ? (pageIndex < 1) : (pageIndex < 2);
}

- (BOOL)isSelfStockPage:(NSInteger)pageIndex {
  return hideSelfStockPage ? NO : (pageIndex == 0);
}

- (BOOL)isFiveDayTopStockPage:(NSInteger)pageIndex {
  return hideSelfStockPage ? (pageIndex == 0) : (pageIndex == 1);
}

- (BOOL)isSearchStockPage:(NSInteger)pageIndex {
  return hideSelfStockPage ? (pageIndex == 1) : (pageIndex == 2);
}

- (void)showSelfStockPage {
  if (hideSelfStockPage) {
    // do nothing;
  }

  int pageIndex = 0;
  [self showPage:pageIndex];
}

- (void)showFiveDayTopStockPage {
  int pageIndex;
  hideSelfStockPage ? (pageIndex = 0) : (pageIndex = 1);
  [self showPage:pageIndex];
}

- (void)showSearchStockPage {
  int pageIndex;
  hideSelfStockPage ? (pageIndex = 1) : (pageIndex = 2);
  [self showPage:pageIndex];}

- (void)showPage:(NSInteger)pageIndex {
  self.contentOffsetInt = pageIndex;
  leftBtn.hidden = ![self hasPreviousPage:pageIndex];
  rightBtn.hidden = ![self hasNextPage:pageIndex];
  _indicatorView.hidden = NO;

  [slideScrollView
      setContentOffset:CGPointMake(
                           slideScrollView.bounds.size.width * pageIndex, 0)];

  if ([self isSelfStockPage:pageIndex]) {
    [searchField resignFirstResponder];
    if (!portfolioStockTableVC.dataBinded) {
      [portfolioStockTableVC refreshButtonPressDown];
    }
  } else if ([self isFiveDayTopStockPage:pageIndex]) {
    [searchField resignFirstResponder];
    if (!fiveDayRiseStocksTableVC.dataBinded) {
      [fiveDayRiseStocksTableVC refreshButtonPressDown];
    }
  } else if ([self isSearchStockPage:pageIndex]) {
    _indicatorView.hidden = YES;
    [searchField becomeFirstResponder];
  }
}

- (void)viewDidAppear:(BOOL)animated {
  [self setExclusiveTouchForButtons:self.view];
  [super viewDidAppear:animated];
}

- (void)setExclusiveTouchForButtons:(UIView *)myView {
  for (UIView *v in [myView subviews]) {
    if ([v isKindOfClass:[UIButton class]])
      [((UIButton *)v)setExclusiveTouch:YES];
    else if ([v isKindOfClass:[UIView class]]) {
      [self setExclusiveTouchForButtons:v];
    }
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];

  [self navigationTopToolView];
  [self createScrollView];
  [self createSlideButtonControls];

  if (self.buyStr == BuyStockPage || self.buyStr == InBuyStockPage) {
    [self showSelfStockPage];
  } else if (self.buyStr == SelfStockPage) {
    [self showSearchStockPage];
    [searchField resignFirstResponder];
  } else {
    [self showSearchStockPage];
  }
}

//创建控制滑动按钮
- (void)createSlideButtonControls {
  leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  leftBtn.frame = CGRectMake(10.0, 25.0 / 2, 80.0 / 2, 60.0 / 2);
  leftBtn.tag = 6601;
  leftBtn.backgroundColor = [UIColor clearColor];
  [leftBtn setImage:[UIImage imageNamed:@"左箭头"]
           forState:UIControlStateNormal];
  [leftBtn addTarget:self
                action:@selector(createButtonTriggerMethods:)
      forControlEvents:UIControlEventTouchUpInside];
  [self.clientView addSubview:leftBtn];

  rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  rightBtn.frame = CGRectMake(self.view.bounds.size.width - 10.0 - 80.0 / 2,
                              25.0 / 2, 80.0 / 2, 60.0 / 2);
  rightBtn.tag = 6602;
  rightBtn.backgroundColor = [UIColor clearColor];
  [rightBtn setImage:[UIImage imageNamed:@"右箭头"]
            forState:UIControlStateNormal];
  [rightBtn addTarget:self
                action:@selector(createButtonTriggerMethods:)
      forControlEvents:UIControlEventTouchUpInside];
  [self.clientView addSubview:rightBtn];
}
//创建UIScrollView
- (void)createScrollView {
  slideScrollView = [[UIScrollView alloc]
      initWithFrame:CGRectMake(0.0, 0, self.view.bounds.size.width,
                               self.clientView.bounds.size.height)];
  slideScrollView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  slideScrollView.delegate = self;
  slideScrollView.pagingEnabled = YES;
  slideScrollView.showsHorizontalScrollIndicator = NO;
  slideScrollView.bounces = NO;
  slideScrollView.contentSize =
      CGSizeMake(self.view.bounds.size.width * [self getTotalPages],
                 self.clientView.bounds.size.height);
  [self.clientView addSubview:slideScrollView];

  //创建分页视图
  [self createTabbedView];
}

//创建分页视图
- (void)createTabbedView {
  int totalPages = [self getTotalPages];
  for (int i = 0; i < totalPages; i++) {
    UIView *brackView = [[UIView alloc]
        initWithFrame:CGRectMake(i * slideScrollView.bounds.size.width, 0.0,
                                 slideScrollView.bounds.size.width,
                                 slideScrollView.bounds.size.height)];
    brackView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
    [slideScrollView addSubview:brackView];
    //标题
    UILabel *titleLab = [[UILabel alloc]
        initWithFrame:CGRectMake(0.0, 30.0 / 2, brackView.bounds.size.width,
                                 60.0 / 2)];
    titleLab.backgroundColor = [UIColor clearColor];
    titleLab.textColor = [Globle colorFromHexRGB:Color_Text_Common];
    titleLab.font = [UIFont systemFontOfSize:Font_Height_16_0];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [brackView addSubview:titleLab];
    //副标题
    UILabel *subtitleLab = [[UILabel alloc]
        initWithFrame:CGRectMake(0.0, 60.0 / 2, brackView.bounds.size.width,
                                 24.0 / 2)];
    subtitleLab.backgroundColor = [UIColor clearColor];
    subtitleLab.textColor = [Globle colorFromHexRGB:Color_Gray];
    subtitleLab.font = [UIFont systemFontOfSize:Font_Height_10_0];
    subtitleLab.textAlignment = NSTextAlignmentCenter;
    subtitleLab.text = @"最近查询股票";
    [brackView addSubview:subtitleLab];
    //下划线
    UIView *underline = [[UIView alloc]
        initWithFrame:CGRectMake(0, 102.0 / 2, brackView.bounds.size.width,
                                 0.5)];
    underline.backgroundColor = [Globle colorFromHexRGB:Color_Border];
    [brackView addSubview:underline];

    CGRect tableRect = CGRectMake(0.0, 103.0 / 2, brackView.bounds.size.width,
                                  brackView.bounds.size.height - 103.0 / 2);

    __weak SelectStocksViewController *weakSelf = self;
    OnStockSelected onStockSelected =
        ^(NSString *stockCode, NSString *stockName, NSString *firstType) {
          [weakSelf invokeSelectedCallbackWithStockCode:stockCode
                                          withStockName:stockName
                                          withFirstType:firstType];

        };

    BaseTableViewController *baseTableVC;

    if ([self isSelfStockPage:i]) {
      titleLab.text = @"自选股";
      titleLab.frame =
          CGRectMake(0.0, 18.0 / 2, brackView.bounds.size.width, 34.0 / 2);
      subtitleLab.text = @"我关心的所有股票";
      subtitleLab.frame =
          CGRectMake(0.0, 60.0 / 2, brackView.bounds.size.width, 24.0 / 2);

      portfolioStockTableVC =
          [[PortfolioStockTableVC alloc] initWithFrame:tableRect];
      portfolioStockTableVC.onStockSelectedCallback = onStockSelected;
      portfolioStockTableVC.filterStockIndex = filterStockIndex;
      baseTableVC = portfolioStockTableVC;
    } else if ([self isFiveDayTopStockPage:i]) {
      titleLab.text = @"5日涨幅榜";
      
      titleLab.frame =
          CGRectMake(0.0, 18.0 / 2, brackView.bounds.size.width, 34.0 / 2);
      subtitleLab.text = @"沪深A股近5天涨幅居前的股票";
      subtitleLab.frame =
          CGRectMake(0.0, 60.0 / 2, brackView.bounds.size.width, 24.0 / 2);
      fiveDayRiseStocksTableVC =
          [[FiveDayRiseStocksTableVC alloc] initWithFrame:tableRect];
      fiveDayRiseStocksTableVC.onStockSelectedCallback = onStockSelected;
      baseTableVC = fiveDayRiseStocksTableVC;
    } else if ([self isSearchStockPage:i]) {
      titleLab.text = @"最近查询股票";
      subtitleLab.hidden = YES;
      stockSearchTableVC =
          [[StockSearchTableVC alloc] initWithFrame:tableRect
                                    withSearchField:searchField];
      stockSearchTableVC.filterStockIndex = filterStockIndex;
      stockSearchTableVC.onStockSelectedCallback = onStockSelected;
      stockSearchTableVC.onSearchFieldFocus = ^{
        [weakSelf showSearchStockPage];
      };
      baseTableVC = stockSearchTableVC;
    }

    baseTableVC.beginRefreshCallBack = ^{
      [weakSelf.indicatorView startAnimating];
    };
    baseTableVC.endRefreshCallBack = ^{
      [weakSelf.indicatorView stopAnimating];
    };

    [brackView addSubview:baseTableVC.view];
    [self addChildViewController:baseTableVC];
  }
}

- (void)invokeSelectedCallbackWithStockCode:(NSString *)stockCode
                              withStockName:(NSString *)stockName
                              withFirstType:(NSString *)firstType {
  NSArray *array = [StockDBManager searchFromdataWithStockName:stockName
                                                 withStockCode:stockCode];
  StockFunds *stock = array[0];
  if (stock) {
    stockCode = stock.code;
  }
  if (self.onStockSelectedCallback) {
    [SimuUtil addSearchHistryStockContent:stockCode];
    [self leftButtonPressWithAnimated:self.buyStr == InBuyStockPage];
    self.onStockSelectedCallback(stockCode, stockName, firstType);
  }
}

#pragma mark--------UIScrollViewDelegate--------

//// called on finger up if the user dragged. velocity is in points/millisecond.
/// targetContentOffset may be changed to adjust where the scroll view comes to
/// rest
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
// withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint
//*)targetContentOffset{
//  NSLog(@"scrollViewWillBeginDragging");
//}
//// called on finger up if the user dragged. decelerate is true if it will
/// continue moving afterwards
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
// willDecelerate:(BOOL)decelerate{
//  NSLog(@"scrollViewDidEndDragging");
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

  // IOSMNCG-3850:
  // 多点触控情况下scrollViewDidEndDecelerating可以不执行，导致左右按钮显示不正确
  int SuperfluoussetX =
      (int)slideScrollView.contentOffset.x % (int)scrollView.bounds.size.width;

  int contentOffsetX =
      slideScrollView.contentOffset.x / scrollView.bounds.size.width;
  if (self.contentOffsetInt != contentOffsetX && SuperfluoussetX == 0) {
    leftBtn.hidden = ![self hasPreviousPage:contentOffsetX];
    rightBtn.hidden = ![self hasNextPage:contentOffsetX];
  }

  if (![self isSearchStockPage:self.contentOffsetInt]) {
    return;
  }

  [searchField resignFirstResponder];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
  NSLog(@"scrollViewDidEndDragging, decelerate = %d:", decelerate);
  if (!decelerate) {
    [self scrollViewDidEndDecelerating:scrollView];
  }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  NSLog(@"scrollViewDidEndDecelerating");
  int contentOffsetX =
      slideScrollView.contentOffset.x / scrollView.bounds.size.width;

  //第二个页面可能仅仅滑动一下又回来，所以要让键盘再弹出来
  if (contentOffsetX == 2 && scrollView == slideScrollView) {
    [searchField becomeFirstResponder];
  }

  if (self.contentOffsetInt == contentOffsetX) {
    return;
  }

  if (contentOffsetX < [self getTotalPages]) {
    self.contentOffsetInt = contentOffsetX;
    [self showPage:self.contentOffsetInt];
  } else {
    self.contentOffsetInt = [self getTotalPages] - 1;
    [self showPage:self.contentOffsetInt];
  }
}
//增大点击区域
- (void)clickTriggeringMethodIncreaseArea {
  [self showSearchStockPage];
}
//导航视图
- (void)navigationTopToolView {
  //创建搜索框视图
  [self createSearchBoxView];
}

//创建搜索框视图
- (void)createSearchBoxView {
  //增大点击区域
  UIButton *areaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  areaBtn.frame =
      CGRectMake(51.f, _topToolBar.bounds.size.height - 40, self.view.width - 99, 34.5f);
  areaBtn.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  [areaBtn addTarget:self
                action:@selector(clickTriggeringMethodIncreaseArea)
      forControlEvents:UIControlEventTouchUpInside];
  [_topToolBar addSubview:areaBtn];

  searchField = [[UITextField alloc]
      initWithFrame:CGRectMake(57.f, _topToolBar.bounds.size.height - 30, self.view.width - 105,
                               17.5f)];
  searchField.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  searchField.textAlignment = NSTextAlignmentLeft;
  [searchField setValue:[Globle colorFromHexRGB:Color_Gray]
             forKeyPath:@"_placeholderLabel.textColor"];
  searchField.placeholder = @"请输入股票代码或拼音首字母";
  searchField.font = [UIFont systemFontOfSize:Font_Height_13_0];
  [_topToolBar addSubview:searchField];

  [searchField becomeFirstResponder];
}

//按钮触发方法
- (void)createButtonTriggerMethods:(UIButton *)Btn {
  switch (Btn.tag) {
  case 6601: {
    int SurplussetX = (int)slideScrollView.contentOffset.x %
                      (int)slideScrollView.bounds.size.width;
    if (SurplussetX == 0) {
      int contentOffsetX =
          slideScrollView.contentOffset.x / slideScrollView.bounds.size.width;
      if ([self hasPreviousPage:contentOffsetX]) {
        [self showPage:contentOffsetX - 1];
      }
    }
  } break;
  case 6602: {
    int SurplussetX = (int)slideScrollView.contentOffset.x %
                      (int)slideScrollView.bounds.size.width;
    if (SurplussetX == 0) {
      int contentOffsetX =
          slideScrollView.contentOffset.x / slideScrollView.bounds.size.width;
      if ([self hasNextPage:contentOffsetX]) {
        [self showPage:contentOffsetX + 1];
      }
    }
  } break;
  default:

    break;
  }

  if (slideScrollView.contentOffset.x + slideScrollView.bounds.size.width ==
      slideScrollView.contentSize.width) {
    _indicatorView.hidden = YES;
  } else {
    _indicatorView.hidden = NO;
  }
}

#pragma mark 刷新
#pragma mark-------SimuIndicatorDelegate-----------
- (void)refreshButtonPressDown {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }

  if ([self isSelfStockPage:self.contentOffsetInt]) {
    [portfolioStockTableVC refreshButtonPressDown];
  } else if ([self isFiveDayTopStockPage:self.contentOffsetInt]) {
    [fiveDayRiseStocksTableVC refreshButtonPressDown];
  }
}

//回调左上侧按钮的协议事件
//左边按钮按下
- (void)leftButtonPress {
  [self leftButtonPressWithAnimated:YES];
}

- (void)leftButtonPressWithAnimated:(BOOL)animated {
  [searchField resignFirstResponder];
  [AppDelegate popViewController:animated];
}

@end

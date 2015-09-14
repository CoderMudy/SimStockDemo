//
//  RealTradeHisDealVC.m
//  SimuStock
//
//  Created by Mac on 14-9-24.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "RealTradeHistoryDealQueryVC.h"
#import "SimuTableView.h"
#import "MJRefreshFooterView.h"

/*
 *类说明：历史交易页面
 */
@interface RealTradeHistoryDealQueryVC () <MJRefreshBaseViewDelegate> {

  //今日委托表格视图
  SimuTableView *sqv_TableView;
  //表格数据
  SimuTableDataResouce *sqv_tableViewDataResouce;
  //时间选择器承载视图
  UIView *rttf_dateView;
  //日期选择器
  UIDatePicker *rttf_DatePicer;
  //显示时间
  UILabel *rttf_TimeLable;
  //标记 是否开始时间
  BOOL rttf_StartTimeFlage;
  //开始时间
  UIButton *rttf_startButton;
  //结束时间
  UIButton *rttf_endButton;
  //总数
  NSString *rttf_totolNumber;
  //数据加载页面
  RealTradeDealList *rttf_datePage;
  //刷新
  MJRefreshFooterView *rttf_refreshView;
  //
  UIView *pickbaseView;
  //开始时间
  NSDate *rttf_startdate;
  NSDate *rttf_enddate;
  //翻页序号
  NSString *rttf_seq;

  //配资界面
  BOOL _capital;

  //数据源
  DataArray *dataMutableArray;
}
@property(retain, nonatomic) NSString *totolNumber;

@end

@implementation RealTradeHistoryDealQueryVC

@synthesize totolNumber = rttf_totolNumber;

- (id)initWithCapital:(BOOL)isCapital {
  self = [super init];
  if (self) {
    _capital = isCapital;
  }
  return self;
}

int stat = 1;
- (void)viewDidLoad {
  //数据绑定的表示符
  _dataBind = NO; //初始化为no

  dataMutableArray = [[DataArray alloc] init];

  [super viewDidLoad];
  self.totolNumber = @"";
  rttf_seq = @"";
  rttf_StartTimeFlage = YES;
  [_littleCattleView setInformation:@"暂无历史成交"];
  self.view.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  rttf_datePage = [[RealTradeDealList alloc] init];
  rttf_datePage.num = 0;
  rttf_datePage.list = [[NSMutableArray alloc] init];
  [self creatControlerViews];
  [self searchDate];
}

- (void)dealloc {
  if (rttf_refreshView) {
    rttf_refreshView.delegate = nil;
    rttf_refreshView.scrollView = nil;
    [rttf_refreshView free];
  }
}

#pragma mark
#pragma mark 创建控件
- (void)creatControlerViews {
  [self resetTopToolBarView];
  [self creatTableViews];
  [self creatfootRefreshView];
  [self creatSearButtonControl];
  [self creatDatePicker];
}

//创建表格
- (void)creatTableViews {
  //创建表格
  sqv_TableView = [[SimuTableView alloc]
      initWithFrame:CGRectMake(0, _topToolBar.frame.size.height + 50, self.view.bounds.size.width,
                               self.view.bounds.size.height - _topToolBar.frame.size.height - 52)];
  [self.view addSubview:sqv_TableView];
  //创建表格数据源
  sqv_tableViewDataResouce = [[SimuTableDataResouce alloc] initWithIdentifier:@"历史成交"];

  sqv_TableView.dataResource = sqv_tableViewDataResouce;
  [sqv_TableView resetTable];
}
/**
 *上拉刷新
 */
- (void)creatfootRefreshView {
  if (rttf_refreshView == nil) {
    rttf_refreshView = [[MJRefreshFooterView alloc] init];
    rttf_refreshView.delegate = self;
    rttf_refreshView.scrollView = [sqv_TableView getUpdateScrollView];
    [rttf_refreshView singleRow];
  }
}

//创建上导航栏控件
- (void)resetTopToolBarView {
  [_topToolBar resetContentAndFlage:@"历史成交" Mode:TTBM_Mode_Leveltwo];
}

//创建历史产讯日期选择控件
- (void)creatSearButtonControl {
  //自动获取当前时间信息，作为默认结束日期[NSDate date];
  NSDate *date = rttf_enddate =
      [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([[NSDate date] timeIntervalSinceReferenceDate] - 24 * 3600)];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *comps;
  // 年月日获得
  comps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                      fromDate:date];
  NSInteger year = [comps year];
  NSInteger month = [comps month];
  NSInteger day = [comps day];

  //把当前时间的前七天，作为开始日期的默认值
  NSDate *date_end = rttf_startdate =
      [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([date timeIntervalSinceReferenceDate] - 7 * 24 * 3600)];
  NSCalendar *calendar_end = [NSCalendar currentCalendar];
  NSDateComponents *comps_end;
  // 年月日获得
  comps_end = [calendar_end components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                              fromDate:date_end];
  NSInteger year_end = [comps_end year];
  NSInteger month_end = [comps_end month];
  NSInteger day_end = [comps_end day];

  CGFloat leftMargin = 8;
  CGFloat top = 12;
  CGFloat height = 27;
  CGFloat widthTo = 25;
  CGFloat widthDate = (WIDTH_OF_SCREEN - leftMargin * 2 - widthTo - 9) / 2.5;

  //时间起始信息
  UIButton *button = rttf_startButton = [UIButton buttonWithType:UIButtonTypeCustom];
  button.frame = CGRectMake(leftMargin, top, widthDate, height);
  button.tag = 40001;
  button.backgroundColor = [Globle colorFromHexRGB:Color_White];
  [button.layer setMasksToBounds:YES];
  button.layer.cornerRadius = height / 2;
  [button.layer setBorderColor:[[Globle colorFromHexRGB:Color_Blue_but] CGColor]]; //描边颜色
  [button.layer setBorderWidth:0.5];                                               //描边粗细
  UIImage *InfoImageDown = [UIImage imageNamed:@"return_touch_down"];
  [button setBackgroundImage:InfoImageDown forState:UIControlStateHighlighted];
  [button setTitle:[NSString stringWithFormat:@"%ld/%02ld/%02ld", (long)year_end, (long)month_end, (long)day_end]
          forState:UIControlStateNormal];
  [button setTitleColor:[Globle colorFromHexRGB:Color_Blue_but] forState:UIControlStateNormal];
  [button setTitleColor:[Globle colorFromHexRGB:Color_White] forState:UIControlStateHighlighted];
  [button setTitleColor:[Globle colorFromHexRGB:Color_Gray] forState:UIControlStateDisabled];
  button.titleLabel.font = [UIFont systemFontOfSize:14];
  [button addTarget:self
                action:@selector(buttonPressDwon:)
      forControlEvents:UIControlEventTouchUpInside];
  [self.clientView addSubview:button];

  //至
  UILabel *lable =
      [[UILabel alloc] initWithFrame:CGRectMake(button.left + button.frame.size.width, button.top, widthTo, height)];
  lable.backgroundColor = [UIColor clearColor];
  lable.font = [UIFont boldSystemFontOfSize:14];
  lable.text = @"至";
  lable.textAlignment = NSTextAlignmentCenter;
  lable.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  [self.clientView addSubview:lable];
  //时间结束信息
  UIButton *buttonright = rttf_endButton = [UIButton buttonWithType:UIButtonTypeCustom];
  buttonright.frame = CGRectMake(lable.left + lable.frame.size.width, button.top, widthDate, height);
  buttonright.tag = 40002;
  buttonright.backgroundColor = [Globle colorFromHexRGB:Color_White];
  [buttonright.layer setMasksToBounds:YES];
  buttonright.layer.cornerRadius = height / 2;
  [buttonright.layer setBorderColor:[[Globle colorFromHexRGB:Color_Blue_but] CGColor]]; //描边颜色
  [buttonright.layer setBorderWidth:0.5]; //描边粗细
  [buttonright setBackgroundImage:InfoImageDown forState:UIControlStateHighlighted];

  [buttonright setTitle:[NSString stringWithFormat:@"%ld/%02ld/%02ld", (long)year, (long)month, (long)day]
               forState:UIControlStateNormal];
  [buttonright setTitleColor:[Globle colorFromHexRGB:Color_Blue_but] forState:UIControlStateNormal];
  [buttonright setTitleColor:[Globle colorFromHexRGB:Color_White]
                    forState:UIControlStateHighlighted];
  [buttonright setTitleColor:[Globle colorFromHexRGB:Color_Gray] forState:UIControlStateDisabled];
  buttonright.titleLabel.font = [UIFont systemFontOfSize:14];
  [buttonright addTarget:self
                  action:@selector(buttonPressDwon:)
        forControlEvents:UIControlEventTouchUpInside];
  [self.clientView addSubview:buttonright];

  //搜索
  BGColorUIButton *uibutton = [BGColorUIButton buttonWithType:UIButtonTypeCustom];
  uibutton.frame = CGRectMake(buttonright.right + 9, buttonright.top, widthDate / 2, height);
  [uibutton.layer setMasksToBounds:YES];
  uibutton.layer.cornerRadius = 14;
  UIImage *image = [UIImage imageNamed:@"搜索小图标.png"];
  [uibutton setImage:image forState:UIControlStateNormal];
  [uibutton setNormalBGColor:[Globle colorFromHexRGB:Color_Blue_but]];
  [uibutton setHighlightBGColor:[Globle colorFromHexRGB:Color_Blue_butDown]];
  [uibutton addTarget:self
                action:@selector(buttonPressDwon:)
      forControlEvents:UIControlEventTouchUpInside];
  uibutton.tag = 40003;
  [self.clientView addSubview:uibutton];
}
//创建日期选择器
- (void)creatDatePicker {
  if (rttf_dateView == nil) {
    rttf_dateView =
        [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    rttf_dateView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:rttf_dateView];
    //透明褐色页面
    UIView *alpview = [[UIView alloc] initWithFrame:rttf_dateView.bounds];
    alpview.backgroundColor = [UIColor blackColor];
    alpview.alpha = 0.7;
    [rttf_dateView addSubview:alpview];
    //承载页面
    pickbaseView = [[UIView alloc] initWithFrame:CGRectMake(20, (self.view.bounds.size.height - 240) / 2,
                                                            self.view.bounds.size.width - 40, 240)];
    [rttf_dateView addSubview:pickbaseView];
    pickbaseView.backgroundColor = [UIColor whiteColor];
    pickbaseView.alpha = 1;
    //时间标签
    rttf_TimeLable =
        [[UILabel alloc] initWithFrame:CGRectMake(10, 0, pickbaseView.bounds.size.width - 20, 35)];
    rttf_TimeLable.backgroundColor = [UIColor clearColor];
    rttf_TimeLable.font = [UIFont systemFontOfSize:18];
    rttf_TimeLable.textAlignment = NSTextAlignmentLeft;
    rttf_TimeLable.text = @"";
    rttf_TimeLable.textColor = [Globle colorFromHexRGB:Color_Text_Common];
    [pickbaseView addSubview:rttf_TimeLable];

    //线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 35, pickbaseView.bounds.size.width, 1)];
    lineView.backgroundColor = [Globle colorFromHexRGB:Color_Blue_but];
    [pickbaseView addSubview:lineView];
    //选择器
    rttf_DatePicer = [[UIDatePicker alloc] init];
    rttf_DatePicer.frame = CGRectMake(0, 35, rttf_dateView.bounds.size.width - 45, 100);
    rttf_DatePicer.datePickerMode = UIDatePickerModeDate;
    rttf_DatePicer.backgroundColor = [UIColor clearColor];
    NSDate *minDate = [self getDateFromString:@"2000-01-01 00:00:00 -0500"];
    NSDate *maxDate =
        [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([[NSDate date] timeIntervalSinceReferenceDate])]; //[self getDateFromString:@"2030-01-01
    // 00:00:00 -0500"];
    rttf_DatePicer.date = [NSDate date];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    //设置为中文显示3
    rttf_DatePicer.locale = locale;

    rttf_DatePicer.minimumDate = minDate;
    rttf_DatePicer.maximumDate = maxDate;
    [rttf_DatePicer addTarget:self
                       action:@selector(datePickerValueChanged:)
             forControlEvents:UIControlEventValueChanged];
    [pickbaseView addSubview:rttf_DatePicer];

    BGColorUIButton *uibutton = [BGColorUIButton buttonWithType:UIButtonTypeCustom];
    float but_width = 140;
    uibutton.frame = CGRectMake((pickbaseView.bounds.size.width - but_width) / 2,
                                pickbaseView.bounds.size.height - 42, but_width, 35);
    [uibutton.layer setMasksToBounds:YES];
    uibutton.layer.cornerRadius = 35 / 2;
    [uibutton buttonWithTitle:@"完成"
              andNormaltextcolor:Color_White
        andHightlightedTextColor:Color_White];
    [uibutton setNormalBGColor:[Globle colorFromHexRGB:Color_Blue_but]];
    [uibutton setHighlightBGColor:[Globle colorFromHexRGB:Color_Blue_butDown]];
    [uibutton addTarget:self
                  action:@selector(buttonPressDwon:)
        forControlEvents:UIControlEventTouchUpInside];
    uibutton.tag = 40004;
    [pickbaseView addSubview:uibutton];
    rttf_dateView.hidden = YES;
  }
}

- (NSDate *)getDateFromString:(NSString *)dateString {
  NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
  [dateFormater setDateFormat:@"yyyy-MM-DD HH:mm:ss ZZZ"];
  return [dateFormater dateFromString:dateString];
}

#pragma mark
#pragma mark 普通功能函数
- (void)searchDate {
  //搜索
  //取得开始时间
  NSString *start_time = rttf_startButton.titleLabel.text;
  NSString *end_time = rttf_endButton.titleLabel.text;
  start_time = [start_time stringByReplacingOccurrencesOfString:@"/" withString:@""];
  end_time = [end_time stringByReplacingOccurrencesOfString:@"/" withString:@""];
  NSInteger n_starttime = [start_time integerValue];
  NSInteger n_endtime = [end_time integerValue];
  if (n_endtime < n_starttime) {
    [NewShowLabel setMessageContent:@"结束时间不能早于开始时间！"];
    return;
  }

  if (_capital) {
    [self queryHisDealFromNet:start_time EndTime:end_time Sqe:@""];
  } else {
    stat = 1;
    [self capitalHistoryData:rttf_startButton.titleLabel.text
                 withEndTime:rttf_endButton.titleLabel.text
                    withStar:[NSString stringWithFormat:@"%d", stat]];
  }
}
- (void)resetDateLable:(NSDate *)input_date {
  if (!input_date)
    return;
  NSDate *date = input_date;
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *comps;
  // 年月日获得
  comps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                      fromDate:date];
  NSInteger year = [comps year];
  NSInteger month = [comps month];
  NSInteger day = [comps day];

  comps = [calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
                      fromDate:date];
  NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
  NSString *weakdays = @"星期一";
  switch (weekday) {
  case 1:
    weakdays = @"星期日";
    break;
  case 2:
    weakdays = @"星期一";
    break;
  case 3:
    weakdays = @"星期二";
    break;
  case 4:
    weakdays = @"星期三";
    break;
  case 5:
    weakdays = @"星期四";
    break;
  case 6:
    weakdays = @"星期五";
    break;
  case 7:
    weakdays = @"星期六";
    break;

  default:
    break;
  }
  NSString *Content =
      [NSString stringWithFormat:@"%ld年%ld月%ld日 %@", (long)year, (long)month, (long)day, weakdays];
  rttf_TimeLable.text = Content;
}

#pragma mark
#pragma mark 按钮点击回调函数
- (void)buttonPressDwon:(UIButton *)button {
  if (button.tag == 40001) {
    //开始时间
    //自动获取当前时间信息，作为默认结束日期[NSDate date];
    rttf_DatePicer.date = rttf_startdate;
    [self resetDateLable:rttf_startdate];

    rttf_StartTimeFlage = YES;
    [self.view bringSubviewToFront:rttf_dateView];
    rttf_dateView.hidden = NO;
  } else if (button.tag == 40002) {
    //结束时间
    rttf_DatePicer.date = rttf_enddate;
    [self resetDateLable:rttf_enddate];
    rttf_StartTimeFlage = NO;
    [self.view bringSubviewToFront:rttf_dateView];
    rttf_dateView.hidden = NO;
  } else if (button.tag == 40003) {
    //搜索
    //取得开始时间
    if ([_indicatorView isAnimating] == NO) {
      [self searchDate];
    }
  } else if (button.tag == 40004) {
    //完成
    if (rttf_StartTimeFlage) {
      rttf_startdate = nil;
      rttf_startdate =
          [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([rttf_DatePicer.date timeIntervalSinceReferenceDate])];

      NSDate *date = rttf_DatePicer.date;
      NSCalendar *calendar = [NSCalendar currentCalendar];
      NSDateComponents *comps;
      // 年月日获得
      comps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                          fromDate:date];
      NSInteger year = [comps year];
      NSInteger month = [comps month];
      NSInteger day = [comps day];

      //开始时间
      [rttf_startButton setTitle:[NSString stringWithFormat:@"%ld/%02ld/%02ld", (long)year, (long)month, (long)day]
                        forState:UIControlStateNormal];
    } else {
      //结束时间
      rttf_enddate = nil;
      rttf_enddate =
          [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([rttf_DatePicer.date timeIntervalSinceReferenceDate])];
      NSDate *date = rttf_DatePicer.date;
      NSCalendar *calendar = [NSCalendar currentCalendar];
      NSDateComponents *comps;
      // 年月日获得
      comps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                          fromDate:date];
      NSInteger year = [comps year];
      NSInteger month = [comps month];
      NSInteger day = [comps day];

      //开始时间
      [rttf_endButton setTitle:[NSString stringWithFormat:@"%ld/%02ld/%02ld", (long)year, (long)month, (long)day]
                      forState:UIControlStateNormal];
    }
    rttf_dateView.hidden = YES;
  }
}
- (void)datePickerValueChanged:(UIDatePicker *)picker {
  NSDate *date = picker.date;
  [self resetDateLable:date];
}
#pragma mark
#pragma mark 协议回调函数
// SimuIndicatorDelegate
- (void)refreshButtonPressDown {
  [_indicatorView startAnimating];
  if (_capital) {
    if (rttf_datePage) {
      rttf_datePage.num = 0;
      [rttf_datePage.list removeAllObjects];
    }

  } else {
    if (dataMutableArray.dataBinded) {
      [dataMutableArray.array removeAllObjects];
    }
  }
  [self searchDate];
}

// MJRefreshBaseViewDelegate 回调函数
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView {
  //如果无网络且本地数据为空，显示无网络；
  if (![SimuUtil isExistNetwork]) {
    [refreshView endRefreshing];
    [NewShowLabel showNoNetworkTip];
    return;
  }
  if (rttf_refreshView == refreshView) {
    NSString *start_time = nil;
    NSString *end_time = nil;
    if (_capital) {
      start_time = [rttf_startButton.titleLabel.text stringByReplacingOccurrencesOfString:@"/"
                                                                               withString:@""];
      end_time =
          [rttf_endButton.titleLabel.text stringByReplacingOccurrencesOfString:@"/" withString:@""];
      [self queryHisDealForNextPageFromNet:start_time EndTime:end_time Sqe:rttf_seq];
    } else {
      start_time = rttf_startButton.titleLabel.text;
      end_time = rttf_endButton.titleLabel.text;
      [self capitalDropDownRefresh:start_time
                       withEndTime:end_time
                           withSup:[NSString stringWithFormat:@"%d", stat]];
    }
  }
}

- (void)resetUI {
  [_indicatorView stopAnimating];
  if (rttf_refreshView) {
    [rttf_refreshView endRefreshing];
  }
}

#pragma mark
#pragma mark 从网络取得数据
//取得历史查询数据(进入页面)
- (void)queryHisDealFromNet:(NSString *)start_time
                    EndTime:(NSString *)end_time
                        Sqe:(NSString *)squ {
  if (start_time == nil)
    return;
  if (end_time == nil)
    return;
  if (![SimuUtil isExistNetwork]) {
    [self noWorkIsNoNetWork];
    return;
  }
  //历史成交查询
  __weak RealTradeHistoryDealQueryVC *myself = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];

  callback.onCheckQuitOrStopProgressBar = ^() {
    RealTradeHistoryDealQueryVC *strongSelf = myself;
    if (strongSelf) {
      //菊花停止
      [_indicatorView stopAnimating];
      _littleCattleView.hidden = YES;
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    if (myself) {
      RealTradeDealList *result = (RealTradeDealList *)obj;
      rttf_datePage.num = result.num;
      [rttf_datePage.list removeAllObjects];
      [rttf_datePage.list addObjectsFromArray:result.list];
      self.totolNumber = [NSString stringWithFormat:@"%d", result.num];
      if (result.num >= 1) {
        RealTradeTodayDealItem *dealItem = ((result.list)[result.num - 1]);
        rttf_seq = dealItem.seq;
      }
      rttf_refreshView.hidden = NO;
      rttf_refreshView.delegate = self;
      rttf_refreshView.scrollView = [sqv_TableView getUpdateScrollView];

      [sqv_tableViewDataResouce resetDealList:result withBool:YES];
      sqv_TableView.dataResource = sqv_tableViewDataResouce;
      [sqv_TableView resetTable];
      [self resetUI];
      if ([result.list count] == 0) {
        [_littleCattleView isCry:NO];
        if (rttf_dateView.hidden == NO) {
          [self.view bringSubviewToFront:rttf_dateView];
        }
      } else {
        _littleCattleView.hidden = YES;
      }
      NSLog(@"SUCCESS");
    }
  };
  callback.onFailed = ^() {
    if (myself) {
      [self resetUI];
      [BaseRequester defaultFailedHandler]();
    }
    [_littleCattleView isCry:YES];
  };
  callback.onError = ^(BaseRequestObject *error, NSException *ex) {
    if (myself) {
      [self resetUI];
      [BaseRequester defaultErrorHandler](error, ex);
    }
    [_littleCattleView isCry:YES];
  };

  [RealTradeDealList loadHistoryDealListWithStartDate:start_time
                                          withEndData:end_time
                                         withPageSize:@"30"
                                              withSeq:squ
                                         WithCallback:callback];

  [_indicatorView startAnimating];
}

//取得历史查询数据(下拉刷新)
- (void)queryHisDealForNextPageFromNet:(NSString *)start_time
                               EndTime:(NSString *)end_time
                                   Sqe:(NSString *)squ {
  if (start_time == nil)
    return;
  if (end_time == nil)
    return;

  if (![SimuUtil isExistNetwork]) {
    [self noWorkIsNoNetWork];
    return;
  }
  //历史成交查询
  __weak RealTradeHistoryDealQueryVC *mySelf = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^() {
    RealTradeHistoryDealQueryVC *strongSelf = mySelf;
    if (strongSelf) {
      //菊花停止
      [_indicatorView stopAnimating];
      _littleCattleView.hidden = YES;
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {

    RealTradeDealList *result = (RealTradeDealList *)obj;
    rttf_datePage.num = rttf_datePage.num + result.num;
    [rttf_datePage.list addObjectsFromArray:result.list];
    self.totolNumber = [NSString stringWithFormat:@"%d", rttf_datePage.num];
    if (result.num >= 1) {
      RealTradeTodayDealItem *dealItem = ((result.list)[result.num - 1]);
      rttf_seq = dealItem.seq;
    } else {
      rttf_refreshView.hidden = YES;
      rttf_refreshView.delegate = nil;
      rttf_refreshView.scrollView = nil;
    }
    [sqv_tableViewDataResouce resetDealList:rttf_datePage withBool:YES];
    sqv_TableView.dataResource = sqv_tableViewDataResouce;
    [sqv_TableView resetTable];
    [self resetUI];

  };
  callback.onFailed = ^() {
    [self resetUI];
    [BaseRequester defaultFailedHandler]();
  };
  callback.onError = ^(BaseRequestObject *error, NSException *ex) {
    [self resetUI];
    [BaseRequester defaultErrorHandler](error, ex);
  };

  [RealTradeDealList loadHistoryDealListWithStartDate:start_time
                                          withEndData:end_time
                                         withPageSize:@"30"
                                              withSeq:squ
                                         WithCallback:callback];

  [_indicatorView startAnimating];
}

//配资界面  -- 历史数据 后期优化
- (void)capitalHistoryData:(NSString *)beginTime
               withEndTime:(NSString *)endTime
                  withStar:(NSString *)starString {
  if (beginTime == nil)
    return;
  if (endTime == nil)
    return;

  [_indicatorView startAnimating];

  //判断网络
  if (![SimuUtil isExistNetwork]) {
    [self noWorkIsNoNetWork];
    [self resetUI];
    return;
  }
  //历史成交查询
  __weak RealTradeHistoryDealQueryVC *myself = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];

  callback.onCheckQuitOrStopProgressBar = ^() {
    RealTradeHistoryDealQueryVC *strongSelf = myself;
    if (strongSelf) {
      [_indicatorView stopAnimating];
      _littleCattleView.hidden = YES;
      return NO;
    } else {
      return YES;
    }

  };

  callback.onSuccess = ^(NSObject *obj) {
    if (myself) {
      //请求成功
      stat++;
      WFHistoryInfoMode *result = (WFHistoryInfoMode *)obj;
      _dataBind = YES;
      rttf_refreshView.hidden = NO;
      rttf_refreshView.delegate = self;
      rttf_refreshView.scrollView = [sqv_TableView getUpdateScrollView];
      if (dataMutableArray.array.count != 0) {
        [dataMutableArray.array removeAllObjects];
      }
      [dataMutableArray.array addObjectsFromArray:result.historyArray];
      [sqv_tableViewDataResouce bindHistoryData:dataMutableArray.array];
      sqv_TableView.dataResource = sqv_tableViewDataResouce;
      [sqv_TableView resetTable];
      [self resetUI];
      if ([result.historyArray count] == 0) {
        [_littleCattleView isCry:NO];
        rttf_refreshView.hidden = YES;
        if (rttf_dateView.hidden == NO) {
          [self.view bringSubviewToFront:rttf_dateView];
        }
      } else {
        rttf_refreshView.hidden = NO;
        _littleCattleView.hidden = YES;
      }
    }
  };
  callback.onFailed = ^() {
    if (myself) {
      [self resetUI];
      [BaseRequester defaultFailedHandler]();
    }
    //数据未绑定
    if (!_dataBind) {
      [NewShowLabel setMessageContent:REQUEST_FAILED_MESSAGE];
      [_littleCattleView isCry:YES];
    } else {
      if (dataMutableArray.array.count == 0) {
        [_littleCattleView isCry:NO];
      } else {
        _littleCattleView.hidden = YES;
      }
    }
  };
  callback.onError = ^(BaseRequestObject *error, NSException *ex) {
    if (myself) {
      [self resetUI];
      [BaseRequester defaultErrorHandler](error, ex);
    }
    [NewShowLabel setMessageContent:REQUEST_FAILED_MESSAGE];
    if (_dataBind) {
      _littleCattleView.hidden = YES;
      [NewShowLabel setMessageContent:REQUEST_FAILED_MESSAGE];
    } else {
      [_littleCattleView isCry:YES];
    }
  };
  [WFHistoryData requestHistoryDataWithBeginTime:beginTime
                                      andEndTime:endTime
                                        withStat:starString
                                    withCallback:callback];
}

#pragma mark - 配资下拉刷新取得数据
- (void)capitalDropDownRefresh:(NSString *)statrTime
                   withEndTime:(NSString *)endTime
                       withSup:(NSString *)sup {
  if (statrTime == nil || endTime == nil)
    return;

  if (![SimuUtil isExistNetwork]) {
    [self noWorkIsNoNetWork];
    [self resetUI];
    return;
  }

  __weak RealTradeHistoryDealQueryVC *weakSelf = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^() {
    RealTradeHistoryDealQueryVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf.indicatorView stopAnimating];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    WFHistoryInfoMode *result = (WFHistoryInfoMode *)obj;
    if (result.historyArray.count == 0) {
      [NewShowLabel setMessageContent:@"没有更多数据"];
      [self resetUI];
      return;
    } else {
      stat++;
      [dataMutableArray.array addObjectsFromArray:result.historyArray];
      [sqv_tableViewDataResouce bindHistoryData:dataMutableArray.array];
      sqv_TableView.dataResource = sqv_tableViewDataResouce;
      [sqv_TableView resetTable];
      [self resetUI];
    }
  };
  callback.onFailed = ^() {
    [self resetUI];
    [BaseRequester defaultFailedHandler]();
  };
  [WFHistoryData requestHistoryDataWithBeginTime:statrTime
                                      andEndTime:endTime
                                        withStat:sup
                                    withCallback:callback];
}

//如果没有网络的判断 有数据不显示小牛 无数据显示哭泣的小牛
- (void)noWorkIsNoNetWork {
  [NewShowLabel setMessageContent:REQUEST_FAILED_MESSAGE];
  if (!_dataBind) {
    [_littleCattleView isCry:YES];
    rttf_refreshView.hidden = YES;
  } else {
    if (dataMutableArray.array.count == 0) {
      [_littleCattleView isCry:YES];
      rttf_refreshView.hidden = YES;
    } else {
      _littleCattleView.hidden = YES;
      rttf_refreshView.hidden = NO;
    }
  }
  [_indicatorView stopAnimating];
}

@end

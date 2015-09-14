//
//  FeedBackViewController.m
//  Settings
//
//  Created by jhss on 13-9-10.
//  Copyright (c) 2013年 jhss. All rights reserved.
//

#import "FeedBackViewController.h"
#import "SimuUtil.h"
#import "MJRefresh.h"
#import "event_view_log.h"
#import "MobClick.h"
#import "JhssImageCache.h"
#import "BaseRequester.h"
#import "FeedbackListWrapper.h"

@implementation FeedBackViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [MobClick beginLogPageView:@"设置-意见反馈"];
  //回拉效果
  self.view.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  [_topToolBar resetContentAndFlage:@"意见反馈" Mode:TTBM_Mode_Leveltwo];
  //右侧button我的反馈
  UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
  rightButton.frame = CGRectMake(self.view.frame.size.width - 93,
                                 _topToolBar.size.height - 44, 93, 44);
  [rightButton setTitle:@"我要反馈" forState:UIControlStateNormal];
  rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
  [rightButton setTitleColor:[Globle colorFromHexRGB:@"4dfdff"]
                    forState:UIControlStateNormal];
  [rightButton setBackgroundImage:[UIImage imageNamed:@"return_touch_down.png"]
                         forState:UIControlStateHighlighted];
  [rightButton addTarget:self
                  action:@selector(myFeedBack)
        forControlEvents:UIControlEventTouchUpInside];
  [_topToolBar addSubview:rightButton];

  [self resetIndicatorView];
  [self createTableView];

  //背景图
  self.view.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  //下载数据
  [_indicatorView startAnimating];
  [self performSelector:@selector(getAllDataFormNet)
             withObject:nil
             afterDelay:0];
  //客服内容只加载一次
  firstRow = YES;
  //留言内容®
  dataArray = [[DataArray alloc] init];
  visibleArray = [[NSMutableArray alloc] init];
  //记录日志
  [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button
                                                   andCode:@"152"];
}
- (void)createTableView {
  //表格
  CGRect frame = self.clientView.bounds;
  _feedbackTableView = [[UITableView alloc]
      initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,
                               frame.size.height)];
  _feedbackTableView.delegate = self;
  _feedbackTableView.dataSource = self;
  _feedbackTableView.backgroundColor = [UIColor clearColor];
  _feedbackTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self.clientView addSubview:_feedbackTableView];
  // tableView底部加底边
  UIView *footView = [[UIView alloc]
      initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
  footView.backgroundColor = [UIColor clearColor];
  //分割线
  UILabel *lineLabel = [[UILabel alloc]
      initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 1)];
  lineLabel.backgroundColor = [Globle colorFromHexRGB:@"e6e5e5"];
  [footView addSubview:lineLabel];
  UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [moreButton setTitle:@"显示更多" forState:UIControlStateNormal];
  moreButton.frame = CGRectMake(0, 30, frame.size.width, 20);
  if ([dataArray.array count] < 20) {
    footView.hidden = YES;
  } else {
    footView.hidden = NO;
  }
  moreButton.backgroundColor = [UIColor clearColor];
  [moreButton setTitleColor:[Globle colorFromHexRGB:@"939393"]
                   forState:UIControlStateNormal];
  moreButton.titleLabel.font = [UIFont systemFontOfSize:15];
  [moreButton addTarget:self
                 action:@selector(moreFeedBackInfo:)
       forControlEvents:UIControlEventTouchUpInside];
  [footView addSubview:moreButton];
  _feedbackTableView.tableFooterView = footView;
}

- (void)myFeedBack {
  //记录日志
  [[event_view_log sharedManager] addPVAndButtonEventToLog:Log_Type_Button
                                                   andCode:@"151"];

  MyFeedBackViewController *myFeedBackVC =
      [[MyFeedBackViewController alloc] init];
  [AppDelegate pushViewControllerFromRight:myFeedBackVC];
  myFeedBackVC.feedbackTableView = self.feedbackTableView;
  myFeedBackVC.dataArray = dataArray;
  myFeedBackVC.visibleArray = visibleArray;
}
- (void)moreFeedBackInfo:(UIButton *)button {
  static int page = 0;
  page++;
  //先释放
  [visibleArray removeAllObjects];
  if ([dataArray.array count] >= page * 20 + 20) {
    for (int i = 0; i < page * 20 + 20; i++) {
      //加载20的的整数倍
      [visibleArray addObject:dataArray.array[i]];
    }
    [_feedbackTableView reloadData];
  } else {
    //没数据了要不显示更多去掉
    _feedbackTableView.tableFooterView.hidden = YES;
    //加载20的余数//加retain，防止dataArray被释放
    visibleArray = [NSMutableArray arrayWithArray:dataArray.array];
    [_feedbackTableView reloadData];
  }
}
- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return [visibleArray count];
}
- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  //确定cell大小+时间label，整体向下平移25
  NSString *string = visibleArray[indexPath.row];
  NSArray *subArray = [string componentsSeparatedByString:@"#"];
  NSString *serviceStr = subArray[0];
  NSString *clientStr = subArray[2];
  CGSize Ssize =
      [serviceStr sizeWithFont:[UIFont systemFontOfSize:14]
             constrainedToSize:CGSizeMake(WIDTH_OF_SCREEN - 55 - 11 - 3 - 23 - 15, MAXFLOAT)
                 lineBreakMode:NSLineBreakByCharWrapping];
  CGSize cSize =
      [clientStr sizeWithFont:[UIFont systemFontOfSize:14]
            constrainedToSize:CGSizeMake(WIDTH_OF_SCREEN - 55 - 11 - 3 - 23 - 15, MAXFLOAT)
                lineBreakMode:NSLineBreakByCharWrapping];
  if (Ssize.height == 0 || cSize.height == 0) {
    return Ssize.height + 10 + 10 + 25 + cSize.height + 7;
  } else
    return Ssize.height + 10 + 10 + 25 + cSize.height + 10 + 10 + 25 + 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *ID = @"cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
  if (cell == nil) {
    // cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
    // reuseIdentifier:ID]autorelease];
    cell = [[UITableViewCell alloc] init];
    //贴图
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    NSString *string = visibleArray[indexPath.row];
    NSLog(@"string:%@", string);
    NSArray *subArray = [string componentsSeparatedByString:@"#"];
    NSLog(@"subArray:%@", subArray);
    NSString *serviceStr = subArray[0];
    NSLog(@"serviceStr:%@", serviceStr);
    NSString *clientStr = subArray[2];
    NSLog(@"clientStr:%@", clientStr);
    CGSize sSize = [serviceStr
             sizeWithFont:[UIFont systemFontOfSize:14]
        constrainedToSize:CGSizeMake(WIDTH_OF_SCREEN - 55 - 11 - 3 - 23 - 15, MAXFLOAT)
            lineBreakMode:NSLineBreakByCharWrapping];
    NSLog(@"sSize.width:%f", sSize.width);
    CGSize cSize = [clientStr
             sizeWithFont:[UIFont systemFontOfSize:14]
        constrainedToSize:CGSizeMake(WIDTH_OF_SCREEN - 55 - 11 - 3 - 23 - 15, MAXFLOAT)
            lineBreakMode:NSLineBreakByCharWrapping];
    if (sSize.width == 0.0)
      sSize.height = 0.0;
    //背景图扩展
    UIImage *sBackImage = [UIImage imageNamed:@"客服回复框"];
    sBackImage = [sBackImage
        resizableImageWithCapInsets:UIEdgeInsetsMake(20, 30, 25, 40)];
    UIImageView *sBackImageView = [[UIImageView alloc]
        initWithFrame:CGRectMake(58, 30, 10 + sSize.width + 10 + 16,
                                 sSize.height + 10 + 10)];
    sBackImageView.image = sBackImage;

    UIImage *cBackImage = [UIImage imageNamed:@"我的反馈框"];
    cBackImage = [cBackImage
        resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 25, 30)];
    UIImageView *cBackImageView;
    if (sSize.height == 0) {
      cBackImageView = [[UIImageView alloc]
          initWithFrame:CGRectMake(WIDTH_OF_SCREEN - cSize.width - 58 - 20 - 10, 30,
                                   cSize.width + 20 + 10,
                                   cSize.height + 10 + 10)];
    } else {
      cBackImageView = [[UIImageView alloc]
          initWithFrame:CGRectMake(WIDTH_OF_SCREEN - 20 - 58 - cSize.width - 10,
                                   30 + 25 + sSize.height + 10 + 10,
                                   20 + 10 + cSize.width,
                                   cSize.height + 10 + 10)];
    }
    cBackImageView.image = cBackImage;
    if (cSize.width == 0) {
      //只有客服回复信息（不存在）
      //左侧头像设计
      UIImageView *headImageView =
          [[UIImageView alloc] initWithFrame:CGRectMake(11, 2 + 25, 42, 42)];
      CALayer *layer = headImageView.layer;
      [layer setMasksToBounds:YES];
      [layer setCornerRadius:21];
      headImageView.layer.borderColor =
          [[UIColor lightGrayColor] colorWithAlphaComponent:0.5].CGColor;
      headImageView.layer.borderWidth = 2.0f;
      [headImageView
          setImage:[UIImage imageNamed:@"customer_service_icon.jpg"]];
      [cell addSubview:headImageView];
      //[headImageView release];
      //左侧label
      UILabel *serviceLabel =
          [[UILabel alloc] initWithFrame:CGRectMake(58 + 23 + 3, 10 + 30,
                                                    sSize.width, sSize.height)];
      serviceLabel.numberOfLines = 0;
      serviceLabel.font = [UIFont systemFontOfSize:14];
      serviceLabel.backgroundColor = [UIColor clearColor];
      serviceLabel.text = serviceStr;
      [cell addSubview:sBackImageView];
      [cell addSubview:serviceLabel];
      //[serviceLabel release];
    } else if (sSize.width == 0) {
      //只有用户反馈信息
      UILabel *labelTime =
          [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
      if ([subArray count] > 4) {
        labelTime.text = [self timeSearch:subArray[4]];
      }
      labelTime.backgroundColor = [UIColor clearColor];
      labelTime.textAlignment = NSTextAlignmentCenter;
      labelTime.font = [UIFont systemFontOfSize:9];
      labelTime.textColor = [Globle colorFromHexRGB:Color_Gray];
      labelTime.center = CGPointMake(WIDTH_OF_SCREEN - 160, 15);
      [cell addSubview:labelTime];
      //右侧头像设计
      UIImageView *headImageView = [[UIImageView alloc]
          initWithFrame:CGRectMake(WIDTH_OF_SCREEN - 11 - 42, 2 + 25, 42, 42)];

      [JhssImageCache setImageView:headImageView
                           withUrl:[SimuUtil getUserImageURL]
              withDefaultImageName:@"用户默认头像"];

      CALayer *layer = headImageView.layer;
      [layer setMasksToBounds:YES];
      [layer setCornerRadius:21];
      headImageView.layer.borderColor =
          [[UIColor lightGrayColor] colorWithAlphaComponent:0.5].CGColor;
      headImageView.layer.borderWidth = 2.0f;
      [cell addSubview:headImageView];
      //右侧label
      UILabel *myLabel = [[UILabel alloc]
          initWithFrame:CGRectMake(WIDTH_OF_SCREEN - cSize.width - 58 - 10 - 10, 10 + 30,
                                   cSize.width, cSize.height)];
      myLabel.text = clientStr; //[subArray objectAtIndex:2];
      myLabel.numberOfLines = 0;
      myLabel.backgroundColor = [UIColor clearColor];
      myLabel.font = [UIFont systemFontOfSize:14];
      [cell addSubview:cBackImageView];
      [cell addSubview:myLabel];
    } else {
      //客服回复信息+用户反馈信息
      //消息时间
      UILabel *serviceLabelTime =
          [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
      if ([subArray count] > 4) {
        serviceLabelTime.text = [self timeSearch:subArray[3]];
      }
      serviceLabelTime.backgroundColor = [UIColor clearColor];
      serviceLabelTime.textAlignment = NSTextAlignmentCenter;
      serviceLabelTime.font = [UIFont systemFontOfSize:9];
      serviceLabelTime.textColor = [Globle colorFromHexRGB:Color_Gray];
      serviceLabelTime.center = CGPointMake(WIDTH_OF_SCREEN - 160, 15);
      [cell addSubview:serviceLabelTime];
      //左侧头像设计
      UIImageView *headImageView =
          [[UIImageView alloc] initWithFrame:CGRectMake(11, 2 + 25, 42, 42)];
      CALayer *layer = headImageView.layer;
      [layer setMasksToBounds:YES];
      [layer setCornerRadius:21];
      headImageView.layer.borderColor =
          [[UIColor lightGrayColor] colorWithAlphaComponent:0.5].CGColor;
      headImageView.layer.borderWidth = 2.0f;
      [headImageView
          setImage:[UIImage imageNamed:@"customer_service_icon.jpg"]];
      [cell addSubview:headImageView];
      //左侧label
      UILabel *serviceLabel =
          [[UILabel alloc] initWithFrame:CGRectMake(58 + 23 + 3, 10 + 30,
                                                    sSize.width, sSize.height)];
      serviceLabel.numberOfLines = 0;
      serviceLabel.font = [UIFont systemFontOfSize:14];
      serviceLabel.backgroundColor = [UIColor clearColor];
      serviceLabel.text = serviceStr;
      [cell addSubview:sBackImageView];
      [cell addSubview:serviceLabel];
      //右侧时间
      UILabel *clientLabelTime =
          [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
      if ([subArray count] > 4) {
        clientLabelTime.text = [self timeSearch:subArray[3]];
      }
      clientLabelTime.backgroundColor = [UIColor clearColor];
      clientLabelTime.textAlignment = NSTextAlignmentCenter;
      clientLabelTime.font = [UIFont systemFontOfSize:9];
      clientLabelTime.textColor = [Globle colorFromHexRGB:Color_Gray];
      clientLabelTime.center = CGPointMake(WIDTH_OF_SCREEN - 160, 10 + 25 + 25 + sSize.height);
      [cell addSubview:clientLabelTime];
      //右侧头像设计
      UIImageView *cHeadImageView = [[UIImageView alloc]
          initWithFrame:CGRectMake(WIDTH_OF_SCREEN - 11 - 42,
                                   2 + 25 + 25 + sSize.height + 10 + 10, 42,
                                   42)];
      [JhssImageCache setImageView:cHeadImageView
                           withUrl:[SimuUtil getUserImageURL]
              withDefaultImageName:@"用户默认头像"];

      CALayer *cLayer = cHeadImageView.layer;
      [cLayer setMasksToBounds:YES];
      [cLayer setCornerRadius:21];
      cHeadImageView.layer.borderColor =
          [[UIColor lightGrayColor] colorWithAlphaComponent:0.5].CGColor;
      cHeadImageView.layer.borderWidth = 2.0f;
      [cell addSubview:cHeadImageView];
      //右侧label
      UILabel *myLabel = [[UILabel alloc]
          initWithFrame:CGRectMake(WIDTH_OF_SCREEN - cSize.width - 58 - 10 - 10,
                                   10 + 30 + 25 + sSize.height + 10 + 10,
                                   cSize.width, cSize.height)];
      myLabel.text = clientStr; //[subArray objectAtIndex:2];
      myLabel.numberOfLines = 0;
      myLabel.backgroundColor = [UIColor clearColor];
      myLabel.font = [UIFont systemFontOfSize:14];
      [cell addSubview:cBackImageView];
      [cell addSubview:myLabel];
    }
  }
  return cell;
}
- (UIImage *)getPhotoFromName:(NSString *)name {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                       NSUserDomainMask, YES);
  // NSFileManager* fileManager=[NSFileManager defaultManager];
  NSString *uniquePath =
      [paths[0] stringByAppendingPathComponent:name];
  BOOL blHave = [[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
  if (!blHave) {
    return nil;
  } else {
    NSData *data = [NSData dataWithContentsOfFile:uniquePath];
    UIImage *img = [[UIImage alloc] initWithData:data];
    // NSLog(@" have");
    return img;
  }
}
- (NSString *)timeSearch:(NSString *)timeStr {
  NSArray *subArray = [timeStr componentsSeparatedByString:@" "];
  if ([subArray count] == 2) {
    NSArray *subArrayYMD =
        [subArray[0] componentsSeparatedByString:@"-"];
    NSArray *subArrayHMS =
        [subArray[1] componentsSeparatedByString:@":"];
    NSString *month = subArrayYMD[1];
    NSString *day = subArrayYMD[2];
    NSString *hour = subArrayHMS[0];
    NSString *minute = subArrayHMS[1];
    return [[NSString alloc]
        initWithFormat:@"%@月%@日    %@:%@", month, day, hour, minute];
  }
  return nil;
}

//创建联网指示器
- (void)resetIndicatorView {
  _indicatorView.frame =
      CGRectMake(self.view.frame.size.width - 83 - 10 - 40,
                 _topToolBar.bounds.size.height - 45, 40, 45);
  [_indicatorView setButonIsVisible:NO];
}

#pragma mark
#pragma mark----------刷新协议函数-----------
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView {
}
- (void)refreshButtonPressDown {
}
#pragma mark
#pragma mark-----------(1)联网函数-----------
//得到所有的app数据
- (void)getAllDataFormNet {
  [_indicatorView startAnimating];
  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak FeedBackViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
      FeedBackViewController *strongSelf = weakSelf;
      if (strongSelf) {
        [strongSelf stopLoading];
        return NO;
      } else {
        return YES;
      }
  };
  callback.onSuccess = ^(NSObject *obj) {
      FeedBackViewController *strongSelf = weakSelf;
      if (strongSelf) {
        [strongSelf bindFeedbackListWrapper:(FeedbackListWrapper *)obj];
      }
  };
  callback.onFailed = ^{ [weakSelf setNoNetwork]; };
  [FeedbackListWrapper requestFeedbackListWithCallback:callback];
}
/**数据绑定*/
- (void)bindFeedbackListWrapper:(FeedbackListWrapper *)obj {
  [dataArray.array removeAllObjects];
  if (firstRow == YES) {
    [dataArray.array
        addObject:@"您" @"好"
        @"！我是客服小优，您对我们的产品有什么意见或建"
        @"议欢" @"迎" @"您反馈给我哦，我会尽力为您解答！我"
        @"更多的联系方式"
        @"：\n电话：010-53599702\n微信：chaogu360\n "
        @"QQ：2457025683##"];
    firstRow = NO;
  }
  [dataArray.array addObjectsFromArray:obj.dataArray];
  if ([dataArray.array count] < 20) {
    _feedbackTableView.tableFooterView.hidden = YES;
    visibleArray = [NSMutableArray arrayWithArray:dataArray.array];
  } else {
    for (int i = 0; i < [dataArray.array count]; i++) {
      [visibleArray addObject:dataArray.array[i]];
    }
  }
  if (_feedbackTableView) {
    [_feedbackTableView reloadData];
    return;
  }
}
- (void)setNoNetwork {
  [NewShowLabel showNoNetworkTip]; //显示无网络提示
  if (dataArray.dataBinded) {
    _littleCattleView.hidden = YES; //数据已经绑定（==显示），隐藏小牛
  } else {
    [_littleCattleView
        isCry:YES]; //数据未绑定（==未显示），显示哭泣的无网络小牛
  }
}

- (void)stopLoading {
  [_indicatorView stopAnimating]; //停止菊花
  //  [self endRefreshLoading]; //停止并隐藏上拉加载更多控件
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

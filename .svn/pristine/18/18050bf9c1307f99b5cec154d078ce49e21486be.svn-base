//
//  ApplicationRecomendViewController.m
//  Settings
//
//  Created by jhss on 13-9-9.
//  Copyright (c) 2013年 jhss. All rights reserved.
//

#import "ApplicationRecomendViewController.h"
#import "AppItem.h"
#import "UIImageView+WebCache.h"
#import "MobClick.h"

#import "ApplicationRecomendListWrapper.h"

@implementation ApplicationRecomendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  CGRect frame = self.view.bounds;
  self.view.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
  self.view.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  [_topToolBar resetContentAndFlage:@"应用推荐" Mode:TTBM_Mode_Leveltwo];
  applicationTableView = [[UITableView alloc]
      initWithFrame:CGRectMake(0, 45, frame.size.width, frame.size.height - 45)];
  applicationTableView.delegate = self;
  applicationTableView.dataSource = self;
  applicationTableView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  applicationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self.clientView addSubview:applicationTableView];
  //白色分界线
  footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, 1)];
  footView.backgroundColor = [UIColor whiteColor];
  applicationTableView.tableFooterView = footView;
  //下载数据
  [self performSelector:@selector(getAllAppDataFormNet) withObject:nil afterDelay:0];
  [_indicatorView startAnimating];
  appAddressArray = @[ @"", @"", @"", @"", @"" ];
  [MobClick beginLogPageView:@"设置-应用推荐"];
}
#pragma mark
#pragma mark--------创建控件---------------------

#pragma mark
#pragma mark---------功能函数---------------------------------
- (void)showMessage:(NSString *)message {
  [NewShowLabel setMessageContent:message];
}
#pragma mark
#pragma mark----------UItableViewdelegate-------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [dataArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 71.0f;
}
- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
  cell.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *ID = @"cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] init];
    AppItem *item = dataArray[indexPath.row];
    if (![item.appLogo isEqualToString:@""]) {
      //图标设计
      //将网址中得部分汉字转化为字符串
      NSString *stringLogo =
          [item.appLogo stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
      //            UIImageView *backImageView = [[UIImageView
      //            alloc]initWithImage:[UIImage imageNamed:@"图标投影"]];
      //            backImageView.frame = CGRectMake(8, 8+58-24, 61, 25);
      //            [cell addSubview:backImageView];
      UIImageView *iconImageView = [[UIImageView alloc] init];
      [iconImageView setImageWithURL:[NSURL URLWithString:stringLogo]];
      iconImageView.layer.borderColor =
          [[UIColor lightGrayColor] colorWithAlphaComponent:0.1].CGColor;
      iconImageView.layer.borderWidth = 0.5f;
      iconImageView.frame = CGRectMake(10, 8, 57, 58);
      [cell addSubview:iconImageView];
      //标题设计
      UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 10, 200, 16)];
      titleLabel.font = [UIFont boldSystemFontOfSize:Font_Height_16_0];
      titleLabel.backgroundColor = [UIColor clearColor];
      titleLabel.text = item.appName;
      titleLabel.textColor = [Globle colorFromHexRGB:@"2f2e2e"];
      //详情
      UILabel *detailLabel =
          [[UILabel alloc] initWithFrame:CGRectMake(75, 32, WIDTH_OF_SCREEN - 10 - 64 - 10, 38)];
      detailLabel.textColor = [Globle colorFromHexRGB:@"939393"];
      detailLabel.font = [UIFont systemFontOfSize:Font_Height_12_0];
      detailLabel.text = item.appDetail;
      detailLabel.backgroundColor = [UIColor clearColor];
      CGSize size = [detailLabel.text
               sizeWithFont:[UIFont systemFontOfSize:Font_Height_12_0]
          constrainedToSize:CGSizeMake(WIDTH_OF_SCREEN - 10 - 64 - 10 - 10 - 57 - 10, MAXFLOAT)
              lineBreakMode:NSLineBreakByWordWrapping];
      if (size.height > 15 + 24) {
        size.height = 30;
      }
      detailLabel.frame = CGRectMake(75, 32, size.width, size.height);
      detailLabel.numberOfLines = 0;
      [cell addSubview:titleLabel];
      [cell addSubview:detailLabel];
    } else {
      UIImageView *defaultImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 7, 60, 58)];
      defaultImageView.image = [UIImage imageNamed:@"用户默认头像"];
      [cell addSubview:defaultImageView];
    }

    //新分栏线
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, WIDTH_OF_SCREEN, 1)];
    downView.backgroundColor = [Globle colorFromHexRGB:@"e3e3e3"];
    [cell addSubview:downView];

    UIView *upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, 1)];
    upView.backgroundColor = [UIColor whiteColor];
    [cell addSubview:upView];
    //右侧button按钮
    //扩展图片
    UIImage *buttonBackImage = [UIImage imageNamed:@"grayButton_UP"];
    buttonBackImage = [buttonBackImage resizableImageWithCapInsets:UIEdgeInsetsMake(13, 7, 13, 13)];
    UIImage *selectedButtonBackImage = [UIImage imageNamed:@"grayButton_down"];
    selectedButtonBackImage =
        [selectedButtonBackImage resizableImageWithCapInsets:UIEdgeInsetsMake(13, 7, 13, 13)];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
    rightButton.frame = CGRectMake(WIDTH_OF_SCREEN - 10 - 64, 20, 64, 31);
    [rightButton setBackgroundImage:buttonBackImage forState:UIControlStateNormal];
    [rightButton setTitleColor:[Globle colorFromHexRGB:@"454545"] forState:UIControlStateNormal];
    rightButton.backgroundColor = [UIColor clearColor];
    rightButton.tag = 10000 + indexPath.row;
    [rightButton setBackgroundImage:buttonBackImage forState:UIControlStateNormal];
    [rightButton setBackgroundImage:selectedButtonBackImage forState:UIControlStateHighlighted];
    //[rightButton setTitleColor:[Globle colorFromHexRGB:@"454545"]
    // forState:UIControlStateHighlighted];
    [rightButton addTarget:self
                    action:@selector(downloadApplication:)
          forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:@"下载" forState:UIControlStateNormal];
    [cell addSubview:rightButton];
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  return cell;
}
#pragma mark 回拉效果

- (void)downloadApplication:(UIButton *)button {
  NSInteger index = button.tag - 10000;
  AppItem *item = dataArray[index];
  // NSLog(@"item.appurl =%@",item.appUrl);
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:item.appUrl]];
}

#pragma mark----------接口修改（联网数据）----------
//得到所有的app数据
- (void)getAllAppDataFormNet {
  [_indicatorView startAnimating];
  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak ApplicationRecomendViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    ApplicationRecomendViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    ApplicationRecomendViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindRecomendListWrappePageData:(ApplicationRecomendListWrapper *)obj];
    }
  };
  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };
  [ApplicationRecomendListWrapper requestPositionDataWithGetAK:[SimuUtil getAK]
                                               withGetSesionID:[SimuUtil getSesionID]
                                                  withCallback:callback];
}
/**数据绑定*/
- (void)bindRecomendListWrappePageData:(ApplicationRecomendListWrapper *)obj {
  [dataArray removeAllObjects];
  [dataArray addObjectsFromArray:obj.AppDataArray];
  [applicationTableView reloadData];
}
- (void)setNoNetwork {
  [NewShowLabel showNoNetworkTip]; //显示无网络提示
}
- (void)stopLoading {
  [_indicatorView stopAnimating]; //停止菊花
}

#pragma mark----------end----------

- (void)dealloc {
  [dataArray removeAllObjects];
}
@end

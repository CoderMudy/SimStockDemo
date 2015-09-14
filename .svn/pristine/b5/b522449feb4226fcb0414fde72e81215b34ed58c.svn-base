//
//  ChangeHeadImageViewController.m
//  SimuStock
//
//  Created by jhss on 13-9-27.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "ChangeHeadImageViewController.h"
#import "HeadItem.h"
#import "ChangeUserInfoRequest.h"
#import "NetLoadingWaitView.h"
#import "HeadImageList.h"
#import "DoTaskStatic.h"
#import "TaskIdUtil.h"

@implementation ChangeHeadImageViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self createMainView];
  [self getHeadImageList];
}
#pragma mark
#pragma mark------界面------
- (void)createMainView {
  //回拉效果
  CGRect frame = self.clientView.bounds;
  self.view.userInteractionEnabled = YES;
  self.view.backgroundColor = [Globle colorFromHexRGB:@"c6c6c6"];
  _indicatorView.hidden = YES;
  [_topToolBar resetContentAndFlage:@"选择头像" Mode:TTBM_Mode_Leveltwo];
  //表格
  headImageTableView = [[UITableView alloc]
      initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width,
                               frame.size.height)];
  headImageTableView.delegate = self;
  headImageTableView.dataSource = self;
  headImageTableView.userInteractionEnabled = YES;
  headImageTableView.separatorColor = [UIColor clearColor];
  headImageTableView.backgroundColor = [UIColor clearColor];
  [self.clientView addSubview:headImageTableView];
}
- (void)getHeadImageList {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel setMessageContent:REQUEST_FAILED_MESSAGE];
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  //解析
  __weak ChangeHeadImageViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    ChangeHeadImageViewController *strongSelf = weakSelf;
    if ([_indicatorView isAnimating]) {
      _indicatorView.hidden = NO;
      [_indicatorView stopAnimating];
    }
    if (strongSelf) {
      return NO;
    } else
      return YES;
  };
  callback.onSuccess = ^(NSObject *obj) {
    ChangeHeadImageViewController *strongSelf = weakSelf;
    if (strongSelf) {
      _indicatorView.hidden = YES;
      HeadImageList *headList = (HeadImageList *)obj;
      headArray = [NSArray arrayWithArray:headList.headArray];
      if ([headArray count] != 0) {
        [headImageTableView reloadData];
      }
    }
  };
  [HeadImageList getUserIconListWithCallBack:callback];
  if (![_indicatorView isAnimating]) {
    _indicatorView.hidden = YES;
    [_indicatorView startAnimating];
  }
}

#pragma mark
#pragma mark------表格协议函数----
- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  if ([headArray count] % 4 == 0) {
    return [headArray count] / 4;
  } else {
    return [headArray count] / 4 + 1;
  }
}
- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return WIDTH_OF_SCREEN / 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *ID = @"cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:ID];
  }
  //去掉选中状态
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  //为了防止数组越界，需要在此作下判断
  if (indexPath.row == [headArray count] / 4) {

    [self selectedChangeHeadImageWithCell:cell
                            WithIndexPath:indexPath
                               WithNumber:([headArray count] % 4)
                                 WithBool:NO];

    for (int i = [headArray count] % 4; i < 4; i++) {
      // headimage底部view
      UIView *headView =
          [[UIView alloc] initWithFrame:CGRectMake(i * WIDTH_OF_SCREEN / 4, 0,
                                                   WIDTH_OF_SCREEN / 4 - 1,
                                                   WIDTH_OF_SCREEN / 4 - 1)];
      headView.backgroundColor = [UIColor whiteColor];
      [cell addSubview:headView];
    }
  } else {
    [self selectedChangeHeadImageWithCell:cell
                            WithIndexPath:indexPath
                               WithNumber:4
                                 WithBool:YES];
  }
  return cell;
}

/** 改变头像的状态 */
- (void)selectedChangeHeadImageWithCell:(UITableViewCell *)cell
                          WithIndexPath:(NSIndexPath *)indexPath
                             WithNumber:(int)number
                               WithBool:(BOOL)selected {
  for (int i = 0; i < number; i++) {
    // headimage底部view
    UIView *headView =
        [[UIView alloc] initWithFrame:CGRectMake(i * WIDTH_OF_SCREEN / 4, 0,
                                                 WIDTH_OF_SCREEN / 4 - 1,
                                                 WIDTH_OF_SCREEN / 4 - 1)];
    headView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
    [cell addSubview:headView];
    HeadItem *item = headArray[indexPath.row * 4 + i];
    if ([item.mType integerValue] < 3) {
      // head头像
      UILabel *backLabel = [[UILabel alloc]
          initWithFrame:CGRectMake(WIDTH_OF_SCREEN / 64, WIDTH_OF_SCREEN / 64,
                                   WIDTH_OF_SCREEN / 64 * 14,
                                   WIDTH_OF_SCREEN / 64 * 14)];
      backLabel.backgroundColor = [Globle colorFromHexRGB:@"dfb567"];
      [headView addSubview:backLabel];
    }
    // head头像
    UIImageView *headImageView = [[UIImageView alloc]
        initWithFrame:CGRectMake(WIDTH_OF_SCREEN / 64, WIDTH_OF_SCREEN / 64,
                                 WIDTH_OF_SCREEN / 64 * 14,
                                 WIDTH_OF_SCREEN / 64 * 14)];
    [JhssImageCache setImageView:headImageView
                         withUrl:item.mUrl
            withDefaultImageName:@"用户默认头像"];
    [headView addSubview:headImageView];
    //顶部button
    UIButton *headButton = [UIButton buttonWithType:UIButtonTypeCustom];
    headButton.frame =
        CGRectMake(0, 0, WIDTH_OF_SCREEN / 4, WIDTH_OF_SCREEN / 4);
    headButton.backgroundColor = [UIColor clearColor];
    if (selected == YES) {
      UIImage *selectedHeadImage = [UIImage imageNamed:@"个人头像_选中"];
      selectedHeadImage = [selectedHeadImage
          resizableImageWithCapInsets:UIEdgeInsetsMake(WIDTH_OF_SCREEN / 32,
                                                       WIDTH_OF_SCREEN / 32,
                                                       WIDTH_OF_SCREEN / 32,
                                                       WIDTH_OF_SCREEN / 32)];
      [headButton setBackgroundImage:selectedHeadImage
                            forState:UIControlStateHighlighted];
    }
    headButton.tag = indexPath.row * 4 + i + 100;
    [headButton addTarget:self
                   action:@selector(clickButton:)
         forControlEvents:UIControlEventTouchUpInside];
    [headView addSubview:headButton];
    //调用数据库中数据
    if ([[SimuUtil getUserImageURL] isEqualToString:item.mUrl]) {

      if (selected == YES) {
        [headButton
            setBackgroundImage:[UIImage imageNamed:@"个人头像_选中"]
                      forState:UIControlStateNormal];
      }

      [headButton setBackgroundColor:[Globle colorFromHexRGB:@"0000"]];
      headButton.alpha = 0.3;
      UIImageView *smilImageView = [[UIImageView alloc]
          initWithFrame:CGRectMake(WIDTH_OF_SCREEN / 64 * 14 -
                                       WIDTH_OF_SCREEN / 16,
                                   WIDTH_OF_SCREEN / 32, WIDTH_OF_SCREEN / 16,
                                   WIDTH_OF_SCREEN / 16)];
      smilImageView.tag = 1001;
      smilImageView.image = [UIImage imageNamed:@"选中"];
      [headView addSubview:smilImageView];
      continue;
    }
  }
}

/**
 修改头像
 */
- (void)clickButton:(UIButton *)button {
  int64_t currentTimestamp = [[NSDate date] timeIntervalSince1970] * 1000;
  //上次点击时间
  if (currentTimestamp - lastPressedTime < 1000) {
    return;
  }
  lastPressedTime = currentTimestamp;

  [NetLoadingWaitView startAnimating];

  //回传头像数据
  HeadItem *item = headArray[button.tag - 100];

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^{
    if ([NetLoadingWaitView isAnimating]) {
      [NetLoadingWaitView stopAnimating];
    }
    return NO;
  };
  __weak ChangeHeadImageViewController *weakSelf = self;
  callback.onSuccess = ^(NSObject *obj) {
    ChangeHeadImageViewController *strongSelf = weakSelf;
    if (strongSelf) {
      // ui部分
      //先去掉上次选定图片
      UIImageView *preHeadImageView =
          (UIImageView *)[self.view viewWithTag:1001];
      [preHeadImageView removeFromSuperview];
      [button setBackgroundColor:[Globle colorFromHexRGB:@"0000"]];
      button.alpha = 0.4;
      //保存tag值
      UIImageView *smilImageView =
          [[UIImageView alloc] initWithFrame:CGRectMake(80 - 30, 10, 20, 20)];
      smilImageView.tag = 1001;
      smilImageView.image = [UIImage imageNamed:@"选中"];
      [button addSubview:smilImageView];
      selectedHeadPic = button.tag - 100;
      //数据部分
      [strongSelf onHeadImageChanged:item.mUrl];
    }
  };

  //加入阻塞
  if (![NetLoadingWaitView isAnimating]) {
    [NetLoadingWaitView startAnimating];
  }

  [ChangeUserInfoRequest changeNickname:nil
                       withNewSignature:nil
                             withSyspic:item.mUrl
                            withPicFile:nil
                withHttpRequestCallBack:callback];
}

- (void)onHeadImageChanged:(NSString *)url {

  [NewShowLabel setMessageContent:@"头像修改成功"];
  if ([[SimuUtil getPersonalInfo] isEqualToString:@""]) {
    [SimuUtil setPersonalInfo:TASK_PERSONAL_INFO];
    [DoTaskStatic doTaskWithTaskType:TASK_PERSONAL_INFO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PersonalInfo"
                                                        object:nil];
  } else {
    NSLog(@"完善个人资料任务已完成！！！");
  }
  [SimuUtil setUserImageURL:url ? url : @""];
  [[NSNotificationCenter defaultCenter] postNotificationName:NT_HeadPic_Change
                                                      object:nil];
  //返回上层
  [JhssImageCache setImageView:self.currentHeadImageView
                       withUrl:url
          withDefaultImageName:@"用户默认头像"];
  [super leftButtonPress];
}

@end

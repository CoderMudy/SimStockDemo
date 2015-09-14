//
//  realTradeMoreVC.m
//  SimuStock
//
//  Created by Mac on 14-9-23.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "RealTradeMoreFeaturesVC.h"

#import "SimuUser.h"
#import "SimuUtil.h"
#import "RealTradeFundTransferVC.h"
#import "RealTradeTransferListVC.h"
#import "RTSpecialTradeVC.h"
#import "RealTradeTodayDealQueryVC.h"
#import "RealTradeHistoryDealQueryVC.h"
#import "UIImage+ColorTransformToImage.h"

typedef NS_ENUM(NSInteger, NumberSection) {
  NumberOne = 0,
  NumberTwo = 1,
  NumberThree = 6
};
typedef NS_ENUM(NSInteger, MapForCell) {
  FirstMapForTop = 1,  //当 cell的个数大于 1时 第一个cell
  LastMapForBottom = 2, //当 cell的个数大于 1时 最后一个cell
  MiddleMap = 3,   //当 cell的个数大于 1时 中间的cell
  AloneMap = 4     //cell的个数 等于或者 1时
};

///表格底视图高度
#define tableviewFootViewHeight 58
///本view宽度
#define viewWidth self.view.frame.size.width

@interface RealTradeMoreFeaturesVC () <UITableViewDataSource,
                                       UITableViewDelegate> {
  /** 表格 */
  UITableView *rtmv_tableView;

  /** 保存 类型 从服务端 获取到的类型 */
  NSArray *_typeTlitleArray;

  /** 标题 */
  NSDictionary *titleDictionary;
  /** 图片 */
  NSDictionary *imageDictionary;

  /** 检查分区 保存图片 */
  NSMutableDictionary *_inspectionDivision;
  /** 保存 title */
  NSMutableDictionary *_titleMutableDictionary;
  /** 分别 保存 标题 三组 分区的数组 */
  NSMutableArray *_titleArray1;
  NSMutableArray *_titleArray2;
  NSMutableArray *_titleArray3;

  /** 图片 三组 */
  NSMutableArray *_imageArray1;
  NSMutableArray *_imageArray2;
  NSMutableArray *_imageArray3;
  /** 搜索用的 */
  NSDictionary *_searchTitleDict;

  /** 检查那个区 */
  NSMutableDictionary *_markNumberDic;
  NSMutableArray *_markArray;
}

@end

@implementation RealTradeMoreFeaturesVC

- (void)viewDidLoad {
  [super viewDidLoad];
  //创建上导航栏
  [self.topToolBar resetContentAndFlage:@"股票交易" Mode:TTBM_Mode_Leveltwo];
  self.indicatorView.hidden = YES;
  _inspectionDivision = [[NSMutableDictionary alloc] init];
  _titleMutableDictionary = [[NSMutableDictionary alloc] init];
  _markNumberDic = [[NSMutableDictionary alloc] init];
  _markArray = [NSMutableArray array];
  titleDictionary = @{
    @"1" : @"当日成交",
    @"2" : @"历史成交",
    @"3" : @"资金转入",
    @"4" : @"资金转出",
    @"5" : @"转账流水",
    @"6" : @"指定交易"
  };
  imageDictionary = @{
    @"1" : @"当日成交小图标.png",
    @"2" : @"历史成交小图标.png",
    @"3" : @"资金转入小图标.png",
    @"4" : @"资金转出小图标.png",
    @"5" : @"转账流水小图标.png",
    @"6" : @"指定交易小图标.png"
  };
  _searchTitleDict = @{
    @"当日成交" : @"1",
    @"历史成交" : @"2",
    @"资金转入" : @"3",
    @"资金转出" : @"4",
    @"转账流水" : @"5",
    @"指定交易" : @"6"
  };

  NSDictionary *materialDic = @{
    @"1" : @(NumberOne),
    @"2" : @(NumberOne),
    @"3" : @(NumberTwo),
    @"4" : @(NumberTwo),
    @"5" : @(NumberTwo),
    @"6" : @(NumberThree),
    @"7" : @(NumberTwo),
    @"8" : @(NumberTwo)
  };

  //从服务端得到 要显示的编号
  NSString *func =
      [[NSUserDefaults standardUserDefaults] objectForKey:@"showListOfMore"];
  // 1 2 3 4 5 6 7 8
  /**
   *
   *  当 3 4 5 7 8 一个区
   *  当 6 单独一个区
   *  当 1 2 区
   *
   */
  _typeTlitleArray = [func componentsSeparatedByString:@","];
  //给编号 分组
  if (_inspectionDivision.count != 0) {
    [_inspectionDivision removeAllObjects];
  }
  //初始化 保存分组编号的数组
  _titleArray1 = [NSMutableArray array];
  _titleArray2 = [NSMutableArray array];
  _titleArray3 = [NSMutableArray array];

  _imageArray1 = [NSMutableArray array];
  _imageArray2 = [NSMutableArray array];
  _imageArray3 = [NSMutableArray array];
  //分区
  for (int i = 0; i < _typeTlitleArray.count; i++) {
    NSInteger numSection = [materialDic[_typeTlitleArray[i]] integerValue];
    //取出图片
    NSString *image = imageDictionary[_typeTlitleArray[i]];
    //取出标题
    NSString *title = titleDictionary[_typeTlitleArray[i]];
    //不可能 取出nil
    switch (numSection) {
    case NumberOne:
      //将 取出来的 编号分类保存
      if (image && title) {
        [_imageArray1 addObject:image];
        [_titleArray1 addObject:title];
      }
      break;
    case NumberTwo:
      if (image && title) {
        [_imageArray2 addObject:image];
        [_titleArray2 addObject:title];
      }
      break;
    case NumberThree:
      if (image && title) {
        [_imageArray3 addObject:image];
        [_titleArray3 addObject:title];
      }
      break;
    }
  }
  if (_titleArray1.count != 0) {
    [self saveArrayForDictionary:_inspectionDivision
                       withArray:_imageArray1
                         withKey:NumberOne];
    [self saveArrayForDictionary:_titleMutableDictionary
                       withArray:_titleArray1
                         withKey:NumberOne];
    [_markArray addObject:@(NumberOne)];
  }
  if (_titleArray2.count != 0) {
    [self saveArrayForDictionary:_inspectionDivision
                       withArray:_imageArray2
                         withKey:NumberTwo];
    [self saveArrayForDictionary:_titleMutableDictionary
                       withArray:_titleArray2
                         withKey:NumberTwo];
    [_markArray addObject:@(NumberTwo)];
  }
  if (_titleArray3.count != 0) {
    [self saveArrayForDictionary:_inspectionDivision
                       withArray:_imageArray3
                         withKey:NumberThree];
    [self saveArrayForDictionary:_titleMutableDictionary
                       withArray:_titleArray3
                         withKey:NumberThree];
    [_markArray addObject:@(NumberThree)];
  }
  [self creatTableViews];
  [rtmv_tableView reloadData];
}

//将数组 保存到 字典里
- (void)saveArrayForDictionary:(NSMutableDictionary *)dic
                     withArray:(NSMutableArray *)array
                       withKey:(NumberSection)num {
  NSString *keys = [NSString stringWithFormat:@"%ld", (long)num];
  [dic setValue:array forKey:keys];
}

#pragma mark
#pragma mark 创建控件
//创建表格
- (void)creatTableViews {

  CGRect tablerect = CGRectMake(9, 10, self.view.frame.size.width - 18,
                                self.view.frame.size.height - 80);
  rtmv_tableView = [[UITableView alloc] initWithFrame:tablerect
                                                style:UITableViewStyleGrouped];
  rtmv_tableView.dataSource = self;
  rtmv_tableView.delegate = self;
  rtmv_tableView.backgroundColor = [Globle colorFromHexRGB:@"#f7f7f7"];
  rtmv_tableView.showsVerticalScrollIndicator = NO;
  rtmv_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  rtmv_tableView.backgroundView = nil;
  [self.clientView addSubview:rtmv_tableView];
  [self createTableViewFootView];
}
/** 实盘退出登录 */
- (void)createTableViewFootView {
  UIView *footView = [[UIView alloc]
      initWithFrame:CGRectMake(0, 0, viewWidth, tableviewFootViewHeight)];
  footView.backgroundColor = [UIColor clearColor];
  //退出登录按钮
  UIButton *firmLogoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
  firmLogoutButton.frame = CGRectMake(0, 10, viewWidth - 9 * 2, 38);
  UIImage *loginImage =
      [UIImage imageFromView:firmLogoutButton
          withBackgroundColor:[Globle colorFromHexRGB:@"a61a1d"]];
  UIImage *loginDownImage =
      [UIImage imageFromView:firmLogoutButton withIndex:logout_button_index];
  [firmLogoutButton setBackgroundImage:loginImage
                              forState:UIControlStateNormal];
  [firmLogoutButton setBackgroundImage:loginDownImage
                              forState:UIControlStateHighlighted];
  [firmLogoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
  firmLogoutButton.titleLabel.font = [UIFont systemFontOfSize:Font_Height_16_0];
  [firmLogoutButton setTitleColor:[UIColor whiteColor]
                         forState:UIControlStateNormal];
  [firmLogoutButton addTarget:self
                       action:@selector(logoutFirmAccount:)
             forControlEvents:UIControlEventTouchUpInside];
  [footView addSubview:firmLogoutButton];
  rtmv_tableView.tableFooterView = footView;
}
/** 实盘退出登录提示 */
- (void)logoutFirmAccount:(UIButton *)button {
  UIAlertView *alertView =
      [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                 message:@"您确定要退出实盘交易吗？"
                                delegate:self
                       cancelButtonTitle:@"取消"
                       otherButtonTitles:@"确定", nil];
  [alertView show];
}
- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) {
    //登录时间清零
    [SimuUser setUserFirmLogonSuccessTime:0];
    //实盘退出登录
    [AppDelegate popViewController:YES];
  }
}
//创建资金转入页面
- (void)creatFundTransferInVC {

  [self startViewController:[[RealTradeFundTransferVC alloc] init:YES]];
}

- (void)startViewController:(UIViewController *)viewController {
  [AppDelegate pushViewControllerFromRight:viewController];
}
//创建资金转出页面
- (void)creatFundTransferOutVC {
  [self startViewController:[[RealTradeFundTransferVC alloc] init:NO]];
}
//创建转账流水页面
- (void)creatTransferWaterVC {
  [self startViewController:[[RealTradeTransferListVC alloc] init]];
}
//创建今日成交页面
- (void)creatTodayDealVC {
  [self
      startViewController:[[RealTradeTodayDealQueryVC alloc] initWithBool:YES]];
}
//创建历史成交页面
- (void)creatHisDealVC {
  [self startViewController:[[RealTradeHistoryDealQueryVC alloc]
                                initWithCapital:YES]];
}

//创建指定交易页面
- (void)creatRealTradeSpecialTradeViewController {
  [self startViewController:[[RTSpecialTradeVC alloc] init]];
}
#pragma mark
#pragma mark 控件协议函数
//分多少区
/**
 *
 *  当 3 4 5 7 8 一个区   2
 *  当 6 单独一个区   3
 *  当 1 2 区  1
 *
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

  return _markArray.count;
}

// UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {

  return [self getTitleArrayForSection:section].count;
}

- (NSArray *)getTitleArrayForSection:(NSInteger)num {
  NumberSection numSection = [_markArray[num] integerValue];
  return [self getTitleArray:numSection];
}

- (NSArray *)getImageArrayForSection:(NSInteger)num {
  NumberSection numSection = [_markArray[num] integerValue];
  return [self getNuberOfRowInSection:numSection];
}
/** 得到每个区的 图片 */
- (NSArray *)getNuberOfRowInSection:(NumberSection)num {
  NSString *key = [NSString stringWithFormat:@"%ld", (long)num];
  return _inspectionDivision[key];
}

/** 得到 title */
- (NSArray *)getTitleArray:(NumberSection)num {
  NSString *key = [NSString stringWithFormat:@"%ld", (long)num];
  return _titleMutableDictionary[key];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *ID = @"cell";
  tableView.backgroundColor = [UIColor clearColor];
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:ID];
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView.backgroundColor = [UIColor clearColor];

    //加入箭头
    UIImage *iamgeArrow = [UIImage imageNamed:@"箭头.png"];
    UIImageView *imageviewArrow =
        [[UIImageView alloc] initWithImage:iamgeArrow];
    float leftwidth = 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
      // ios7.0及以上版本
      leftwidth = self.view.frame.size.width - 30 - iamgeArrow.size.width;
    } else {
      // ios7.0版本
      leftwidth = self.view.frame.size.width - iamgeArrow.size.width - 50;
    }
    imageviewArrow.frame = CGRectMake(
        leftwidth, (cell.bounds.size.height - iamgeArrow.size.height) / 2,
        iamgeArrow.size.width, iamgeArrow.size.height);
    [cell.contentView addSubview:imageviewArrow];
    // cell 贴图
    NSInteger num = [tableView numberOfRowsInSection:indexPath.section];
    if (num > 2) {
      if (indexPath.row == 0) {
        [self FirstMapForCell:cell withMark:FirstMapForTop];
      } else if (indexPath.row == (num - 1)) {
        [self FirstMapForCell:cell withMark:LastMapForBottom];
      } else {
        [self FirstMapForCell:cell withMark:MiddleMap];
      }

      //加线
      if (indexPath.row < (num - 1)) {
        [self addLineFormCell:cell];
      }
    } else if (num == 2) {
      if (indexPath.row == 0) {
       [self FirstMapForCell:cell withMark:FirstMapForTop];
      } else if (indexPath.row == 1) {
        [self FirstMapForCell:cell withMark:LastMapForBottom];
      }
      //加线
      if (indexPath.row == 0) {
        [self addLineFormCell:cell];
      }
    } else if (num < 2) {
      [self FirstMapForCell:cell withMark:AloneMap];
    }
    //设置 小图标 和 title
    NSArray *imagArray;
    NSArray *titleArray;

    titleArray = [self getTitleArrayForSection:indexPath.section];
    imagArray = [self getImageArrayForSection:indexPath.section];

    UIImage *image = [UIImage imageNamed:imagArray[indexPath.row]];
    UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
    imageview.frame =
        CGRectMake(5, (cell.bounds.size.height - image.size.height) / 2,
                   image.size.width, image.size.height);
    [cell.contentView addSubview:imageview];
    //设置title
    UILabel *titlelable = [[UILabel alloc]
        initWithFrame:CGRectMake(imageview.frame.origin.x +
                                     imageview.frame.size.width + 3,
                                 (cell.bounds.size.height - 16) / 2,
                                 cell.bounds.size.width -
                                     (imageview.frame.origin.x +
                                      imageview.frame.size.width + 3 - 40),
                                 16)];
    titlelable.backgroundColor = [UIColor clearColor];
    titlelable.font = [UIFont systemFontOfSize:Font_Height_16_0];
    titlelable.textAlignment = NSTextAlignmentLeft;
    titlelable.textColor = [Globle colorFromHexRGB:Color_Text_Common];
    titlelable.text = titleArray[indexPath.row];
    [cell.contentView addSubview:titlelable];
  }
  return cell;
}


//cell加线
-(void)addLineFormCell:(UITableViewCell *)cell
{
  float linewidth = 0;
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    // ios7.0及以上版本
    linewidth = 23.5;
  } else {
    linewidth = 36;
  }
  UIView *_downView = [[UIView alloc]
                       initWithFrame:CGRectMake(0, 47 - 1,
                                                self.view.frame.size.width - linewidth,
                                                0.5)];
  _downView.backgroundColor = [Globle colorFromHexRGB:@"e3e3e3"];
  [cell.contentView addSubview:_downView];
  
  //下白
  UIView *_upView = [[UIView alloc]
                     initWithFrame:CGRectMake(0, 47 - 0.5,
                                              self.view.frame.size.width - linewidth,
                                              0.5)];
  _upView.backgroundColor = [UIColor whiteColor];
  [cell.contentView addSubview:_upView];
}

// cell 贴图
- (void)FirstMapForCell:(UITableViewCell *)cell withMark:(MapForCell)map {
  UIImage *rowImage = nil;
  UIImage *selectedImage = nil;
  switch (map) {
  case FirstMapForTop:
    rowImage = [UIImage imageNamed:@"列表01.png"];
    selectedImage = [UIImage imageNamed:@"select_up.png"];
    rowImage =
        [rowImage resizableImageWithCapInsets:UIEdgeInsetsMake(7, 5, 2, 5)];
    break;
  case LastMapForBottom:
    rowImage = [UIImage imageNamed:@"列表_03"];
    selectedImage = [UIImage imageNamed:@"select_down.png"];
    rowImage =
        [rowImage resizableImageWithCapInsets:UIEdgeInsetsMake(2, 5, 7, 5)];
    break;
  case MiddleMap:
    rowImage = [UIImage imageNamed:@"列表02"];
    selectedImage = [UIImage imageNamed:@"select_middle.png"];
    rowImage =
        [rowImage resizableImageWithCapInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
    break;
  case AloneMap:
    rowImage = [UIImage imageNamed:@"列表00.png"];
    rowImage =
        [rowImage resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    selectedImage = [UIImage imageNamed:@"select_middle.png"];
    break;
  }
  selectedImage =
      [selectedImage resizableImageWithCapInsets:UIEdgeInsetsMake(3, 5, 3, 5)];
  UIImageView *rowBackImageView = [[UIImageView alloc]
      initWithFrame:CGRectMake(0, 0, cell.contentView.bounds.size.width, 47)];
  UIImageView *selectedBackImageView = [[UIImageView alloc]
      initWithFrame:CGRectMake(0, 0, cell.contentView.bounds.size.width, 47)];
  if (AloneMap) {
    selectedBackImageView.layer.cornerRadius = 4.0f;
    selectedBackImageView.layer.masksToBounds = YES;
  }
  rowBackImageView.image = rowImage;
  selectedBackImageView.image = selectedImage;
  cell.selectedBackgroundView = selectedBackImageView;
  cell.backgroundView = rowBackImageView;
}

// UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 47;
}
- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
  return 3;
}
- (CGFloat)tableView:(UITableView *)tableView
    heightForFooterInSection:(NSInteger)section {
  return 3;
}
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *array = [self getTitleArrayForSection:indexPath.section];
  NSString *numString = _searchTitleDict[array[indexPath.row]];
  [self jumpSpecifiedPage:[numString integerValue]];

  [tableView reloadData];
}

- (void)jumpSpecifiedPage:(NSInteger)number {
  switch (number) {
  case 1:
    //今日成交
    [self creatTodayDealVC];
    break;
  case 2:
    //历史成交
    [self creatHisDealVC];
    break;
  case 3:
    //资金转入
    [self creatFundTransferInVC];
    break;
  case 4:
    //资金转出
    [self creatFundTransferOutVC];
    break;
  case 5:
    //转账流水
    [self creatTransferWaterVC];
    break;
  case 6:
    //指定交易
    [self creatRealTradeSpecialTradeViewController];
    break;
  }
}
@end

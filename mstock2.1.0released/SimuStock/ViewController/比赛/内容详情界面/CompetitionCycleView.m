//
//  CompetitionCycleView.m
//  SimuStock
//
//  Created by moulin wang on 14-5-14.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "CompetitionCycleView.h"
#import "SimuUtil.h"
#import "CompetitionCycleCell.h"
#import "ProductListItem.h"

@implementation CompetitionCycleView
@synthesize cycleView;
@synthesize warningView;
@synthesize buyDiamondsView;
@synthesize exchangeView;
@synthesize productId;

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.userInteractionEnabled = YES;
    _evenPointBool = YES;
  }
  return self;
}

//参赛周期视图
- (void)competitionCycleView:(SimuCompetitionMillionCycleData *)cycleData
                       title:(NSString *)name {
  judge = 1;
  selectRow = 2;
  dataArr = cycleData.list;
  cycleView = [[UIView alloc]
      initWithFrame:CGRectMake((self.bounds.size.width - 494.0 / 2) / 2,
                               (self.bounds.size.height -
                                (78.0 * 3 + 118.0 + 121.0 + 3.0) / 2) /
                                   2,
                               494.0 / 2,
                               (78.0 * 3 + 118.0 + 121.0 + 3.0) / 2)];
  cycleView.backgroundColor = [UIColor whiteColor];
  [cycleView.layer setMasksToBounds:YES];
  cycleView.layer.cornerRadius = 5.0;
  [self addSubview:cycleView];
  //比赛标题
  [self titleView:name
             rect:CGRectMake(0, 26.0 / 2, cycleView.bounds.size.width, 34.0 / 2)
       parentView:cycleView];
  //参赛周期标题
  [self competitionCycleTitle];
  [self dividingLineLayerrect:CGRectMake(0.0, 118.0 / 2,
                                         cycleView.bounds.size.width, 3.0 / 2)
                   parentView:cycleView
                        color:[Globle colorFromHexRGB:@"31bce9"]];
  [self createTableView:YES
                   rect:CGRectMake(0.0, (118.0 + 3.0) / 2,
                                   cycleView.bounds.size.width, (78.0 * 3) / 2)
             parentView:cycleView];

  [self cancelDetermineButtonToViewDetermineTag:
            5000 backTag:5002 rect:CGRectMake(0.0, (118.0 + 3.0 + 78.0 * 3) / 2,
                                              cycleView.bounds.size.width,
                                              121.0 / 2)
                                     parentView:cycleView
                                  determineName:@"确定"
                                 determineColor:[Globle
                                                    colorFromHexRGB:@"31bce9"]];
}
//比赛标题
- (void)titleView:(NSString *)title
             rect:(CGRect)rect
       parentView:(UIView *)parentView {
  //标题
  UILabel *titleLab = [[UILabel alloc] initWithFrame:rect];
  titleLab.backgroundColor = [UIColor clearColor];
  titleLab.textColor = [UIColor blackColor];
  titleLab.textAlignment = NSTextAlignmentCenter;
  titleLab.font = [UIFont systemFontOfSize:19.f];
  titleLab.text = title;
  [parentView addSubview:titleLab];
}
//参赛周期标题
- (void)competitionCycleTitle {
  //标题
  UILabel *cycleTitleLab = [[UILabel alloc]
      initWithFrame:CGRectMake(0, (22.0 + 32.0 + 22.0) / 2,
                               cycleView.bounds.size.width, 26.0 / 2)];
  cycleTitleLab.backgroundColor = [UIColor clearColor];
  cycleTitleLab.textColor = [Globle colorFromHexRGB:@"5a5a5a"];
  cycleTitleLab.textAlignment = NSTextAlignmentCenter;
  cycleTitleLab.font = [UIFont systemFontOfSize:Font_Height_12_0];
  cycleTitleLab.text = @"请选择你的参赛周期";
  [cycleView addSubview:cycleTitleLab];
}
//分割线
- (void)dividingLineLayerrect:(CGRect)rect
                   parentView:(UIView *)parentView
                        color:(UIColor *)color {
  CALayer *layer = [CALayer layer];
  layer.frame = rect;
  layer.backgroundColor = color.CGColor;
  [parentView.layer addSublayer:layer];
}
//表格视图
- (void)createTableView:(BOOL)Slide
                   rect:(CGRect)rect
             parentView:(UIView *)parentView {
  UITableView *diamondTableView =
      [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
  diamondTableView.scrollEnabled = Slide;
  diamondTableView.dataSource = self;
  diamondTableView.delegate = self;
  diamondTableView.separatorStyle = UITableViewCellAccessoryNone;
  [parentView addSubview:diamondTableView];
}
#pragma mark
#pragma mark----购买提醒视图----
- (void)determineTheRaceView:(NSInteger)number {
  CGRect frame = cycleView.bounds;
  // zxc修改
  maskView = [[UIView alloc]
      initWithFrame:CGRectMake(frame.origin.x, frame.origin.y - 66 + 66,
                               frame.size.width, frame.size.height + 66)];
  maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
  [maskView.layer setMasksToBounds:YES];
  maskView.layer.cornerRadius = 5.0;
  [cycleView addSubview:maskView];
  UIView *remindView = [[UIView alloc]
      initWithFrame:CGRectMake(0.0, 100.0 / 2, maskView.bounds.size.width,
                               (152.0 + 121.0) / 2)];
  remindView.backgroundColor = [UIColor whiteColor];
  [remindView.layer setMasksToBounds:YES];
  remindView.layer.cornerRadius = 5.0;
  [maskView addSubview:remindView];
  //内容
  UILabel *contentLab = [[UILabel alloc]
      initWithFrame:CGRectMake(16.0, 0.0, remindView.bounds.size.width - 32.0,
                               152.0 / 2)];
  contentLab.backgroundColor = [UIColor clearColor];
  contentLab.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  contentLab.textAlignment = NSTextAlignmentCenter;
  contentLab.numberOfLines = 0;
  contentLab.font = [UIFont systemFontOfSize:Font_Height_16_0];
  contentLab.text = [NSString
      stringWithFormat:@"确认扣除%ld颗钻石参赛？", (long)number];
  [remindView addSubview:contentLab];
  //确定和取消
  [self cancelDetermineButtonToViewDetermineTag:
            5001 backTag:5003 rect:CGRectMake(0.0, 152.0 / 2,
                                              remindView.bounds.size.width,
                                              121.0 / 2)
                                     parentView:remindView
                                  determineName:@"确定"
                                 determineColor:[Globle
                                                    colorFromHexRGB:@"31bce9"]];
}
//确定 取消 充值等按钮
- (void)cancelDetermineButtonToViewDetermineTag:(NSInteger)determineTag
                                        backTag:(NSInteger)backTag
                                           rect:(CGRect)rect
                                     parentView:(UIView *)parentView
                                  determineName:(NSString *)determineName
                                 determineColor:(UIColor *)determineColor {
  UIView *bgView = [[UIView alloc] initWithFrame:rect];
  bgView.backgroundColor = [Globle colorFromHexRGB:@"d1d1d1"];
  [parentView addSubview:bgView];
  //返回按钮
  UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
  backButton.tag = backTag;
  backButton.frame =
      CGRectMake(15, (bgView.bounds.size.height - 34.0) / 2, 100, 34);
  backButton.backgroundColor = [Globle colorFromHexRGB:@"afb3b5"];
  [backButton setTitle:@"返回" forState:UIControlStateNormal];
  [backButton.layer setMasksToBounds:YES];
  [backButton.layer setCornerRadius:17];
  backButton.titleLabel.font = [UIFont boldSystemFontOfSize:Font_Height_16_0];
  [backButton addTarget:self
                 action:@selector(touchdown1:)
       forControlEvents:UIControlEventTouchDown];
  [backButton addTarget:self
                 action:@selector(outSide1:)
       forControlEvents:UIControlEventTouchUpOutside];
  [backButton addTarget:self
                 action:@selector(cycleButtonTriggeringMethod:)
       forControlEvents:UIControlEventTouchUpInside];
  [bgView addSubview:backButton];
  //确定 兑换 充值等
  UIButton *determine = [UIButton buttonWithType:UIButtonTypeCustom];
  determine.frame =
      CGRectMake(250 - 115, (bgView.bounds.size.height - 34.0) / 2, 100, 34);
  determine.tag = determineTag;
  determine.backgroundColor =
      determineColor; //[Globle colorFromHexRGB:@"3cc1cb"];
  [determine setTitle:determineName forState:UIControlStateNormal];
  [determine.layer setMasksToBounds:YES];
  [determine.layer setCornerRadius:17];
  determine.titleLabel.font = [UIFont boldSystemFontOfSize:Font_Height_16_0];
  [determine addTarget:self
                action:@selector(touchdown2:)
      forControlEvents:UIControlEventTouchDown];
  [determine addTarget:self
                action:@selector(outSide2:)
      forControlEvents:UIControlEventTouchUpOutside];
  [determine addTarget:self
                action:@selector(cycleButtonTriggeringMethod:)
      forControlEvents:UIControlEventTouchUpInside];
  [bgView addSubview:determine];
}
//立即购买按钮
- (void)createBuyNowButtonParentView:(UIView *)parentView rect:(CGRect)rect {
  UIView *bgView = [[UIView alloc] initWithFrame:rect];
  bgView.backgroundColor = [Globle colorFromHexRGB:@"#d1d1d1"];
  [parentView addSubview:bgView];
  //确定
  UIButton *determine = [UIButton buttonWithType:UIButtonTypeCustom];
  determine.frame =
      CGRectMake((494.0 - 286.0) / 4, (bgView.bounds.size.height - 34.0) / 2,
                 286.0 / 2, 68.0 / 2);
  determine.tag = 5005;
  determine.backgroundColor = [Globle colorFromHexRGB:@"31bce9"];
  [determine setTitle:@"立即购买" forState:UIControlStateNormal];
  [determine.layer setMasksToBounds:YES];
  [determine.layer setCornerRadius:17];
  determine.titleLabel.font = [UIFont boldSystemFontOfSize:Font_Height_14_0];
  [determine addTarget:self
                action:@selector(touchdown2:)
      forControlEvents:UIControlEventTouchDown];
  [determine addTarget:self
                action:@selector(outSide2:)
      forControlEvents:UIControlEventTouchUpOutside];
  [determine addTarget:self
                action:@selector(cycleButtonTriggeringMethod:)
      forControlEvents:UIControlEventTouchUpInside];
  [bgView addSubview:determine];
}
//点击背景
- (void)touchdown1:(UIButton *)button {
  [button setBackgroundColor:[Globle colorFromHexRGB:@"83888b"]];
}
- (void)outSide1:(UIButton *)button {
  [button setBackgroundColor:[Globle colorFromHexRGB:@"afb3b5"]];
}
- (void)touchdown2:(UIButton *)button {
  if (button.tag == 5101 || button.tag == 5102 || button.tag == 5103) {
    [button setBackgroundColor:[Globle colorFromHexRGB:@"086dae"]];
  } else {
    [button setBackgroundColor:[Globle colorFromHexRGB:@"086dae"]];
  }
}
- (void)outSide2:(UIButton *)button {

  if (button.tag == 5101 || button.tag == 5102 || button.tag == 5103) {
    [button setBackgroundColor:[Globle colorFromHexRGB:@"31bce9"]];
  } else {
    [button setBackgroundColor:[Globle colorFromHexRGB:@"31bce9"]];
  }
}
/*商城弹出框方法
 1.title为“兑换”
 说明:
 右侧按钮名字为“兑换”  tag=5101
 右侧按钮名字为“充值”  tag=5102

 2.title为“详情”
 说明:
 右侧按钮名字为“兑换”  tag=5103
 */
#pragma mark
#pragma mark-----UIButton触发方法-----
- (void)cycleButtonTriggeringMethod:(UIButton *)btn {

  if (!_evenPointBool) {
    return;
  }
  _evenPointBool = NO;
  [self performSelector:@selector(timeEnough)
             withObject:nil
             afterDelay:0.3f]; //使用延时进行限制
  switch (btn.tag) {
  case 5000: //周期选择确定
  {

    [btn setBackgroundColor:[Globle colorFromHexRGB:@"31bce9"]];
    if (diaNumber == 0) {
      return;
    } else {
      [self determineTheRaceView:diaNumber];
    }

  } break;
  case 5001: //参赛确定
  {
    [btn setBackgroundColor:[Globle colorFromHexRGB:@"31bce9"]];
    if (typeInt == 0) {
      return;
    }
    if (_delegate &&
        [_delegate
            respondsToSelector:@selector(
                                   requestParticipatingDeductionDiamond:)]) {
      [_delegate requestParticipatingDeductionDiamond:typeInt];
    }
  } break;
  case 5002: //取消CompetitionCycleView视图
  {
    [btn setBackgroundColor:[Globle colorFromHexRGB:@"afb3b5"]];
    self.delegate = nil;
    [self removeFromSuperview];
  } break;
  case 5003: //取消参赛
  {
    [maskView removeFromSuperview];
    [btn setBackgroundColor:[Globle colorFromHexRGB:@"afb3b5"]];
  } break;
  case 5004: //充值
  {
    [btn setBackgroundColor:[Globle colorFromHexRGB:@"31bce9"]];
    if (_delegate &&
        [_delegate respondsToSelector:@selector(rechargeDataRequest)]) {
      [_delegate rechargeDataRequest];
    }
  } break;
  case 5005: //立即购买
  {
    [btn setBackgroundColor:[Globle colorFromHexRGB:@"31bce9"]];
    if (!productId) {
      return;
    }
    if (_delegate &&
        [_delegate respondsToSelector:@selector(buyNowProductId:)]) {
      [_delegate buyNowProductId:productId];
    }
  } break;
  case 5101: //兑换->兑换按钮
  {
    [btn setBackgroundColor:[Globle colorFromHexRGB:@"31bce9"]];
    if (!productId) {
      return;
    }
    if (_delegate &&
        [_delegate
            respondsToSelector:@selector(diamondExchangeFundsToBuyCards:)]) {
      [_delegate diamondExchangeFundsToBuyCards:productId];
    }
  } break;
  case 5102: //兑换->充值按钮
  {
    [btn setBackgroundColor:[Globle colorFromHexRGB:@"31bce9"]];
    if (_delegate &&
        [_delegate
            respondsToSelector:@selector(conversionTipRechargeButtonMethod)]) {
      [_delegate conversionTipRechargeButtonMethod];
    }
  } break;
  case 5103: //详情->兑换按钮
  {
    [btn setBackgroundColor:[Globle colorFromHexRGB:@"31bce9"]];
    if (_delegate &&
        [_delegate respondsToSelector:
                       @selector(detailsButtonToTriggerTheConversionMethod)]) {
      [_delegate detailsButtonToTriggerTheConversionMethod];
    }
  } break;

  default:
    break;
  }
}
//延时
- (void)timeEnough {
  _evenPointBool = YES;
}
#pragma mark
#pragma mark-----UITableView代理方法-----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
  return dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 78.0 / 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *Cell = @"identifier";
  CompetitionCycleCell *cell = (CompetitionCycleCell *)
      [tableView dequeueReusableCellWithIdentifier:Cell];
  if (cell == nil) {
    cell =
        [[CompetitionCycleCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:Cell];
  }
  if (1 == judge) {
    NSInteger diamondInt =
        [[dataArr[indexPath.row] objectForKey:@"diamond"] integerValue];
    cell.diamondLab.text =
        [NSString stringWithFormat:@"%ld钻石", (long)diamondInt];
    NSString *sad_des = [dataArr[indexPath.row] objectForKey:@"des"];
    cell.quantityLab.frame = CGRectMake(120.0, (76.0 - 30.0) / 4, 120.0, 15.0);
    cell.quantityLab.text = [NSString stringWithFormat:@"%@", sad_des];
    if (selectRow == indexPath.row) {
      cell.circleImageV.hidden = NO;
      //钻石数
      diaNumber =
          [[dataArr[indexPath.row] objectForKey:@"diamond"] integerValue];
      typeInt = [[dataArr[indexPath.row] objectForKey:@"type"] integerValue];
    } else {
      cell.circleImageV.hidden = YES;
    }
  }
  if (2 == judge) {
    CompetitionPurchaseDisplayData *displayData = dataArr[indexPath.row];
    cell.diamondLab.text = displayData.name;
    cell.quantityLab.text =
        [NSString stringWithFormat:@"%ld元", (long)displayData.costPrice];
    if (selectRow == indexPath.row) {
      cell.circleImageV.hidden = NO;
      self.productId = [NSString stringWithFormat:@"%@", displayData.productId];
    }
  }
  cell.selectionStyle = UITableViewCellSelectionStyleNone;
  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (selectRow == indexPath.row) {
    return;
  }
  NSIndexPath *selectndexPath =
      [NSIndexPath indexPathForRow:selectRow inSection:0];
  CompetitionCycleCell *cell1 =
      (CompetitionCycleCell *)[tableView cellForRowAtIndexPath:selectndexPath];
  cell1.circleImageV.hidden = YES;
  CompetitionCycleCell *cell =
      (CompetitionCycleCell *)[tableView cellForRowAtIndexPath:indexPath];
  cell.circleImageV.hidden = NO;
  selectRow = indexPath.row;
  if (judge == 1) {
    diaNumber = [[dataArr[indexPath.row] objectForKey:@"diamond"] integerValue];
    typeInt = [[dataArr[indexPath.row] objectForKey:@"type"] integerValue];
  } else if (judge == 2) {
    CompetitionPurchaseDisplayData *displayData = dataArr[indexPath.row];
    self.productId = [NSString stringWithFormat:@"%@", displayData.productId];
  }
}

#pragma mark
#pragma mark----钻石不足警告视图----
- (void)diamondInadequateWarningsView {
  warningView = [[UIView alloc]
      initWithFrame:CGRectMake((self.bounds.size.width - 494.0 / 2) / 2,
                               (self.bounds.size.height - (152.0 + 121.0) / 2) /
                                   2,
                               494.0 / 2, (152.0 + 121.0) / 2)];
  warningView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  [warningView.layer setMasksToBounds:YES];
  warningView.layer.cornerRadius = 5.0;
  [self addSubview:warningView];
  UILabel *contentLab = [[UILabel alloc]
      initWithFrame:CGRectMake(16.0, 0.0, warningView.bounds.size.width - 32.0,
                               152.0 / 2)];
  contentLab.backgroundColor = [UIColor clearColor];
  contentLab.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  contentLab.numberOfLines = 0;
  contentLab.textAlignment = NSTextAlignmentLeft;
  contentLab.font = [UIFont systemFontOfSize:Font_Height_16_0];
  contentLab.text = @"你的钻石数量不足，请先充值购买钻石";
  [warningView addSubview:contentLab];
  [self cancelDetermineButtonToViewDetermineTag:
            5004 backTag:5002 rect:CGRectMake(0.0, 152.0 / 2,
                                              warningView.bounds.size.width,
                                              121.0 / 2)
                                     parentView:warningView
                                  determineName:@"充值"
                                 determineColor:[Globle
                                                    colorFromHexRGB:@"31bce9"]];
}

//购买钻石视图
- (void)buyDiamondsView:(NSMutableArray *)arr
       rightButtonColor:(UIColor *)rightcolor {
  judge = 2;
  selectRow = 0;
  dataArr = arr;
  if (buyDiamondsView == nil) {
  }
  buyDiamondsView = [[UIView alloc]
      initWithFrame:CGRectMake((self.bounds.size.width - 494.0 / 2) / 2,
                               (self.bounds.size.height -
                                (78.0 * 3 + 82.0 + 121.0 + 3.0) / 2) /
                                   2,
                               494.0 / 2, (78.0 * 3 + 82.0 + 121.0 + 3.0) / 2)];
  buyDiamondsView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  [buyDiamondsView.layer setMasksToBounds:YES];
  buyDiamondsView.layer.cornerRadius = 5.0;
  [self addSubview:buyDiamondsView];
  //购买钻石
  [self titleView:@"购买钻石"
             rect:CGRectMake(0, 0, buyDiamondsView.bounds.size.width, 82.0 / 2)
       parentView:buyDiamondsView];
  [self dividingLineLayerrect:CGRectMake(0.0, 82.0 / 2,
                                         buyDiamondsView.bounds.size.width,
                                         3.0 / 2)
                   parentView:buyDiamondsView
                        color:rightcolor];
  [self createTableView:YES
                   rect:CGRectMake(0.0, 85.0 / 2,
                                   buyDiamondsView.bounds.size.width,
                                   78.0 * 3 / 2)
             parentView:buyDiamondsView];

  //立即购买按钮
  [self cancelDetermineButtonToViewDetermineTag:
            5005 backTag:5002 rect:CGRectMake(0.0, (85.0 + 78.0 * 3) / 2,
                                              buyDiamondsView.bounds.size.width,
                                              121.0 / 2)
                                     parentView:buyDiamondsView
                                  determineName:@"立即购买"
                                 determineColor:rightcolor];
}

- (void)mallExchangeViewTitle:(NSString *)title
                      message:(NSString *)message
               rightButtonTag:(NSInteger)tag
              rightButtonName:(NSString *)rightName
                WithproductId:(NSString *)_productId {
  productId = _productId;

  //阴影
  UIView *shadowView = [[UIView alloc]
      initWithFrame:CGRectMake((self.bounds.size.width - 494.0 / 2) / 2 - 2.5f,
                               (self.bounds.size.height - (246.0 + 121.0) / 2) /
                                       2 -
                                   2.5f,
                               494.0 / 2 + 5.0f, (246.0 + 121.0) / 2 + 5.0f)];
  shadowView.backgroundColor = [Globle colorFromHexRGB:Color_Black alpha:0.3];
  shadowView.layer.cornerRadius = 7; //
  [self addSubview:shadowView];

  //主窗体
  exchangeView = [[UIView alloc]
      initWithFrame:CGRectMake((self.bounds.size.width - 494.0 / 2) / 2,
                               (self.bounds.size.height - (246.0 + 121.0) / 2) /
                                   2,
                               494.0 / 2, (246.0 + 121.0) / 2)];
  exchangeView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  [exchangeView.layer setMasksToBounds:YES];
  exchangeView.layer.cornerRadius = 5.0;

  [self addSubview:exchangeView];
  //比赛标题
  [self titleView:title
             rect:CGRectMake(0, 0, exchangeView.bounds.size.width, 82.0 / 2)
       parentView:exchangeView];

  [self
      dividingLineLayerrect:CGRectMake(0.0, 82.0 / 2,
                                       exchangeView.bounds.size.width, 3.0 / 2)
                 parentView:exchangeView
                      color:[Globle colorFromHexRGB:@"31bce9"]]; //颜色要修改
  //内容
  UILabel *messageLab = [[UILabel alloc]
      initWithFrame:CGRectMake(16.0, 85.0 / 2,
                               exchangeView.bounds.size.width - 32.0,
                               (246.0 - 85.0) / 2)];
  messageLab.backgroundColor = [UIColor clearColor];
  messageLab.textColor = [UIColor blackColor];
  messageLab.textAlignment = NSTextAlignmentLeft;
  messageLab.numberOfLines = 0;
  messageLab.font = [UIFont systemFontOfSize:Font_Height_16_0];
  messageLab.text = message;
  [exchangeView addSubview:messageLab];
  [self cancelDetermineButtonToViewDetermineTag:
            tag backTag:5002 rect:CGRectMake(0.0, 246.0 / 2,
                                             exchangeView.bounds.size.width,
                                             121.0 / 2)
                                     parentView:exchangeView
                                  determineName:rightName
                                 determineColor:[Globle
                                                    colorFromHexRGB:@"31bce9"]];
}
//钻石不足视图
- (void)diamondInadequateWarningsView:(NSString *)message
                      withButtonTitle:(NSString *)buttonTitle {
  warningView = [[UIView alloc]
      initWithFrame:CGRectMake((self.bounds.size.width - 494.0 / 2) / 2,
                               (self.bounds.size.height - (152.0 + 121.0) / 2) /
                                   2,
                               494.0 / 2, (152.0 + 121.0) / 2)];
  warningView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  [warningView.layer setMasksToBounds:YES];
  warningView.layer.cornerRadius = 5.0;
  [self addSubview:warningView];
  UILabel *contentLab = [[UILabel alloc]
      initWithFrame:CGRectMake(16.0, 0.0, warningView.bounds.size.width - 32.0,
                               152.0 / 2)];
  contentLab.backgroundColor = [UIColor clearColor];
  contentLab.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  contentLab.numberOfLines = 0;
  contentLab.textAlignment = NSTextAlignmentLeft;
  contentLab.font = [UIFont systemFontOfSize:Font_Height_16_0];
  contentLab.text = message;
  [warningView addSubview:contentLab];
  [self cancelDetermineButtonToViewDetermineTag:
            5004 backTag:5002 rect:CGRectMake(0.0, 152.0 / 2,
                                              warningView.bounds.size.width,
                                              121.0 / 2)
                                     parentView:warningView
                                  determineName:buttonTitle
                                 determineColor:[Globle
                                                    colorFromHexRGB:@"31bce9"]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

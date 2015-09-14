//
//  WeiBoExtendButtons.m
//  SimuStock
//
//  Created by Yuemeng on 15/1/4.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WeiBoExtendButtons.h"
#import "GetBarTopListData.h"
#import "TopTweetStockData.h"
#import "AddTitleData.h"
#import "EliteTweetStockData.h"
#import "UnEliteTweetStockData.h"
#import "DropTStockData.h"
#import "CollectTStockData.h"
#import "WBCoreDataUtil.h"
#import "GetUserACLData.h"
#import "UnTopTweetStockData.h"
#import "WeiBoToolTip.h"
#import "BlueViewAndArrow.h"

#define ViewHeight 36

@implementation WeiBoExtendButtons

static WeiBoExtendButtons *wbButtons;

+ (WeiBoExtendButtons *)sharedExtendButtons {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    wbButtons = [[WeiBoExtendButtons alloc] init];
    wbButtons.hidden = YES;
    wbButtons.alpha = 0;
  });
  return wbButtons;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    [self createUI];
  }
  return self;
}

- (void)createUI {
  //设置按钮，根据权限设计按钮个数即自身大小
  //框高度72， 三角高度18 宽 37， 分割线线高48
  self.frame = [UIScreen mainScreen].bounds;
  self.backgroundColor = [UIColor clearColor];
  self.userInteractionEnabled = YES;

  //添加背景框和蓝色箭头
  _blueViewAndArrow = [[BlueViewAndArrow alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_VIEW, 45)];
  [self addSubview:_blueViewAndArrow];
}

#pragma mark - 置顶cell长按对外函数
+ (void)showWithBarTopTweetData:(BarTopTweetData *)data
                        offsetY:(CGFloat)offsetY
                           cell:(NSObject *)cell {
  //慢网可能为nil
  if (!data) {
    return;
  }

  wbButtons.data = data;
  wbButtons.cell = cell;

  //防止新生成假数据操作
  if (!data.tstockid) {
    return;
  }

  //根据权限及置顶状态重新设置按键
  [wbButtons refreshButtonsFormTopCell];

  //重设宽度、重设箭头
  [wbButtons resetBlueViewAndArrowsFrameWithOffsetY:offsetY];
  //上面最好封装进GCD
  [wbButtons showAndScaleLarge];
}

#pragma mark - 微博cell长按对外函数
+ (void)showWithTweetListItem:(TweetListItem *)item offsetY:(CGFloat)offsetY cell:(NSObject *)cell {
  //慢网可能为nil
  if (!item) {
    return;
  }

  wbButtons.item = item;
  wbButtons.cell = cell;

  //防止新生成假数据操作
  if (!item.tstockid) {
    return;
  }
  //根据权限重新设置按键
  [wbButtons refreshButtonsFormWeiboCell];

  //重设宽度、重设箭头
  [wbButtons resetBlueViewAndArrowsFrameWithOffsetY:offsetY];
  //上面最好封装进GCD
  [wbButtons showAndScaleLarge];
}

/** 聊股内容页表头复制 */
+ (void)showButtonWithCopyContent:(NSString *)content
                          offsetY:(CGFloat)offsetY
                           bgView:(NSObject *)bgView {
  wbButtons.cell = bgView;
  //防止新生成假数据操作
  if (content && [content length] < 1) {
    return;
  }
  //根据权限重新设置按键
  //第一步 清空全部按钮和竖线
  //  [wbButtons.blueView removeAllSubviews];
  [wbButtons.blueViewAndArrow removeAllSubviews];
  ButtonPressed action = ^{
    [wbButtons hideAndScaleSmall];
    /** 复制聊股内容 */
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = content;
  };
  [wbButtons buttonMaker:@"复制聊股内容" action:action];

  //重设宽度、重设箭头
  [wbButtons resetBlueViewAndArrowsFrameWithOffsetY:offsetY];
  //上面最好封装进GCD
  [wbButtons showAndScaleLarge];
}

#pragma mark -聊股内容页长按操作
/** 聊股内容页长按生成按钮 */
+ (void)showButtonWithTweetListItem:(TweetListItem *)item
                            offsetY:(CGFloat)offsetY
                               cell:(NSObject *)cell {
  wbButtons.item = item;
  wbButtons.cell = cell;

  //防止新生成假数据操作
  if (!item.tstockid) {
    return;
  }
  //根据权限重新设置按键
  [wbButtons createDeleteButtonOfWeiboCell];

  //重设宽度、重设箭头
  [wbButtons resetBlueViewAndArrowsFrameWithOffsetY:offsetY];
  //上面最好封装进GCD
  [wbButtons showAndScaleLarge];
}

/** 删除按钮（聊股内容页） */
- (void)createDeleteButtonOfWeiboCell {
  //第一步 清空全部按钮和竖线
  //  [_blueView removeAllSubviews];
  [wbButtons.blueViewAndArrow removeAllSubviews];

  UserACLData *aclData = [GetUserACLData sharedUserACLData].userACLData;
  _isTopCell = NO;

  //根据权限、item 设置相关属性状态和按钮按键名称
  // 0.先检测是管理员还是本吧版主
  if ([aclData.num isEqualToString:@"002"]) {
    _isAdmin = YES;
    _isBarHost = YES;
  } else if ([aclData.num isEqualToString:@"001"]) {
    _isAdmin = NO;
    _isBarHost = NO;
    //吧主，必须循环检测是否有当前bar的管理权限
    NSArray *barLists = aclData.barList;
    for (NSNumber *barId in barLists) {
      if ([[_item.barId stringValue] isEqualToString:[barId stringValue]]) {
        _isBarHost = YES;
        break;
      }
    }
  } else {
    //其他角色均是NO
    _isAdmin = NO;
    _isBarHost = NO;
  }

  // 4.删除，管理员和吧主及聊股发表人均可删除
  if (_isAdmin || _isBarHost || [[_item.uid stringValue] isEqualToString:[SimuUtil getUserID]]) {
    ButtonPressed deleteButtonClick = ^{
      [self hideAndScaleSmall];
      [self requestDropTStockData];
    };
    [self buttonMaker:@"删除" action:deleteButtonClick];
  }
}

#pragma mark - ☀️weibocell，根据用户权限生成所有按钮和分割线
- (void)refreshButtonsFormWeiboCell {
  //第一步 清空全部按钮和竖线
  //  [_blueView removeAllSubviews];
  [wbButtons.blueViewAndArrow removeAllSubviews];

  UserACLData *aclData = [GetUserACLData sharedUserACLData].userACLData;
  _isTopCell = NO;

  //根据权限、item 设置相关属性状态和按钮按键名称
  // 0.先检测是管理员还是本吧版主
  if ([aclData.num isEqualToString:@"002"]) {
    _isAdmin = YES;
    _isBarHost = YES;
  } else if ([aclData.num isEqualToString:@"001"]) {
    _isAdmin = NO;
    _isBarHost = NO;
    //吧主，必须循环检测是否有当前bar的管理权限
    NSArray *barLists = aclData.barList;
    for (NSNumber *barId in barLists) {
      if ([[_item.barId stringValue] isEqualToString:[barId stringValue]]) {
        _isBarHost = YES;
        break;
      }
    }
  } else {
    //其他角色均是NO
    _isAdmin = NO;
    _isBarHost = NO;
  }

  // 1.全局置顶，只有超级管理员才有此按钮，不需要检测状态
  if (_isAdmin) {
    ButtonPressed globleTopButtonClick = ^{

      [self hideAndScaleSmall];
      //先请求，如果返回值为0607再添加标题
      [self requestTopTweetStockDataWithType:2];
    };
    [self buttonMaker:@"全局置顶" action:globleTopButtonClick];
  }

  //如果对本吧有操作权限
  // 2.置顶，置顶不需要检测状态
  if (_isBarHost) {
    ButtonPressed topButtonClick = ^{

      [self hideAndScaleSmall];
      //先请求，如果返回值为0607再添加标题
      [self requestTopTweetStockDataWithType:1];
    };
    [self buttonMaker:@"置顶" action:topButtonClick];

    // 3.加精，检测加精状态
    ButtonPressed eliteButtonClick = ^{

      [self hideAndScaleSmall];
      [self getEliteStatus];
    };
    if (_item.elite) {
      [self buttonMaker:@"取消加精" action:eliteButtonClick];
    } else {
      [self buttonMaker:@"加精" action:eliteButtonClick];
    }
  }

  // 4.收藏 所有用户都有，只需检测是否收藏即可
  _item.isCollected = [WBCoreDataUtil fetchCollectTid:_item.tstockid];
  ButtonPressed collectButtonClick = ^{

    [self hideAndScaleSmall];
    [self getCollectStatus];
  };
  if (_item.isCollected) {
    [self buttonMaker:@"取消收藏" action:collectButtonClick];
    //添加进数组
  } else {
    //    /// 如果是自己发表的不能收藏
    //    if (![[_item.userListItem.userId stringValue]
    //            isEqualToString:[SimuUtil getUserID]]) {
    [self buttonMaker:@"收藏" action:collectButtonClick];
    //添加进数组
    //    }
  }

  // 5.删除，管理员和吧主及聊股发表人均可删除
  if (_isBarHost || [[_item.uid stringValue] isEqualToString:[SimuUtil getUserID]]) {
    ButtonPressed deleteButtonClick = ^{

      [self hideAndScaleSmall];
      [self requestDropTStockData];
    };
    [self buttonMaker:@"删除" action:deleteButtonClick];
  }
}

#pragma mark 🌛topWeiboCell
- (void)refreshButtonsFormTopCell {
  //第一步 清空全部按钮和竖线
  //  [_blueView removeAllSubviews];
  [wbButtons.blueViewAndArrow removeAllSubviews];

  UserACLData *aclData = [GetUserACLData sharedUserACLData].userACLData;
  _isTopCell = YES;

  //根据权限、item 设置相关属性状态和按钮按键名称
  // 0.先检测是管理员还是本吧版主
  if ([aclData.num isEqualToString:@"002"]) {
    _isAdmin = YES;
    _isBarHost = YES;
  } else if ([aclData.num isEqualToString:@"001"]) {
    _isAdmin = NO;
    _isBarHost = NO;
    //吧主，必须循环检测是否有当前bar的管理权限
    NSArray *barLists = aclData.barList;
    for (NSNumber *barId in barLists) {
      if ([[_data.barId stringValue] isEqualToString:[barId stringValue]]) {
        _isBarHost = YES;
        break;
      }
    }
  } else {
    //其他角色均是NO
    _isAdmin = NO;
    _isBarHost = NO;
  }

  // 1.全局置顶或取消全局，只有超级管理员才有此按钮
  // 若置顶类型为1，则出现’全局置顶‘、‘取消置顶’按钮
  // 若置顶类型为2，只出现‘取消全局’
  if (_isAdmin) {
    //吧内置顶
    if (_data.topType == 1) {
      ButtonPressed globleTopButtonClick = ^{

        [self hideAndScaleSmall];
        //先请求，如果返回值为0607再添加标题
        [self requestTopTweetStockDataWithType:2];
      };
      [self buttonMaker:@"全局置顶" action:globleTopButtonClick];
      //全局置顶
    } else if (_data.topType == 2) {
      ButtonPressed unGlobleTopButtonClick = ^{

        [self hideAndScaleSmall];
        [self requestUnTopTweetStockDataWithType:2];
      };
      [self buttonMaker:@"取消全局" action:unGlobleTopButtonClick];
    } else {
      //以后可能有其他权限，预留
    }
  }

  //如果对本吧有操作权限
  if (_isBarHost) {
    // 2.取消置顶，置顶类型为吧内置顶，才能取消置顶
    if (_data.topType == 1) {
      ButtonPressed unTopButtonClick = ^{

        [self hideAndScaleSmall];
        [self requestUnTopTweetStockDataWithType:1];
      };
      [self buttonMaker:@"取消置顶" action:unTopButtonClick];
    }

    // 3.加精，检测加精状态
    ButtonPressed eliteButtonClick = ^{

      [self hideAndScaleSmall];
      [self getEliteStatus];
    };
    if (_data.elite) {
      [self buttonMaker:@"取消加精" action:eliteButtonClick];
    } else {
      [self buttonMaker:@"加精" action:eliteButtonClick];
    }
  }

  // 4.收藏 所有用户都有，只需检测是否收藏即可
  _data.isCollected = [WBCoreDataUtil fetchCollectTid:_data.tstockid];
  ButtonPressed collectButtonClick = ^{

    [self hideAndScaleSmall];
    [self getCollectStatus];
  };
  if (_data.isCollected) {
    [self buttonMaker:@"取消收藏" action:collectButtonClick];
    //添加进数组
  } else {
    if (![[_item.userListItem.userId stringValue] isEqualToString:[SimuUtil getUserID]]) {
      [self buttonMaker:@"收藏" action:collectButtonClick];
      //添加进数组
    }
  }

  // 5.删除，只有管理员和吧主可删除
  if (_isBarHost) {
    ButtonPressed deleteButtonClick = ^{

      [self hideAndScaleSmall];
      [self requestDropTStockData];
    };
    [self buttonMaker:@"删除" action:deleteButtonClick];
  }
}

#pragma mark - 创建分隔符
- (UIView *)separatorMakerWithStartX:(CGFloat)startX {
  UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(startX, 6, 1, 24)];
  UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.5f, 24)];
  leftLine.backgroundColor = [Globle colorFromHexRGB:Color_SeparatorLeft];
  UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(0.5f, 0, 0.5f, 24)];
  rightLine.backgroundColor = [Globle colorFromHexRGB:Color_SeparatorRight];
  [separator addSubview:leftLine];
  [separator addSubview:rightLine];
  return separator;
}

#pragma mark - 根据权限设计需要的按钮
- (void)buttonMaker:(NSString *)title action:(ButtonPressed)action {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setTitle:title forState:UIControlStateNormal];
  button.titleLabel.font = [UIFont systemFontOfSize:Font_Height_14_0];
  [button setTitleColor:[Globle colorFromHexRGB:Color_White] forState:UIControlStateNormal];

  //根据title计算文字长度
  CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:Font_Height_14_0]
                       constrainedToSize:CGSizeMake(WIDTH_OF_SCREEN, CGFLOAT_MAX)];
  button.frame = CGRectMake(_blueWidth, 0, titleSize.width + 18, ViewHeight);
  _blueWidth += button.frame.size.width;
  //添加竖线
  [_blueViewAndArrow addSubview:[self separatorMakerWithStartX:_blueWidth]];
  [button setOnButtonPressedHandler:action];

  [_blueViewAndArrow addSubview:button];
}

#pragma mark - ⭐️重设蓝框和箭头位置
- (void)resetBlueViewAndArrowsFrameWithOffsetY:(CGFloat)offsetY {
  //根据长按位置和cell高度计算提示框应该出现的位置

  CGRect blueViewFrame = _blueViewAndArrow.frame;
  blueViewFrame.origin.y = offsetY - 36 - 45; //需要出现在手指的上方
  if (blueViewFrame.origin.y < 20) {
    blueViewFrame.origin.y = 20;
  }

  _blueViewAndArrow.frame = blueViewFrame;
  //调整宽度并重新绘制蓝色提示框三角图
  [_blueViewAndArrow reDrawRectWithWidth:_blueWidth];
  _blueWidth = 0;
}

#pragma mark - 网络请求
#pragma mark 无网提示
- (void)setNoNetwork {
  [NewShowLabel showNoNetworkTip]; //显示无网络提示
}

- (void)stopLoading {
}

#pragma mark （全局/股吧）置顶
- (void)requestTopTweetStockDataWithType:(NSInteger)type {
  if (![SimuUtil isExistNetwork] || (!_item && !_data)) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak WeiBoExtendButtons *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    WeiBoExtendButtons *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    WeiBoExtendButtons *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindTopTweetStockData:(TopTweetStockData *)obj type:type];
    }
  };
  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };

  __weak TweetListItem *weakItem = _item;
  callback.onError = ^(BaseRequestObject *error, NSException *ex) {
    if (error && [error.status isEqualToString:@"0607"]) {
      //添加标题
      [WeiboToolTip showInputViewWithTitle:@"聊股标题"
                               placeholder:@"请输入聊股标题"
                               finishblock:^(NSString *title) {
                                 weakItem.title = title;
                                 weakItem.heightCache[HeightCacheKeyTitle] = @25;
                                 //调用添加标题请求
                                 [weakSelf requestAddTitleWithType:type];
                               }];
    } else {
      [BaseRequester defaultErrorHandler](error, ex);
    }
  };

  [TopTweetStockData requestTopTweetStockDataWithBarId:(_isTopCell ? _data.barId : _item.barId)
                                           withTweetId:(_isTopCell ? _data.tstockid : _item.tstockid)
                                              withType:type
                                          withCallback:callback];
}

- (void)bindTopTweetStockData:(TopTweetStockData *)obj type:(NSInteger)type {
  if ((!_item && !_data)) {
    return;
  }
  if (type == 1) {
    [NewShowLabel setMessageContent:@"置顶成功"];
  } else {
    [NewShowLabel setMessageContent:@"全局置顶成功"];
  }
  //通知VC刷新置顶区域
  if (_extendTopButtonClickBlock) {
    _extendTopButtonClickBlock((_isTopCell ? nil : _item), _cell);
  }
  [self setNil];
}

#pragma mark （全局/股吧）取消置顶，只用于topcell
- (void)requestUnTopTweetStockDataWithType:(NSInteger)type {
  if (![SimuUtil isExistNetwork] || (!_item && !_data)) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak WeiBoExtendButtons *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    WeiBoExtendButtons *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    WeiBoExtendButtons *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindUnTopTweetStockData:(UnTopTweetStockData *)obj type:type];
    }
  };
  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };

  [UnTopTweetStockData requestUnTopTweetStockWithBarId:_data.barId
                                           withTweetId:_data.tstockid
                                              withType:type
                                          withCallback:callback];
}

- (void)bindUnTopTweetStockData:(UnTopTweetStockData *)obj type:(BOOL)type {
  if ((!_item && !_data)) {
    return;
  }
  if (type == 1) {
    [NewShowLabel setMessageContent:@"取消置顶成功"];
  } else {
    [NewShowLabel setMessageContent:@"取消全局置顶成功"];
  }
  //通知VC刷新置顶区域，需添加block
  if (_extendUnTopButtonClickBlock) {
    _extendUnTopButtonClickBlock(_data.tstockid, _cell);
  }
}

#pragma mark 添加标题接口
- (void)requestAddTitleWithType:(NSInteger)type {
  if (![SimuUtil isExistNetwork]) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak WeiBoExtendButtons *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    WeiBoExtendButtons *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    WeiBoExtendButtons *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindAddTitleData:(AddTitleData *)obj type:type];
    }
  };
  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };

  [AddTitleData requestAddTitleDataWithTweetId:_item.tstockid
                                     withTitle:_item.title
                                  withCallback:callback];
}

- (void)bindAddTitleData:(AddTitleData *)obj type:(NSInteger)type {
  [self requestTopTweetStockDataWithType:type];
}

#pragma mark 获取聊股加精状态
- (void)getEliteStatus {

  if (_isTopCell ? _data.elite : _item.elite) {
    //取消加精
    [self requestUnEliteTweetStockData];
  } else {
    //加精
    [self requestEliteTweetStockData];
  }
}

#pragma mark 聊股加精
- (void)requestEliteTweetStockData {
  if (![SimuUtil isExistNetwork] || (!_item && !_data)) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak WeiBoExtendButtons *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    WeiBoExtendButtons *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    WeiBoExtendButtons *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindEliteTweetStockData:(EliteTweetStockData *)obj];
    }
  };
  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };

  [EliteTweetStockData requestEliteTweetStockWithBarId:(_isTopCell ? _data.barId : _item.barId)
                                           withTweetId:(_isTopCell ? _data.tstockid : _item.tstockid)
                                          withCallback:callback];
}

- (void)bindEliteTweetStockData:(EliteTweetStockData *)obj {
  if ((!_item && !_data)) {
    return;
  }
  [NewShowLabel setMessageContent:@"加精成功"];
  _isTopCell ? (_data.elite = 1) : (_item.elite = 1);
  //通知刷新精华列表
  if (_extendEliteButtonClickBlock) {
    _extendEliteButtonClickBlock(YES, (_isTopCell ? _data.tstockid : _item.tstockid), _cell);
  }
  [self setNil];
}

#pragma mark 取消聊股加精
- (void)requestUnEliteTweetStockData {
  if (![SimuUtil isExistNetwork] || (!_item && !_data)) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak WeiBoExtendButtons *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    WeiBoExtendButtons *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    WeiBoExtendButtons *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindUnEliteTweetStockData:(UnEliteTweetStockData *)obj];
    }
  };
  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };

  [UnEliteTweetStockData requestUnEliteTweetStockWithBarId:(_isTopCell ? _data.barId : _item.barId)
                                               withTweetId:(_isTopCell ? _data.tstockid : _item.tstockid)
                                              withCallback:callback];
}

- (void)bindUnEliteTweetStockData:(UnEliteTweetStockData *)obj {
  if ((!_item && !_data)) {
    return;
  }
  [NewShowLabel setMessageContent:@"取消加精成功"];
  _isTopCell ? (_data.elite = 0) : (_item.elite = 0);
  if (_extendEliteButtonClickBlock) {
    _extendEliteButtonClickBlock(NO, (_isTopCell ? _data.tstockid : _item.tstockid), _cell);
  }
  [self setNil];
}

#pragma mark 删除聊股
- (void)requestDropTStockData {
  if (![SimuUtil isExistNetwork] || (!_item && !_data)) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak WeiBoExtendButtons *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    WeiBoExtendButtons *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    WeiBoExtendButtons *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindDropTStockData:(DropTStockData *)obj];
    }
  };
  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };

  callback.onError = ^(BaseRequestObject *obj, NSException *exc) {
    [BaseRequester defaultErrorHandler](obj, exc);
  };

  [DropTStockData requestDropTStockDataWithBarId:(_isTopCell ? _data.barId : _item.barId)
                                     withTweetId:(_isTopCell ? _data.tstockid : _item.tstockid)
                                    withCallback:callback];
}

/** 删除聊股成功信息提示（聊股主页） */
- (void)bindDropTStockData:(DropTStockData *)obj {
  if ((!_item && !_data)) {
    return;
  }
  [NewShowLabel setMessageContent:@"删除成功"];
  if (_extendDeleteButtonClickBlock) {
    _extendDeleteButtonClickBlock((_isTopCell ? _data.tstockid : _item.tstockid), _cell);
  }
  [self setNil];
}

#pragma mark 获取收藏状态
- (void)getCollectStatus {
  if (_isTopCell ? _data.isCollected : _item.isCollected) {
    //取消收藏
    [self requestCollectTStockDataWithAct:-1];
  } else {
    //收藏
    [self requestCollectTStockDataWithAct:1];
  }
}

#pragma mark 收藏股聊
- (void)requestCollectTStockDataWithAct:(NSInteger)act {
  if (![SimuUtil isExistNetwork] || (!_item && !_data)) {
    [self setNoNetwork];
    [self stopLoading];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak WeiBoExtendButtons *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    WeiBoExtendButtons *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    WeiBoExtendButtons *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindCollectTStockData:(CollectTStockData *)obj act:act];
    }
  };
  callback.onFailed = ^{
    [weakSelf setNoNetwork];
  };

  callback.onError = ^(BaseRequestObject *obj, NSException *exc) {
    [NewShowLabel setMessageContent:obj.message];
    if ([obj.status isEqualToString:@"0602"]) {
      //已经被收藏，直接写入本地数据库
      [WBCoreDataUtil insertCollectTid:(_isTopCell ? _data.tstockid : _item.tstockid)];
    } else {
      [BaseRequester defaultErrorHandler](obj, exc);
    }
  };

  [CollectTStockData requestCollectTStockDataWithTStockId:(_isTopCell ? _data.tstockid : _item.tstockid)
                                                  withAct:act
                                             withCallback:callback];
}

- (void)bindCollectTStockData:(CollectTStockData *)obj act:(NSInteger)act {
  if ((!_item || !_data)) {
    return;
  }
  NSDictionary *userInfo = @{ @"data" : _isTopCell ? _data : _item, @"operation" : @(act) };
  //广播收藏成功，收藏数加1
  [[NSNotificationCenter defaultCenter] postNotificationName:CollectWeiboSuccessNotification
                                                      object:self
                                                    userInfo:userInfo];

  //根据动作，写入或删除
  if (act == 1) {
    [NewShowLabel setMessageContent:@"添加收藏成功"];
    //本地数据绑定
    _isTopCell ? (_data.isCollected = YES) : (_item.isCollected = YES);
    //写入数据库
    [WBCoreDataUtil insertCollectTid:(_isTopCell ? _data.tstockid : _item.tstockid)];
  } else {
    [NewShowLabel setMessageContent:@"取消收藏成功"];
    //本地数据绑定
    _isTopCell ? (_data.isCollected = NO) : (_item.isCollected = NO);
    //数据库删除
    [WBCoreDataUtil deleteCollectTid:(_isTopCell ? _data.tstockid : _item.tstockid)];
    if (_extendCancleCollectButtonClickBlock) {
      _extendCancleCollectButtonClickBlock((_isTopCell ? _data.tstockid : _item.tstockid), _cell);
    }
  }
  [self setNil];
}

#pragma mark - 置nil
- (void)setNil {
  //参数置nil，安全保险起见
  _item = nil;
  _data = nil;
  _cell = nil;
  _isBarHost = NO;
  _isAdmin = NO;
  _isTopCell = NO;
}

#pragma mark - 触摸回调
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self hideAndScaleSmall];
}

#pragma mark - 放大展现动画
- (void)showAndScaleLarge {
  wbButtons.hidden = NO;
  wbButtons.transform = CGAffineTransformMakeScale(0.9, 0.9);
  [UIView animateWithDuration:0.1
      delay:0
      options:UIViewAnimationOptionCurveEaseIn
      animations:^{
        wbButtons.transform = CGAffineTransformMakeScale(1, 1);
        wbButtons.alpha = 1;
      }
      completion:^(BOOL finished){
      }];
}

#pragma mark - 缩小消失动画
- (void)hideAndScaleSmall {

  wbButtons.transform = CGAffineTransformMakeScale(1, 1);
  [UIView animateWithDuration:0.1
      delay:0
      options:UIViewAnimationOptionCurveEaseIn
      animations:^{
        wbButtons.transform = CGAffineTransformMakeScale(0.9, 0.9);
        wbButtons.alpha = 0;
      }
      completion:^(BOOL finished) {
        wbButtons.hidden = YES;
      }];
}

@end

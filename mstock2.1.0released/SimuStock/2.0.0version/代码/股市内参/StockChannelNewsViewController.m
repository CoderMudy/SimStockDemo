//
//  StockChannelNewsViewController.m
//  SimuStock
//
//  Created by Mac on 15/5/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "StockChannelNewsViewController.h"
#import "OrderViewController.h"
@implementation StockChannelNewsViewController

/** 单击导航栏“说明”按钮响应函数 */
- (void)clickOnInstructionBtn:(UIButton *)clickedBtn {
  NewsChannelItem *item = [myChannelList.channels objectAtIndex:pageIndex];
  NSString *selectedChangel = item.channleID;
  OrderViewController *orderVC = [[OrderViewController alloc] init];
  __weak StockChannelNewsViewController *weakSelf = self;
  orderVC.block = ^() {
    StockChannelNewsViewController *strongSelf = weakSelf;
    if (strongSelf) {
      NewsChannelList *mylist = [FileStoreUtil loadMyNewsChannelList];
      if (mylist.channels.count > 0) {
        [myChannelList.channels removeAllObjects];
        [myChannelList.channels addObjectsFromArray:mylist.channels];
      }
      ///选择当前频道
      [self getChangleID:selectedChangel];
      [self createMainView];
    }
  };
  [AppDelegate pushViewControllerFromRight:orderVC];
  return;
}

///判断当前选择的频道
- (NSInteger)getChangleID:(NSString *)changleid {
  pageIndex = 0;
  [myChannelList.channels enumerateObjectsUsingBlock:^(NewsChannelItem *obj, NSUInteger idx, BOOL *stop) {

    if ([obj.channleID isEqualToString:changleid]) {
      pageIndex = (int)idx;

      *stop = YES;
    }

  }];
  return pageIndex;
}

#pragma mark ——— 子控件懒加载 ———
/** 懒加载顶部右侧“说明”按钮 */
- (UIButton *)instructionBtn {
  if (_instructionBtn == nil) {
    _instructionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  }
  return _instructionBtn;
}
/** 设置顶部右侧“说明”按钮 */
- (void)setupInstructionBtn {
  self.instructionBtn.frame =
      CGRectMake(CGRectGetMinX(_indicatorView.frame) - 10, CGRectGetMinY(_indicatorView.frame), 45,
                 CGRectGetHeight(_indicatorView.bounds));
  [self.instructionBtn setTitle:@"栏目" forState:UIControlStateNormal];
  self.instructionBtn.titleLabel.font = [UIFont systemFontOfSize:Font_Height_16_0];
  [self.instructionBtn setTitleColor:[Globle colorFromHexRGB:@"4dfdff"]
                            forState:UIControlStateNormal];
  [self.instructionBtn setBackgroundImage:[UIImage imageNamed:@"return_touch_down.png"]
                                 forState:UIControlStateHighlighted];
  [self.instructionBtn addTarget:self
                          action:@selector(clickOnInstructionBtn:)
                forControlEvents:UIControlEventTouchUpInside];
  [self.topToolBar addSubview:self.instructionBtn];
}

//点击标签回调
- (void)changeToIndex:(NSInteger)index {
  if (index > 0) {
  } else
    index = 0;
  CGFloat screenWidth = self.view.bounds.size.width;
  [_scrollView setContentOffset:CGPointMake(screenWidth * index, 0) animated:YES];

  NewsChannelItem *channel = myChannelList.channels[index];
  StockNewsListTableViewController *vc = channelVCs[channel.channleID];
  if (!vc.dataBinded) {
    [vc refreshButtonPressDown];
  }

  pageIndex = index;
  selectedChannel = channel;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [Globle colorFromHexRGB:@"ffffff"];
  [_topToolBar resetContentAndFlage:@"股市内参" Mode:TTBM_Mode_Leveltwo];
  _indicatorView.hidden = YES;
  ///导航条右上角，频道选择
  [self setupInstructionBtn];

  channelVCs = [[NSMutableDictionary alloc] init];

  myChannelList = [[NewsChannelList alloc] init];
  myChannelList.channels = [[NSMutableArray alloc] init];
  moreChannelList = [[NewsChannelList alloc] init];
  moreChannelList.channels = [[NSMutableArray alloc] init];

  NewsChannelList *mylist = [FileStoreUtil loadMyNewsChannelList];
  if (mylist.channels.count > 0) {
    [myChannelList.channels addObjectsFromArray:mylist.channels];
  } else {
    NSString *path =
        [[NSBundle mainBundle] pathForResource:@"OrderViewController.plist" ofType:nil];
    NSMutableArray *mylist = [NSMutableArray arrayWithContentsOfFile:path];
    for (int i = 0; i < mylist.count; i++) {
      NSDictionary *dic = [mylist objectAtIndex:i];
      NSString *changId = [dic objectForKey:@"ChangID"];
      NSString *Name = [dic objectForKey:@"Name"];
      NewsChannelItem *item = [[NewsChannelItem alloc] init];
      item.channleID = changId;
      item.name = Name;
      if (i == 0) {
        item.isEditable = NO;
        item.isVisible = NO;
      } else {
        item.isEditable = YES;
        item.isVisible = YES;
      }
      [myChannelList.channels addObject:item];
    }
    [FileStoreUtil saveMyNewsChannelList:myChannelList];
  }
  /// ui布局
  pageIndex = 0;
  [self createMainView];
  ///重新更新频道信息
  [self requestChannelList];
}

//创建滚动视图
- (void)createScrollView {
  CGFloat width = self.view.bounds.size.width;
  CGFloat height = CGRectGetHeight(self.clientView.bounds) - 35.0f;

  if (!_scrollView) {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 35.0f, width, height)];
    _scrollView.contentSize = CGSizeMake(width * myChannelList.channels.count, height);
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.bounces = NO;
    _scrollView.backgroundColor = [UIColor clearColor];
    [self.clientView addSubview:_scrollView];
  } else {
    [_scrollView removeAllSubviews];
    _scrollView.contentOffset = CGPointMake(0, 0);
    _scrollView.contentSize = CGSizeMake(0, height);
  }
}

//设置标示线 在滚动是代理方法里
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (scrollView == _scrollView) {
    ///偏移量
    CGFloat tool_left = scrollView.contentOffset.x / _scrollView.width * topToolbarView.maxlineView.width;
    topToolbarView.maxlineView.left = tool_left;
  }
}

#pragma mark scrollView代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  CGPoint offset = scrollView.contentOffset;
  if (offsetX.x != offset.x && scrollView == _scrollView && offset.x >= 0 &&
      offset.x <= _scrollView.width * (myChannelList.channels.count - 1)) {
    NSInteger index = offset.x / _scrollView.width;
    [topToolbarView changTapToIndex:index];
    pageIndex = index;
    [self refreshButtonPressDown];
    offsetX = offset;
  }
}
#pragma mark
#pragma mark------------------界面---------------

- (void)createMainView {
  [self createScrollView];

  if (!topToolbarView) {
    topToolbarView =
        [[TopToolBarUIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 35)
                                            DataArray:myChannelList.channels
                                  withInitButtonIndex:0];
    topToolbarView.Tooldelegate = self;
    [self.clientView addSubview:topToolbarView];
  } else {
    topToolbarView.ttlv_corSelIndex = pageIndex;
    [topToolbarView removeAllSubviews];
    [topToolbarView creatCtrlor:myChannelList.channels];
  }

  [self updateViewControllers];
}

/** 更新当前页面，例如：当用户编辑要现实的栏目时，可以调用此方法
 * 1. 从父VC中移除；
 * 2. 重用或新建子vc，添加至父vc中；
 * 3. 重置当前选中的栏目，如果仍然存在，显示此栏目，否则显示第一个栏目
 */
- (void)updateViewControllers {
  CGFloat width = self.view.size.width;
  //  __block NSInteger newSelectIndex = 0;
  NSMutableDictionary *oldChannelVCs = [channelVCs mutableCopy];
  [channelVCs removeAllObjects];
  [_scrollView removeAllSubviews];
  [myChannelList.channels enumerateObjectsUsingBlock:^(NewsChannelItem *obj, NSUInteger idx, BOOL *stop) {
    //数据
    CGRect frame = CGRectMake(width * idx, 0, width, CGRectGetHeight(_scrollView.bounds));

    StockNewsListTableViewController *vc = oldChannelVCs[obj.channleID];
    if (vc == nil) {
      vc = [[StockNewsListTableViewController alloc] initWithFrame:frame
                                                     withChannelID:obj.channleID
                                                   withChannelName:obj.name];

      __weak StockChannelNewsViewController *weakSelf = self;
      vc.beginRefreshCallBack = ^{
        [weakSelf.indicatorView startAnimating];
      };

      vc.endRefreshCallBack = ^{
        [weakSelf.indicatorView stopAnimating];
      };
    } else {
      vc.view.frame = frame;
    }
    channelVCs[obj.channleID] = vc;
    [_scrollView addSubview:vc.view];

  }];
  _scrollView.contentSize = CGSizeMake(width * channelVCs.count, _scrollView.height);
  _scrollView.contentOffset = CGPointMake(width * pageIndex, 0);
  //  pageIndex =newSelectIndex;
  //切换至新选中的栏目
  [self changeToIndex:pageIndex];
}

#pragma mark-----------------------end-----------------------

- (void)refreshButtonPressDown {
  NewsChannelItem *channel = myChannelList.channels[pageIndex];
  StockNewsListTableViewController *vc = channelVCs[channel.channleID];
  [vc refreshButtonPressDown];
}

- (void)requestChannelList {
  [_indicatorView startAnimating];

  __weak StockChannelNewsViewController *weakSelf = self;
  CleanAction cleanAction = ^{
    [weakSelf.indicatorView stopAnimating];
  };
  HttpRequestCallBack *callback =
      [HttpRequestCallBack initWithOwner:self cleanCallback:cleanAction];
  callback.onSuccess = ^(NSObject *obj) {
    cleanAction();
    NewsChannelList *allChannels = (NewsChannelList *)obj;
    [weakSelf bindChannels:allChannels];
  };
  [NewsChannelList requestChannelListWithCallBack:callback];
}

- (void)bindChannels:(NewsChannelList *)allChannels {
  NSMutableSet *queryArray = [[NSMutableSet alloc] init];
  if (myChannelList.channels.count > 0) {
    [moreChannelList.channels removeAllObjects];
    [allChannels.channels enumerateObjectsUsingBlock:^(NewsChannelItem *obj, NSUInteger idx, BOOL *stop) {
      [queryArray addObject:obj.channleID];
    }];
    for (NSInteger i = myChannelList.channels.count - 1; i >= 0; i--) {
      NewsChannelItem *obj = myChannelList.channels[i];
      if ([queryArray containsObject:obj.channleID]) {
        // do nothing
      } else {
        [moreChannelList.channels addObject:obj];
        [myChannelList.channels removeObjectAtIndex:i];
      }
    }
    [allChannels.channels enumerateObjectsUsingBlock:^(NewsChannelItem *obj, NSUInteger idx, BOOL *stop) {
      NSInteger index = [self indexOfNewsChannelItem:obj];
      if (index == -1) {
        [moreChannelList.channels addObject:obj];
      }
    }];
  } else {
    [allChannels.channels enumerateObjectsUsingBlock:^(NewsChannelItem *obj, NSUInteger idx, BOOL *stop) {
      ///如何原先 自选没有的话，默认前四个为默认选中的
      if (idx < 4) {
        if (idx == 0) {
          obj.isEditable = false;
        }
        [myChannelList.channels addObject:obj];
      } else {
        [moreChannelList.channels addObject:obj];
      }
    }];
  }

  [FileStoreUtil saveMyNewsChannelList:myChannelList];
  [FileStoreUtil saveMoreNewsChannelList:moreChannelList];
  [self createMainView];
}

///判断是否my选中的频道，是否包含
- (NSInteger)indexOfNewsChannelItem:(NewsChannelItem *)item {
  if (myChannelList.channels.count > 0) {
    for (NSInteger i = 0; i < myChannelList.channels.count; i++) {
      NewsChannelItem *obj = myChannelList.channels[i];
      if ([item.channleID isEqualToString:obj.channleID]) {
        return i;
      }
    }
  }
  return -1;
}
@end

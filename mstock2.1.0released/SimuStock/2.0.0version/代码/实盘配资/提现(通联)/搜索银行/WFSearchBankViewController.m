//
//  WFSearchBankViewController.m
//  SimuStock
//
//  Created by moulin wang on 15/4/12.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WFSearchBankViewController.h"
#import "NetLoadingWaitView.h"
#import "ConditionsWithKeyBoardUsing.h"
#import "BaseRequester.h"
#import "WFBankInfoData.h"
#import "BankInforCell.h"

@interface WFSearchBankViewController () {
  NSMutableArray *_sideBarArray;
  //测栏
  UIView *_sideBarView;
  //数据源 里面存放银行数据
  WFBankData *_bankData;

  //记录tableView头里的内容
  NSArray *headArrayKeys;
}
@end

@implementation WFSearchBankViewController

- (void)bankWithCallback:(OnCellSelected)callback {
  onContactsSelechedBankCallback = callback;
}

- (id)init {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self getBankInfoData];
  //无数据小牛
  [_littleCattleView setInformation:@"未找到相关银行"];
  currentSection = -1;
  _sideBarArray = [NSMutableArray array];
  //创建查询相关控件
  [self creatSearchViewOfBank];
  //创建tableview
  [self creatTabelViewBank];
  //创建中间显示字母
  [self createBigChar];
  //创建侧栏
  [self createSideBarView];
}
//创建侧栏
- (void)createSideBarView {
  //侧栏的frame
  _sideBarView = [[UIView alloc]
      initWithFrame:CGRectMake(self.clientView.bounds.size.width - 23, 0, 23,
                               CGRectGetHeight(self.clientView.bounds))];
  _sideBarView.backgroundColor = [UIColor whiteColor];
  _sideBarView.alpha = 0.5f;
  [self.clientView addSubview:_sideBarView];
  [self createSideBarWithTiltarray:ALPHA_ARRAY];
}

//根据key值创建测栏
- (void)createSideBarWithTiltarray:(NSArray *)titleArray {
  //根据数组 创建sideBarView里的btn
  //新的需求 固定26个索引
  if (titleArray.count != 0) {
    CGFloat boundsHeight = CGRectGetHeight(_sideBarView.bounds) / 26.0f;
    [self creatButtonWithTitleArray:titleArray
                         withHeight:0
                   withBoundsHeight:boundsHeight];
  } else {
    _sideBarView.hidden = YES;
  }
}
//根据keys值的多少 来创建button
- (void)creatButtonWithTitleArray:(NSArray *)titlearray
                       withHeight:(CGFloat)height
                 withBoundsHeight:(CGFloat)BoundsHeight {
  if (_sideBarArray.count != 0) {
    [_sideBarArray removeAllObjects];
  }
  if (_sideBarView.subviews.count != 0) {
    [_sideBarView removeAllSubviews];
  }
  UIView *lineView = [[UIView alloc]
      initWithFrame:CGRectMake(0, 0, 0.5,
                               CGRectGetHeight(_sideBarView.bounds))];
  lineView.backgroundColor = [Globle colorFromHexRGB:@"bdbdbd"];
  [_sideBarView addSubview:lineView];
  for (int index = 0; index < titlearray.count; index++) {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =
        CGRectMake(0, height + index * BoundsHeight,
                   CGRectGetWidth(_sideBarView.bounds) - 1.0f, BoundsHeight);
    NSString *title = titlearray[index];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[Globle colorFromHexRGB:@"086dae"]
              forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor clearColor];
    btn.tag = index;
    btn.selected = YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:Font_Height_10_0];
    [btn addTarget:self
                  action:@selector(sideBarButtonAction:)
        forControlEvents:UIControlEventTouchUpInside];
    dispatch_async(dispatch_get_main_queue(), ^{
      [_sideBarView addSubview:btn];
      [_sideBarArray addObject:btn];
    });
  }
}
//按钮点击事件
- (void)sideBarButtonAction:(UIButton *)sideBarButton {
  for (int i = 0; i < _sideBarArray.count; i++) {
    UIButton *btn = _sideBarArray[i];
    if (btn.selected == NO || btn.selected == YES) {
      btn.selected = YES;
      [btn setTitleColor:[Globle colorFromHexRGB:@"086dae"]
                forState:UIControlStateNormal];
    }
  }
  if (sideBarButton.selected == YES) {
    [sideBarButton setSelected:NO];
    [sideBarButton setTitleColor:[Globle colorFromHexRGB:@"30f0ff"]
                        forState:UIControlStateNormal];
  } else {
    [sideBarButton setSelected:YES];
    [sideBarButton setTitleColor:[Globle colorFromHexRGB:@"086dae"]
                        forState:UIControlStateNormal];
  }
  searchButton.userInteractionEnabled = YES;
  [searchButton setImage:[UIImage imageNamed:@"搜索"]
                forState:UIControlStateNormal];
  //判断被点击的按钮 在不在银行数组里
  for (int i = 0; i < headArrayKeys.count; i++) {
    if ([sideBarButton.titleLabel.text isEqualToString:headArrayKeys[i]]) {
      //手动滚动指定位置
      NSIndexPath *selectIndexPath =
          [NSIndexPath indexPathForRow:0 inSection:i];
      [bankInfoTabelView scrollToRowAtIndexPath:selectIndexPath
                               atScrollPosition:UITableViewScrollPositionTop
                                       animated:YES];
    }
  }
  charLable.hidden = NO;
  charLable.text = sideBarButton.titleLabel.text;
  // 2秒后消失
  [self performBlock:^{
    charLable.hidden = YES;
  } withDelaySeconds:1.0f];

  [self performBlock:^{
    [sideBarButton setTitleColor:[Globle colorFromHexRGB:@"086dae"]
                        forState:UIControlStateNormal];
    sideBarButton.selected = YES;
  } withDelaySeconds:5.0f];
}

#pragma mark - 获取将要消失的header
- (void)tableView:(UITableView *)tableView
    didEndDisplayingHeaderView:(UIView *)view
                    forSection:(NSInteger)section {
  //返回当前所有可见的 NSIndexPath
  NSArray *cellArray = [tableView indexPathsForVisibleRows];
  if (cellArray.count != 0 && cellArray) {
    NSIndexPath *ind = cellArray[0];
    NSString *string = headArrayKeys[ind.section];
    [self buttonSeletedHighlightStat:string];
  }
}

//改变button的状态
- (void)buttonSeletedHighlightStat:(NSString *)titleLetter {

  for (int i = 0; i < _sideBarArray.count; i++) {
    UIButton *btn = _sideBarArray[i];
    NSString *string = btn.titleLabel.text;
    if ([titleLetter isEqualToString:string]) {
      //相同 让其高亮
      if (btn.selected == NO) {
        btn.selected = YES;
        [btn setTitleColor:[Globle colorFromHexRGB:@"30f0ff"]
                  forState:UIControlStateNormal];
      }
    } else {
      //其他按钮 默认状态
      btn.selected = NO;
      [btn setTitleColor:[Globle colorFromHexRGB:@"086dae"]
                forState:UIControlStateNormal];
    }
  }
}

/**
 * 创建查询相关控件
 */
- (void)creatSearchViewOfBank {
  //导航条 上添加
  //搜索输入框
  UIView *backView = [[UIView alloc]
      initWithFrame:CGRectMake(CGRectGetMaxX(_topToolBar.backButton.frame),
                               _topToolBar.frame.size.height - 44 + 4,
                               CGRectGetWidth(_topToolBar.bounds) -
                                   CGRectGetMaxX(_topToolBar.backButton.frame) -
                                   CGRectGetWidth(_indicatorView.bounds),
                               44 - 8)];
  backView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  [_topToolBar addSubview:backView];
  //搜索框textField（先扩大点击范围）
  UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
  leftButton.frame = CGRectMake(0, 0, backView.frame.size.width - 34,
                                backView.frame.size.height);
  [leftButton addTarget:self
                 action:@selector(inputTextFieldBecomeRespond)
       forControlEvents:UIControlEventTouchUpInside];
  [backView addSubview:leftButton];
  //输入框 textFiled
  inputConteactBankTF = [[ExtendedTextField alloc]
      initWithFrame:CGRectMake(10, 8, backView.frame.size.width - 20 - 20, 20)];
  //预留字
  inputConteactBankTF.placeholder = @"搜银行";
  inputConteactBankTF.font = [UIFont systemFontOfSize:Font_Height_15_0];
  inputConteactBankTF.textAlignment = NSTextAlignmentLeft;
  inputConteactBankTF.delegate = self;
  //现在输入长度
  [inputConteactBankTF setMaxLength:12];
  //收键盘的模式
  inputConteactBankTF.returnKeyType = UIReturnKeySearch;

  //添加事件
  [inputConteactBankTF addTarget:self
                          action:@selector(textFieldChange:)
                forControlEvents:UIControlEventEditingChanged];

  [backView addSubview:inputConteactBankTF];

  //搜索按钮
  searchButton = [[UIButton alloc]
      initWithFrame:CGRectMake(backView.frame.size.width - 34, 0, 34,
                               backView.frame.size.height)];
  [searchButton setBackgroundImage:[UIImage imageNamed:@"搜索记录背景"]
                          forState:UIControlStateNormal];
  [searchButton setImage:[UIImage imageNamed:@"搜索_不可点击状态"]
                forState:UIControlStateNormal];
  searchButton.userInteractionEnabled = NO;
  [searchButton addTarget:self
                   action:@selector(searchContact:)
         forControlEvents:UIControlEventTouchUpInside];
  [backView addSubview:searchButton];
  // zxc蓝色分割线
  UIView *lineView = [[UIView alloc]
      initWithFrame:CGRectMake(backView.frame.size.width - 34.5, 6, 0.5,
                               backView.frame.size.height - 12)];
  lineView.backgroundColor = [Globle colorFromHexRGB:@"086dae"];
  [backView addSubview:lineView];
}
// UIButton - leftButton点击事件
- (void)inputTextFieldBecomeRespond {
  [inputConteactBankTF becomeFirstResponder];
}

#pragma mark-- 刷新按钮
- (void)refreshButtonPressDown {
  [_indicatorView startAnimating];
  //无网
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    if (!bankInfoArray.dataBinded) {
      [_indicatorView stopAnimating];
      return;
    } else {
      [_indicatorView stopAnimating];
    }
  } else {
    //有网  无数据绑定
    if (!bankInfoArray.dataBinded) {
      [self getBankInfoData];
    } else {
      [_indicatorView stopAnimating];
    }
  }
  return;
  if (inputConteactBankTF.text.length <= 0) {
    [self getBankInfoData];
  } else {
    //如果有内容 判断网络
    if (![SimuUtil isExistNetwork]) {
      [self notWork];
    }
  }
}

//搜索 点击搜索按钮进行搜索
- (void)searchContact:(UIButton *)button {
  //键盘收回
  [inputConteactBankTF resignFirstResponder];
  //调用搜索方法
  [self searchTheContentOfTheInputBox:inputConteactBankTF.text];
}

#pragma mark - 根据输入框的内容进行搜索
- (void)searchTheContentOfTheInputBox:(NSString *)text {
  //获取输入框里的内容 将输入内容转回成拼音
  NSString *searchContent = [self nameToPinYinWithName:text];
  //去除空格
  searchContent =
      [searchContent stringByReplacingOccurrencesOfString:@" " withString:@""];
  //判断 如果等于空
  if (searchContent == nil || searchContent.length <= 0) {
    [NewShowLabel setMessageContent:@"请输入搜索内容"];
    [_indicatorView stopAnimating];
    [bankInfoTabelView reloadData];
    return;
  }
  _sideBarView.hidden = YES;
  //点击先判断 有没有数据
  if (bankInfoArray.dataBinded) {
    //判断内容长度
    if (searchContent.length == 1) {
      //一个字符的搜索方法
      [self textFiledWithOneCharForSearch:searchContent];
    } else {
      //多个字符的搜索方法
      [self searchTextWith:searchContent];
    }
  } else {
    //如果没有数据 请求网络
    [self getBankInfoData];
  }
}

/** 创建tableview */
- (void)creatTabelViewBank {
  bankInfoTabelView =
      [[UITableView alloc] initWithFrame:self.clientView.bounds];
  bankInfoTabelView.dataSource = self;
  bankInfoTabelView.delegate = self;
  bankInfoTabelView.backgroundColor = [UIColor clearColor];
  bankInfoTabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self.clientView addSubview:bankInfoTabelView];
  //每个区的头高度 20
  //[bankInfoTabelView setSectionHeaderHeight:14.5];
  bankInfoTabelView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
/** 创建中间显示字母 */
- (void)createBigChar {
  charLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 49.0f, 49.0f)];
  charLable.center = CGPointMake(self.clientView.frame.size.width * 0.5,
                                 self.clientView.frame.size.height * 0.5);
  charLable.backgroundColor = [Globle colorFromHexRGB:@"0a7ac2"];
  charLable.textAlignment = NSTextAlignmentCenter;
  charLable.font = [UIFont systemFontOfSize:25.0f];
  charLable.textColor = [UIColor whiteColor];
  charLable.layer.masksToBounds = YES;
  charLable.layer.cornerRadius = 5.0f;
  charLable.hidden = YES;
  [self.clientView addSubview:charLable];
}
////正在输入时
- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
  if ([string isEqualToString:@"\n"]) {
    return YES;
  }
  NSString *toBeString =
      [textField.text stringByReplacingCharactersInRange:range
                                              withString:string];
  if ([string length] == 0 && [toBeString length] == 0) {
    //无网 无数据
    if (![SimuUtil isExistNetwork] && !bankInfoArray.dataBinded) {
      [self noWorkNoData];
      return YES;
    }
    //无网 有数据
    if (bankInfoArray.dataBinded && ![SimuUtil isExistNetwork]) {
      [self noWorkButDataBind];
      return YES;
    }
    //有网 无数据
    if (!bankInfoArray.dataBinded) {
      [self getBankInfoData];
      return YES;
    }
    //有网有数据
    [self noWorkButDataBind];
    return YES;
  } else {
    //长度 不为零
    if (![SimuUtil isExistNetwork]) {
      if (!bankInfoArray.dataBinded) {
        _sideBarView.hidden = YES;
      }
    }
  }
  return YES;
}

- (void)textFieldChange:(ExtendedTextField *)textField {
  if (textField.text.length > 0) {
    searchButton.userInteractionEnabled = YES;
    [searchButton setImage:[UIImage imageNamed:@"搜索"]
                  forState:UIControlStateNormal];
  } else {
    searchButton.userInteractionEnabled = NO;
    [searchButton setImage:[UIImage imageNamed:@"搜索_不可点击状态"]
                  forState:UIControlStateNormal];
  }
}

///无网无数据
- (void)noWorkNoData {
  //显示哭泣的小牛
  [_littleCattleView isCry:YES];
  bankInfoTabelView.hidden = YES;
  _sideBarView.hidden = YES;
}

///有网无数据
- (void)noWorkButDataBind {
  _littleCattleView.hidden = YES;
  bankInfoTabelView.hidden = NO;
  _sideBarView.hidden = NO;
  [self reloadOrTableView];
}

//滚动时 键盘消失
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  [inputConteactBankTF resignFirstResponder];
}

/** 获取数据  */
- (void)getBankInfoData {
  //菊花转动
  [_indicatorView startAnimating];
  if (![SimuUtil isExistNetwork]) {
    //没有网络的情况
    [self notWork];
    return;
  }
  _littleCattleView.hidden = YES;
  //发送网络请求
  __weak WFSearchBankViewController *weakSelf = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^() {
    WFSearchBankViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf.indicatorView stopAnimating];
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    _bankData = (WFBankData *)obj;
    //转化数据 对数据进行分组
    [self processingBankDataWithArray:(WFBankData *)obj];
  };
  callback.onFailed = ^() {
    if (bankInfoArray.dataBinded) {
      //绑定数据
      _littleCattleView.hidden = YES;
    } else {
      [_littleCattleView isCry:NO];
    }
  };
  callback.onError = ^(BaseRequestObject *obj, NSException *exc) {
    if (bankInfoArray.dataBinded) {
      _littleCattleView.hidden = YES;
    }
    if (obj.status) {
      [NewShowLabel setMessageContent:obj.message];
    } else {
      [BaseRequester defaultErrorHandler](obj, exc);
    }
  };
  //请求数据
  [WFBankInfoData requestBankInfoWithCallbackWithType:@"1"
                                         withCallback:callback];
}

//没有网络的情况下
- (void)notWork {
  //提示网络不给力
  dispatch_async(dispatch_get_main_queue(), ^{
    [_indicatorView stopAnimating];
    [NewShowLabel showNoNetworkTip];
    //判断有没有数据绑定
    if (bankInfoArray.dataBinded) {
      _littleCattleView.hidden = YES;
    } else {
      //无网络小牛
      [_littleCattleView isCry:YES];
      _sideBarView.hidden = YES;
    }
  });
}

//数据周转中心
- (void)processingBankDataWithArray:(WFBankData *)bankArray {
  bankInfoArray = [[DataArray alloc] init];
  for (WFBankData *BF in bankArray.dataArray.array) {
    //得到银行名称
    [bankInfoArray.array addObject:BF.bankName];
  }
  //所有银行名称的字典
  bankNameDict = [[NSMutableDictionary alloc] init];
  //转化成拼音的字典
  pinyinDict = [[NSMutableDictionary alloc] init];
  //过滤后的符合条件的和剩下的银行
  filterDict = [[NSMutableDictionary alloc] init];
  //是否过滤
  isFilter = YES;
  if (bankInfoArray.array.count <= 0) {
    //没有数据 显示小牛
    bankInfoArray.dataBinded = YES;
    _littleCattleView.hidden = NO;
    bankInfoTabelView.hidden = YES;
    _sideBarView.hidden = YES;
  } else {
    _littleCattleView.hidden = YES;
    //用来判断 数据有没有绑定过
    bankInfoArray.dataBinded = YES;
    bankInfoTabelView.hidden = NO;
    _sideBarView.hidden = NO;
    //将数组里的汉子 转化成拼音 存放到字典里
    [self createPinYinDictWithBankArray:bankInfoArray.array
                         withMutablDict:bankNameDict];
  }
}

#pragma mark - 搜索协议函数 + 汉子转化成拼音
- (void)createPinYinDictWithBankArray:(NSArray *)bankArray
                       withMutablDict:(NSMutableDictionary *)mutableDic {
  for (NSString *string in ALPHA_ARRAY) {
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    BOOL realExist = NO;
    for (NSString *nameBank in bankArray) {
      //汉子转化成拼音
      NSString *pinyinNic = [self nameToPinYinWithName:nameBank];
      //把拼音转化成大小
      pinyinNic = [pinyinNic uppercaseString];
      //判断第一个字符 等于 那个
      if ([pinyinNic hasPrefix:string]) {
        //本地保存转换内容
        //汉字转化成拼音 + key值 汉字
        [pinyinDict setObject:pinyinNic forKey:nameBank];
        // pinyinDict = @{@"中国银行":@"zhongguoyinhang"};
        // pinyinDict[nameBank] = pinyinNic;
        //添加到数组里
        [temp addObject:nameBank];
        realExist = YES;
      }
    }
    //分类保存 用字典来保存
    if (realExist) {
      [mutableDic setObject:temp forKey:string];
    }
  }
  //循环玩 得到所有的 keys值  即tableview头里的内容 用数组保存起来
  headArrayKeys = mutableDic.allKeys;
  if (headArrayKeys.count != 0) {
    headArrayKeys = [headArrayKeys
        sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
  }
  [self reloadTableview];
}

//刷新数据
- (void)reloadTableview {
  if ([NetLoadingWaitView isAnimating]) {
    [NetLoadingWaitView stopAnimating];
  }
  //刷新tableview
  [bankInfoTabelView reloadData];
}

/** 汉字转化成拼音 */
- (NSString *)nameToPinYinWithName:(NSString *)name {
  //只有字母和数字的情况
  if ([[ConditionsWithKeyBoardUsing shareInstance] isNumbersOrLetters:name]) {
    return [name uppercaseString];
  }

  //已经转换过了
  if ([pinyinDict objectForKey:name]) {
    return [pinyinDict objectForKey:name];
  }
  if (outPutFormat == nil) {
    outPutFormat = [[HanyuPinyinOutputFormat alloc] init];
    [outPutFormat setToneType:ToneTypeWithoutTone];
    [outPutFormat setVCharType:VCharTypeWithV];
    [outPutFormat setCaseType:CaseTypeLowercase];
  }
  NSString *outPutPinYin =
      [PinyinHelper toHanyuPinyinStringWithNSString:name
                        withHanyuPinyinOutputFormat:outPutFormat
                                       withNSString:@""];
  return outPutPinYin;
}

/** 键盘收回时搜索 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if (textField == inputConteactBankTF) {
    [textField resignFirstResponder];
    [self searchTheContentOfTheInputBox:textField.text];
    return YES;
  }
  return YES;
}

//单个字符 进行的搜索方法
- (void)textFiledWithOneCharForSearch:(NSString *)oneChar {
  //单字符搜索
  oneChar = [oneChar uppercaseString];
  NSArray *nameBank = bankNameDict[oneChar];
  isFilter = NO;
  [self addDataWithSouces:nameBank withMutableDic:filterDict];
}

/** 对输入框里的内容进行搜索 */
- (void)searchTextWith:(NSString *)textfiledString {
  if ([textfiledString length] < 1) {
    [self reloadOrTableView];
    return;
  } else {
    isFilter = NO;
  }

  if (![SimuUtil isExistNetwork]) {
    if (!bankInfoArray.dataBinded) {
      return;
    }
  } else {
    if (!bankInfoArray.dataBinded) {
      [self getBankInfoData];
    }
  }

  [self crateFilterDictWithSearchTextName:textfiledString];
}

/** 根据输入框里的内容 搜索到的结果 */
- (void)crateFilterDictWithSearchTextName:(NSString *)textSearchString {
  //试试在主线程里执行
  NSMutableArray *array = [[NSMutableArray alloc] init];
  //外部组循环（字母）
  for (int index = 0; index < [bankNameDict.allKeys count]; index++) {
    NSArray *temp =
        [bankNameDict objectForKey:[bankNameDict.allKeys objectAtIndex:index]];
    //内部各个用户循环
    for (NSString *stringBank in temp) {
      //汉字转化成拼音
      NSString *pinyin1 = [pinyinDict objectForKey:stringBank];
      //所用到的搜索功能
      if ([self searchResult:pinyin1 searchText:textSearchString] == YES) {
        [array addObject:stringBank];
      }
    }
  }
  [self addDataWithSouces:array withMutableDic:filterDict];
}

/** 判断字符串是否包含某个字符串 */
- (BOOL)searchResult:(NSString *)contachName searchText:(NSString *)searchT {
  if (contachName == nil || searchT == nil ||
      [contachName isEqualToString:@"(null)"] == YES) {
    return NO;
  }
  searchT = [searchT uppercaseString];
  NSRange foundRange = [contachName rangeOfString:searchT];
  if (foundRange.length > 0) {
    return YES;
  } else {
    return NO;
  }
}

/** 接收数据 区分数据 */
- (void)addDataWithSouces:(NSArray *)localarray
           withMutableDic:(NSMutableDictionary *)dictionary {
  if ([dictionary.allKeys count] != 0) {
    [dictionary removeAllObjects];
  }
  for (NSString *string in ALPHA_ARRAY) {
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    BOOL realExist = NO;
    for (NSString *bankName in localarray) {
      //汉字转拼音
      NSString *pinyinNic = [pinyinDict objectForKey:bankName];
      pinyinNic = [pinyinNic uppercaseString];
      if ([pinyinNic hasPrefix:string]) {
        [temp addObject:bankName];
        realExist = YES;
      }
    }
    //分类存取数组
    if (realExist) {
      [dictionary setObject:temp forKey:string];
    }
  }
  //单个字符搜索结果 不为空
  if (dictionary.count != 0) {
    _littleCattleView.hidden = YES;
    bankInfoTabelView.hidden = NO;
    [self reloadTableview];
  } else {
    [_littleCattleView isCry:NO];
    bankInfoTabelView.hidden = YES;
  }
  [_indicatorView stopAnimating];
  _sideBarView.hidden = YES;
}

- (void)reloadOrTableView {
  isFilter = YES;
  if ([bankNameDict count] > 0) {
    _littleCattleView.hidden = YES;
  } else {
    _littleCattleView.hidden = NO;
  }
  [bankInfoTabelView reloadData];
}

#pragma mark - 表格协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  NSArray *keys = isFilter ? [self defaultKeys] : [self filteredKeys];
  return keys.count;
}

/** 头里的内容 */
- (NSString *)tableView:(UITableView *)tableView
    titleForHeaderInSection:(NSInteger)section {
  NSArray *keys = isFilter ? [self defaultKeys] : [self filteredKeys];
  return [keys objectAtIndex:section];
}

- (UIView *)tableView:(UITableView *)tableView
    viewForHeaderInSection:(NSInteger)section {
  NSArray *keys = isFilter ? [self defaultKeys] : [self filteredKeys];
  UIView *bgView =
      [[UIView alloc] initWithFrame:CGRectMake(0, 0, BGViewWidth, 16)];
  bgView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Table_Title];
  UILabel *titleLabel =
      [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 100, 16)];
  titleLabel.textAlignment = NSTextAlignmentLeft;
  titleLabel.text = [keys objectAtIndex:section];
  titleLabel.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  titleLabel.font = [UIFont systemFontOfSize:Font_Height_12_0];
  titleLabel.backgroundColor = [UIColor clearColor];
  [bgView addSubview:titleLabel];
  return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
  return 16.0f;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  NSArray *keys = isFilter ? [self defaultKeys] : [self filteredKeys];
  NSMutableDictionary *dictionary = isFilter ? bankNameDict : filterDict;
  NSArray *array = [dictionary objectForKey:[keys objectAtIndex:section]];
  return [array count];
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 45.0f;
}

NSInteger totalMark;     //记录当前区 有多少行 row
NSInteger trackMark = 0; //记录 当前到了第几行 row
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *keys = isFilter ? [self defaultKeys] : [self filteredKeys];
  NSMutableDictionary *dict = isFilter ? bankNameDict : filterDict;
  NSArray *array = [dict objectForKey:[keys objectAtIndex:indexPath.section]];
  NSString *bankName = [array objectAtIndex:indexPath.row];
  static NSString *cellName = @"cell";
  BankInforCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"BankInforCell"
                                          owner:nil
                                        options:nil] lastObject];
    cell.lineView.hidden = YES;
  }
  cell.myLable.text = bankName;
  //给cell添加线
  NSInteger rows = [tableView numberOfRowsInSection:indexPath.section];
  if (rows != 1) {
    trackMark = indexPath.row;
    totalMark = rows - 1;
    if (trackMark != totalMark) {
      cell.lineView.hidden = NO;
    } else {
      cell.lineView.hidden = YES;
    }
  }
  return cell;
}

//点击cell
- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  //获取cell
  BankInforCell *cell =
      (BankInforCell *)[tableView cellForRowAtIndexPath:indexPath];
  NSString *string = cell.myLable.text;
  NSString *bankID;
  for (WFBankData *data in _bankData.dataArray.array) {
    if ([string isEqualToString:data.bankName]) {
      bankID = data.bankID;
    }
  }
  onContactsSelechedBankCallback(cell.myLable.text, bankID);
  [super leftButtonPress];
}

/**
 * 排序 通过某种规则排序字符串SEL
 */
- (NSArray *)defaultKeys {
  return [bankNameDict.allKeys
      sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

/**
 * 过滤后的排序
 */
- (NSArray *)filteredKeys {
  return [filterDict.allKeys
      sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}
@end

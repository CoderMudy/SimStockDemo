//
//  WFSearchBankViewController.m
//  SimuStock
//
//  Created by moulin wang on 15/4/12.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WFSearchBankViewController.h"
#import "BaseRequester.h"

@interface WFSearchBankViewController () {
  NSMutableArray *_sideBarArray;
  //测栏
  UIView *_sideBarView;
  
  WFBankData *_bankData;
}



@end

@implementation WFSearchBankViewController

- (void)bankWithCallback:(OnCellSelected)callback {
  onContactsSelechedBankCallback = callback;
}

- (id)init {
  self = [super init];
  if (self) {
    // [NetLoadingWaitView startAnimating];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
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
  
  [self getBankInfoData];
  
//  //创建子线程 获取数据
//  [NSThread detachNewThreadSelector:@selector(getBankInfoData)
//                           toTarget:self
//                         withObject:nil];
}
//创建侧栏
- (void)createSideBarView {
  _sideBarView = [[UIView alloc]
      initWithFrame:CGRectMake(self.clientView.bounds.size.width - 25, 0, 25,
                               CGRectGetHeight(self.clientView.bounds))];
  _sideBarView.backgroundColor = [UIColor whiteColor];
  _sideBarView.hidden = YES;
  [self.clientView addSubview:_sideBarView];
}

//根据key值创建测栏
- (void)createSideBarWithTiltarray:(NSArray *)titleArray {
  _sideBarView.hidden = NO;
  //根据数组 创建sideBarView里的btn
  if (titleArray.count > 0 && titleArray.count < 26) {
    //如果 小于26的话 btn的高 = 25
    CGFloat height =
        (CGRectGetHeight(_sideBarView.bounds) - titleArray.count * 25) * 0.5;
    [self creatButtonWithTitleArray:titleArray
                         withHeight:height
                   withBoundsHeight:25];
  } else if (titleArray.count == 26) {
    CGFloat boundsHeight = CGRectGetHeight(_sideBarView.bounds) / 26.0f;
    [self creatButtonWithTitleArray:titleArray
                         withHeight:0
                   withBoundsHeight:boundsHeight];
  } else if (titleArray.count == 0) {
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
      initWithFrame:CGRectMake(0, 0, 0.5, CGRectGetHeight(_sideBarView.bounds))];
  lineView.backgroundColor = [Globle colorFromHexRGB:@"bdbdbd"];
  [_sideBarView addSubview:lineView];
  for (int index = 0; index < titlearray.count; index++) {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, height + index * BoundsHeight, 25, BoundsHeight);
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
    if (btn.selected == NO) {
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
  //手动滚动指定位置
  NSIndexPath *selectIndexPath =
      [NSIndexPath indexPathForRow:0 inSection:sideBarButton.tag];
  [bankInfoTabelView scrollToRowAtIndexPath:selectIndexPath
                           atScrollPosition:UITableViewScrollPositionTop
                                   animated:YES];
  charLable.hidden = NO;
  charLable.text = sideBarButton.titleLabel.text;
  // 2秒后消失
  [self performBlock:^{
    charLable.hidden = YES;
  } withDelaySeconds:2.0f];

  [self performBlock:^{
    [sideBarButton setTitleColor:[Globle colorFromHexRGB:@"086dae"]
                        forState:UIControlStateNormal];
    sideBarButton.selected = YES;
  } withDelaySeconds:5.0f];
}

/**
 * 创建查询相关控件
 */
- (void)creatSearchViewOfBank {
  //导航条
  //覆盖原先的导航条
  UIView *bottomView = [[UIView alloc]
      initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,
                               _topToolBar.frame.size.height)];
  bottomView.backgroundColor = [UIColor clearColor];
  [_topToolBar addSubview:bottomView];
  //隐藏菊花
  _indicatorView.hidden = YES;
  //搜索输入框
  UIView *backView = [[UIView alloc]
      initWithFrame:CGRectMake(10, _topToolBar.frame.size.height - 44 + 4,
                               self.view.frame.size.width - 58 - 20, 44 - 8)];
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
  inputConteactBankTF.placeholder = @"搜索银行";
  inputConteactBankTF.font = [UIFont systemFontOfSize:Font_Height_15_0];
  inputConteactBankTF.textAlignment = NSTextAlignmentLeft;
  inputConteactBankTF.delegate = self;
  //现在输入长度
  [inputConteactBankTF setMaxLength:12];
  //收键盘的模式
  inputConteactBankTF.returnKeyType = UIReturnKeySearch;
  
  
  //添加事件
  [inputConteactBankTF addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
  
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
  //取消按钮
  UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
  cancelButton.frame = CGRectMake(_topToolBar.bounds.size.width - 58,
                                  topToolBarHeight - 44.0, 95.0 * 0.5, 44);
  [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
  cancelButton.titleLabel.font = [UIFont systemFontOfSize:Font_Height_16_0];
  cancelButton.titleLabel.textColor = [Globle colorFromHexRGB:Color_White];
  cancelButton.backgroundColor = [UIColor clearColor];
  [cancelButton addTarget:self
                   action:@selector(leftButtonPress)
         forControlEvents:UIControlEventTouchUpInside];
  [cancelButton setBackgroundImage:[UIImage imageNamed:@"return_touch_down"]
                          forState:UIControlStateHighlighted];
  [_topToolBar addSubview:cancelButton];
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

//搜索
- (void)searchContact:(UIButton *)button {
  [inputConteactBankTF resignFirstResponder];
  NSString *searchContent = [self nameToPinYinWithName:inputConteactBankTF.text];
  searchContent = [searchContent stringByReplacingOccurrencesOfString:@" " withString:@""];
  if (searchContent == nil || searchContent.length <= 0) {
    [NewShowLabel setMessageContent:@"请输入搜索内容"];
    [bankInfoTabelView reloadData];
    return;
  }
  //调用搜索
  if ([searchContent length] == 1) {
    if (![SimuUtil isExistNetwork]) {
      if (bankInfoArray.dataBinded) {
        [self textFiledWithOneCharForSearch:searchContent];
      }else{
        [_littleCattleView isCry:YES];
      }
    }else{
      if (!bankInfoArray.dataBinded) {
        [self getBankInfoData];
        [self performSelector:@selector(textFiledWithOneCharForSearch:) withObject:searchContent afterDelay:1.0f];
      }else{
        [self textFiledWithOneCharForSearch:searchContent];
      }
    }
  } else {
    if (![SimuUtil isExistNetwork]) {
      if (bankInfoArray.dataBinded) {
        [self searchTextWith:searchContent];
      }else{
        [_littleCattleView isCry:YES];
      }
    }else{
      if (!bankInfoArray.dataBinded) {
        [self getBankInfoData];
        [self performSelector:@selector(searchTextWith:) withObject:searchContent afterDelay:1.0f];
      }else{
        [self searchTextWith:searchContent];
      }
    }
    
    //[self searchTextWith:searchContent];
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
  [bankInfoTabelView setSectionHeaderHeight:20.0f];
  bankInfoTabelView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
/** 创建中间显示字母 */
- (void)createBigChar {
  charLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 55.0f, 55.0f)];
  charLable.center = CGPointMake(self.clientView.frame.size.width * 0.5,
                                 self.clientView.frame.size.height * 0.5);
  charLable.backgroundColor = [Globle colorFromHexRGB:@"0a78bf"];
  charLable.textAlignment = NSTextAlignmentCenter;
  charLable.font = [UIFont systemFontOfSize:25.0f];
  charLable.textColor = [UIColor whiteColor];
  charLable.layer.masksToBounds = YES;
  charLable.layer.cornerRadius = 5.0f;
  charLable.hidden = YES;
  [self.clientView addSubview:charLable];
}

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
    if (![SimuUtil isExistNetwork]) {
      if (!bankInfoArray.dataBinded) {
        [_littleCattleView isCry:YES];
        bankInfoTabelView.hidden = YES;
        _sideBarView.hidden = YES;
      }else{
        [self reloadOrTableView];
        bankInfoTabelView.hidden = NO;
        _sideBarView.hidden = NO;
        _littleCattleView.hidden = YES;
      }
    }else{
      if (!bankInfoArray.dataBinded) {
        [self getBankInfoData];
      }else{
        [self reloadOrTableView];
        bankInfoTabelView.hidden = NO;
        _sideBarView.hidden = NO;
        _littleCattleView.hidden = YES;
      }
    }
  }
//  //按钮背景变化
//  if ([toBeString length] == 0 && [textField.text length] == 1) {
//    searchButton.userInteractionEnabled = NO;
//    [searchButton setImage:[UIImage imageNamed:@"搜索_不可点击状态"]
//                  forState:UIControlStateNormal];
//  } else {
//    searchButton.userInteractionEnabled = YES;
//    [searchButton setImage:[UIImage imageNamed:@"搜索"]
//                  forState:UIControlStateNormal];
//  }
  return YES;
}

-(void)textFieldChange:(ExtendedTextField *)textField
{
  NSLog(@"textField = %@",textField.text);
  if (textField.text.length > 0) {
    searchButton.userInteractionEnabled = YES;
    [searchButton setImage:[UIImage imageNamed:@"搜索"]
                  forState:UIControlStateNormal];
  }else{
    searchButton.userInteractionEnabled = NO;
    [searchButton setImage:[UIImage imageNamed:@"搜索_不可点击状态"]
                  forState:UIControlStateNormal];
  }
  NSString *pinYin = [self nameToPinYinWithName:textField.text];
  if (pinYin.length == 1) {
    if (bankInfoArray.dataBinded) {
      [self reloadOrTableView];
      bankInfoTabelView.hidden = NO;
      _sideBarView.hidden = NO;
      _littleCattleView.hidden = YES;
    }else{
      [_littleCattleView isCry:YES];
      bankInfoTabelView.hidden = YES;
      _sideBarView.hidden = YES;
    }
  }
}


//滚动时 键盘消失
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  [inputConteactBankTF resignFirstResponder];
}

/** 获取数据  */
- (void)getBankInfoData {
  if (![SimuUtil isExistNetwork]) {
    //没有网络的情况
    [self notWork];
    return;
  }
  _littleCattleView.hidden = YES;
  //发送网络请求
  __weak WFSearchBankViewController *weakSelf = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^(){
    WFSearchBankViewController *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    }else{
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj){
    WFBankData *bankData = (WFBankData *)obj;
    _bankData = bankData;
    [self processingBankDataWithArray:bankData];
  };
  callback.onFailed = ^(){
    if (_bankData.dataArray.dataBinded) {
      //绑定数据
      [bankInfoTabelView reloadData];
      _littleCattleView.hidden = YES;
    }else{
      [_littleCattleView isCry:NO];
    }
  };
  callback.onError = ^(BaseRequestObject *obj,NSException *exc){
    if (obj.status) {
      [NewShowLabel setMessageContent:obj.message];
    }else{
      [BaseRequester defaultErrorHandler](obj,exc);
    }
  };
  //请求数据
  [WFBankInfoData requestBankInfoWithCallbackWithType:@"1" withCallback:callback];
}

-(void)notWork
{
  //提示网络不给力
  dispatch_async(dispatch_get_main_queue(), ^{
    [NewShowLabel showNoNetworkTip];
    //判断有没有数据绑定
    if (_bankData.dataArray.dataBinded == YES) {
      _littleCattleView.hidden = YES;
    }else{
      //无网络小牛
      [_littleCattleView isCry:YES];
    }
  });
}

-(void)processingBankDataWithArray:(WFBankData *)bankArray
{
  bankInfoArray = [[DataArray alloc] init];
  for (WFBankData *BF in bankArray.dataArray.array) {
    NSString *bankName = BF.bankName;
    [bankInfoArray.array addObject:bankName];
  }
  //所以银行
  bankNameDict = [[NSMutableDictionary alloc] init];
  //转化成拼音
  pinyinDict = [[NSMutableDictionary alloc] init];
  //过滤后的符合条件的和剩下的银行
  filterDict = [[NSMutableDictionary alloc] init];
  isFilter = YES;
  if (bankInfoArray.array.count <= 0) {
    //没有数据 显示小牛
    bankArray.dataArray.dataBinded = NO;
    bankInfoArray.dataBinded = NO;
    _littleCattleView.hidden = NO;
  }else{
    bankArray.dataArray.dataBinded = YES;
    _littleCattleView.hidden = YES;
    bankInfoArray.dataBinded = YES;
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
    //将搜索框里的内容转化成拼音
    NSString *pinYin = [self nameToPinYinWithName:textField.text];
    if ([textField.text length] < 1) {
      [self reloadOrTableView];
      [NewShowLabel setMessageContent:@"搜索内容不能为空"];
      bankInfoTabelView.hidden = NO;
      return YES;
    } else if ([pinYin length] == 1) {
      //调用一个字母的排序方法
      if (![SimuUtil isExistNetwork]) {
        if (bankInfoArray.dataBinded) {
          [self textFiledWithOneCharForSearch:pinYin];
        }else{
          [_littleCattleView isCry:YES];
        }
      }else{
        if (!bankInfoArray.dataBinded) {
          [self getBankInfoData];
          [self performSelector:@selector(textFiledWithOneCharForSearch:) withObject:pinYin afterDelay:1.0f];
        }else{
          [self textFiledWithOneCharForSearch:pinYin];
        }
      }
      //[self textFiledWithOneCharForSearch:pinYin];
      return YES;
    }
    if (![SimuUtil isExistNetwork]) {
      if (bankInfoArray.dataBinded) {
        [self searchTextWith:pinYin];
      }else{
        [_littleCattleView isCry:YES];
      }
    }else{
      if (!bankInfoArray.dataBinded) {
        [self getBankInfoData];
        [self performSelector:@selector(searchTextWith:) withObject:pinYin afterDelay:1.0f];
      }else{
        [self searchTextWith:pinYin];
      }
    }

   // [self searchTextWith:pinYin];
    [inputConteactBankTF resignFirstResponder];
    return YES;
  } else {
    return YES;
  }
}

- (void)textFiledWithOneCharForSearch:(NSString *)oneChar {
  if (![SimuUtil isExistNetwork]) {
    if (!bankInfoArray.dataBinded) {
      return;
    }
  }else{
    if (!bankInfoArray.dataBinded) {
      [self getBankInfoData];
      return; 
    }
  }
  
  oneChar = [oneChar uppercaseString];
  NSString *temp = @"";
  for (UIButton *button in _sideBarArray) {
    NSString *string = button.titleLabel.text;
    if ([oneChar isEqualToString:string]) {
      temp = @"找到匹配的标记符";
      [self sideBarButtonAction:button];
    }
  }
  if ([temp isEqualToString:@""]) {
    _littleCattleView.hidden = NO;
    bankInfoTabelView.hidden = YES;
    _sideBarView.hidden = YES;
  }else{
    _littleCattleView.hidden = YES;
    _sideBarView.hidden = NO;
    bankInfoTabelView.hidden = NO;
  }
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
  }else{
    if (!bankInfoArray.dataBinded) {
      [self getBankInfoData];
    }
  }
   //开启子线程
  dispatch_queue_t queue =
      dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  dispatch_group_t group = dispatch_group_create();
  __weak WFSearchBankViewController *weakSelf = self;
  dispatch_group_async(group, queue, ^{
    WFSearchBankViewController *strongSelf = weakSelf;
    if (strongSelf) {
      //调用搜索方法
      [strongSelf crateFilterDictWithSearchTextName:textfiledString];
    }
  });
  dispatch_group_notify(group, dispatch_get_main_queue(), ^{
    [self reloadTableview];
  });
}

/** 根据输入框里的内容 搜索到的结果 */
- (void)crateFilterDictWithSearchTextName:(NSString *)textSearchString {
  dispatch_async(
      dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *array = [[NSMutableArray alloc] init];
        //外部组循环（字母）
        for (int index = 0; index < [bankNameDict.allKeys count]; index++) {
          NSArray *temp = [bankNameDict
              objectForKey:[bankNameDict.allKeys objectAtIndex:index]];
          //内部各个用户循环
          for (NSString *stringBank in temp) {
            //汉字转化成拼音
            NSString *pinyin1 = [pinyinDict objectForKey:stringBank];
            //所用到的搜索功能
            if ([self searchResult:pinyin1 searchText:textSearchString] ==
                YES) {
              [array addObject:stringBank];
            }
          }
        }
       
        if ([array count] == 0 && textSearchString.length > 0) {
          dispatch_async(dispatch_get_main_queue(), ^{
            [_littleCattleView isCry:NO];
            _littleCattleView.hidden = NO;
            bankInfoTabelView.hidden = YES;
            _sideBarView.hidden = YES;

          });
        } else {
          _littleCattleView.hidden = YES;
          bankInfoTabelView.hidden = NO;
          _sideBarView.hidden = NO;
          //接受数据 区分数据
          [self addDataWithSouces:array withMutableDic:filterDict];
        }
      });
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
  [self reloadTableview];
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
  [self createSideBarWithTiltarray:keys];
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
  return 44.0f;
}

NSInteger  totalMark; //记录当前区 有多少行 row
NSInteger  trackMark = 0; //记录 当前到了第几行 row
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *keys = isFilter ? [self defaultKeys] : [self filteredKeys];
  NSMutableDictionary *dict = isFilter ? bankNameDict : filterDict;
  NSArray *array = [dict objectForKey:[keys objectAtIndex:indexPath.section]];
  NSString *bankName = [array objectAtIndex:indexPath.row];
  static NSString *cellName = @"cell";
  BankInforCell *cell =
      [tableView dequeueReusableCellWithIdentifier:cellName];
  if (cell == nil) {
    cell = [[[NSBundle mainBundle] loadNibNamed:@"BankInforCell" owner:nil options:nil]lastObject];
    cell.lineView.hidden = YES;
  }
  cell.textLabel.text = bankName;
  cell.textLabel.font = [UIFont systemFontOfSize:Font_Height_17_0];
  //给cell添加线
  NSInteger rows = [tableView numberOfRowsInSection:indexPath.section];
  if (rows != 1) {
    trackMark = indexPath.row;
    totalMark = rows - 1;
    if (trackMark != totalMark) {
      cell.lineView.hidden = NO;
    }else{
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
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  NSLog(@"%@",cell.textLabel.text);
  NSString *string = cell.textLabel.text;
  int bankID;
  for (WFBankData *data in _bankData.dataArray.array) {
    if ([string isEqualToString:data.bankName]) {
      bankID = [data.bankID intValue];
    }
  }
  onContactsSelechedBankCallback(cell.textLabel.text,bankID);
  [super leftButtonPress];
}

////线
//- (void)viewDidLayoutSubviews {
//  [super viewDidLayoutSubviews];
//  if ([bankInfoTabelView respondsToSelector:@selector(setSeparatorInset:)]) {
//    [bankInfoTabelView setSeparatorInset:UIEdgeInsetsMake(0, 25, 0, 25)];
//  }
//  if ([bankInfoTabelView respondsToSelector:@selector(setLayoutMargins:)]) {
//    [bankInfoTabelView setLayoutMargins:UIEdgeInsetsMake(0, 25, 0, 25)];
//  }
//}
//
//- (void)tableView:(UITableView *)tableView
//      willDisplayCell:(UITableViewCell *)cell
//    forRowAtIndexPath:(NSIndexPath *)indexPath {
//  if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
//    [cell setSeparatorInset:UIEdgeInsetsMake(0, 25, 0, 25)];
//  }
//  if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//    [cell setLayoutMargins:UIEdgeInsetsMake(0, 25, 0, 25)];
//  }
//}

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
- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

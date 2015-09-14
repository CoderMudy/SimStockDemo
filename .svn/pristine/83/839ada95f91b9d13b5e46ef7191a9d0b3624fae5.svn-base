//
//  WeiBoMyContactsVC.m
//  SimuStock
//
//  Created by jhss on 14-11-24.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "WeiBoMyContactsVC.h"
#import "ContactCell.h"
#import "UIImageView+WebCache.h"
#import "MyAttentionInfo.h"
#import "pinyin.h"
#import "ConditionsWithKeyBoardUsing.h"
#import "SimuUtil.h"
#import "NetLoadingWaitView.h"
#import "NSString+Java.h"

@implementation WeiBoMyContactsVC

- (void)FriendsWithCallBack:(OnContactsSelected)callback {
  // tableViewCell 回调函数
  onContactsSelectedCallback = callback;
}
- (id)init {
  self = [super init];
  if (self) {
    [NetLoadingWaitView startAnimating];
  }
  return self;
}
- (void)viewDidLoad {
  [super viewDidLoad];
  [self createSearchView];
  [self createTableview];
  [self createBigChar];
  [self createRecentContactView];
  [NSThread detachNewThreadSelector:@selector(getAttentionData) toTarget:self withObject:nil];
}
/*
 * 创建查询相关控件
 */
- (void)createSearchView {
  //导航条
  _indicatorView.hidden = YES;
  //搜索输入栏
  CGFloat left = CGRectGetMaxX(_topToolBar.backButton.frame) + 1;
  UIView *backView =
      [[UIView alloc] initWithFrame:CGRectMake(left, _topToolBar.height - 40, _topToolBar.width - left * 2,
                                               35)]; //高度
  backView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  [_topToolBar addSubview:backView];
  //搜索栏TextField(扩大点击范围)
  UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
  leftButton.frame = CGRectMake(0, 0, backView.frame.size.width - 34, backView.frame.size.height);
  leftButton.backgroundColor = [UIColor clearColor];
  [leftButton addTarget:self
                 action:@selector(inputTextFieldBecomeRespond)
       forControlEvents:UIControlEventTouchUpInside];
  [backView addSubview:leftButton];
  //输入栏
  inputContactTF =
      [[ExtendedTextField alloc] initWithFrame:CGRectMake(10, 8, backView.frame.size.width - 20 - 10 * 2, 20)];
  inputContactTF.placeholder = @"搜索联系人";
  inputContactTF.font = [UIFont systemFontOfSize:15.0f];
  inputContactTF.textAlignment = NSTextAlignmentLeft;
  inputContactTF.delegate = self;
  [inputContactTF setMaxLength:12];
  inputContactTF.returnKeyType = UIReturnKeySearch;
  [backView addSubview:inputContactTF];
  //搜索栏
  searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 60, 44.0f)];
  searchBar.delegate = self;
  [searchBar setTintColor:[Globle colorFromHexRGB:Color_Blue_but]];
  searchBar.hidden = YES;
  searchBar.placeholder = @"搜索联系人";
  searchBar.tintColor = [Globle colorFromHexRGB:@"086dae"];
  searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
  searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
  searchBar.keyboardType = UIKeyboardTypeDefault;
  [self.view addSubview:searchBar];
  WBMyContactsTableView.tableHeaderView = searchBar;

  //侧栏索引
  searchDisplay =
      [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
  searchDisplay.searchResultsDataSource = self;
  searchDisplay.searchResultsDelegate = self;
  WBMyContactsTableView = searchDisplay.searchResultsTableView;

  //搜索按钮
  searchButton =
      [[UIButton alloc] initWithFrame:CGRectMake(backView.frame.size.width - 34, 0, 34, backView.frame.size.height)];
  [searchButton setBackgroundImage:[UIImage imageNamed:@"搜索记录背景"]
                          forState:UIControlStateNormal];
  [searchButton setImage:[UIImage imageNamed:@"搜索_不可点击状态"] forState:UIControlStateNormal];
  searchButton.userInteractionEnabled = NO;
  [searchButton addTarget:self
                   action:@selector(searchContact:)
         forControlEvents:UIControlEventTouchUpInside];
  [backView addSubview:searchButton];

  // zxc加蓝色的分割线
  UIView *lineView =
      [[UIView alloc] initWithFrame:CGRectMake(backView.frame.size.width - 34.5, 6, 0.5, backView.frame.size.height - 12)];
  lineView.backgroundColor = [Globle colorFromHexRGB:Color_Blue_but];
  [backView addSubview:lineView];
}

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
  if ([string isEqualToString:@"\n"]) {
    return YES;
  }
  NSString *toBeString =
      [textField.text stringByReplacingCharactersInRange:range withString:string];
  if ([string length] == 0 && [toBeString length] == 0) {
    [self reloadOriTableview];
  }
  //按钮背景变化（删除一位一位的删，跟踪）
  if ([toBeString length] == 0 && [textField.text length] == 1) {
    searchButton.userInteractionEnabled = NO;
    [searchButton setImage:[UIImage imageNamed:@"搜索_不可点击状态"] forState:UIControlStateNormal];
  } else {
    searchButton.userInteractionEnabled = YES;
    [searchButton setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
  }
  return YES;
}
/*
 *获取关注数据
 */
- (void)getAttentionData {
  //获取关注信息
  WBMyContactsArray = [NSArray arrayWithArray:[[MyAttentionInfo sharedInstance] getAttentionArray]];
  //所有昵称
  nameDict = [[NSMutableDictionary alloc] init];
  //满足邀请昵称
  filterDict = [[NSMutableDictionary alloc] init];
  //拼音存储字典
  pinyinDict = [[NSMutableDictionary alloc] init];

  isFilter = YES;
  //最近联系人
  NSString *userIdKey = [NSString stringWithFormat:@"recentContacts_%@", [SimuUtil getUserID]];
  recentContacts = [[NSUserDefaults standardUserDefaults] objectForKey:userIdKey];
  NSArray *useridArr = [recentContacts componentsSeparatedByString:@"#"];
  recentContactArr = [[NSMutableArray alloc] init];
  //获得最近联系人 数组
  for (MyAttentionInfoItem *item in WBMyContactsArray) {
    for (NSString *uid in useridArr) {
      if ([uid isEqualToString:[item.userListItem.userId stringValue]]) {
        [recentContactArr addObject:item];
      }
    }
  }
  if ([WBMyContactsArray count] > 0) {
    if ([recentContactArr count] > 0) {
      recentContactTableview.hidden = NO;
      recentContactTableview.frame =
          CGRectMake(0, 0, self.clientView.frame.size.width, [recentContactArr count] * 60.0f + 30.0f);
      [recentContactTableview reloadData];
      [recentContactTableview reloadData];
      WBMyContactsTableView.tableHeaderView = recentContactTableview;
    } else { //无最近联系人
      recentContactTableview.hidden = YES;
    }
    _littleCattleView.hidden = YES;
  } else {
    _littleCattleView.hidden = NO;
    [_littleCattleView showCryCattleWithContent:@"没有联系人\n找呀找呀找朋友去吧"];
  }
  [self createPinYinDictWithLocalArray:WBMyContactsArray withDict:nameDict];
}

/*
 * 创建表格
 */
- (void)createTableview {
  WBMyContactsTableView = [[UITableView alloc] initWithFrame:self.clientView.bounds];
  WBMyContactsTableView.delegate = self;
  WBMyContactsTableView.dataSource = self;
  WBMyContactsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

  WBMyContactsTableView.backgroundColor = [UIColor clearColor];
  [self.clientView addSubview:WBMyContactsTableView];

  [WBMyContactsTableView setSectionHeaderHeight:20.0f];
  [WBMyContactsTableView setSectionIndexColor:[Globle colorFromHexRGB:Color_Blue_but]];
  //索引透明
  [WBMyContactsTableView setSectionIndexTrackingBackgroundColor:[UIColor clearColor]];

  if (SYSTEM_VERSION >= 7.0) {
    [WBMyContactsTableView setSectionIndexBackgroundColor:[UIColor clearColor]];
  }
}

/*
 *最近联系人
 */
- (void)createRecentContactView {
  recentContactTableview = [[UITableView alloc] init];
  recentContactTableview.delegate = self;
  recentContactTableview.dataSource = self;
  recentContactTableview.bounces = NO;
  recentContactTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
  recentContactTableview.backgroundColor = [UIColor clearColor];
  [WBMyContactsTableView setTableHeaderView:recentContactTableview];
}
/*
 * 搜索联系人
 */
- (void)searchContact:(UIButton *)button {
  [inputContactTF resignFirstResponder];
  [self searchTextWith:inputContactTF.text.trim];
}
/** 键盘搜索按钮 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if (textField == inputContactTF) {
    if ([textField.text length] < 1) {
      [self reloadOriTableview];
      return YES;
    }
    [self searchTextWith:inputContactTF.text.trim];
    [inputContactTF resignFirstResponder];
    return YES;
  } else
    return YES;
}
/*
 * 未查到联系人
 */
- (void)notFoundFriends:(BOOL)isFound {
  [_littleCattleView setInformation:@"没有找到相关股友"];
  if (isFound) {
    WBMyContactsTableView.hidden = YES;
    recentContactTableview.hidden = YES;
    _littleCattleView.hidden = NO;
  } else {
    WBMyContactsTableView.hidden = NO;
    recentContactTableview.hidden = NO;
    _littleCattleView.hidden = YES;
  }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  //滚动的时候消除键盘
  [inputContactTF resignFirstResponder];
}
/** 扩大textfield的点击范围 */
- (void)inputTextFieldBecomeRespond {
  [inputContactTF becomeFirstResponder];
}
#pragma mark------searchbar------
/*
 *搜索记录随输入改变
 */
- (void)searchTextWith:(NSString *)searchText {
  if ([searchText length] < 1) {
    [self reloadOriTableview];
    return;
  } else {
    isFilter = NO;
  }
  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
  dispatch_group_t group = dispatch_group_create();
  __weak WeiBoMyContactsVC *weakSelf = self;
  dispatch_group_async(group, queue, ^{
    WeiBoMyContactsVC *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf createFilterDictWithSearchText:searchText];
    }
  });
  dispatch_group_notify(group, dispatch_get_main_queue(), ^{
    [self reloadTableview];
  });
}
- (NSArray *)createFilterDictWithSearchText:(NSString *)searchText {
  NSMutableArray *array = [[NSMutableArray alloc] init];
  searchText = [self nameToPinYinWith:searchText];
  //外部组循环（字母）
  for (int index = 0; index < [nameDict.allKeys count]; index++) {
    NSArray *temp = nameDict[nameDict.allKeys[index]];
    //内部各个用户循环
    for (MyAttentionInfoItem *item in temp) {
      //汉字转拼音
      NSString *pinyin1 = pinyinDict[item.userListItem.nickName];
      //所用到的搜索功能
      if ([self searchResult:pinyin1 searchText:searchText]) {
        [array addObject:item];
      }
    }
  }

  //无数据小牛
  [_littleCattleView setInformation:@"未找到相关数据"];
  if ([array count] == 0 && searchText.length > 0) {
    [_littleCattleView isCry:NO];
    recentContactTableview.hidden = YES;
    _littleCattleView.hidden = NO;
  } else {
    _littleCattleView.hidden = YES;
    if ([recentContactArr count] > 0) {
      recentContactTableview.hidden = NO;
    }
  }
  [self addDataWithSouces:array withMutoableDic:filterDict];
  return array;
}
/** 汉字转化为拼音 */
- (NSString *)nameToPinYinWith:(NSString *)name {
  //只有字母和数字的情况
  if ([[ConditionsWithKeyBoardUsing shareInstance] isNumbersOrLetters:name]) {
    return [name uppercaseString];
  }
  //已转换过
  if (pinyinDict[name]) {
    return pinyinDict[name];
  }
  if (!outputFormat) {
    outputFormat = [[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeLowercase];
  }
  NSString *outputPinyin = [PinyinHelper toHanyuPinyinStringWithNSString:name
                                             withHanyuPinyinOutputFormat:outputFormat
                                                            withNSString:@""];
  return outputPinyin;
}
/** 判断字符串是否包含某个字符串 */
- (BOOL)searchResult:(NSString *)contactName searchText:(NSString *)searchT {
  if (contactName == nil || searchT == nil || [contactName isEqualToString:@"(null)"] == YES) {
    return NO;
  }
  NSRange foundRange = [contactName rangeOfString:searchT];
  if (foundRange.length > 0)
    return YES;
  else
    return NO;
}
/*
 * 输出每个拼音的首字母（简写）
 */
- (NSString *)namToPinYinFisrtNameWith:(NSString *)name {
  NSString *outputString = @"";
  for (int i = 0; i < [name length]; i++) {
    outputString =
        [NSString stringWithFormat:@"%@%c", outputString, pinyinFirstLetter([name characterAtIndex:i])];
  }
  return outputString;
}
#pragma mark
#pragma mark----搜索协议函数---
/** 本地保存昵称拼音 */
- (void)createPinYinDictWithLocalArray:(NSArray *)localArray withDict:(NSMutableDictionary *)dict {
  for (NSString *string in ALPHA_ARRAY) {
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    BOOL realExist = NO;
    for (MyAttentionInfoItem *item in localArray) {
      //汉字转拼音
      NSString *pinyinNic = [self nameToPinYinWith:item.userListItem.nickName];
      pinyinNic = [pinyinNic uppercaseString];
      if ([pinyinNic hasPrefix:string]) {
        //本地保存转换内容
        pinyinDict[item.userListItem.nickName] = pinyinNic;
        [temp addObject:item];
        realExist = YES;
      }
    }
    //分类存取数组
    if (realExist) {
      dict[string] = temp;
    }
  }
  [self reloadTableview];
}
/** 接收数据，区分数据 */
- (void)addDataWithSouces:(NSArray *)localarray withMutoableDic:(NSMutableDictionary *)dictionary {
  if ([dictionary.allKeys count] != 0) {
    [dictionary removeAllObjects];
  }
  for (NSString *string in ALPHA_ARRAY) {
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    BOOL realExist = NO;
    for (MyAttentionInfoItem *item in localarray) {
      //汉字转拼音
      NSString *pinyinNic = pinyinDict[item.userListItem.nickName];
      pinyinNic = [pinyinNic uppercaseString];
      if ([pinyinNic hasPrefix:string]) {
        [temp addObject:item];
        realExist = YES;
      }
    }
    //分类存取数组
    if (realExist) {
      dictionary[string] = temp;
    }
  }
}
- (void)reloadOriTableview {
  isFilter = YES;
  if ([nameDict count] > 0) {
    _littleCattleView.hidden = YES;
  } else {
    _littleCattleView.hidden = NO;
  }
  [WBMyContactsTableView reloadData];
}
- (void)refreshTableView {
  [WBMyContactsTableView reloadData];
}
- (void)reloadTableview {
  if ([NetLoadingWaitView isAnimating]) {
    [NetLoadingWaitView stopAnimating];
  }
  //  recentContactTableview.hidden = YES;
  [WBMyContactsTableView reloadData];
}
#pragma mark
#pragma mark--------表格协议--------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (tableView == recentContactTableview) {
    return 1;
  }
  NSArray *keys = isFilter ? [self defaultKeys] : [self filteredKeys];
  return keys.count;
}
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
  NSArray *keys = isFilter ? [self defaultKeys] : [self filteredKeys];
  return keys;
}
/** 表格标题（系统加入方式) */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  if (tableView == recentContactTableview) {
    return @"最近联系人";
  }
  NSArray *keys = isFilter ? [self defaultKeys] : [self filteredKeys];
  return keys[section];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  NSArray *keys = isFilter ? [self defaultKeys] : [self filteredKeys];
  if (tableView == recentContactTableview) {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BGViewWidth, 30)];
    bgView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Table_Title];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 100, 30)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = @"最近联系人";
    titleLabel.textColor = [Globle colorFromHexRGB:Color_Text_Common];
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    titleLabel.backgroundColor = [UIColor clearColor];
    [bgView addSubview:titleLabel];
    return bgView;
  } else {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BGViewWidth, 16)];
    bgView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Table_Title];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 100, 16)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = keys[section];
    titleLabel.textColor = [Globle colorFromHexRGB:Color_Text_Common];
    titleLabel.font = [UIFont systemFontOfSize:12.0f];
    titleLabel.backgroundColor = [UIColor clearColor];
    [bgView addSubview:titleLabel];
    return bgView;
  }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (tableView == recentContactTableview) {
    return 30.0f;
  } else {
    return 16.0f;
  }
}
/** 添加组索引 */
- (NSInteger)tableView:(UITableView *)tableView
    sectionForSectionIndexTitle:(NSString *)title
                        atIndex:(NSInteger)index {
  charLabel.hidden = NO;
  charLabel.text = title;
  [self performBlock:^{
    charLabel.hidden = YES;
  } withDelaySeconds:2.0f];
  //如果索引固定26字母时，可以用 [ALPHA rangeOfString:title].location
  return index;
}
/** 中间字母显示 */
- (void)createBigChar {
  charLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 55.0f, 55.0f)];
  charLabel.center = CGPointMake(self.clientView.frame.size.width / 2, self.clientView.frame.size.height / 2);
  charLabel.backgroundColor = [Globle colorFromHexRGB:@"#0a78bf"];
  charLabel.textAlignment = NSTextAlignmentCenter;
  charLabel.font = [UIFont systemFontOfSize:25.0f];
  charLabel.textColor = [UIColor whiteColor];
  [charLabel.layer setMasksToBounds:YES];
  [charLabel.layer setCornerRadius:5.0f];
  charLabel.hidden = YES;
  [self.clientView addSubview:charLabel];
}
/*
 *----------
 *  行操作
 *----------
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (tableView == recentContactTableview) {
    return [recentContactArr count];
  }
  //获取当前组的
  NSArray *keys = isFilter ? [self defaultKeys] : [self filteredKeys];
  NSMutableDictionary *dictionary = isFilter ? nameDict : filterDict;
  NSArray *array = dictionary[keys[section]];
  return [array count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 60.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (tableView == recentContactTableview) {
    static NSString *cellId = @"recentCell";
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
      cell = [[ContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }

    MyAttentionInfoItem *item = recentContactArr[indexPath.row];
    if (indexPath.row == 0) {
      cell.uplineView.hidden = YES;
      cell.downlineView.hidden = YES;
    } else {
      cell.uplineView.hidden = NO;
      cell.downlineView.hidden = NO;
    }
    [cell.mHeadImageView setImageWithURL:[NSURL URLWithString:item.userListItem.headPic]
                        placeholderImage:[UIImage imageNamed:@"用户默认头像"]];
    cell.mTitleLabel.text = item.userListItem.nickName;
    cell.mDetailLabel.text = [NSString stringWithFormat:@"%@没有签名", item.userListItem.nickName];
    [cell.mTitleLabel showVipNickNameLabel:item.userListItem.vipType
                           withNormalColor:Color_Text_Common];
    return cell;
  }
  NSArray *keys = isFilter ? [self defaultKeys] : [self filteredKeys];
  NSMutableDictionary *dict = isFilter ? nameDict : filterDict;
  NSArray *array = dict[keys[indexPath.section]];
  MyAttentionInfoItem *item = array[indexPath.row];
  // static？
  static NSString *cellId = @"searchCell";
  ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
  if (cell == nil) {
    cell = [[ContactCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
  }
  [cell.mHeadImageView setImageWithURL:[NSURL URLWithString:item.userListItem.headPic]
                      placeholderImage:[UIImage imageNamed:@"用户默认头像"]];
  if (indexPath.row == 0) {
    cell.uplineView.hidden = YES;
    cell.downlineView.hidden = YES;
  } else {
    cell.uplineView.hidden = NO;
    cell.downlineView.hidden = NO;
  }
  cell.mTitleLabel.text = item.userListItem.nickName;
  [cell.mTitleLabel showVipNickNameLabel:item.userListItem.vipType
                         withNormalColor:Color_Text_Common];
  cell.mDetailLabel.text = [NSString stringWithFormat:@"%@没有签名", item.userListItem.nickName];
  return cell;
}
/** 表格选择 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  MyAttentionInfoItem *item;
  if (tableView == recentContactTableview) {
    item = recentContactArr[indexPath.row];
  } else {
    NSArray *keys = isFilter ? [self defaultKeys] : [self filteredKeys];
    NSMutableDictionary *dict = isFilter ? nameDict : filterDict;
    NSArray *array = dict[keys[indexPath.section]];
    item = array[indexPath.row];
  }
  NSString *mUserId = [item.userListItem.userId stringValue];

  //最近联系人(点击重复用户时)
  NSString *userIdKey = [NSString stringWithFormat:@"recentContacts_%@", [SimuUtil getUserID]];
  NSString *allUserId = [[NSUserDefaults standardUserDefaults] objectForKey:userIdKey];
  NSArray *useridArr = [allUserId componentsSeparatedByString:@"#"];
  if ([useridArr count] == 0) {
    //首次存入
    [[NSUserDefaults standardUserDefaults] setObject:mUserId forKey:userIdKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
  } else if ([useridArr count] < 2) {
    NSString *seUid = useridArr[0];
    NSString *str;
    if (![self compareFirstUid:seUid WithSecondUid:mUserId]) {
      str = [NSString stringWithFormat:@"%@#%@", seUid, mUserId

      ];
    } else {
      str = [NSString stringWithFormat:@"%@", mUserId];
    }
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:userIdKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
  } else if ([useridArr count] < 3) {
    NSString *seUid = useridArr[0];
    NSString *thUid = useridArr[1];
    NSString *str;
    if ([self compareFirstUid:mUserId WithSecondUid:seUid]) {
      str = [NSString stringWithFormat:@"%@#%@", thUid, seUid];
    } else if ([self compareFirstUid:mUserId WithSecondUid:thUid]) {
      str = [NSString stringWithFormat:@"%@#%@", seUid, thUid];
    } else {
      str = [NSString stringWithFormat:@"%@#%@#%@", thUid, seUid, mUserId];
    }
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:userIdKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
  } else {
    NSString *seUid = useridArr[0];
    NSString *thUid = useridArr[1];
    NSString *foUid = useridArr[2];
    NSString *str;
    if ([self compareFirstUid:mUserId WithSecondUid:seUid]) {
      str = [NSString stringWithFormat:@"%@#%@#%@", thUid, foUid, seUid];
    } else if ([self compareFirstUid:mUserId WithSecondUid:thUid]) {
      str = [NSString stringWithFormat:@"%@#%@#%@", seUid, foUid, thUid];
    } else if ([self compareFirstUid:mUserId WithSecondUid:foUid]) {
      str = [NSString stringWithFormat:@"%@#%@#%@", seUid, thUid, foUid];
    } else {
      str = [NSString stringWithFormat:@"%@#%@#%@", thUid, foUid, mUserId];
    }
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:userIdKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
  }
  tableView.userInteractionEnabled = NO;
  onContactsSelectedCallback(mUserId, item.userListItem.nickName);
  //切换界面（传参）
  [self leftButtonPress];
}
/** 比较两个uid是否相同*/
- (BOOL)compareFirstUid:(NSString *)firstUid WithSecondUid:(NSString *)secondUid {
  if ([firstUid longLongValue] == [secondUid longLongValue]) {
    return YES;
  } else {
    return NO;
  }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [inputContactTF resignFirstResponder];
}
- (void)leftButtonPress {
  [inputContactTF resignFirstResponder];
  [super leftButtonPress];
}

/**
 * 选择后排序
 * 过滤后的内容
 */
- (NSArray *)filteredKeys {
  return [filterDict.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

/**
 * 默认keys排序
 * 通过某种规则排序字符串SEL
 */
- (NSArray *)defaultKeys {
  return [nameDict.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

@end

//
//  MatchSelectUniversityViewController.m
//  SimuStock
//
//  Created by Jhss on 15/8/11.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MatchSelectUniversityViewController.h"
#import "SimuUtil.h"
#import "NewShowLabel.h"
#import "BaseRequester.h"
#import "MatchUniversityNameCell.h"
#import "FileStoreUtil.h"
#import "ConditionsWithKeyBoardUsing.h"
#import "PinYinForObjc.h"
#import "NSString+validate.h"
#import "NSString+Java.h"

static NSString *const DEFALT_FROM_ID = @"0";
static NSString *const DEFALT_REQ_NUM = @"10000";

@implementation UniversityTableAdapter

#pragma mark - 表格协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [self.owner sectionKeys].count;
}

//返回索引数组
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
  return self.owner.sectionKeys;
}

/** 头里的内容 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return [[self.owner sectionKeys] objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  MatchUniversityNameCell *cell =
      (MatchUniversityNameCell *)[tableView dequeueReusableCellWithIdentifier:self.nibName];
  NSArray *array = [self.owner sectionDictionary][[self.owner sectionKeys][indexPath.section]];
  NSString *schoolName = array[indexPath.row];

  cell.unversityName.text = schoolName;
  //给cell添加线
  NSInteger rowNum = [tableView numberOfRowsInSection:indexPath.section];
  NSInteger lastRowIndex = rowNum - 1;
  if (indexPath.row == lastRowIndex) {
    cell.verticalLine.hidden = YES;
  } else {
    cell.verticalLine.hidden = NO;
  }
  return cell;
}
// cell的点击方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  //获取cell
  NSArray *array = [self.owner sectionDictionary][[self.owner sectionKeys][indexPath.section]];
  NSString *schoolName = array[indexPath.row];

  if (self.owner.onClickUniversityName) {
    self.owner.onClickUniversityName(schoolName);
  }
  [self.owner leftButtonPress];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 16)];
  bgView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Table_Title];
  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 100, 16)];
  titleLabel.textAlignment = NSTextAlignmentLeft;
  titleLabel.text = [self.owner sectionKeys][section];
  titleLabel.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  titleLabel.font = [UIFont systemFontOfSize:Font_Height_12_0];
  titleLabel.backgroundColor = [UIColor clearColor];
  [bgView addSubview:titleLabel];
  return bgView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 16.0f;
}

//侧栏索引点击方法
- (NSInteger)tableView:(UITableView *)tableView
    sectionForSectionIndexTitle:(NSString *)title
                        atIndex:(NSInteger)index {
  return index;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSArray *array = [self.owner sectionDictionary][[self.owner sectionKeys][section]];
  return [array count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 45.0f;
}

#pragma mark
#pragma mark 辅助函数

- (id)initWithViewController:(UIViewController *)viewController {
  if (self = [super initWithTableViewController:nil withDataArray:nil]) {
    _container = viewController;
  }
  return self;
}

- (NSString *)nibName {
  static NSString *cellNibName;
  if (cellNibName == nil) {
    cellNibName = NSStringFromClass([MatchUniversityNameCell class]);
  }
  return cellNibName;
}

- (MatchSelectUniversityViewController *)owner {
  return (MatchSelectUniversityViewController *)self.container;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  int contentOffsetY = scrollView.contentOffset.y;
  if (contentOffsetY != 0) {
    //隐藏键盘
    if (self.owner.sectionKeys.count > 0) {
      [self.owner.view endEditing:YES];
    }
  }
}

@end

#pragma mark
#pragma mark MatchSelectUniversityViewController

@implementation MatchSelectUniversityViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  //创建搜索栏
  [self createSearchBarView];
  //创建高校列表
  [self creatUniversityNameListTabelView];
  //创建没有搜素到内容的view
  [self creatSearchNotFoundView];

  UniversityInfoData *cachedData = [FileStoreUtil loadMatchUniversityNameList];
  //如果有缓存的话读取缓存
  if (cachedData && cachedData.dataArray.count > 0) {
    //读取缓存
    [self bindUniversityNameList:cachedData saveToCache:NO];

    //加载缓存成功，请求增量数据即可
    [self requestUniversityListWithFromId:cachedData.maxSortId ? cacheDataItem.maxSortId : DEFALT_FROM_ID];
  } else {
    //无缓存数据，请求全部数据
    [self requestUniversityListWithFromId:DEFALT_FROM_ID];
  }
}

/** 创建没有搜索的的小牛视图 */
- (void)creatSearchNotFoundView {
  self.notFoundView =
      [[[NSBundle mainBundle] loadNibNamed:@"SearchNotFoundView" owner:nil options:nil] lastObject];
  self.notFoundView.frame = self.clientView.frame;
  [self.view addSubview:self.notFoundView];
  self.notFoundView.hidden = YES;
}

#pragma mark---------------------------创建UI----------------------
/** 创建搜索栏 */
- (void)createSearchBarView {
  //隐藏菊花
  _indicatorView.hidden = YES;
  //创建搜索框
  CGFloat left = CGRectGetMaxX(_topToolBar.backButton.frame) + 1;
  UIView *backView =
      [[UIView alloc] initWithFrame:CGRectMake(left, _topToolBar.height - 40, _topToolBar.width - left * 2, 35)];
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
  //搜索内容输入框
  inputUniversityNameTF =
      [[ExtendedTextField alloc] initWithFrame:CGRectMake(10, 8, backView.frame.size.width - 20, 20)];
  inputUniversityNameTF.placeholder = @"请输入高校名称";
  inputUniversityNameTF.font = [UIFont systemFontOfSize:15.0f];
  inputUniversityNameTF.textAlignment = NSTextAlignmentLeft;
  inputUniversityNameTF.delegate = self;
  [inputUniversityNameTF setMaxLength:12];
  inputUniversityNameTF.returnKeyType = UIReturnKeySearch;
  [backView addSubview:inputUniversityNameTF];

  //搜索栏
  searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44.0f)];
  searchBar.delegate = self;
  [searchBar setTintColor:[Globle colorFromHexRGB:Color_Blue_but]];
  searchBar.hidden = YES;
  searchBar.backgroundColor = [UIColor clearColor];
  searchBar.placeholder = @"搜索联系人";
  searchBar.tintColor = [Globle colorFromHexRGB:@"086dae"];
  searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
  searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
  searchBar.keyboardType = UIKeyboardTypeDefault;
  [self.view addSubview:searchBar];
  universityNameTableVC.tableHeaderView = searchBar;
  //侧栏索引
  searchDisplay =
      [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];

  universityNameTableVC = searchDisplay.searchResultsTableView;

  //搜索按钮
  searchButton =
      [[UIButton alloc] initWithFrame:CGRectMake(backView.frame.size.width - 34, 0, 34, backView.frame.size.height)];
  [searchButton setBackgroundImage:[UIImage imageNamed:@"搜索记录背景"]
                          forState:UIControlStateNormal];
  [searchButton setImage:[UIImage imageNamed:@"搜索_不可点击状态"] forState:UIControlStateNormal];
  searchButton.userInteractionEnabled = NO;
  [searchButton addTarget:self
                   action:@selector(searchContentsBegin)
         forControlEvents:UIControlEventTouchUpInside];
  [backView addSubview:searchButton];
  // 蓝色的分割线
  UIView *lineView =
      [[UIView alloc] initWithFrame:CGRectMake(backView.frame.size.width - 34.5, 6, 0.5, backView.frame.size.height - 12)];
  lineView.backgroundColor = [Globle colorFromHexRGB:Color_Blue_but];
  [backView addSubview:lineView];
}

/** 开始进行搜素 */
- (void)searchContentsBegin {
  //键盘收回
  [self.view endEditing:YES];

  // filterDict搜索获得的数据，每次搜索之前清空
  [filterDict removeAllObjects];
  //获取输入的内容
  NSString *inputText = [inputUniversityNameTF.text trim];
  //判断是否为中文
  BOOL isChinese = [NSString validataInputIsChinese:inputText];
  NSString *searchStr;
  if (isChinese) {
    //如果是汉字先转换为字母
    searchStr = [[PinYinForObjc chineseConvertToPinYinHead:inputText] uppercaseString];
  } else {
    searchStr = [inputText uppercaseString];
  }
  //搜索获得的学校名字，values
  NSMutableArray *searchedValueArr = [NSMutableArray array];
  // if user input chinese, foreach item, judgy school name start with the chinese

  // if user input English letters, check school pinyinName start with the English letters
  for (UniversityInfoItem *item in cacheDataItem.dataArray) {
    //如果是汉字的处理
    if (isChinese && [item.schoolName hasPrefix:inputText]) {

      [searchedValueArr addObject:item.schoolName];
    } else if (!isChinese && [item.pinyinName hasPrefix:searchStr]) {
      [searchedValueArr addObject:item.schoolName];
    }
  }

  // if not found, return chinese or pinyinName contains the input
  if (searchedValueArr.count == 0 && inputText.length > 1) {
    for (UniversityInfoItem *item in cacheDataItem.dataArray) {
      //如果是汉字的处理
      if (isChinese &&
          [self containsAllLettersWithSeachText:item.schoolName withLetters:inputText]) {
        [searchedValueArr addObject:item.schoolName];
      } else if (!isChinese &&
                 [self containsAllLettersWithSeachText:item.pinyinName withLetters:searchStr]) {
        [searchedValueArr addObject:item.schoolName];
      }
    }
  }

  NSString *keyString = [searchStr substringToIndex:1];
  //获得搜索内容
  [filterDict setObject:searchedValueArr forKey:keyString];
  //刷新列表
  isFilter = NO;
  [self ifSearchedNotFoundWithSearchedValueArray:searchedValueArr];
  //清空数据源
  [universityNameTableVC reloadData];
}

- (BOOL)containsAllLettersWithSeachText:(NSString *)searchedText withLetters:(NSString *)letters {
  NSInteger fromIndex = 0;
  NSUInteger length = [searchedText length];

  for (int i = 0; i < letters.length; i++) {
    unichar letter = [letters characterAtIndex:i];
    for (; fromIndex < length; fromIndex++) {
      if (letter == [searchedText characterAtIndex:fromIndex]) {
        break;
      }
    }
    if (fromIndex == length) {
      return NO;
    }
  }
  return YES;
}

- (void)ifSearchedNotFoundWithSearchedValueArray:(NSArray *)searchedValueArray {
  if ([filterDict count] > 0 && searchedValueArray.count > 0) {
    self.notFoundView.hidden = YES;
    universityNameTableVC.hidden = NO;
  } else {
    universityNameTableVC.hidden = YES;
    self.notFoundView.hidden = NO;
  }
}

/** 输入栏扩大化按钮触发操作 */
- (void)inputTextFieldBecomeRespond {
  [inputUniversityNameTF becomeFirstResponder];
}

/** 创建高校名称tableview */
- (void)creatUniversityNameListTabelView {
  _tableAdatper = [[UniversityTableAdapter alloc] initWithViewController:self];
  searchDisplay.searchResultsDataSource = _tableAdatper;
  searchDisplay.searchResultsDelegate = _tableAdatper;

  universityNameTableVC = [[UITableView alloc] initWithFrame:self.clientView.bounds];
  universityNameTableVC.dataSource = _tableAdatper;
  universityNameTableVC.delegate = _tableAdatper;
  universityNameTableVC.backgroundColor = [UIColor clearColor];
  universityNameTableVC.separatorStyle = UITableViewCellSeparatorStyleNone;

  UINib *cellNib = [UINib nibWithNibName:_tableAdatper.nibName bundle:nil];
  [universityNameTableVC registerNib:cellNib forCellReuseIdentifier:_tableAdatper.nibName];
  [self.clientView addSubview:universityNameTableVC];
  //每个区的头高度 20
  universityNameTableVC.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  [universityNameTableVC setSectionIndexColor:[Globle colorFromHexRGB:Color_Blue_but]];
  //改变索引选中的背景颜色
  [universityNameTableVC setSectionIndexTrackingBackgroundColor:[UIColor clearColor]];
  if (SYSTEM_VERSION >= 7.0) {
    [universityNameTableVC setSectionIndexBackgroundColor:[UIColor clearColor]];
  }
}

#pragma mark--------------数据列表--------------------------------------
//首次请求所有数据；并添加缓存
- (void)requestUniversityListWithFromId:(NSString *)fromId {
  //判断网络
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  __weak MatchSelectUniversityViewController *weakSelf = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^() {
    MatchSelectUniversityViewController *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    UniversityInfoData *item = (UniversityInfoData *)obj;
    [self bindUniversityNameList:item saveToCache:YES];

  };
  [UniversityInfoData requetMathSelectUniversityNameWithFromId:fromId
                                                    withReqNum:DEFALT_REQ_NUM
                                                  withCallback:callback];
}

- (void)bindUniversityNameList:(UniversityInfoData *)item saveToCache:(BOOL)saveToCache {

  //  数据缓存后，依旧读取的缓存
  if (cacheDataItem == nil) {
    cacheDataItem = item;
  } else {
    [item.dataArray enumerateObjectsUsingBlock:^(UniversityInfoItem *schoolItem, NSUInteger idx, BOOL *stop) {
      if (cacheDataItem.codeDic[schoolItem.schoolCode] == nil) {
        [cacheDataItem.dataArray addObject:schoolItem];
        cacheDataItem.codeDic[schoolItem.schoolCode] = schoolItem.schoolCode;
      }
    }];
  }
  if (saveToCache) {
    //数据进行缓存
    [FileStoreUtil saveMatchUniversityNameList:item];
  }

  //创建数据
  [self dataProcessingMethod];
  [universityNameTableVC reloadData];
}

///数据处理
- (void)dataProcessingMethod {
  schoolNameDict = [[NSMutableDictionary alloc] init];
  //过滤后的符合条件的
  filterDict = [[NSMutableDictionary alloc] init];

  //是否过滤
  isFilter = YES;
  if (cacheDataItem.dataArray.count <= 0) {
    universityNameTableVC.hidden = YES;
  } else {
    universityNameTableVC.hidden = NO;
    ///创建表格数据（schoolNameDict）
    [cacheDataItem.dataArray enumerateObjectsUsingBlock:^(UniversityInfoItem *item, NSUInteger idx, BOOL *stop) {
      //存放value名字的汉语
      NSMutableArray *tempValueArr = schoolNameDict[item.indexLetter];
      if (tempValueArr == nil) {
        tempValueArr = [NSMutableArray array];
        //分类保，保存到字典
        schoolNameDict[item.indexLetter] = tempValueArr;
      }
      [tempValueArr addObject:item.schoolName];
    }];

    //循环完成后 得到所有的key值（section的值）
    headArrayKeys = schoolNameDict.allKeys;
    //如果索引有值的话，进行排序
    if (headArrayKeys.count > 0) {
      headArrayKeys = [headArrayKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    }
  }
}

- (NSArray *)sectionKeys {
  NSArray *keys = isFilter ? [self defaultKeys] : [self filteredKeys];
  return keys ? keys : @[];
}

- (NSDictionary *)sectionDictionary {
  NSMutableDictionary *keys = isFilter ? schoolNameDict : filterDict;
  return keys ? keys : @{};
}

/**
 * 排序 通过某种规则排序字符串SEL
 */
- (NSArray *)defaultKeys {
  return headArrayKeys;
}
/**
 * 过滤后的排序
 */
- (NSArray *)filteredKeys {
  return [filterDict.allKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

#pragma mark--------------textField--------------------------------------

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
  if ([string isEqualToString:@"\n"]) {
    return YES;
  }
  NSString *toBeString =
      [textField.text stringByReplacingCharactersInRange:range withString:string];
  //按钮背景变化（删除一位一位的删，跟踪）
  if ([toBeString length] == 0 && [textField.text length] == 1) {
    searchButton.userInteractionEnabled = NO;
    [searchButton setImage:[UIImage imageNamed:@"搜索_不可点击状态"] forState:UIControlStateNormal];
    //输入框为空的时候返回全部数据
    isFilter = YES;
    self.notFoundView.hidden = YES;
    universityNameTableVC.hidden = NO;
    [universityNameTableVC reloadData];
  } else {
    searchButton.userInteractionEnabled = YES;
    [searchButton setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
  }
  return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
  //停止表格滚动
  [universityNameTableVC setContentOffset:universityNameTableVC.contentOffset animated:NO];
  return YES;
}
/**键盘搜索按钮*/
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if ([textField.text length] > 0) {
    [self searchContentsBegin];
    return YES;
  } else {
    return NO;
  }
}

@end

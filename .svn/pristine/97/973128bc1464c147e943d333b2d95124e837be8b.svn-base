//
//  AddGroupVC.m
//  SimuStock
//
//  Created by jhss on 15/6/18.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "AddGroupVC.h"
#import "NSString+validate.h"
#import "NewShowLabel.h"
#import "NewSelfGroupData.h"
#import "BaseRequester.h"
#import "PortfolioStockModel.h"
#import "ModifySelfGroupData.h"
#import "NetLoadingWaitView.h"

///分组名称最大长度:  最长4个汉字/8个英文
static const NSInteger MAX_CHAR_NUM = 8;

@implementation AddGroupVC

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(textFieldEditChanged:)
             name:UITextFieldTextDidChangeNotification
           object:_groupNameTextField];

  [self setupSubView];
}

- (void)setupSubView {
  _groupNameTextField.delegate = self;
  _confirmButton.layer.cornerRadius = _confirmButton.bounds.size.height / 2;
  [_confirmButton.layer setMasksToBounds:YES];
  _confirmButton.normalBGColor = [Globle colorFromHexRGB:Color_WFOrange_btn];
  _confirmButton.highlightBGColor =
      [Globle colorFromHexRGB:Color_WFOrange_btnDown];

  [_confirmButton buttonWithTitle:@"确定"
               andNormaltextcolor:@"ffffff"
         andHightlightedTextColor:@"ffffff"];
}

//输入完后统计字符长度
- (void)textFieldEditChanged:(NSNotification *)obj {
  NSInteger length = [self getToInt:[(UITextField *)obj.object text]];
  _lengthLabel.text = [NSString stringWithFormat:@"%ld/8", (long)length];
  _groupNameTextField.textColor = (length > MAX_CHAR_NUM)
                                      ? [UIColor redColor]
                                      : [Globle colorFromHexRGB:Color_Black];
}

///计算字符串长度
- (NSUInteger)getToInt:(NSString *)strtemp {
  NSStringEncoding enc =
      CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
  NSData *data = [strtemp dataUsingEncoding:enc];
  return [data length];
}

//收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [_groupNameTextField resignFirstResponder];
}

- (IBAction)confirmButtonClick:(UIButton *)sender {
  [self.view endEditing:YES];

  NSString *context = [SimuUtil stringReplaceSpace:_groupNameTextField.text];
  if (context.length == 0) {
    [NewShowLabel setMessageContent:@"请输入分组名称"];
    return;
  }

  if ([self getToInt:context] > MAX_CHAR_NUM) {
    [NewShowLabel setMessageContent:@"请输入8位以内的字符"];
    return;
  }

  if (![NSString validataChineseOrEnglish:context]) {
    [NewShowLabel setMessageContent:@"分组名只能输入英文或中文"];
    return;
  }

  if (self.state == AddGroupState) {
    [NetLoadingWaitView startAnimating];
    [self doAddNewGroupRequest];
  } else if (self.state == ModifyGroupState) {
    QuerySelfStockElement *element =
        [[PortfolioStockManager currentPortfolioStockModel]
                .local findGroupById:_groupId];
    if ([element.groupName isEqualToString:context]) {
      [NewShowLabel setMessageContent:@"自选股分组名称未修改"];
      return;
    }
    //检测分组名是否已经存在
    if ([self isGroupNameExisted:context]) {
      [NewShowLabel setMessageContent:@"自选股分组名称重复"];
      return;
    }
    [NetLoadingWaitView startAnimating];
    [self doModifyNewGroupRequest];
  }
}

- (BOOL)isGroupNameExisted:(NSString *)newGroupName {
  __block BOOL existed = NO;
  NSMutableArray *groupArray =
      [PortfolioStockManager currentPortfolioStockModel].local.dataArray;
  [groupArray enumerateObjectsUsingBlock:^(QuerySelfStockElement *element,
                                           NSUInteger idx, BOOL *stop) {
    if ([element.groupName isEqualToString:newGroupName]) {
      existed = YES;
      *stop = YES;
    }
  }];
  return existed;
}

///修改分组请求
- (void)doModifyNewGroupRequest {

  if (![SimuUtil isExistNetwork]) {

    [NetLoadingWaitView stopAnimating];
    [NewShowLabel showNoNetworkTip];
    return;
  }
  NSString *groudName = [SimuUtil stringReplaceSpace:_groupNameTextField.text];

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];

  callback.onCheckQuitOrStopProgressBar = ^{
    if ([NetLoadingWaitView isAnimating]) {
      [NetLoadingWaitView stopAnimating];
    }
    return NO;
  };

  __weak AddGroupVC *weakSelf = self;
  callback.onSuccess = ^(NSObject *obj) {
    AddGroupVC *strongSelf = weakSelf;
    if (strongSelf) {
      if (strongSelf.modifyGroupSuccess) {
        strongSelf.modifyGroupSuccess();
      }

      QuerySelfStockElement *element =
          [[PortfolioStockManager currentPortfolioStockModel]
                  .local findGroupById:strongSelf.groupId];
      element.groupName = groudName;
      [[PortfolioStockManager currentPortfolioStockModel] save];
    }
  };

  [ModifySelfGroupData requestSelfStockGroupListDataWithGroupId:self.groupId
                                                  withGroupName:groudName
                                                       Callback:callback];
}

///新建分组请求
- (void)doAddNewGroupRequest {

  if (![SimuUtil isExistNetwork]) {

    [NetLoadingWaitView stopAnimating];
    [NewShowLabel showNoNetworkTip];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];

  callback.onCheckQuitOrStopProgressBar = ^{
    if ([NetLoadingWaitView isAnimating]) {
      [NetLoadingWaitView stopAnimating];
    }
    return NO;
  };

  __weak AddGroupVC *weakSelf = self;
  callback.onSuccess = ^(NSObject *obj) {
    AddGroupVC *strongSelf = weakSelf;
    if (strongSelf) {
      NSDictionary *result = ((NewSelfGroupData *)obj).dic[@"result"];
      QuerySelfStockElement *element = [[QuerySelfStockElement alloc] init];
      element.groupId = [result[@"groupId"] stringValue];
      element.groupName = strongSelf.groupNameTextField.text;
      [[PortfolioStockManager currentPortfolioStockModel]
              .local.dataArray addObject:element];
      NSLog(@"🐷添加分组成功！%@", element.groupId);
      [[PortfolioStockManager currentPortfolioStockModel] save];
      if (_addGroupSuccess) {
        _addGroupSuccess();
      }
    }
  };

  NSString *context = [SimuUtil stringReplaceSpace:_groupNameTextField.text];

  [NewSelfGroupData requestNewSelfGroupName:context WithCallback:callback];
}

@end

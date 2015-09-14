//
//  AddGroupClientVC.m
//  SimuStock
//
//  Created by jhss on 15/6/18.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "AddGroupClientVC.h"

@implementation AddGroupClientVC

- (instancetype)initWithGroupType:(OperateGroupType)type
                       andGroupId:(NSString *)groupId {
  if (self = [super init]) {
    _type = type;
    _groupId = groupId;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  //创建顶部topBar
  [self createTopBarView];
  //创建提醒设置CV
  [self createAddGrounpVC];
}

///创建顶部topBar
- (void)createTopBarView {
  if (_type == AddGroup) {
    [_topToolBar resetContentAndFlage:@"新建分组" Mode:TTBM_Mode_Leveltwo];
  } else if (_type == ModifyGroup) {
    [_topToolBar resetContentAndFlage:@"修改分组名称" Mode:TTBM_Mode_Leveltwo];
  }

  _indicatorView.hidden = YES;
}

///创建新建分组VC
- (void)createAddGrounpVC {
  if (!_addGroupVC) {
    _addGroupVC = [[AddGroupVC alloc] init];
  }

  __weak AddGroupClientVC *weakSelf = self;
  if (_type == AddGroup) {
    _addGroupVC.addGroupSuccess = ^() {
      [weakSelf leftButtonPress];
    };
    _addGroupVC.state = AddGroupState;
  } else if (_type == ModifyGroup) {
    _addGroupVC.modifyGroupSuccess = ^() {
      [weakSelf leftButtonPress];
    };
    _addGroupVC.groupId = _groupId;
    _addGroupVC.state = ModifyGroupState;
  }

  _addGroupVC.view.frame = self.clientView.bounds;
  [self.clientView addSubview:_addGroupVC.view];
  self.clientView.backgroundColor = [UIColor greenColor];
  _addGroupVC.groupNameTextField.text = _groupName;
  //向分组名编辑页面传递分组名，以便触发字数统计方法
  [[NSNotificationCenter defaultCenter]
      postNotificationName:UITextFieldTextDidChangeNotification
                    object:_addGroupVC.groupNameTextField];
}

@end

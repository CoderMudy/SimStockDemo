//
//  AddGroupVC.h
//  SimuStock
//
//  Created by jhss on 15/6/18.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Block.h"

typedef enum : NSUInteger {
  AddGroupState,    //添加分组
  ModifyGroupState, //修改分组
} OperateGroupState;

typedef void (^AddGroupSuccess)(void);
typedef void (^ModifyGroupSuccess)(void);

@interface AddGroupVC : UIViewController <UITextFieldDelegate>

@property(nonatomic) OperateGroupState state;
@property(strong, nonatomic) IBOutlet UILabel *lengthLabel;
/**新建分组名称*/
@property(weak, nonatomic) IBOutlet UITextField *groupNameTextField;
/**确认按钮*/
@property(weak, nonatomic) IBOutlet BGColorUIButton *confirmButton;
@property(nonatomic, strong) NSString *groupId;
@property(nonatomic, copy) AddGroupSuccess addGroupSuccess;
@property(nonatomic, copy) ModifyGroupSuccess modifyGroupSuccess;

@end

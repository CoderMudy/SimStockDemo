//
//  AddGroupClientVC.h
//  SimuStock
//
//  Created by jhss on 15/6/18.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "AddGroupVC.h"

typedef enum : NSUInteger {
  AddGroup,    //添加分组
  ModifyGroup, //修改分组
} OperateGroupType;

/*
 *  新建分组、修改分组
 */
@interface AddGroupClientVC : BaseViewController {
  AddGroupVC *_addGroupVC;
}

@property(nonatomic) OperateGroupType type;
@property(nonatomic, copy) NSString *groupId;
@property(nonatomic, copy) NSString *groupName;

- (instancetype)initWithGroupType:(OperateGroupType)type
                       andGroupId:(NSString *)groupId;

@end

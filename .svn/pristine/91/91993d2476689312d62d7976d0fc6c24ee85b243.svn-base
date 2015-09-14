//
//  MyGoldListWrapper.h
//  SimuStock
//
//  Created by jhss on 15/5/12.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
@class HttpRequestCallBack;
/**我的任务数据*/
@interface TaskListItem : NSObject <ParseJson>

/**任务描述*/
@property(nonatomic,strong)NSString *descrip;
/**完成任务可获得金币数*/
@property(nonatomic,retain)NSNumber *goldNum;
/**任务名称*/
@property(nonatomic,strong)NSString *name;
/**任务状态*/
@property(nonatomic,retain)NSNumber *taskStatus;
/**按钮文字*/
@property(nonatomic,strong)NSString *taskText;
/**任务类型*/
@property(nonatomic,retain)NSNumber *type;
/**可领取金币数*/
@property(nonatomic,retain)NSNumber *unReceiveGold;
/**任务引导地址*/
@property(nonatomic,strong)NSString *forwardUrl;
/**任务编码*/
@property(nonatomic,strong)NSString *taskId;


@end
@interface MyGoldListWrapper : JsonRequestObject<Collectionable>
/**指向当前签到天*/
@property(nonatomic,retain) NSNumber *arrowDay;
/**个人金币数*/
@property(nonatomic,retain) NSNumber *balanceNum;
/**明日签到可获得金币*/
@property(nonatomic,retain) NSNumber *tomorrowNum;
@property(strong, nonatomic) NSMutableArray *taskListArray;
/**获取我的任务列表*/
+ (void)requestmyTaskListWithCallback:(HttpRequestCallBack *)callback;

@end

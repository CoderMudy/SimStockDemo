//
//  MyGoldListWrapper.m
//  SimuStock
//
//  Created by jhss on 15/5/12.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MyGoldListWrapper.h"
#import "JsonFormatRequester.h"
#import "TaskIdUtil.h"
@implementation TaskListItem
-(void)jsonToObject:(NSDictionary *)dic{
  self.descrip = dic[@"description"];
  self.goldNum = dic[@"goldNum"];
  self.name = dic[@"name"];
  self.taskStatus = dic[@"taskStatus"];
  self.taskText = dic[@"taskText"];
  self.type = dic[@"type"];
  self.unReceiveGold = dic[@"unReceiveGold"];
  self.forwardUrl = dic[@"forwardUrl"];
  self.taskId = [SimuUtil changeIDtoStr:dic[@"taskId"]];

}
@end

@implementation MyGoldListWrapper

-(void)jsonToObject:(NSDictionary *)dic{
  [super jsonToObject:dic];
  self.arrowDay = dic[@"arrowDay"];
  self.balanceNum = dic[@"balanceNum"];
  self.tomorrowNum = dic[@"tomorrowNum"];
  NSArray *array = dic[@"taskList"];
  self.taskListArray = [[NSMutableArray alloc]init];
  for (NSDictionary *subDic in array) {
    TaskListItem *item =[[TaskListItem alloc]init];
    [item jsonToObject:subDic];
    if (![item.taskId isEqualToString:TASK_REAL_TRADE_SHOW_OFF] &&
        ![item.taskId isEqualToString:TASK_SHOW_ENTRUST]){
        [self.taskListArray addObject:item];
    }
  }
}

- (NSArray *)getArray {
  return _taskListArray;
}

+ (void)requestmyTaskListWithCallback:(HttpRequestCallBack *)callback {
  NSString *url = [user_address
                   stringByAppendingString:
                   @"jhss/task/myTaskList"];
  
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[MyGoldListWrapper class]
             withHttpRequestCallBack:callback];
}
@end

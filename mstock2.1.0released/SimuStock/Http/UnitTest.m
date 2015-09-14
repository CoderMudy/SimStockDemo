//
//  UnitTest.m
//  SimuStock
//
//  Created by Mac on 14/11/28.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

@implementation UnitTest

+ (void)testBuyTalk {

  NSString *content = @"#topic#买入股票\ue001： <stock name=\"浙江众成\"  "
                      @"code=\"21002522\" /> \n买入价格：18.17 "
                      @"\n买入数量：1300 \n成交金额：23621.00 \n手续费：0.00";
  [WeiboUtil parseWeiboRichContext:content];
}

//+ (void)testCoreData {
//  //获取Context
//  NSManagedObjectContext *context = [AppDelegate getManagedObjectContext];
//  //插入对象
//  Favorite *favorite = (Favorite *)
//      [NSEntityDescription insertNewObjectForEntityForName:@"Favorite"
//                                    inManagedObjectContext:context];
//  //设置属性
//  favorite.favoriteObjectid = @12;
//  favorite.favoriteObjectType = @1;
//  favorite.userId = [SimuUtil getUserID];
//  //保存插入数据
//  NSError *error;
//  if ([context save:&error]) {
//    NSLog(@"save success");
//  }
//
//  //生成查询请求
//  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//  //查询Favorite表
//  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Favorite"
//                                            inManagedObjectContext:context];
//  [fetchRequest setEntity:entity];
//  //执行查询
//  NSArray *fetchedObjects =
//      [context executeFetchRequest:fetchRequest error:&error];
//  //遍历查询结果
////  for (Favorite *info in fetchedObjects) {
//    //    NSLog(@"id: %@", info.favoriteObjectid);
//    //    NSLog(@"type: %@", info.favoriteObjectType);
//  }
//}
//
////赞股聊
//+ (NSError *)insertPraiseTStockId:(NSNumber *)tid {
//}

@end

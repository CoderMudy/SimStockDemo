//
//  event_view_log.m
//  DDMenuController
//
//  Created by moulin wang on 13-9-7.
//
//

#import "event_view_log.h"
#import "JSONKit.h"
//#import "JSON.h"
//判断是否用waifi上网
#import "ASIFormDataRequest.h"
//#import "WebServiceManager.h"
#import "BaseRequester.h"
#import "UIDevice+IdentifierAddition.h"
#import "JsonFormatRequester.h"
#import "OpenUDID.h"

// lq
#import "MobClick.h"

#define kTableName @"EVENT_LOG"
#define kDefDBName @"EVENT.sqlite"

@implementation logEventItem

@synthesize Type = lei_Type;
@synthesize Codes = lei_Codes;

- (id)initWithType:(Log_Type)type Code:(NSString *)codes {
  self = [super init];
  if (self) {
    lei_Type = type;
    //功能点编码
    self.Codes = codes;
  }
  return self;
}

@end

static event_view_log *_sharedDBManager = nil;

@implementation event_view_log
+ (event_view_log *)sharedManager {

  @synchronized([event_view_log class]) {
    if (!_sharedDBManager)
      _sharedDBManager = [[self alloc] init];
    return _sharedDBManager;
  }

  return nil;
}

+ (id)alloc {

  @synchronized([event_view_log class]) {
    NSAssert(
        _sharedDBManager == nil,
        @"Attempted to allocated a second instance________sql_data_log_server");
    _sharedDBManager = [super alloc];
    return _sharedDBManager;
  }
  return nil;
}

- (id)init {
  self = [super init];
  if (self) {

    eventItemArray = [[NSMutableArray alloc] initWithCapacity:5];
    int state = [self initializeDBWithName:kDefDBName];
    if (state == -1) {
      NSLog(@"数据库初始化失败");
    } else {
      NSLog(@"数据库初始化成功");
    }
    [self createDataBase];
    logTimer =
        [NSTimer scheduledTimerWithTimeInterval:3.0
                                         target:self
                                       selector:@selector(subThreadMethod:)
                                       userInfo:nil
                                        repeats:YES];
  }
  return self;
}
#pragma mark
#pragma mark 线程相关函数
- (void)subThreadMethod:(NSTimer *)theTimer {
  // return;
  if (theTimer != logTimer)
    return;
  @synchronized(eventItemArray) {
    if (eventItemArray == nil)
      return;
    if ([eventItemArray count] > 0) {
      // NSLog(@"线程执行一次");
      NSInteger count = [eventItemArray count];
      // logEventItem * item=[eventItemArray objectAtIndex:count-1];
      for (NSInteger i = count - 1; i >= 1; i--) {
        logEventItem *item = eventItemArray[i];
        if (item) {
          [self progressItem:item];
          [eventItemArray removeObject:item];
        }
      }
    }
  }
}

- (void)progressItem:(logEventItem *)Item {
  if (Item.Type == Log_Type_StartApp) {
    // app启动事件写入日志
    BOOL firstAC = NO;
    if ([Item.Codes isEqualToString:@"1"] == YES) {
      firstAC = YES;
    }
    [self addEventLogWithAppStart:firstAC];
  } else if (Item.Type == Log_Type_OnLineTime) {
    //在线时长事件写入日志
    [self addEventLogWithOnLine];
  } else if (Item.Type == Log_Type_Loginstart) {
    //登录事件事件写入日志
    [self addEventLogWithLogin];
  } else if (Item.Type == Log_Type_PV || Item.Type == Log_Type_Button) {
    [self addEventLogWithPVAndButton:(Log_Type)Item.Type andCode:Item.Codes];
  }
}

#pragma mark
/**
 * @brief 初始化数据库操作
 * @param name 数据库名称
 * @return 返回数据库初始化状态， 0 为 已经存在，1 为创建成功，-1 为创建失败
 */
- (int)initializeDBWithName:(NSString *)name {
  if (!name) {
    return -1; // 返回数据库创建失败
  }
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                       NSUserDomainMask, YES);
  NSString *documentDirectory = paths[0];
  // dbPath： 数据库路径，在Document中。
  _name = [documentDirectory stringByAppendingPathComponent:name];
  NSFileManager *fileManager = [NSFileManager defaultManager];
  BOOL exist = [fileManager fileExistsAtPath:_name];
  [self connect];
  if (!exist) {
    return 0;
  } else {
    return 1; // 返回 数据库已经存在
  }
}

/// 连接数据库
- (void)connect {
  if (!_db) {
    _db = [[FMDatabase alloc] initWithPath:_name];
  }
  if (![_db open]) {
    NSLog(@"不能打开数据库 ++%@", _name);
  }
}
/// 关闭连接
- (void)close {
  [_db close];
  _sharedDBManager = nil;
}
/**
 * @brief 创建数据库
 */
- (void)createDataBase {
  FMResultSet *set =
      [_db executeQuery:[NSString stringWithFormat:@"select count(*) from "
                                                   @"sqlite_master where type "
                                                   @"='table' and name = '%@'",
                                                   kTableName]];

  [set next];

  NSInteger count = [set intForColumnIndex:0];

  BOOL existTable = !!count;

  if (existTable) {
    // TODO:是否更新数据库
    NSLog(@"数据库已存在");
  } else {
    // TODO: 插入新的数据库
    NSString *sql = @"CREATE TABLE EVENT_LOG (uid INTEGER PRIMARY KEY "
                    @"AUTOINCREMENT  NOT NULL, type INTEGER,code TEXT,number "
                    @"INTEGER, description TEXT)";
    BOOL res = [_db executeUpdate:sql];
    if (!res) {
      NSLog(@"数据库创建失败");
    } else {
      NSLog(@"数据库创建成功");
    }
  }
}
/**
 * @brief 保存一条用户记录
 *
 * @param user 需要保存的用户数据
 */
- (void)saveUser:(Log_Type)type
       eventCode:(NSString *)code
     eventNumber:(NSInteger)number
  andDescription:(NSString *)description {
  NSString *insertSQL = [NSString
      stringWithFormat:@"INSERT INTO EVENT_LOG (type,code,number,description) "
                       @"VALUES(\"%d\",\"%@\",\"%ld\",\"%@\")",
                       type, code, (long)number, description];
  [_db executeUpdate:insertSQL];
}
/**
 * @brief 修改pv和按钮事件信息
 *
 * @param user 需要修改的用户信息
 */
- (void)mergeWithUser:(Log_Type)type
                 Code:(NSString *)code
            andNumber:(NSInteger)number {

  if (type == Log_Type_PV || type == Log_Type_Button) {
    // pv事件
    NSString *sql_str = [NSString
        stringWithFormat:
            @"UPDATE EVENT_LOG set number='%ld' where type='%d' and code='%@'",
            (long)number, type, code];
    [_db executeUpdate:sql_str];
  }
}
//
- (NSInteger)findNumberWithTypeAndCode:(Log_Type)type Code:(NSString *)code {
  NSString *query = [NSString
      stringWithFormat:
          @"SELECT number FROM EVENT_LOG where type='%d' and code='%@'", type,
          code];

  FMResultSet *rs = [_db executeQuery:query];
  int _number = -1;
  while ([rs next]) {
    _number = [rs intForColumn:@"number"];
  }
  [rs close];
  return _number;
}
- (NSArray *)findWithUid {
  NSString *query = @"SELECT * FROM EVENT_LOG ORDER BY uid DESC limit 20";

  FMResultSet *rs = [_db executeQuery:query];
  //    计入取出来的所有的uids
  NSMutableArray *array_uids = [[NSMutableArray alloc] initWithCapacity:0];
  NSMutableArray *array = [NSMutableArray arrayWithCapacity:[rs columnCount]];
  while ([rs next]) {
    NSMutableArray *user = [[NSMutableArray alloc] initWithCapacity:0];
    NSInteger uid = [rs intForColumn:@"uid"];
    [user addObject:@(uid)];
    //        存储uid
    [array_uids addObject:[NSString stringWithFormat:@"%ld", (long)uid]];

    int type = [rs intForColumn:@"type"];
    [user addObject:@(type)];
    NSString *code = [rs stringForColumn:@"code"];
    [user addObject:code];
    int number = [rs intForColumn:@"number"];
    [user addObject:@(number)];
    NSString *description = [rs stringForColumn:@"description"];
    [user addObject:description];
    [array addObject:user];
  }
  //    取出20条数据，然后先删除
  [self deleteUserWithIds:array_uids];
  [rs close];
  return array;
}
//删除多个uid行
- (void)deleteUserWithIds:(NSArray *)uids {
  NSString *query =
      [NSString stringWithFormat:@"DELETE FROM EVENT_LOG WHERE uid in ("];
  for (int i = 0; i < [uids count]; i++) {
    query = [NSString stringWithFormat:@"%@'%@'", query, uids[i]];
    if (i < [uids count] - 1) {
      query = [NSString stringWithFormat:@"%@,", query];
    }
  }
  query = [NSString stringWithFormat:@"%@);", query];
  [_db executeUpdate:query];
}

/**
 *     //查找同一种类型的数据有多少条
 *
 *
 *      查找
 **/
- (int)Count_data_sql_name {
  NSString *query =
      [NSString stringWithFormat:@"SELECT count(1) FROM EVENT_LOG"];
  FMResultSet *rs = [_db executeQuery:query];
  while ([rs next]) {
    return [rs intForColumnIndex:0];
  }
  return 0;
}
//-(int)count_EventWithTypeAndCode:(NSInteger)type andCode:(NSInteger)code
//{
//    NSString * query=[NSString stringWithFormat:@"SELECT count(1) FROM
//    EVENT_LOG type='%d' and code='%d'",type,code];
//    FMResultSet * rs = [_db executeQuery:query];
//    while ([rs next]) {
//        return  [rs intForColumnIndex:0];
//    }
//    return 0;
//
//}
#pragma mark
#pragma mark 对外接口
// app启动事件写到日志中
- (void)addAppStartEventToLog:(BOOL)isFirstAC {
  @synchronized(eventItemArray) {
    NSString *AC = @"-1";
    if (isFirstAC) {
      AC = @"1";
    }
    logEventItem *Item =
        [[logEventItem alloc] initWithType:Log_Type_StartApp Code:AC];
    [eventItemArray insertObject:Item atIndex:0];
    if (isFirstAC) {
      [event_view_log requestActivateNotify];
    }
  }
}
//登录事件写的日志中
- (void)addLoginEventToLog {
  @synchronized(eventItemArray) {
    logEventItem *Item =
        [[logEventItem alloc] initWithType:Log_Type_Loginstart Code:@"-1"];
    [eventItemArray insertObject:Item atIndex:0];
    [event_view_log requestRegisterNotify];
  }
}
//在线时长事件写到日志中
- (void)addOnLineEventToLog {
  @synchronized(eventItemArray) {
    logEventItem *Item =
        [[logEventItem alloc] initWithType:Log_Type_OnLineTime Code:@"-1"];
    [eventItemArray insertObject:Item atIndex:0];
  }
}
// pv和按钮事件写到日志中
- (void)addPVAndButtonEventToLog:(Log_Type)event_type
                         andCode:(NSString *)codes {
  @synchronized(eventItemArray) {
    // lq
    NSLog(@"codes = %@", codes);
    [MobClick event:codes];
    //[MobClick event:@"0002" label:@"炒股牛人"];
    logEventItem *Item =
        [[logEventItem alloc] initWithType:event_type Code:codes];
    [eventItemArray insertObject:Item atIndex:0];
  }
}

#pragma mark
#pragma mark 内部使用接口
//加入启动日志
- (void)addEventLogWithAppStart:(BOOL)isFirstActive {
  NSString *descraption = @"";
  // ak
  NSString *ak = [SimuUtil getAK];
  descraption = [descraption stringByAppendingString:@"ak:"];
  descraption = [descraption stringByAppendingString:ak];
  descraption = [descraption stringByAppendingString:@","];
  //启动时间
  NSString *vt = [SimuUtil getCorTime];
  descraption = [descraption stringByAppendingString:@"vt:"];
  descraption = [descraption stringByAppendingString:vt];
  descraption = [descraption stringByAppendingString:@","];
  //机器唯一码
  NSString *ucode = [SimuUtil getUUID];
  descraption = [descraption stringByAppendingString:@"ucode:"];
  descraption = [descraption stringByAppendingString:ucode];
  descraption = [descraption stringByAppendingString:@","];
  //设备机型
  NSString *dm = [SimuUtil getDevicesModel];
  descraption = [descraption stringByAppendingString:@"dm:"];
  descraption = [descraption stringByAppendingString:dm];
  descraption = [descraption stringByAppendingString:@","];
  //设备分辨率
  NSString *sr = [SimuUtil getScreenScol];
  descraption = [descraption stringByAppendingString:@"sr:"];
  descraption = [descraption stringByAppendingString:sr];
  descraption = [descraption stringByAppendingString:@","];
  //操作系统
  NSString *os = [SimuUtil getsystemVersions];
  descraption = [descraption stringByAppendingString:@"os:"];
  descraption = [descraption stringByAppendingString:os];
  descraption = [descraption stringByAppendingString:@","];
  //运营商
  NSString *op = [SimuUtil checkCarrier];
  descraption = [descraption stringByAppendingString:@"op:"];
  descraption = [descraption stringByAppendingString:op];
  descraption = [descraption stringByAppendingString:@","];
  //当前上网方式
  NSString *net = [AppDelegate getNetworkDescription];
  descraption = [descraption stringByAppendingString:@"net:"];
  descraption = [descraption stringByAppendingString:net];
  descraption = [descraption stringByAppendingString:@","];
  //是否首次激活
  NSString *ac = @"0";
  if (isFirstActive) {
    ac = @"1";
    descraption = [descraption stringByAppendingString:@"ac:"];
    descraption = [descraption stringByAppendingString:ac];
    descraption = [descraption stringByAppendingString:@","];
  }

  [self event_view_log:Log_Type_StartApp
               andCode:@"-1"
             andnumber:-1
       andDescripstion:descraption];
}
//在线时长日志纪
- (void)addEventLogWithOnLine {
  NSString *descraption = @"";
  // ak
  NSString *ak = [SimuUtil getAK];
  descraption = [descraption stringByAppendingString:@"ak:"];
  descraption = [descraption stringByAppendingString:ak];
  descraption = [descraption stringByAppendingString:@","];
  //会话id
  NSString *sessionid = [SimuUtil getSesionID];
  descraption = [descraption stringByAppendingString:@"sessionid:"];
  descraption = [descraption stringByAppendingString:sessionid];
  descraption = [descraption stringByAppendingString:@","];
  //登录用户
  NSString *uid = [SimuUtil getUserID];
  descraption = [descraption stringByAppendingString:@"uid:"];
  descraption = [descraption stringByAppendingString:uid];
  descraption = [descraption stringByAppendingString:@","];

  //用户登录时间
  NSString *st = [SimuUtil getLoginTime];
  if (st == nil) {
    st = @"111";
  }
  descraption = [descraption stringByAppendingString:@"st:"];
  descraption = [descraption stringByAppendingString:st];
  descraption = [descraption stringByAppendingString:@","];

  //退出时间
  NSString *et = [SimuUtil getCorTime];
  descraption = [descraption stringByAppendingString:@"et:"];
  descraption = [descraption stringByAppendingString:et];
  descraption = [descraption stringByAppendingString:@","];

  [self event_view_log:Log_Type_OnLineTime
               andCode:@"-1"
             andnumber:-1
       andDescripstion:descraption];
}
//登录日志纪录
- (void)addEventLogWithLogin {
  NSString *descraption = @"";
  // ak
  NSString *ak = [SimuUtil getAK];
  descraption = [descraption stringByAppendingString:@"ak:"];
  descraption = [descraption stringByAppendingString:ak];
  descraption = [descraption stringByAppendingString:@","];
  //登录用户
  NSString *uid = [SimuUtil getUserID];
  descraption = [descraption stringByAppendingString:@"uid:"];
  descraption = [descraption stringByAppendingString:uid];
  descraption = [descraption stringByAppendingString:@","];

  //登录时间
  NSString *et = [SimuUtil getCorTime];
  descraption = [descraption stringByAppendingString:@"vt:"];
  descraption = [descraption stringByAppendingString:et];
  descraption = [descraption stringByAppendingString:@","];

  [self event_view_log:Log_Type_Loginstart
               andCode:@"-1"
             andnumber:-1
       andDescripstion:descraption];
}
// pv事件和按钮事件
- (void)addEventLogWithPVAndButton:(Log_Type)event_type
                           andCode:(NSString *)codes {
  NSString *descraption = @"";
  // ak
  NSString *ak = [SimuUtil getAK];
  descraption = [descraption stringByAppendingString:@"ak:"];
  descraption = [descraption stringByAppendingString:ak];
  descraption = [descraption stringByAppendingString:@","];

  //    //会话id
  //    NSString * sessionid=[SimuUtil getSesionID];
  //    descraption=[descraption stringByAppendingString:@"sessionid:"];
  //    descraption=[descraption stringByAppendingString:sessionid];
  //    descraption=[descraption stringByAppendingString:@","];

  //登录用户
  NSString *uid = [SimuUtil getUserID];
  descraption = [descraption stringByAppendingString:@"uid:"];
  descraption = [descraption stringByAppendingString:uid];
  descraption = [descraption stringByAppendingString:@","];

  //    //type 类型
  //    NSString * type=[NSString stringWithFormat:@"%d",event_type];
  //    descraption=[descraption stringByAppendingString:@"type:"];
  //    descraption=[descraption stringByAppendingString:type];
  //    descraption=[descraption stringByAppendingString:@","];

  //功能编码
  NSString *code = [NSString stringWithFormat:@"%@", codes];
  descraption = [descraption stringByAppendingString:@"code:"];
  descraption = [descraption stringByAppendingString:code];
  descraption = [descraption stringByAppendingString:@","];

  //访问时间
  NSString *et = [SimuUtil getCorTime];
  descraption = [descraption stringByAppendingString:@"vt:"];
  descraption = [descraption stringByAppendingString:et];
  descraption = [descraption stringByAppendingString:@","];

  [self event_view_log:event_type
               andCode:codes
             andnumber:1
       andDescripstion:descraption];
}
/**
 *   操作event事件表
 **/
- (void)event_view_log:(Log_Type)type
               andCode:(NSString *)code
             andnumber:(NSInteger)number
       andDescripstion:(NSString *)description;
{
  if (type == Log_Type_Button) {
    // pv事件和按钮事件

    //查看是否有同类事件
    NSInteger numbers = [self findNumberWithTypeAndCode:type Code:code];
    if (numbers == -1) {
      //以前没有此类事件，加入数据库
      [self saveUser:type
               eventCode:code
             eventNumber:number
          andDescription:description];
    } else {
      //以前有此类事件，更新数据库纪录
      [self mergeWithUser:type Code:code andNumber:number + 1];
    }
  } else {
    [self saveUser:type
             eventCode:code
           eventNumber:number
        andDescription:description];
  }

  //    然后判断是否需要上传数据
  if ([self IS_NOT_Need_upload]) {

    //        说明需要上传数据了
    [self NEED_uploade];
  }
}

#pragma mark
#pragma mark 上传服务器相关函数
//需要上传后台服务器的时候
- (void)NEED_uploade {
  //从数据库取得数据
  NSArray *DataArray = [self findWithUid];
  if (DataArray == nil || [DataArray count] < 1)
    return;
  //纪录上传时间
  [self saveUpdataTime];

  // PV和按钮事件数组
  NSMutableArray *PVEventArray = [[NSMutableArray alloc] init];
  //事件统计按钮
  NSMutableArray *EventArray = [[NSMutableArray alloc] init];
  //启动app数组
  NSMutableArray *AppStartArray = [[NSMutableArray alloc] init];
  //在线时长数组
  NSMutableArray *onLineArray = [[NSMutableArray alloc] init];
  //登录事件数组
  NSMutableArray *loginArray = [[NSMutableArray alloc] init];

  for (NSArray *obj in DataArray) {
    //日志类型
    NSNumber *type = obj[1];
    NSInteger ntype = [type integerValue];
    //日志描述
    NSString *description = obj[4];
    //事件数量
    NSNumber *number = obj[3];
    NSInteger event_number = [number integerValue];
    if (ntype == Log_Type_Button) {
      //按钮事件
      if (event_number > 1) {
        NSString *event_numstr =
            [NSString stringWithFormat:@",num:%ld", (long)event_number];
        description = [description stringByAppendingString:event_numstr];
      }
      [EventArray addObject:description];
    } else if (ntype == Log_Type_PV) {
      // pv事件
      [PVEventArray addObject:description];
    } else if (ntype == Log_Type_StartApp) {
      //启动事件
      [AppStartArray addObject:description];
    } else if (ntype == Log_Type_OnLineTime) {
      //在线时长
      [onLineArray addObject:description];
    } else if (ntype == Log_Type_Loginstart) {
      //登录
      [loginArray addObject:description];
    }
  }

  //转化成json字符串
  // pv事件上传
  if ([PVEventArray count] > 0) {
    NSData *data = [self arrayToDataWithJson:PVEventArray];
    if (data) {
      [self sendTradeDataToServer:data WithUrl:@"pvstat"];
    }
  }
  if ([EventArray count] > 0) {
    NSData *data = [self arrayToDataWithJson:PVEventArray];
    if (data) {
      [self sendTradeDataToServer:data WithUrl:@"eventstat"];
    }
  }
  //开机事件上传
  if ([AppStartArray count] > 0) {
    NSData *data = [self arrayToDataWithJson:AppStartArray];
    if (data) {
      [self sendTradeDataToServer:data WithUrl:@"startapp"];
    }
  }
  //在线时长上传
  if ([onLineArray count] > 0) {
    NSData *data = [self arrayToDataWithJson:onLineArray];
    if (data) {
      [self sendTradeDataToServer:data WithUrl:@"onlinetime"];
    }
  }
  //登录事件上传
  if ([loginArray count] > 0) {
    NSData *data = [self arrayToDataWithJson:loginArray];
    if (data) {
      [self sendTradeDataToServer:data WithUrl:@"logonstat"];
    }
  }

  /*//  从数据库中获取，需要的数据
  //    存储，数据库中获取的数据
  NSMutableArray * array_upload_data=[[[NSMutableArray
  alloc]initWithCapacity:0]autorelease];
  NSArray * Ary=[self findWithUid];

  for (NSArray * ary in Ary) {

      if ([ary count]>=3) {

          NSDictionary * event_log_dic=[NSDictionary
  dictionaryWithObjectsAndKeys:ak_version,@"ak",name,@"code",[ary
  objectAtIndex:2],@"num", nil];
          [array_upload_data addObject:event_log_dic];

      }
  }

  [[WebServiceManager sharedManager]Log_post_data:@"eventstat"
  andData:array_upload_data completion:^(NSDictionary * dic)
  {

      if (dic && [[dic objectForKey:@"status"]isEqualToString:@"0000"]) {

      }
      else
      {
          //          从新将数据插回数据库
          [self ADD_saveUSer:array_upload_data];

      }

  }];*/
}
// array 数组转化成为json格式的数据
- (NSData *)arrayToDataWithJson:(NSArray *)inputarray {
  if (inputarray == nil || [inputarray count] == 0)
    return nil;
  NSMutableArray *jsonDataArray = [[NSMutableArray alloc] init];
  for (NSString *obj in inputarray) {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    NSArray *array = [obj componentsSeparatedByString:@","];
    for (NSString *value in array) {
      NSArray *KeyAndVaues = [value componentsSeparatedByString:@":"];
      if (KeyAndVaues && [KeyAndVaues count] == 2) {
        dictionary[KeyAndVaues[0]] = KeyAndVaues[1];
      }
    }
    [jsonDataArray addObject:dictionary];
  }
  NSDictionary *jsondic = @{ @"data" : jsonDataArray };
  NSData *data = [jsondic JSONData];
  // NSString * jsonstr=[jsondic JSONString];
  // NSString * datastr=[@"data=" stringByAppendingString:jsonstr];
  // NSData * data=[datastr dataUsingEncoding: NSUTF8StringEncoding];
  // NSLog(@"%@",datastr);
  return data;
}
////插入多条数据
//-(void)ADD_saveUSer:(NSArray *)array
//{
//    NSArray * main_array=[array copy];
//    for (NSDictionary * array_User in main_array) {
//        NSString * name=array_User[@"code"];
//        NSString * jsonStr=array_User[@"num"];
//
//        //        单条添加
//    [self saveUser:name  andDescription:jsonStr];
//    }
//    if (main_array) {
//        [main_array release];
//    }
//
//}

//是否需要上传——数据
- (BOOL)IS_NOT_Need_upload {
  // return NO;

  //        判断是否同属性的信息，是否超过20条
  int app_data = [self Count_data_sql_name];
  if (app_data >= 20) {
    return YES;
  } else
    return NO;
  //    判断是否用wifi上传
  if ([[AppDelegate getNetworkDescription] isEqualToString:@"wifi"]) {
    return YES;
  }
  //离上次上传时间间隔是否超过十分钟
  if ([self Judgment_time]) {
    return YES;
  }

  return NO;
}
//判断与上传一次，上传同种数据的类型的数据的时间，间隔是否大于10分钟
- (BOOL)Judgment_time {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *Last_Time = [defaults objectForKey:Log_UpTime];
  //   如果是没有上次上传时间，就不上传
  if ([Last_Time floatValue] == 0.0) {
    return NO;
  }

  //获取系统当前的时间戳
  NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
  NSTimeInterval a = [dat timeIntervalSince1970] * 1000;

  if (a - [Last_Time longLongValue] > 600) {
    return YES;
  }
  return NO;
}
- (void)saveUpdataTime {
  NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
  NSTimeInterval a = [date timeIntervalSince1970] * 1000;
  // NSString *timeString = [NSString stringWithFormat:@"%f", a];
  int64_t dTime = [@(a) longLongValue]; // 将double转为int64_t型
  NSString *curTime = [NSString stringWithFormat:@"%llu", dTime];
  [[NSUserDefaults standardUserDefaults] setObject:curTime forKey:Log_UpTime];
}

#pragma mark
#pragma mark 网络函数
- (void)sendTradeDataToServer:(NSData *)data WithUrl:(NSString *)url {
  if (data == nil)
    return;
  NSString *host = [NSString
      stringWithFormat:@"%@%@/%@/", stat_address, @"stat",
                       url]; // stat_address／／@"http://118.186.136.13:80/"
  NSLog(@"url=%@", host);
  ASIFormDataRequest *request =
      [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:host]];
  //超时时间
  request.timeOutSeconds = 40;
  //定义异步方法
  [request setDelegate:self];
  [request setDidFailSelector:@selector(SendSelfCodesDidFailed:)];
  [request setDidFinishSelector:@selector(SendSelfCodesDidSuccess:)];
  //用户自定义数据   字典类型  （可选）
  //设定http头
  NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
  //设定ak
  NSString *AK = [SimuUtil getAK];
  [headers setValue:AK forKey:@"ak"];
  if (![[SimuUtil getSesionID] isEqualToString:@"-1"]) {
    //设定会话id
    NSString *ID = [SimuUtil getSesionID];
    [headers setValue:ID forKey:@"sessionid"];
    //用户id
    NSString *M_userID = [SimuUtil getUserID];
    [headers setValue:M_userID forKey:@"userid"];
  }
  //加入时间
  NSString *m_time = [SimuUtil getCorTime];
  // NSString * m_value=[m_time stringByAppendingString:sid];
  [headers setValue:m_time forKey:@"ts"];
  request.requestHeaders = headers;

  // post的数据
  NSString *aString =
      [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  [request setPostValue:aString forKey:@"data"];
  //[request appendPostData:data];
  //开始执行
  [request startAsynchronous];
}

+ (void)requestActivateNotify {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];

  callback.onSuccess = ^(NSObject *obj) {
    NSLog(@"");
  };
  callback.onFailed = ^{
  };
  callback.onError = ^(BaseRequestObject *err, NSException *ex) {
  };

  NSString *url =
      [stat_address stringByAppendingString:@"stat/promote/activateNotify"];
  UIDevice *dv = [UIDevice currentDevice];
  NSDictionary *dic = @{
    @"udid" : [dv macaddress],
    @"idfa" : [dv idfa],
    @"idfv" : [dv idfv],
    @"app" : [SimuUtil appid],
    @"openudid" : [OpenUDID value],
    @"activateFlag" : @"1"
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:dic
              withRequestObjectClass:[JsonRequestObject class]
             withHttpRequestCallBack:callback];
}

+ (void)requestRegisterNotify {
  NSString *key = @"first_register";
  NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];

  if ([settings objectForKey:key]) {
    return;
  }
  [settings setObject:@"1" forKey:key];
  [settings synchronize];

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];

  callback.onSuccess = ^(NSObject *obj) {
    NSLog(@"");
  };
  callback.onFailed = ^{
  };
  callback.onError = ^(BaseRequestObject *err, NSException *ex) {
  };

  NSString *url =
      [stat_address stringByAppendingString:@"stat/promote/registNotify"];
  UIDevice *dv = [UIDevice currentDevice];
  NSDictionary *dic = @{
    @"udid" : [dv macaddress],
    @"idfa" : [dv idfa],
    @"idfv" : [dv idfv],
    @"app" : [SimuUtil appid],
    @"userid" : [SimuUtil getUserID],
    @"openudid" : [OpenUDID value],
    @"ak" : [SimuUtil getAK],
    @"resolution" : [SimuUtil getScreenScol],
    @"os" : [SimuUtil getsystemVersions],
    @"model" : [SimuUtil getDevicesModel],
    @"operator" : [SimuUtil checkCarrier],
    @"net" : [SimuUtil getNetWorkType],
    @"registerFlag" : @"1",
    @"activateFlag" : @"1"
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:dic
              withRequestObjectClass:[JsonRequestObject class]
             withHttpRequestCallBack:callback];
}

@end

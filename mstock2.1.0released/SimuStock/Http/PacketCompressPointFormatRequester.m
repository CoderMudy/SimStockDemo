//
//  CompressPointStreamFormatRequester.m
//  SimuStock
//
//  Created by Mac on 14-10-31.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "PacketCompressPointFormatRequester.h"
#import "CustomPageData.h"

// public final static byte COMPRESS_LONG='1';
// public final static byte COMPRESS_INT='2';
// public final static byte COMPRESS_DATETIME='3';

@implementation PacketCompressPointFormatRequester
- (void)requestFinished:(ASIHTTPRequest *)request {
  NSData *data = [request responseData];
  if (data == nil || [data length] < 2) {
    [self handleFailed];
    return;
  }
  @try {

    NSMutableArray *tableDataArray =
        [PacketCompressPointFormatRequester parseComPointPackageTables:data];
    NSString *status = nil;
    NSString *message = nil;

    for (int t = 0; t < [tableDataArray count]; t++) {
      //取得状态
      PacketTableData *m_paketTableData = tableDataArray[t];
      if ([m_paketTableData.tableName isEqualToString:@"status"]) {
        //状态表格
        NSMutableDictionary *dataDictionary =
            (m_paketTableData.tableItemDataArray)[0];
        status = dataDictionary[@"status"];
        message = dataDictionary[@"message"];
        if (![status isEqualToString:@"0000"]) {
          BaseRequestObject *requestObject = [[BaseRequestObject alloc] init];
          requestObject.status = status;
          requestObject.message = message;
          [self handleError:requestObject orException:nil];
          return;
        }
      }
    }
    //解析
    id<ParseCompressPointPacket> object =
            (id <ParseCompressPointPacket>) [[self.requestObjectClass alloc] init];
    if (object &&
        [object respondsToSelector:@selector(packetCompressPointToObject:)]) {
      [object packetCompressPointToObject:tableDataArray];
      BaseRequestObject *requestObject = object;
      requestObject.status = status;
      [self handleSuccess:requestObject];
    } else {
      NSException *ex =
          [NSException exceptionWithName:@"NO method found: streamToObject"
                                  reason:@"NO method found: streamToObject"
                                userInfo:nil];
      [self handleError:nil orException:ex];
    }
  } @catch (NSException *ex) {
    [self handleError:nil orException:ex];
  } @finally {
    [[BaseRequester getRequestCache] removeObject:self];
  }
}

//解析逐点压缩表格
+ (NSMutableArray *)parseComPointPackageTables:(NSData *)data {
  NSInteger expectedLength = [data readIntAt:0];
  if (expectedLength != data.length) {
    NSString *responseString =
        [[NSString alloc] initWithBytes:[data bytes]
                                 length:[data length]
                               encoding:NSUTF8StringEncoding];
    NSLog(@"%@", responseString);
    [NSException raise:@"invalid data exception"
                format:@"real length: %ld, expected length: %ld",
                       (long)data.length, (long)expectedLength];
  }

  //取得数据总长度
  int m_corIndex = 12;

  //表格的数量
  int m_tableNumber = [data readIntAt:m_corIndex];
  m_corIndex += 4;

  NSMutableArray *tableDataArray = [[NSMutableArray alloc] init];

  for (int i = 0; i < m_tableNumber; i++) {
    PacketTableData *m_paketTableData = [[PacketTableData alloc] init];
    if (m_paketTableData) {
      //取得表名长度，可能返回返回负数
      uint title_lenth = [data readIntAt:m_corIndex];
      m_corIndex += 4;
      //表格名称
      NSString *table_name = [[NSString alloc]
          initWithData:[data subdataWithRange:NSMakeRange(m_corIndex,
                                                          title_lenth)]
              encoding:NSUTF8StringEncoding];
      m_paketTableData.tableName = table_name;
      m_corIndex += title_lenth;
      //表格字段数
      int field_Number = [data readIntAt:m_corIndex];
      m_paketTableData.tableConnumber = field_Number;
      m_corIndex += 4;
      //表格字段解析
      for (int j = 0; j < field_Number; j++) {
        tableFeildItemInfo *m_feildItemInfo = [[tableFeildItemInfo alloc] init];
        //解析是否有注释
        Byte *lenth = (Byte *)[data bytes];
        int expflage = lenth[m_corIndex] & 0xff;
        m_corIndex++;
          m_feildItemInfo.isNotes = expflage == 1;

        //解析字段类型
        NSString *fieltype = [[NSString alloc]
            initWithData:[data subdataWithRange:NSMakeRange(m_corIndex, 1)]
                encoding:NSUTF8StringEncoding];
        // NSLog(@"type: %@",fieltype);
        m_feildItemInfo.type = fieltype;
        m_corIndex++;

        //解析精度
        short Precision = [data readshortAt:m_corIndex];
        m_feildItemInfo.precision = Precision;
        m_corIndex += 2;

        //解析字段最大长度
        int feildmaxlenth = [data readIntAt:m_corIndex];
        m_feildItemInfo.maxLenth = feildmaxlenth;
        m_corIndex += 4;

        //解析字段名称
        int name_lenth = [data readIntAt:m_corIndex];
        m_feildItemInfo.namelenth = name_lenth;
        m_corIndex += 4;
        NSString *feilname = [[NSString alloc]
            initWithData:[data subdataWithRange:NSMakeRange(m_corIndex,
                                                            name_lenth)]
                encoding:NSUTF8StringEncoding];
        // NSLog(@"name: %@",feilname);
        m_feildItemInfo.name = feilname;
        m_corIndex += name_lenth;

        //注释解析
        if (m_feildItemInfo.isNotes) {
          int explain_lenth = [data readIntAt:m_corIndex];
          m_feildItemInfo.notesLenth = explain_lenth;
          m_corIndex += 4;
          NSString *feilname = [[NSString alloc]
              initWithData:[data subdataWithRange:NSMakeRange(m_corIndex,
                                                              explain_lenth)]
                  encoding:NSUTF8StringEncoding];
          m_feildItemInfo.notescontent = feilname;
          m_corIndex += explain_lenth;
        }
        [m_paketTableData.fieldItemArray addObject:m_feildItemInfo];
      }
      //解析行数据
      int lineNumber = [data readIntAt:m_corIndex];
      m_paketTableData.tableLinenumber = lineNumber;
      m_corIndex += 4;
      NSMutableDictionary *preValueDic = [[NSMutableDictionary alloc] init];
      for (int k = 0; k < m_paketTableData.tableLinenumber; k++) {
        NSMutableDictionary *dataDictionary =
            [[NSMutableDictionary alloc] init];
        //得到变量类型
        for (int h = 0; h < field_Number; h++) {
          tableFeildItemInfo *itemInfo = (m_paketTableData.fieldItemArray)[h];
          if ([itemInfo.type isEqualToString:@"S"] ||
              [itemInfo.type isEqualToString:@"s"]) {
            //字符串类型
            int contentlent = [data readIntAt:m_corIndex];
            m_corIndex += 4;
            NSString *content = [[NSString alloc]
                initWithData:[data subdataWithRange:NSMakeRange(m_corIndex,
                                                                contentlent)]
                    encoding:NSUTF8StringEncoding];
            dataDictionary[itemInfo.name] = content;
            m_corIndex += contentlent;

          } else if ([itemInfo.type isEqualToString:@"N"] ||
                     [itemInfo.type isEqualToString:@"n"]) {
            int content = [data readIntAt:m_corIndex];
            m_corIndex += 4;
            NSNumber *numberdata = @(content);
            dataDictionary[itemInfo.name] = numberdata;
          } else if ([itemInfo.type isEqualToString:@"L"] ||
                     [itemInfo.type isEqualToString:@"l"]) {
            long long content = [data readInt64At:m_corIndex];
            // NSLog(@"L %@",itemInfo.name);
            m_corIndex += 8;
            NSNumber *numberdata = @(content);
            dataDictionary[itemInfo.name] = numberdata;
          } else if ([itemInfo.type isEqualToString:@"F"] ||
                     [itemInfo.type isEqualToString:@"f"]) {
            float content = [data readFloatAt:m_corIndex];
            // NSLog(@"L %@",itemInfo.name);
            m_corIndex += 4;
            NSNumber *numberdata = @(content);
            dataDictionary[itemInfo.name] = numberdata;
          } else if ([itemInfo.type isEqualToString:@"T"] ||
                     [itemInfo.type isEqualToString:@"t"]) {
            short content = [data readshortAt:m_corIndex];
            // NSLog(@"L %@",itemInfo.name);
            m_corIndex += 2;
            NSNumber *numberdata = @(content);
            dataDictionary[itemInfo.name] = numberdata;
          } else if ([itemInfo.type isEqualToString:@"D"] ||
                     [itemInfo.type isEqualToString:@"d"]) {
            double content = [data readDoubleAt:m_corIndex];
            // NSLog(@"L %@",itemInfo.name);
            m_corIndex += 8;
            NSNumber *numberdata = @(content);
            dataDictionary[itemInfo.name] = numberdata;
          } else if ([itemInfo.type isEqualToString:@"2"]) { // COMPRESS_INT
            NSNumber *preValue = preValueDic[itemInfo.name];
            //逐点压缩INT类型（COMPRESS_INT）
            NSNumber *temp = @(m_corIndex);
            NSInteger content = [data readCompressIntAt:&temp];
            NSNumber *numberdata =
                @(preValue ? [preValue integerValue] + content : content);
            preValueDic[itemInfo.name] = numberdata;
            dataDictionary[itemInfo.name] = numberdata;
            m_corIndex = [temp intValue];
          } else if ([itemInfo.type isEqualToString:@"1"]) {
            NSNumber *preValue = preValueDic[itemInfo.name];
            //逐点压缩long 类型（COMPRESS_LONG）
            NSNumber *temp = @(m_corIndex);
            long long content = [data readCompressLongAt:&temp];
            NSNumber *numberdata =
                @(preValue ? [preValue longLongValue] + content : content);
            preValueDic[itemInfo.name] = numberdata;
            dataDictionary[itemInfo.name] = numberdata;
            m_corIndex = [temp intValue];
          } else if ([itemInfo.type isEqualToString:@"3"]) {
            //逐点压缩日期时间格式（COMPRESS_DATETIME
            //使用int型表示yyyyMMddhhmiss）
            long long content = [data readCompressDateTimeAt:m_corIndex];
            m_corIndex = m_corIndex + 4;
            NSNumber *numberdata = @(content);
            dataDictionary[itemInfo.name] = numberdata;
          } else if ([itemInfo.type isEqualToString:@"Y"] ||
                     [itemInfo.type isEqualToString:@"y"]) {
            int content = [data readByteAt:m_corIndex];
            m_corIndex += 1;
            NSNumber *numberdata = @(content);
            dataDictionary[itemInfo.name] = numberdata;
          } else {
            NSLog(@"error, not support type");
          }
        }
        if (dataDictionary) {
          [m_paketTableData.tableItemDataArray addObject:dataDictionary];
        }
      }
    }
    if (m_paketTableData) {
      [tableDataArray addObject:m_paketTableData];
    }
  }
  return tableDataArray;
}

@end

//
//  ThirdWayLogon.h
//  SimuStock
//
//  Created by jhss on 14-7-7.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

//三方
#import <ShareSDK/ISSViewDelegate.h>
#import "LogonDataParsingClass.h"
#import "UserConst.h"

//个人信息页面_三方绑定数据回传
@protocol bindThirdPartLoginDelegate <NSObject>

- (void)rowThirdPartWithToken:(NSString *)token
                   withOpenId:(NSString *)openId
                 withNickName:(NSString *)nickName
                     withType:(UserBindType)type;

@end

@interface ThirdWayLogon : NSObject <ISSViewDelegate> {

  //保存三方获得的信息
  NSString *tempUid;
  NSString *tempNickName;
  NSString *tempHeadImage;
  NSString *tempThirdPartImage;
  NSString *tempTitleName;
  NSInteger tempShareType;
  LogonDataParsingClass *logonDataParsing;
}
//个人信息页面_三方绑定数据回传
@property(weak, nonatomic) id<bindThirdPartLoginDelegate> delegate;
//三方授权过程
- (void)getAuthWithShareType:(NSInteger)shareType;
//切换界面
- (void)thirdPartRegister:(NSString *)uid
             withNickName:(NSString *)nickName
            withHeadImage:(NSString *)headImage
            withShareType:(NSInteger)shareType
                withToken:(NSString *)token
       withThirdPartImage:(NSString *)thirdPartImage
                withTitle:(NSString *)titleName;
@end

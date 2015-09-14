#import <Foundation/Foundation.h>
@protocol tztkhcertdelegate;
@interface tztkhInfosec : NSObject <tztSocketDataDelegate>
{
    int _ntztHqReq;
    NSString* _strUserID; //用户ID
    int _nCertType; //证书类型 0 中登 1 自建
    NSString* _strCertSN;  //证书SN号
    NSString* _strCertDN; //证书DN号
    NSMutableDictionary* _certInfo; //证书请求信息
    id<tztkhcertdelegate> _tztdelegate;
}
@property (nonatomic,assign) id <tztkhcertdelegate> tztdelegate;
@property (nonatomic,retain) NSString* strUserID;
@property (nonatomic,retain) NSString* strCardID;
@property  int nCertType;
@property (nonatomic,retain) NSString* strCertSN;
@property (nonatomic,retain) NSString* strCertDN;
@property (nonatomic,retain) NSMutableDictionary* certInfo;
@property (nonatomic) BOOL   bHaveCert;

+(tztkhInfosec*)getShareInfosec;
+(void)freeShareInstance;
//导入证书   身份证号    证书申请其他信息
-(BOOL)importCert:(NSString*)strUserID certType:(int)nCertType info:(NSMutableDictionary*)certInfo;
//签名  原文  签名方式
- (NSString*)tztCertSignData:(NSString*)strOrgData nSignType:(int)nSignType;
//验签
- (BOOL)tztCertverifyData:(NSData *)OrgData SignedData:(NSData *)SignatureData nSignType:(int)nSignType;

//使用证书   身份证号    证书其他信息  判断是否存在对应证书
-(BOOL)useCert:(NSString*)strUserID certType:(int)nCertType info:(NSMutableDictionary*)certInfo;
@end

@protocol tztkhcertdelegate<NSObject>
@required
- (void)tztkhcertimport:(BOOL)bsucess withUserID:(NSString *)strUserID;//
@end
extern tztkhInfosec    *g_tztkhInfosec;

@interface tztHTTPData (tztkhInfosec)
-(NSDictionary *)tztSignatureData:(NSString*)strData;
//根据dict字典，对各个key所对应的value单独进行签名，并存放到字典中返回
-(NSDictionary*)tztHttpGetSignatureData:(NSMutableDictionary*)dict;
@end
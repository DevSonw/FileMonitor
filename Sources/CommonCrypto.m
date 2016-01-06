#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>
#import "HookUtil.h"

#import "IFHOOK.h"
#ifdef Crypto_IF_HOOK

//#define DEBUG_INFO   //启动调试信息



//HOOK_CFUNCTION(int, (void *)0xFFFFFFFF, sqlite3_create_function,  sqlite3 *db, const char *zFunctionName, int nArg, int eTextRep, void *pApp, void (*xFunc)(sqlite3_context* context,int,sqlite3_value** value), void (*xStep)(sqlite3_context*,int,sqlite3_value**), void (*xFinal)(sqlite3_context*))
//{
//#ifdef DEBUG_INFO
//    NSLog(@"~~~~~~~~~~~~~~~~~~~15");
//#endif
//
//    NSString *data = @"";
//    if ( zFunctionName) {
//        data = [[NSString alloc] initWithFormat:@"%s",zFunctionName];
//    }
//    _Logsqlite3(@"sqlite3_create_function",data);
//
//    return _sqlite3_create_function(db,zFunctionName,nArg,eTextRep,pApp,xFunc,xStep,xFinal);
//}
/*
 SQLITE_API int sqlite3_create_function(
 sqlite3 *db,
 const char *zFunctionName,
 int nArg,
 int eTextRep,
 void *pApp,
 void (*xFunc)(sqlite3_context*,int,sqlite3_value**),
 void (*xStep)(sqlite3_context*,int,sqlite3_value**),
 void (*xFinal)(sqlite3_context*)
 );
 */

//HOOK_CFUNCTION(const unsigned char *, (void *)0xFFFFFFFF, sqlite3_column_blob, sqlite3_stmt* stmt, int iCol)
//{
//#ifdef DEBUG_INFO
//    NSLog(@"~~~~~~~~~~~~~~~~~~~16");
//#endif
//    const char *str = _sqlite3_column_blob(stmt,iCol);
//    NSString *data;
//    if (str) {
//        data = [[NSString alloc] initWithUTF8String:str];
//    }
//    return str;
//}
//SQLITE_API const void *sqlite3_column_blob(sqlite3_stmt*, int iCol);


/*
 CCCryptorStatus
 CCCrypt(CCOperation op, CCAlgorithm alg, CCOptions options, const void *key, size_t keyLength, const void *iv, const void *dataIn, size_t dataInLength, void *dataOut, size_t dataOutAvailable, size_t *dataOutMoved);
*/


HOOK_CFUNCTION(CCCryptorStatus, RTLD_DEFAULT, CCCrypt,CCOperation op, CCAlgorithm alg, CCOptions options,const void *key, size_t keyLength, const void *iv,const void *dataIn, size_t dataInLength, void *dataOut,size_t dataOutAvailable, size_t *dataOutMoved)
{
    CCCryptorStatus status = _CCCrypt(op,alg,options,key,keyLength,iv,dataIn,dataInLength,dataOut,dataOutAvailable,dataOutMoved);
    //1 kCCEncrypt
    //2 kCCAlgorithmAES128
    //3 kCCOptionPKCS7Padding kCCOptionECBMode
    //5 kCCBlockSizeAES128
    //7 buf1
    //8 length1
    //9 buf2
    //10 length2
    //11 readed
     _LogCommonCypto(@"CCCrypt",op,alg,options,key,iv,dataIn,dataInLength,dataOut,dataOutAvailable,dataOutMoved);
    
    return status;
//void LogCommonCypto(NSString * funcName,CCOperation op, CCAlgorithm alg, CCOptions options, const void *key, const void *dataIn, size_t dataInLength, void *dataOut, size_t dataOutAvailable, size_t *dataOutMoved, void *returnAddress);

}

//void CCHmac(
//            CCHmacAlgorithm algorithm,  /* kCCHmacSHA1, kCCHmacMD5 */
//            const void *key,
//            size_t keyLength,           /* length of key in bytes */
//            const void *data,
//            size_t dataLength,          /* length of data in bytes */
//            void *macOut)               /* MAC written here */

HOOK_CFUNCTION(void, RTLD_DEFAULT, CCHmac,\
               CCHmacAlgorithm algorithm, \
               const void *key, \
               size_t keyLength,const void *data,size_t dataLength,void *macOut)
{
    //    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    //    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    //    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    //    CC_SHA1(data.bytes, data.length, digest);
    //    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    //    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    //        [output appendFormat:@"%02x", digest[i]];
    //    return output;
    
    //    kCCHmacAlgSHA1,
    //    kCCHmacAlgMD5,
    //    kCCHmacAlgSHA256,
    //    kCCHmacAlgSHA384,
    //    kCCHmacAlgSHA512,
    //    kCCHmacAlgSHA224
    
//    NSLog(@"_CCHmac_CCHmac_CCHmac_CCHmac_");
    _CCHmac(algorithm,key,keyLength,data,dataLength,macOut);
    
    unsigned char*result = (unsigned char*)macOut;
    if (keyLength && dataLength)
    {
        NSString *NS_result =  [NSString stringWithFormat:\
    @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",\
                                result[0], result[1], result[2], result[3],\
                                result[4], result[5], result[6], result[7],\
                                result[8], result[9], result[10], result[11],\
                                result[12], result[13], result[14], result[15],\
                                result[16], result[17], result[18], result[19]];
        
        NSString *NS_data =[NSString stringWithFormat:@"%s",data];
        
        NSString *NS_key = [NSString stringWithFormat:@"%s",key];
        
        _LogCommonCyptoCCHmac(@"CCHmac",algorithm,NS_key,NS_data,NS_result);
    }
}




//void CCHmacInit(
//                CCHmacContext *ctx,
//                CCHmacAlgorithm algorithm,
//                const void *key,
//                size_t keyLength)

HOOK_CFUNCTION(void, RTLD_DEFAULT, CCHmacInit,\
               CCHmacContext *ctx, \
               CCHmacAlgorithm algorithm, \
               const void *key,size_t keyLength)
{
    //    kCCHmacAlgSHA1,
    //    kCCHmacAlgMD5,
    //    kCCHmacAlgSHA256,
    //    kCCHmacAlgSHA384,
    //    kCCHmacAlgSHA512,
    //    kCCHmacAlgSHA224
    
    _CCHmacInit(ctx,algorithm,key,keyLength);
    
    char keytmp[1024];
    memset(keytmp, 0, 1024);
    memcpy(keytmp, key, keyLength);
    
    
    
    if (keyLength)
    {
        NSString *NS_Key = [NSString stringWithFormat:@"%s",keytmp];
        
        _LogCommonCyptoCCHmac(@"CCHmacInit",algorithm,NS_Key,@"",@"");
    }
}


//void CCHmacUpdate(
//                  CCHmacContext *ctx,
//                  const void *data,
//                  size_t dataLength)
HOOK_CFUNCTION(void, RTLD_DEFAULT, CCHmacUpdate,\
               CCHmacContext *ctx, \
               const void *data, \
               size_t dataLength)
{
    //    kCCHmacAlgSHA1,
    //    kCCHmacAlgMD5,
    //    kCCHmacAlgSHA256,
    //    kCCHmacAlgSHA384,
    //    kCCHmacAlgSHA512,
    //    kCCHmacAlgSHA224
    //    notknow
    _CCHmacUpdate(ctx,data,dataLength);
    
    
    if (dataLength)
    {
        NSString *NS_data = [NSString stringWithFormat:@"%s",data];
       _LogCommonCyptoCCHmac(@"CCHmacUpdate",6,@"",NS_data,@"");
    }
}

//void CCHmacFinal(
//                 CCHmacContext *ctx,
//                 void *macOut)

HOOK_CFUNCTION(void, RTLD_DEFAULT, CCHmacFinal,\
               CCHmacContext *ctx, \
               void *macOut)
{
    //    kCCHmacAlgSHA1,
    //    kCCHmacAlgMD5,
    //    kCCHmacAlgSHA256,
    //    kCCHmacAlgSHA384,
    //    kCCHmacAlgSHA512,
    //    kCCHmacAlgSHA224
    //    notknow
    
    _CCHmacFinal(ctx,macOut);
    unsigned char    *mac = macOut;
    
    char  hexmac[ 2 * CC_MD5_DIGEST_LENGTH + 1 ];
    char *p = hexmac;
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++ ) {
        snprintf( p, 3, "%02x", mac[ i ] );
        p += 2;
    }

        NSString *NS_result = [NSString stringWithFormat:@"%s",hexmac];
        _LogCommonCyptoCCHmac(@"CCHmacFinal",6,@"",@"",NS_result);
}

//rr = sizeof(buf);
//CCHmacUpdate( &ctx, buf, rr );
//
//CCHmacFinal( &ctx, mac );
//
//p = hexmac;
//for ( i = 0; i < CC_MD5_DIGEST_LENGTH; i++ ) {
//    snprintf( p, 3, "%02x", mac[ i ] );
//    p += 2;
//}
//
//printf( "%s\n", hexmac );


#endif

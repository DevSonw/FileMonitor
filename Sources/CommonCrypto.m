#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

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


HOOK_CFUNCTION(CCCryptorStatus, (void *)0xFFFFFFFF, CCCrypt,CCOperation op, CCAlgorithm alg, CCOptions options,const void *key, size_t keyLength, const void *iv,const void *dataIn, size_t dataInLength, void *dataOut,size_t dataOutAvailable, size_t *dataOutMoved)
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
     _LogCommonCypto(@"CCCrypt",op,alg,options,key,dataIn,dataInLength,dataOut,dataOutAvailable,dataOutMoved);
    
    return status;
//void LogCommonCypto(NSString * funcName,CCOperation op, CCAlgorithm alg, CCOptions options, const void *key, const void *dataIn, size_t dataInLength, void *dataOut, size_t dataOutAvailable, size_t *dataOutMoved, void *returnAddress);

}

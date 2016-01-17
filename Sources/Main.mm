
#import <vector>
#import <algorithm>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "SQLiteStorage.h"



//#define NSLog(...)

//目录
#define GLobalFileMonitorPath @"%@uiautomation/%@_%@.filemon",NSTemporaryDirectory(),NSProcessInfo.processInfo.processName,GET_TIME_APPVERSION()

#define GET_TIME_APPVERSION() [NSString stringWithFormat:@"%@__%@_%@",[SQLiteStorage getBackgroundRealDateString],\
[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"],\
[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]

NSString *FileMonitorPath = [NSString stringWithFormat:GLobalFileMonitorPath];

#define GLobalFileMonitorPath @"%@PrivateAPI/%@_%@.privateapi",NSTemporaryDirectory(),NSProcessInfo.processInfo.processName,GET_TIME_APPVERSION()

NSString *PrivateAPIPath = [NSString stringWithFormat:GLobalFileMonitorPath];

int print_once = 1;//print log path once


//排除私有API调用函数的数据用的。
int PrivateAPIindexdlopen = 0;
NSMutableArray *dlopen_excludeArray = [NSMutableArray arrayWithCapacity:10];

int PrivateAPIindexdlsym = 0;
NSMutableArray *dlsym_excludeArray = [NSMutableArray arrayWithCapacity:10];

int PrivateAPIindexobjc_getClass = 0;
NSMutableArray *objc_getClass_excludeArray = [NSMutableArray arrayWithCapacity:10];

int PrivateAPIindexobjc_NSClassFromString = 0;
NSMutableArray *NSClassFromString_excludeArray = [NSMutableArray arrayWithCapacity:10];

int PrivateAPIindexobjc_NSSelectorFromString = 0;
NSMutableArray *NSSelectorFromString_excludeArray = [NSMutableArray arrayWithCapacity:10];


//noninstance:
int PrivateAPIindexobjc_noninstance_performSelector_ = 0;
NSMutableArray *noninstance_performSelector_excludeArray = [NSMutableArray arrayWithCapacity:10];

int PrivateAPIindexobjc_noninstance_performSelector_withObject_ = 0;
NSMutableArray *noninstance_performSelector_withObject_excludeArray = [NSMutableArray arrayWithCapacity:10];

int PrivateAPIindexobjc_noninstance_performSelector_withObject_withObject_ = 0;
NSMutableArray *noninstance_performSelector_withObject_withObject_excludeArray = [NSMutableArray arrayWithCapacity:10];


//instance:
        //protocol
int PrivateAPIindexobjc_performSelector_ = 0;
NSMutableArray *performSelector_excludeArray = [NSMutableArray arrayWithCapacity:10];

int PrivateAPIindexobjc_performSelector_withObject_ = 0;
NSMutableArray *performSelector_withObject_excludeArray = [NSMutableArray arrayWithCapacity:10];

int PrivateAPIindexobjc_performSelector_withObject_withObject_ = 0;
NSMutableArray *performSelector_withObject_withObject_excludeArray = [NSMutableArray arrayWithCapacity:10];

        //normal
int PrivateAPIindexobjc_performSelector_withObject_afterDelay_ = 0;
NSMutableArray *performSelector_withObject_afterDelay_excludeArray = [NSMutableArray arrayWithCapacity:10];

int PrivateAPIindexobjc_performSelector_withObject_afterDelay_inModes_ = 0;
NSMutableArray *performSelector_withObject_afterDelay_inModes_excludeArray = [NSMutableArray arrayWithCapacity:10];

int PrivateAPIindexobjc_performSelectorOnMainThread_withObject_waitUntilDone_ = 0;
NSMutableArray *performSelectorOnMainThread_withObject_waitUntilDone_excludeArray = [NSMutableArray arrayWithCapacity:10];

int PrivateAPIindexobjc_performSelectorOnMainThread_withObject_waitUntilDone_modes_ = 0;
NSMutableArray *performSelectorOnMainThread_withObject_waitUntilDone_modes_excludeArray = [NSMutableArray arrayWithCapacity:10];

int PrivateAPIindexobjc_performSelector_onThread_withObject_waitUntilDone_ = 0;
NSMutableArray *performSelector_onThread_withObject_waitUntilDone_excludeArray = [NSMutableArray arrayWithCapacity:10];

int PrivateAPIindexobjc_performSelector_onThread_withObject_waitUntilDone_modes_ = 0;
NSMutableArray *performSelector_onThread_withObject_waitUntilDone_modes_excludeArray = [NSMutableArray arrayWithCapacity:10];

int PrivateAPIindexobjc_performSelectorInBackground_withObject_ = 0;
NSMutableArray *performSelectorInBackground_withObject_excludeArray = [NSMutableArray arrayWithCapacity:10];


//排除所有的文件名的操作的过滤   正则表达式
//has pathExtension-> lowercaseString
//NSPredicate
//NSString *string = @"asdasdasdasd.png.exe";
//NSString *pathexten = [string pathExtension];
NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(png|bmp|jpg|tiff|gif|pcx|tga|exif|fpx|svg|psd|cdr|pcd|dxf|ufo|eps|ai|raw|mp3|mp4|avi|3gp|rmvb|wmv|mkv|mpg|vob|mov|flv)" options:0 error:nil];

//NSArray *checkingResults  = [regex matchesInString:pathexten options:0 range:NSMakeRange(0, [pathexten length])];
//for (NSTextCheckingResult *match in checkingResults)
//{
//    NSLog(@"%@",[pathexten substringWithRange:match.range]);
//}



BOOL SQLITERECORD = 0; //1 数据库记录 0 xml记录

//可选项
//#define PRINT_FILTERINFO //自动过滤多余的信息 如 加载nib等
#define PRINT_REPEAT_INFO //自动过滤重复的信息
#define PRINT_PATH_MODE  //动态观看日志信息
//#define DEBUG_MODE

//#define WRITE_TO_FILE //查看写文件成功

SQLiteStorage *traceStorage;
NSString *objectTypeNotSupported = @"FileMon - Not supported";


int PRINT_GLOBAL_COUNT = 0;
int WRITE_GLOBAL_COUNT = 0; //写的次数

NSMutableArray *HASHarray =   [[NSMutableArray alloc]init];
NSMutableArray *logfilesarray=[[NSMutableArray alloc]init];

#define PRINT_DATA(mode,funcname,pathordata) {PRINT_GLOBAL_COUNT++;NSLog(@"%-5d---FileMonitor---%@ : %@ : %@",PRINT_GLOBAL_COUNT,mode,funcname,pathordata);}





#define ____________________________________________________________________________________________________HTTP

#import "AFHTTPRequestOperationManager.h"
#import "ASIHTTPRequest.h"

//目录
#define GLobalHttpMonitorPath @"%@httplog/%@_%@.httplog",NSTemporaryDirectory(),NSProcessInfo.processInfo.processName,GET_TIME_APPVERSION()

NSString *HttpMonitorPath = [NSString stringWithFormat:GLobalHttpMonitorPath];

#define PRINT_HTTP_DATA(mode,data,pathordata) NSLog(@"---------------------------HTTPMonitor---%@ %@ : %@",mode,data,pathordata);


//
#if __cplusplus
extern "C"
#endif
void LogRequest(NSURLRequest *request,NSString* FuncName, void *returnAddress)
{
    static int s_index = 0;
    static NSString *_logDir = nil;
    static std::vector<NSURLRequest *> _requests;
    
    if (_logDir == nil)
    {
        _logDir = [[NSString alloc] initWithFormat:HttpMonitorPath];
        NSLog(@"HttpMonitorPath = %@",_logDir);
        [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if ([request respondsToSelector:@selector(HTTPMethod)])
    {
        if (std::find(_requests.begin(), _requests.end(), request) == _requests.end())
        {
            NSString *file = [NSString stringWithFormat:@"%@/%03d=%@.plist", _logDir, s_index++, NSUrlPath([request.URL.host stringByAppendingString:request.URL.path])];
            
            NSDictionary *param = [NSDictionary dictionaryWithObject:request.URL.absoluteString forKey:FuncName];
            NSLog(@"param = %@\nfile = %@",param,file);
            
            PRINT_HTTP_DATA(FuncName,param,file);
            [param writeToFile:file  atomically:YES];
            
        }
    }
}

//
#if __cplusplus
extern "C"
#endif
void LogRequestASIHTTPRequest(ASIHTTPRequest *request, void *returnAddress)
{
    static int s_index = 0;
    static NSString *_logDir = nil;
    
    if (_logDir == nil)
    {
        _logDir = [[NSString alloc] initWithFormat:HttpMonitorPath];
        NSLog(@"HttpMonitorPath = %@",_logDir);
        [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if ([request respondsToSelector:@selector(requestMethod)])
    {
        NSDictionary *param = [NSDictionary dictionaryWithObject:request.url.absoluteString forKey:@"ASIHTTPRequest"];
        
        NSString *file = [NSString stringWithFormat:@"%@/%03d=ASI%@.plist", _logDir, s_index++, NSUrlPath([request.url.host stringByAppendingString:request.url.path])];
        PRINT_HTTP_DATA(@"ASIHTTPRequest",param,file);
        BOOL flag = [param writeToFile:file  atomically:NO];
        
    }
}


//
#if __cplusplus
extern "C"
#endif
void LogAFHTTPRequestOperationManager(AFHTTPRequestOperationManager* OperationManager,NSString *method,NSString *URLString,id parameters, void *returnAddress)
{
    static int s_index = 0;
    static NSString *_logDir = nil;
    
    if (_logDir == nil)
    {
        _logDir = [[NSString alloc] initWithFormat:HttpMonitorPath];
        NSLog(@"HttpMonitorPath = %@",_logDir);
        [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if (method)
    {
        NSDictionary *param = [NSDictionary dictionaryWithObject:URLString forKey:@"AFHTTPRequest"];
        
        NSString *file = [NSString stringWithFormat:@"%@/%03d=AFH%@.plist", _logDir, s_index++, NSUrlPath([[[OperationManager baseURL] host] stringByAppendingString:[[OperationManager baseURL] path]])];
        
        PRINT_HTTP_DATA(@"AFHTTPRequest",param,file);
        BOOL flag = [param writeToFile:file  atomically:NO];
        
    }
}













#define ____________________________________________________________________________________________________NSArray
void LogNSArrayWrite(NSString *funcName,id data,NSString *path, void *returnAddress)
{
    @try {
#ifdef DEBUG_MODE
        NSLog(@"data = %@",data);
        NSLog(@"path = %@",path);
#endif
        if (data == nil) {
#ifdef PRINT_PATH_MODE
            PRINT_DATA(@"Write data=nil",path,[@"NSArray_" stringByAppendingString:funcName])
#endif
            return;
        }
        static NSString *_logDir = nil;
        static int s_index=0,s_index2 = 0,s_index3 = 0,s_index4 = 0,s_index5 = 0;
        
        if (_logDir == nil)
        {
            _logDir = [[NSString alloc] initWithFormat:FileMonitorPath];
            BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
            
            if (!isDirExist) {
                [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
            }
        }
        
        //NSString *tmpPath = [[path description] stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
        NSString *filepath = nil;
        
        if ([funcName isEqualToString:@"arrayWithContentsOfURL_"]) {
            filepath = [NSString stringWithFormat:@"%@/NSData_%@_%04d.plist",_logDir,funcName, s_index++];
        }
        else if([funcName isEqualToString:@"arrayWithContentsOfFile_"])
        {
            filepath = [NSString stringWithFormat:@"%@/NSData_%@_%04d.plist",_logDir,funcName, s_index2++];
        }
        else if([funcName isEqualToString:@"writeToURL_atomically_"])
        {
            filepath = [NSString stringWithFormat:@"%@/NSData_%@_%04d.plist",_logDir,funcName, s_index4++];
        }
        else if([funcName isEqualToString:@"writeToFile_atomically_"])
        {
            filepath = [NSString stringWithFormat:@"%@/NSData_%@_%04d.plist",_logDir,funcName, s_index5++];
        }
        else
            return;
        
#ifdef DEBUG_MODE
        NSLog(@"filepath=%@",filepath);
        NSLog(@"[[data description] class] = %@",[[data description] class]);
        NSLog(@"data = %@",data);
#endif
        
#ifdef PRINT_PATH_MODE
        PRINT_DATA(@"Write",path,[@"NSArray_" stringByAppendingString:funcName])
#endif
        
        NSDictionary *dic0 = [NSDictionary dictionaryWithObject:data forKey:path];
        NSString *funcName2 = [NSString stringWithFormat:@"NSData_%@",funcName];
        
        NSDictionary *dic = [NSDictionary dictionaryWithObject:dic0 forKey:funcName2];
        
        //    FILE *fp;
        //    fp=fopen([filepath UTF8String], "w");
        //    if ([dic description]) {
        //        fprintf(fp, "%s",[[dic description] UTF8String]);
        //    }
        //    fclose(fp);
        
        if (filepath) {
            BOOL flag = [dic writeToFile:filepath
                              atomically:YES];
#ifdef WRITE_TO_FILE
            NSLog(@"1flag = %d",flag);
#endif
        }
    }
    @catch (NSException *exception) {
        NSLog(@"LogNSArrayWrite exception reason=%@",exception.reason);
    }
    @finally {
        return;
    }

}

#define ____________________________________________________________________________________________________NSFileHandle NSData printable
void LogNSFileHandle(NSString * funcName,id data, void *returnAddress)
{
    PRINT_DATA(@"filehandle",funcName,data);
}


#define ____________________________________________________________________________________________________json
void LogNSJSONSerialization(NSString * funcName,id source,id dest, void *returnAddress)
{
    NSString *filepath;
    static NSString *_logDir = nil;
    static int s_index=0,s_index2 = 0,s_index3 = 0,s_index4 = 0;
    
    if (_logDir == nil)
    {
        _logDir = [[NSString alloc] initWithFormat:FileMonitorPath];
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    
//    NSLog(@"source = %@  dest = %@",[source class],[dest class]);
//    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:dest];
//    id data = [NSKeyedUnarchiver unarchiveObjectWithData:dest];
//    NSData *data = [NSData dataWithBytes:[dest bytes] length:[dest length]];

//    NSString * strdata = [[NSString alloc] initWithData:dest encoding:NSUTF8StringEncoding];
    
    NSString *source2 = [NSString stringWithFormat:@"%@",source];
    NSDictionary *dicData = [NSDictionary dictionaryWithObject:dest forKey:source2];
    
//    NSMutableDictionary *tmp = [NSMutableDictionary dictionaryWithObject:@"1" forKey:@"2"];
//    if ([source isKindOfClass:[tmp class]]) {
//        NSDictionary *source2 = [[NSDictionary alloc] initWithDictionary:source];
//        NSDictionary *dic = [NSDictionary dictionaryWithObject:@"123" forKey:@"456"];
//        dicData = [NSDictionary dictionaryWithObject:dest forKey:dic];
//        NSLog(@"source2 = %@",[source2 class]);
//    }
//    else
//    {
//        dicData = [NSDictionary dictionaryWithObject:dest forKey:source];
//        NSLog(@"source = %@",[source class]);
//    }

    if (dicData == nil) {
        return;
    }
    if ([funcName isEqualToString:@"JSONObjectWithData_options_error_"]) {
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index++];
    }
    else if([funcName isEqualToString:@"dataWithJSONObject_options_error_"]) {
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index2++];
    }
    else if([funcName isEqualToString:@"JSONLit_objectFromJSONStringWithParseOptions_error_"]) {
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index3++];
    }
    else if([funcName isEqualToString:@"JSONLit_objectFromJSONDataWithParseOptions_error_"]) {
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index4++];
    }
    else{
        NSLog(@"error~~~  %@",funcName);
        return;
    }
    
#ifdef PRINT_PATH_MODE
//    PRINT_DATA(funcName,@"read_the_log_file",filepath)
        PRINT_DATA(funcName,@"read_the_log_file",dicData)
#endif
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:dicData forKey:funcName];
    
    
    @synchronized(filepath)
    {
        BOOL flag = [dic writeToFile:filepath
                          atomically:YES];
#ifdef WRITE_TO_FILE
        NSLog(@"2flag = %d",flag);
#endif
    }
//        raise( SIGINT );
}



#define ____________________________________________________________________________________________________md5
void LogHash(NSString * funcName,NSString *source,NSString *dest, void *returnAddress)
{
#ifdef PRINT_REPEAT_INFO
    @synchronized(HASHarray)
    {
    for (NSString *item in HASHarray){
        if ([item isEqualToString:source])
        {
            return;
        }
    }
    [HASHarray addObject:source];
    }
#endif
    NSString *filepath;
    static NSString *_logDir = nil;
    static int s_index=0,s_index2 = 0,s_index3 = 0,s_index4 = 0,s_index5 = 0,s_index6 = 0;
    
    if (_logDir == nil)
    {
        _logDir = [[NSString alloc] initWithFormat:FileMonitorPath];
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }

    NSDictionary *dicData = [NSDictionary dictionaryWithObject:dest forKey:source];

    if (dicData == nil) {
        return;
    }
    if ([funcName isEqualToString:@"CC_MD5"]) {
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index++];
    }
    else if([funcName isEqualToString:@"CC_SHA1"]) {
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index2++];
    }
    else{
        NSLog(@"error~~~  %@",funcName);
        return;
    }
    
#ifdef PRINT_PATH_MODE
    PRINT_DATA(funcName,dicData,filepath)
#endif
    
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:dicData forKey:funcName];
    BOOL flag = [dic writeToFile:filepath
                      atomically:YES];
#ifdef WRITE_TO_FILE
    NSLog(@"3flag = %d",flag);
#endif
}



#define ____________________________________________________________________________________________________base64
void LogBase64(NSString * funcName,NSString *data1,id data2, void *returnAddress)
{
    NSString *filepath;
    static NSString *_logDir = nil;
    static int s_index=0,s_index2 = 0,s_index3 = 0,s_index4 = 0,s_index5 = 0,s_index6 = 0;
    
    if (_logDir == nil)
    {
        _logDir = [[NSString alloc] initWithFormat:FileMonitorPath];
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    
    NSDictionary *dicData = [NSDictionary dictionaryWithObject:data2 forKey:data1];
#ifdef PRINT_PATH_MODE
    PRINT_DATA(@"Base64",funcName,dicData)
#endif
   
    if (dicData == nil) {
        return;
    }
    
    if ([funcName isEqualToString:@"base64Encoding"]) {
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index++];
    }
    else if ([funcName isEqualToString:@"base64EncodedDataWithOptions_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index2++];
    }
    else if ([funcName isEqualToString:@"base64EncodedStringWithOptions_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index3++];
    }//
    else if ([funcName isEqualToString:@"initWithBase64EncodedData_options_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index4++];
    }
    else if ([funcName isEqualToString:@"initWithBase64EncodedString_options_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index5++];
    }
    else if ([funcName isEqualToString:@"initWithBase64Encoding_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index6++];
    }
    else{
        NSLog(@"error~~~ LogBase64");
        return;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:dicData forKey:funcName];
    BOOL flag = [dic writeToFile:filepath
                      atomically:YES];
#ifdef WRITE_TO_FILE
    NSLog(@"4flag = %d",flag);
#endif
}



#define ____________________________________________________________________________________________________CommonCrypto

void LogCommonCyptoCCHmac(NSString * funcName,CCHmacAlgorithm algorithm,NSString* NS_key,NSString* NS_data,NSString* NS_result,void *returnAddress)
{
    NSString *filepath;
    static NSString *_logDir = nil;
    static int s_index=0,s_index2 = 0,s_index3 = 0,s_index4 = 0,s_index5 = 0,s_index6 = 0,s_index7 = 0,s_index8 = 0,s_index9 = 0,s_index10 = 0,s_index11 = 0;
    
    if (_logDir == nil)
    {
        _logDir = [[NSString alloc] initWithFormat:FileMonitorPath];
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }

    /*
     kCCHmacAlgSHA1,
     kCCHmacAlgMD5,
     kCCHmacAlgSHA256,
     kCCHmacAlgSHA384,
     kCCHmacAlgSHA512,
     kCCHmacAlgSHA224
     */
    NSString * Cypto_alg = nil;
    switch (algorithm) {
        case 0:
            Cypto_alg = @"kCCHmacAlgSHA1";
            break;
        case 1:
            Cypto_alg = @"kCCHmacAlgMD5";
            break;
        case 2:
            Cypto_alg = @"kCCHmacAlgSHA256";
            break;
        case 3:
            Cypto_alg = @"kCCHmacAlgSHA384";
            break;
        case 4:
            Cypto_alg = @"kCCHmacAlgSHA512";
            break;
        case 5:
            Cypto_alg = @"kCCHmacAlgSHA224";
            break;
        case 6:
            Cypto_alg = @"kCCHmacAlgNotKnow";
            break;
        default:
#ifdef PRINT_PATH_MODE
            PRINT_DATA(@"CCHmac",funcName,@"alg_error~");
#endif
            return;
            break;
    }
    
    NSArray *arryData =     [NSArray arrayWithObjects:Cypto_alg,     NS_key,      NS_data      , NS_result      ,nil];
    NSArray *arryDataKeys = [NSArray arrayWithObjects:@"CCHmac_alg",@"NS_key",@"NS_data",@"NS_result",nil];
    
    NSDictionary *dicData = [NSDictionary dictionaryWithObjects:arryData forKeys:arryDataKeys];
    
    
#ifdef PRINT_PATH_MODE
    PRINT_DATA(@"CCHmac",funcName,dicData)
#endif
    
    if (dicData == nil) {
        return;
    }
    if ([funcName isEqualToString:@"CCHmac"]) {
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index++];
    }
    else if ([funcName isEqualToString:@"CCHmacInit"]) {
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index2++];
    }
    else if ([funcName isEqualToString:@"CCHmacUpdate"]) {
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index3++];
    }
    else if ([funcName isEqualToString:@"CCHmacFinal"]) {
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index4++];
    }
    else{
        NSLog(@"funcName~~~");
        return;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:dicData forKey:funcName];
    
    BOOL flag = [dic writeToFile:filepath
                      atomically:YES];
#ifdef WRITE_TO_FILE
    NSLog(@"5flag = %d",flag);
#endif
}


void LogCommonCypto(NSString * funcName,CCOperation op, CCAlgorithm alg, CCOptions options, const void *key, const void *iv, const void *dataIn, size_t dataInLength, void *dataOut, size_t dataOutAvailable, size_t *dataOutMoved, void *returnAddress)
{
    //1 kCCEncrypt
    //2 kCCAlgorithmAES128
    //3 kCCOptionPKCS7Padding kCCOptionECBMode
    //5 kCCBlockSizeAES128
    //7 buf1
    //8 length1
    //9 buf2
    //10 length2
    //11 readed
    NSString *filepath;
    static NSString *_logDir = nil;
    static int s_index=0,s_index2 = 0,s_index3 = 0,s_index4 = 0,s_index5 = 0,s_index6 = 0,s_index7 = 0,s_index8 = 0,s_index9 = 0,s_index10 = 0,s_index11 = 0;
    
    if (_logDir == nil)
    {
        _logDir = [[NSString alloc] initWithFormat:FileMonitorPath];
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    NSString *Cypto_op = nil;
    if (op == kCCEncrypt) {
        Cypto_op = @"kCCEncrypt";
    }
    else if(op == kCCDecrypt)
    {
        Cypto_op = @"kCCDecrypt";
    }
    else
    {
#ifdef PRINT_PATH_MODE
        PRINT_DATA(@"Cypto",funcName,@"op_error~");
#endif
        return;
    }
    /*
     kCCAlgorithmAES128 = 0,
     kCCAlgorithmAES = 0,
     kCCAlgorithmDES,1
     kCCAlgorithm3DES,2
     kCCAlgorithmCAST,3
     kCCAlgorithmRC4,4
     kCCAlgorithmRC2,5
     kCCAlgorithmBlowfish6
     */
    NSString * Cypto_alg = nil;
    switch (alg) {
        case 0:
            Cypto_alg = @"AES";
            break;
        case 1:
            Cypto_alg = @"DES";
            break;
        case 2:
            Cypto_alg = @"3DES";
            break;
        case 3:
            Cypto_alg = @"CAST";
            break;
        case 4:
            Cypto_alg = @"RC4";
            break;
        case 5:
            Cypto_alg = @"RC2";
            break;
        case 6:
            Cypto_alg = @"Blowfish6";
            break;
        default:
#ifdef PRINT_PATH_MODE
            PRINT_DATA(@"Cypto",funcName,@"alg_error~");
#endif
            return;
            break;
    }
    /*
     kCCOptionPKCS7Padding   = 0x0001,
     kCCOptionECBMode        = 0x0002
     */
    NSString * Cypto_options = nil;
    switch (options) {
        case 0:
            Cypto_options = @"None";
            break;
        case 1:
            Cypto_options = @"kCCOptionPKCS7Padding";
            break;
        case 2:
            Cypto_options = @"kCCOptionECBMode";
            break;
        case 3:
            Cypto_options = @"kCCOptionPKCS7Padding|kCCOptionECBMode";
            break;
        default:
#ifdef PRINT_PATH_MODE
            NSString *errorCode =[NSString stringWithFormat:@"options_error~ %d",options];
            PRINT_DATA(@"Cypto",funcName,errorCode);
#endif
            return;
            break;
    }
    NSString *Cypto_key = [NSString stringWithFormat:@"%s",key];
    NSString *Cypto_iv = [NSString stringWithFormat:@"%s",iv];
    
    NSData *Cypto_dataIn = [NSData dataWithBytes:dataIn length:dataInLength];
    NSData *Cypto_dataOut = [NSData dataWithBytes:dataOut length:dataOutAvailable];
    NSNumber *Cypto_Moved = [NSNumber numberWithInt:*dataOutMoved];
    //NSString *data = [NSString stringWithFormat:@"%@_%@_%@_%@_%@_%@_%@",Cypto_op,Cypto_alg,Cypto_options,Cypto_key,Cypto_dataIn,Cypto_dataOut,Cypto_Moved];
    NSArray *arryData = [NSArray arrayWithObjects:Cypto_op,              Cypto_alg,      Cypto_options,   Cypto_key,Cypto_iv,   Cypto_dataIn,     Cypto_dataOut,   Cypto_Moved, nil];
    NSArray *arryDataKeys = [NSArray arrayWithObjects:@"Encrypt_or_Decrypt",@"Cypto_alg",@"Cypto_options",@"Cypto_key",@"Cypto_iv",@"Cypto_dataIn",@"Cypto_dataOut",@"Cypto_Moved",nil];
    
    NSDictionary *dicData = [NSDictionary dictionaryWithObjects:arryData forKeys:arryDataKeys];
    
    
#ifdef PRINT_PATH_MODE
    PRINT_DATA(@"Cypto",funcName,dicData)
#endif
    
    if (dicData == nil) {
        return;
    }
    if ([funcName isEqualToString:@"CCCrypt"]) {
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index++];
    }
    else{
        NSLog(@"funcName~~~");
        return;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:dicData forKey:funcName];
    
    //    FILE *fp;
    //    fp=fopen([filepath UTF8String], "w");
    //
    //    if ([dic description]) {
    //        fprintf(fp,"%s", [[dic description] UTF8String]);
    //    }
    //
    //
    //    fclose(fp);
    BOOL flag = [dic writeToFile:filepath
                      atomically:YES];
#ifdef WRITE_TO_FILE
    NSLog(@"5flag = %d",flag);
#endif
}


#define ____________________________________________________________________________________________________NSUserDefaults
void LogNSUserDefaults(NSString * funcName,id data, void *returnAddress)
{
    NSString *filepath;
    static NSString *_logDir = nil;
    static int s_index=0,s_index2 = 0,s_index3 = 0,s_index4 = 0,s_index5 = 0,s_index6 = 0,s_index7 = 0,s_index8 = 0,s_index9 = 0,s_index10 = 0,s_index11 = 0,s_index12 = 0,s_index13 = 0,s_index14 = 0,s_index15 = 0,s_index16 = 0,s_index17 = 0,s_index18 = 0,s_index20 = 0,s_index21 = 0,s_index22 = 0,s_index23 = 0,s_index24 = 0,s_index25 = 0,s_index26 = 0,s_index27 = 0,s_index28 = 0,s_index29 = 0;
    
    
    if (_logDir == nil)
    {
        _logDir = [[NSString alloc] initWithFormat:FileMonitorPath];
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    
    if (data == nil) {
#ifdef PRINT_PATH_MODE
        PRINT_DATA(@"NSUserDefaults data = nil",funcName,@"")
#endif
        return;
    }
#ifdef PRINT_PATH_MODE
    PRINT_DATA(@"NSUserDefaults",funcName,data)
#endif
    

    if ([data isKindOfClass:[NSString class]]) {
        if ([data isEqualToString:@""]) {
            return;
        }
    }
    if ([funcName isEqualToString:@"dataForKey_"]) {
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index++];
    }
    else if ([funcName isEqualToString:@"arrayForKey_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index2++];
    }
    else if ([funcName isEqualToString:@"boolForKey_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index3++];
    }
    else if ([funcName isEqualToString:@"dictionaryForKey_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index4++];
    }
    else if ([funcName isEqualToString:@"floatForKey_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index5++];
    }
    else if ([funcName isEqualToString:@"integerForKey_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index6++];
    }
    else if ([funcName isEqualToString:@"objectForKey_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index7++];
    }
    else if ([funcName isEqualToString:@"stringArrayForKey_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index8++];
    }
    else if ([funcName isEqualToString:@"stringForKey_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index9++];
    }
    else if ([funcName isEqualToString:@"doubleForKey_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index10++];
    }
    else if ([funcName isEqualToString:@"URLForKey_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index11++];
    }
    else if ([funcName isEqualToString:@"setBool_forKey_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index12++];
    }
    else if ([funcName isEqualToString:@"setFloat_forKey_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index13++];
    }
    else if ([funcName isEqualToString:@"setInteger_forKey_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index14++];
    }
    else if ([funcName isEqualToString:@"setObject_forKey_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index15++];
    }
    else if ([funcName isEqualToString:@"setDouble_forKey_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index16++];
    }
    else if ([funcName isEqualToString:@"setURL_forKey_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index17++];
    }
    else if ([funcName isEqualToString:@"removeObjectForKey_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index18++];
    }
    else if ([funcName isEqualToString:@"persistentDomainForName_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index20++];
    }
//    else if ([funcName isEqualToString:@"persistentDomainNames_"]){
//        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index21++];
//    }
    else if ([funcName isEqualToString:@"removePersistentDomainForName_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index22++];
    }
    else if ([funcName isEqualToString:@"setPersistentDomain_forName_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index23++];
    }
    else if ([funcName isEqualToString:@"objectIsForcedForKey_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index24++];
    }
    else if ([funcName isEqualToString:@"objectIsForcedForKey_inDomain_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index25++];
    }
    else if ([funcName isEqualToString:@"dictionaryRepresentation"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index26++];
    }
    else if ([funcName isEqualToString:@"removeVolatileDomainForName_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index27++];
    }
    else if ([funcName isEqualToString:@"setVolatileDomain_forName_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index28++];
    }
    else if ([funcName isEqualToString:@"volatileDomainForName_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index29++];
    }
    else{
        NSLog(@"error~~~ LogNSUserDefaults");
        return;
    }

    NSDictionary *dic = [NSDictionary dictionaryWithObject:data forKey:funcName];
    
//    FILE *fp;
//    fp=fopen([filepath UTF8String], "w");
//    
//    if ([dic description]) {
//        fprintf(fp,"%s", [[dic description] UTF8String]);
//    }
//    
//    
//    fclose(fp);
    BOOL flag = [dic writeToFile:filepath
                      atomically:YES];
#ifdef WRITE_TO_FILE
    NSLog(@"6flag = %d",flag);
#endif
}



#define ____________________________________________________________________________________________________FMDB

void LogFMDB(NSDictionary*dic,NSString *funcName,void *returnAddress)
{
    @try {
#ifdef DEBUG_MODE
        NSLog(@"dic = %@",dic);
#endif
        if (dic == nil) {
#ifdef PRINT_PATH_MODE
            PRINT_DATA(@"FMBD data=nil",dic,@"")
#endif
            return;
        }
        static NSString *_logDir = nil;
        
        if (_logDir == nil)
        {
            _logDir = [[NSString alloc] initWithFormat:FileMonitorPath];
            BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
            
            if (!isDirExist) {
                [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
            }
        }
        //NSString *tmpPath = [[path description] stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
        NSString *filepath = nil;
        static int s_index=0,s_index2 = 0,s_index3 = 0,s_index4 = 0,s_index5 = 0,s_index6 = 0,s_index7 = 0;
#ifdef PRINT_PATH_MODE
        PRINT_DATA(@"FMDB",@"",funcName)
#endif
        
        if ([funcName isEqualToString:@"_FMDatabase_open"]) {
            filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index++];
        }
        else if ([funcName isEqualToString:@"_FMDatabase_openWithFlags_vfs_"]){
            filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index2++];
        }
        else if ([funcName isEqualToString:@"_FMDatabase_databaseWithPath_"]){
            filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index3++];
        }
        else if ([funcName isEqualToString:@"_FMDatabase_initWithPath_"]){
            filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index4++];
        }
        else if ([funcName isEqualToString:@"_FMDatabase_executeQuery_withArgumentsInArray_orDictionary_orVAList_"]){
            filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index5++];
        }
        else if ([funcName isEqualToString:@"_FMDatabase_executeUpdate_error_withArgumentsInArray_orDictionary_orVAList_"]){
            filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index6++];
        }
        else if ([funcName isEqualToString:@"_FMDatabase_executeStatements_withResultBlock_"]){
            filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index7++];
        }
        else{
            NSLog(@"error~~~ Logsqlite3");
            return;
        }
        
        if (filepath) {
            BOOL flag = [dic writeToFile:filepath
                              atomically:YES];
#ifdef WRITE_TO_FILE
            NSLog(@"1flag = %d",flag);
#endif
        }
    }
    @catch (NSException *exception) {
        NSLog(@"LogFBDM exception reason=%@",exception.reason);
    }
    @finally {
        return;
    }
}






#define ____________________________________________________________________________________________________sqlite3
void Logsqlite3(NSString * funcName,NSString *data, void *returnAddress)
{
    NSString *filepath;
    static NSString *_logDir = nil;
    static int s_index=0,s_index2 = 0,s_index3 = 0,s_index4 = 0,s_index5 = 0,s_index6 = 0,s_index7 = 0,s_index8 = 0,s_index9 = 0,s_index10 = 0,s_index11 = 0,s_index12 = 0;
  
    if (_logDir == nil)
    {
        _logDir = [[NSString alloc] initWithFormat:FileMonitorPath];
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }

#ifdef PRINT_PATH_MODE
    PRINT_DATA(@"sqlite3",funcName,data)
#endif
    
    if (data == nil || [data isEqualToString:@""]) {
        return;
    }
    if ([funcName isEqualToString:@"sqlite3_column_text"]) {
         filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index++];
    }
    else if ([funcName isEqualToString:@"sqlite3_sql"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index2++];
    }
    else if ([funcName isEqualToString:@"sqlite3_prepare"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index3++];
    }
    else if ([funcName isEqualToString:@"sqlite3_prepare_v2"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index4++];
    }
    else if ([funcName isEqualToString:@"sqlite3_prepare16"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index5++];
    }
    else if ([funcName isEqualToString:@"sqlite3_prepare16_v2"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index6++];
    }
    else if ([funcName isEqualToString:@"sqlite3_open"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index7++];
    }
    else if ([funcName isEqualToString:@"sqlite3_open16"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index8++];
    }
    else if ([funcName isEqualToString:@"sqlite3_open_v2"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index9++];
    }
    else if ([funcName isEqualToString:@"sqlite3_exec"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index10++];
    }
    else if ([funcName isEqualToString:@"sqlite3_create_function"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index11++];
    }
    else if ([funcName isEqualToString:@"sqlite3_value_text"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index12++];
    }
    else{
        NSLog(@"error~~~ Logsqlite3");
        return;
    }
    NSDictionary *dic0 = [NSDictionary dictionaryWithObject:data forKey:@"sqlite3"];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:dic0 forKey:funcName];
    
//    FILE *fp;
//    fp=fopen([filepath UTF8String], "w");
//
//    if ([dic description]) {
//        fprintf(fp,"%s", [[dic description] UTF8String]);
//    }
//    
//    
//    fclose(fp);
    BOOL flag = [dic writeToFile:filepath
                      atomically:YES];
#ifdef WRITE_TO_FILE
    NSLog(@"7flag = %d",flag);
#endif
}




#define Function_keychain________________________________________________
#if __cplusplus
extern "C"
#endif
void LogKeychainFunc(NSString *funcName,id data, void *returnAddress)
{
    NSMutableDictionary* query = (NSMutableDictionary*)data;
    
    NSString *filepath = nil;
    static NSString *_logDir = nil;
    static int s_index=0,s_index2 = 0,s_index3 = 0,s_index4 = 0;
    
    if (_logDir == nil)
    {
        _logDir = [[NSString alloc] initWithFormat:FileMonitorPath];
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
//        NSLog(@"_logDir = %@",_logDir);
//        NSLog(@"isDirExist = %d",isDirExist);
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    
    if ([funcName isEqualToString:@"SecItemCopyMatching_"]) {
         filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index++];
#ifdef PRINT_PATH_MODE
         PRINT_DATA(@"Keychain",funcName,data)
#endif
    }
    else if ([funcName isEqualToString:@"SecItemAdd_"])
    {
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index2++];
#ifdef PRINT_PATH_MODE
        PRINT_DATA(@"Keychain",funcName,data)
#endif
    }
    else if ([funcName isEqualToString:@"SecItemUpdate_"])
    {
        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index3++];
#ifdef PRINT_PATH_MODE
        PRINT_DATA(@"Keychain",funcName,data)
#endif
    }
    else if([funcName isEqualToString:@"SecItemDelete_"])
    {

        filepath = [NSString stringWithFormat:@"%@/%@_%04d.plist",_logDir,funcName, s_index4++];
#ifdef PRINT_PATH_MODE
        PRINT_DATA(@"Keychain",funcName,data)
#endif
    }
    else
    {
        NSLog(@"error");
        return;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:data forKey:funcName];
    
//    FILE *fp;
//    fp=fopen([filepath UTF8String], "w");
//        if ([dic description]) {
//        fprintf(fp,"%s", [[dic description] UTF8String]);
//    }
//    fclose(fp);
    if (filepath) {
//        [dic writeToFile:filepath  atomically:YES];
    }
}


#define ____________________________________________________________________________________________________NSDictionary
#define Function_Write_Create_________________________
#if __cplusplus
extern "C"
#endif
void LogNSDictionaryWrite(NSString *funcName,id data,NSString *path, void *returnAddress)
{
#ifdef DEBUG_MODE
    NSLog(@"data = %@",data);
    NSLog(@"path = %@",path);
#endif
    
    NSRange range = [path rangeOfString:@"filemon"];
    if (range.location != NSNotFound) {
        return;
    }
    if (data == nil) {
#ifdef PRINT_PATH_MODE
        NSLog(@"path = %@",path);
        PRINT_DATA(@"Write data = nil",path,[@"NSDictionary_" stringByAppendingString:funcName])
#endif
        return;
    }
    static NSString *_logDir = nil;
    static int s_index=0,s_index2 = 0;
    
    if (_logDir == nil)
    {
        _logDir = [[NSString alloc] initWithFormat:FileMonitorPath];
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    //NSString *tmpPath = [[path description] stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *filepath;
    
    if ([funcName isEqualToString:@"writeToFile_atomically_"]) {
        filepath = [NSString stringWithFormat:@"%@/NSDictionary_%@_%04d.plist",_logDir,funcName, s_index++];
    }
    else if([funcName isEqualToString:@"writeToURL_atomically_"])
    {
        filepath = [NSString stringWithFormat:@"%@/NSDictionary_%@_%04d.plist",_logDir,funcName, s_index2++];
    }
    else{
        return;
    }

#ifdef DEBUG_MODE
    NSLog(@"filepath=%@",filepath);
    NSLog(@"[[data description] class] = %@",[[data description] class]);
    NSLog(@"data = %@",data);
#endif
    
#ifdef PRINT_PATH_MODE
    PRINT_DATA(@"Write",path,[@"NSDictionary_" stringByAppendingString:funcName])
#endif
    
    NSDictionary *dic0 = [NSDictionary dictionaryWithObject:data forKey:path];
    
    NSString *funcName2 = [NSString stringWithFormat:@"NSDictionary_%@",funcName];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:dic0 forKey:funcName2];
    

    
//    FILE *fp;
//    fp=fopen([filepath UTF8String], "w");
//        if ([dic description]) {
//        fprintf(fp,"%s", [[dic description] UTF8String]);
//    }
//    fclose(fp);
    BOOL flag = [dic writeToFile:filepath
                      atomically:YES];
#ifdef WRITE_TO_FILE
    NSLog(@"8flag= %d",flag);
#endif
}


#define ____________________________________________________________________________________________________NSData
#if __cplusplus
extern "C"
#endif
void LogNSDataWrite(NSString *funcName,id data,NSString *path, void *returnAddress)
{
    @try {
#ifdef DEBUG_MODE
    NSLog(@"data = %@",data);
    NSLog(@"path = %@",path);
#endif
    if (data == nil) {
#ifdef PRINT_PATH_MODE
        PRINT_DATA(@"Write data = nil",path,[@"NSData_" stringByAppendingString:funcName])
#endif
        return;
    }
    static NSString *_logDir = nil;
    static int s_index=0,s_index2 = 0,s_index3 = 0,s_index4 = 0,s_index5 = 0,s_index6 = 0,s_index7 = 0,s_index8 = 0,s_index9 = 0,s_index10 = 0;
    
    if (_logDir == nil)
    {
        _logDir = [[NSString alloc] initWithFormat:FileMonitorPath];
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    
    //NSString *tmpPath = [[path description] stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *filepath = nil;
    
    if ([funcName isEqualToString:@"writeToFile_atomically_"]) {
        filepath = [NSString stringWithFormat:@"%@/NSData_%@_%04d.plist",_logDir,funcName, s_index++];
    }
    else if([funcName isEqualToString:@"writeToFile_options_error_"])
    {
        filepath = [NSString stringWithFormat:@"%@/NSData_%@_%04d.plist",_logDir,funcName, s_index2++];
    }
    else if([funcName isEqualToString:@"writeToURL_atomically_"])
    {
        if ([path hasPrefix:@"file://"]) {
            return;
        }
        filepath = [NSString stringWithFormat:@"%@/NSData_%@_%04d.plist",_logDir,funcName, s_index3++];
    }
    else if([funcName isEqualToString:@"writeToURL_options_error_"])
    {
        if ([path hasPrefix:@"file://"]) {
            return;
        }
        filepath = [NSString stringWithFormat:@"%@/NSData_%@_%04d.plist",_logDir,funcName, s_index4++];
    }
    else if([funcName isEqualToString:@"initWithContentsOfFile_options_error_"])
    {
        filepath = [NSString stringWithFormat:@"%@/NSData_%@_%04d.plist",_logDir,funcName, s_index5++];
    }
    else if([funcName isEqualToString:@"initWithContentsOfURL_options_error_"])
    {
        filepath = [NSString stringWithFormat:@"%@/NSData_%@_%04d.plist",_logDir,funcName, s_index6++];
    }
    else if([funcName isEqualToString:@"dataWithContentsOfURL_options_error_"])
    {
        filepath = [NSString stringWithFormat:@"%@/NSData_%@_%04d.plist",_logDir,funcName, s_index7++];
    }
    else if([funcName isEqualToString:@"dataWithContentsOfURL_"])
    {
        filepath = [NSString stringWithFormat:@"%@/NSData_%@_%04d.plist",_logDir,funcName, s_index8++];
    }
    else if([funcName isEqualToString:@"dataWithContentsOfFile_options_error_"])
    {
        filepath = [NSString stringWithFormat:@"%@/NSData_%@_%04d.plist",_logDir,funcName, s_index9++];
    }
    else if([funcName isEqualToString:@"dataWithContentsOfFile_"])
    {
        filepath = [NSString stringWithFormat:@"%@/NSData_%@_%04d.plist",_logDir,funcName, s_index10++];
    }
    else
        return;

#ifdef DEBUG_MODE
    NSLog(@"filepath=%@",filepath);
    NSLog(@"[[data description] class] = %@",[[data description] class]);
    NSLog(@"data = %@",data);
#endif

#ifdef PRINT_PATH_MODE
    PRINT_DATA(@"Write",path,[@"NSData_" stringByAppendingString:funcName])
#endif
    NSDictionary *dic0 = [NSDictionary dictionaryWithObject:data forKey:path];
        
    NSString *funcName2 = [NSString stringWithFormat:@"NSData_%@",funcName];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:dic0 forKey:funcName2];
    
        
//    FILE *fp;
//    fp=fopen([filepath UTF8String], "w");
//    if ([dic description]) {
//        fprintf(fp, "%s",[[dic description] UTF8String]);
//    }
//    fclose(fp);
    if (filepath) {
        BOOL flag = [dic writeToFile:filepath
                          atomically:YES];
#ifdef WRITE_TO_FILE
        NSLog(@"9flag = %d",flag);
#endif
    }
    }
    @catch (NSException *exception) {
        NSLog(@"LogNSDataWrite exception reason=%@",exception.reason);
    }
    @finally {
        return;
    }
}


#define ____________________________________________________________________________________________________NSString
#if __cplusplus
extern "C"
#endif
void LogNSStringWrite(NSString *funcName,id data,NSString *path, void *returnAddress)
{
#ifdef DEBUG_MODE
    NSLog(@"data = %@",data);
    NSLog(@"path = %@",path);
#endif
    if (data == nil) {
#ifdef PRINT_PATH_MODE
        PRINT_DATA(@"Write data = nil",path,[@"NSString_" stringByAppendingString:funcName])
#endif
        return;
    }
    static NSString *_logDir = nil;
    static int s_index=0,s_index2 = 0,s_index3 = 0,s_index4 = 0;
    
    if (_logDir == nil)
    {
        _logDir = [[NSString alloc] initWithFormat:FileMonitorPath];
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    
    //NSString *tmpPath = [[path description] stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *filepath= nil;
    
    if ([funcName isEqualToString:@"writeToFile_atomically_encoding_error_"]) {
        filepath = [NSString stringWithFormat:@"%@/NSString_%@_%04d.plist",_logDir,funcName, s_index++];
    }
    else if([funcName isEqualToString:@"writeToFile_atomically_"])
    {
        filepath = [NSString stringWithFormat:@"%@/NSString_%@_%04d.plist",_logDir,funcName, s_index2++];
    }
    else if([funcName isEqualToString:@"writeToURL_atomically_encoding_error_"])
    {

        filepath = [NSString stringWithFormat:@"%@/NSString_%@_%04d.plist",_logDir,funcName, s_index3++];
    }
    else
    {
        filepath = [NSString stringWithFormat:@"%@/NSString_%@_%04d.plist",_logDir,funcName, s_index4++];
    }
    
#ifdef DEBUG_MODE
    NSLog(@"filepath=%@",filepath);
    NSLog(@"[[data description] class] = %@",[[data description] class]);
    NSLog(@"data = %@",data);
#endif
    
#ifdef PRINT_PATH_MODE
    PRINT_DATA(@"Write",path,[@"NSString_" stringByAppendingString:funcName])
#endif
    NSDictionary *dic0 = [NSDictionary dictionaryWithObject:data forKey:path];
    
        NSString *funcName2 = [NSString stringWithFormat:@"NSString_%@",funcName];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:dic0 forKey:funcName2];
    
//    FILE *fp;
//    fp=fopen([filepath UTF8String], "w");
//    if ([dic description]) {
//        fprintf(fp,  "%s",[[dic description] UTF8String]);
//    }
//    fclose(fp);
    if (filepath) {
        BOOL flag = [dic writeToFile:filepath
                          atomically:YES];
#ifdef WRITE_TO_FILE
        NSLog(@"10flag = %d",flag);
#endif
    }
}


#define ____________________________________________________________________________________________________Thecommon
void LoginitWithContentsOffileorurl(NSString *funcName,id data,id pathorurl, void *returnAddress)
{
    if (data == nil) {
        return;
    }

#ifdef PRINT_REPEAT_INFO
    @try {
        @synchronized(logfilesarray) {
        if ([data description]) {
            for (NSString *item in logfilesarray){
                if ([item isEqualToString:[data description]])
                {
                    return;
                }
            }
            [logfilesarray addObject:[data description]];
        }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"LoginitWithContentsOffileorurl error exception reason=%@",exception.reason);
        NSLog(@"exdata = %@",data);
    }
    @finally {
        return;
    }
#endif
    
    NSString *str;
    NSDictionary *dic;
    NSString *filepath = nil;
    NSString *prefix;
    static NSString *_logDir = nil;
    static int s_index=0,s_index2 = 0;
    
    if (_logDir == nil)
    {
        _logDir = [[NSString alloc] initWithFormat:FileMonitorPath];
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }

    if ([data isKindOfClass:[NSString class]]) {
        prefix = @"data=NSString";
    }
    else if ([data isKindOfClass:[NSDictionary class]])
    {
        prefix = @"data=NSDictionary";

    }
    else if ([data isKindOfClass:[NSData class]])
    {
        prefix = @"data=NSData";
    }
    else
        prefix = @"data=NotKnow";
    
    if ([pathorurl isKindOfClass:[NSURL class]]) {
        str = [NSString stringWithFormat:@"%@_%@,%@",prefix,funcName,[(NSURL*)pathorurl absoluteURL]];
#ifdef PRINT_PATH_MODE
        PRINT_DATA(@"LoginitWithContentsOffileorurl",@"",str)
#endif
        filepath = [NSString stringWithFormat:@"%@/%@_%@_%04d.plist",_logDir,prefix,funcName, s_index++];
           dic = [NSDictionary dictionaryWithObject:data forKey:[(NSURL*)pathorurl absoluteURL]];
    }
    else{
#ifdef PRINT_FILTERINFO
        if ([(NSString*)pathorurl hasSuffix:@"nib"]) {
            return;
        }
#endif
        str = [NSString stringWithFormat:@"%@_%@,%@",prefix,funcName,pathorurl];

#ifdef PRINT_PATH_MODE
        PRINT_DATA(@"init",@"",str)
#endif
        filepath = [NSString stringWithFormat:@"%@/%@_%@_%04d.plist",_logDir,prefix,funcName, s_index2++];
           dic = [NSDictionary dictionaryWithObject:data forKey:pathorurl];
    }
    NSDictionary *dic2 = [NSDictionary dictionaryWithObject:dic forKey:funcName];
    
    
//    FILE *fp;
//    fp=fopen([filepath UTF8String], "w");
//    if ([dic description]) {
//        fprintf(fp, "%s",[[dic description] UTF8String]);
//    }
//    fclose(fp);
    if (filepath) {
        BOOL flag = [dic2 writeToFile:filepath
                          atomically:YES];
#ifdef WRITE_TO_FILE
        NSLog(@"11flag = %d",flag);
#endif
    }
    
}

void LogComparedata(NSString *funcName,id data,id data2, void *returnAddress)
{
    NSString *str;
    NSString *filepath;
    NSString *prefix;
    static NSString *_logDir = nil;
    static int s_index=0,s_index2 = 0,s_index3 = 0,s_index4 = 0;
    
    if (data == nil&&data2 ==nil) {
        return;
    }
    if (data == nil) {
        data =@"";
    }
    if (data2 == nil) {
        data2 =@"";
    }

    if (_logDir == nil)
    {
        _logDir = [[NSString alloc] initWithFormat:FileMonitorPath];
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    
    if ([data isKindOfClass:[NSString class]]) {
        prefix = @"data=NSString";
        
        str = [NSString stringWithFormat:@"%@_%@_%@_%@",prefix,funcName,data,data2];
#ifdef PRINT_PATH_MODE
        PRINT_DATA(@"Compare",@"",str)
#endif
        filepath = [NSString stringWithFormat:@"%@/%@_%@_%04d.plist",_logDir,prefix,funcName, s_index++];

         }
    else if ([data isKindOfClass:[NSDictionary class]])
    {
        prefix = @"data=NSDictionary";
        
//过滤~~~~~~~~~~~~~~~~~~~~
#ifdef PRINT_FILTERINFO
        if ([(NSDictionary*)data objectForKey:@"NSColor"] || [(NSDictionary*)data objectForKey:@"NSFont"]) {
            return;
        }
#endif
        str = [NSString stringWithFormat:@"%@_%@_%@_%@",prefix,funcName,data,data2];
        //str = [NSString stringWithFormat:@"%@_%@",prefix,funcName];
        
#ifdef PRINT_PATH_MODE
        PRINT_DATA(@"Compare",@"",str)
#endif
        filepath = [NSString stringWithFormat:@"%@/%@_%@_%04d.plist",_logDir,prefix,funcName, s_index2++];

    }
    else if ([data isKindOfClass:[NSData class]])
    {
        prefix = @"data=NSData";
        
        str = [NSString stringWithFormat:@"%@_%@_%@_%@",prefix,funcName,data,data2];
#ifdef PRINT_PATH_MODE
        PRINT_DATA(@"Compare",@"",str)
#endif
        filepath = [NSString stringWithFormat:@"%@/%@_%@_%04d.plist",_logDir,prefix,funcName, s_index3++];
    }
    else
    {
        prefix = @"data=UnKonw";
        
        str = [NSString stringWithFormat:@"%@_%@_%@_%@",prefix,funcName,data,data2];
#ifdef PRINT_PATH_MODE
        PRINT_DATA(@"Compare",@"",str)
#endif
        filepath = [NSString stringWithFormat:@"%@/%@_%@_%04d.plist",_logDir,prefix,funcName, s_index4++];
    }

    
    NSDictionary *dic0 = [NSDictionary dictionaryWithObject:data forKey:data2];

            NSString *funcName2 = [NSString stringWithFormat:@"%@_%@",prefix,funcName];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:dic0 forKey:funcName2];
    
//    FILE *fp;
//    fp=fopen([filepath UTF8String], "w");
//    if ([dic description]) {
//        fprintf(fp,  "%s",[[dic description] UTF8String]);
//    }
//    fclose(fp);
    if (filepath) {
        BOOL flag = [dic writeToFile:filepath
                          atomically:YES];
#ifdef WRITE_TO_FILE
        NSLog(@"12flag = %d",flag);
#endif
    }
}

#define ____________________________________________________________________________________________________NSFileManagerDelegate
void LogNSFileManagerDelegate(NSString *funcName,id src,id dest, void *returnAddress)
{
    NSString *str = [NSString stringWithFormat:@"%@%@_%@",funcName,src,dest];
    
    if ([funcName isEqualToString:@"fileManager_shouldCopyItemAtPath_toPath_"]) {
        PRINT_DATA(@"Copy",@"",[@"NSFileManagerDelegate_" stringByAppendingString:str])
        return;
    }
    else if([funcName isEqualToString:@"fileManager_shouldCopyItemAtURL_toURL_"])
    {
        PRINT_DATA(@"Copy",@"",[@"NSFileManagerDelegate_" stringByAppendingString:str])
        return;
    }
    else if([funcName isEqualToString:@"fileManager_shouldMoveItemAtURL_toURL_"])
    {
        PRINT_DATA(@"Move",@"",[@"NSFileManagerDelegate_" stringByAppendingString:str])
        return;
    }
    else if([funcName isEqualToString:@"fileManager_shouldMoveItemAtPath_toPath_"])
    {
        PRINT_DATA(@"Move",@"",[@"NSFileManagerDelegate_" stringByAppendingString:str])
        return;
    }
    else
        NSLog(@"error~");

}



#define ____________________________________________________________________________________________________NSFileManager

#if __cplusplus
extern "C"
#endif
void LogNSFileManagerWrite(NSString *funcName,id data,NSString *path, void *returnAddress)
{
    NSRange range = [path rangeOfString:@"filemon"];
    if (range.location != NSNotFound) {
        return;
    }
    
#ifdef DEBUG_MODE
    NSLog(@"data = %@",data);
    NSLog(@"path = %@",path);
#endif
    
    static NSString *_logDir = nil;
    static int s_index=0,s_index2=0;
    
    if (_logDir == nil)
    {
        _logDir = [[NSString alloc] initWithFormat:FileMonitorPath];
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    
    //NSString *tmpPath = [[path description] stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    

    NSString *filepath;
    
    if ([funcName isEqualToString:@"createDirectoryAtPath_attributes_"]) {
        PRINT_DATA(@"Create",path,[@"NSFileManager_" stringByAppendingString:funcName])
        return;
    }
    else if([funcName isEqualToString:@"createDirectoryAtURL_withIntermediateDirectories_attributes_error_"])
    {
        PRINT_DATA(@"Create",path,[@"NSFileManager_" stringByAppendingString:funcName])
        return;
    }
    else if([funcName isEqualToString:@"createDirectoryAtPath_withIntermediateDirectories_attributes_error"])
    {
        PRINT_DATA(@"Create",path,[@"NSFileManager_" stringByAppendingString:funcName])
        return;
    }
    else if([funcName isEqualToString:@"contentsAtPath_"])
    {
        PRINT_DATA(@"Create",path,[@"NSFileManager_" stringByAppendingString:funcName])
        filepath = [NSString stringWithFormat:@"%@/NSFileManager_%@_%04d.plist",_logDir,funcName, s_index++];
    }
    else
    {
//        PRINT_DATA(@"Create",path,[@"NSFileManager_" stringByAppendingString:funcName])
//         filepath = [NSString stringWithFormat:@"%@/NSFileManager_%@_%04d.plist",_logDir,funcName, s_index2++];
        NSLog(@"error");
        return;
    }
    
#ifdef DEBUG_MODE
    NSLog(@"filepath=%@",filepath);
    NSLog(@"[[data description] class] = %@",[[data description] class]);
    NSLog(@"data = %@",data);
#endif
    
#ifdef PRINT_PATH_MODE
    PRINT_DATA(@"Write",path,[@"NSFileManager_" stringByAppendingString:funcName])
#endif
    if (data != nil) {
        NSDictionary *dic0 = [NSDictionary dictionaryWithObject:data forKey:path];
        
        NSString *funcName2 = [NSString stringWithFormat:@"NSFileManager_%@",funcName];
        NSDictionary *dic = [NSDictionary dictionaryWithObject:dic0 forKey:funcName2];
        
//        FILE *fp;
//        fp=fopen([filepath UTF8String], "w");
//        if ([dic description]) {
//             fprintf(fp,  "%s",[[dic description] UTF8String]);
//        }
//        fclose(fp);
        BOOL flag = [dic writeToFile:filepath
                          atomically:YES];
#ifdef WRITE_TO_FILE
        NSLog(@"13flag = %d",flag);
#endif
    }
}
#define Function_Change_Attributes__________________________
#if __cplusplus
extern "C"
#endif
void LogNSFileManagerChange_Attributes(NSString *funcName,NSString *path,NSDictionary  *attributes, void *returnAddress)
{
    
//   NSFileBusy, NSFileCreationDate, NSFileExtensionHidden, NSFileGroupOwnerAccountID, NSFileGroupOwnerAccountName, NSFileHFSCreatorCode, NSFileHFSTypeCode, NSFileImmutable, NSFileModificationDate, NSFileOwnerAccountID, NSFileOwnerAccountName, NSFilePosixPermissions
    NSString *str = [NSString stringWithFormat:@"NSFileManager_%@,%@",funcName,[attributes description]];
#ifdef PRINT_PATH_MODE
    PRINT_DATA(@"Change_Attributes",path,str)
#endif
}


#define Function_create_SymbolicLink__________________________
#if __cplusplus
extern "C"
#endif
void LogNSFileManagerCreateSymblic(NSString *funcName,id souce,id  dest, void *returnAddress)
{
        NSString *str;
    if ([souce isKindOfClass:[NSURL class]]) {
        str = [NSString stringWithFormat:@"NSFileManager_%@,%@:%@",funcName,[(NSURL*)souce absoluteURL],[(NSURL*)dest absoluteURL]];
#ifdef PRINT_PATH_MODE
        PRINT_DATA(@"CreateSymblic",@"",str)
#endif
    }
    else
    {
        str = [NSString stringWithFormat:@"NSFileManager_%@,%@:%@",funcName,souce,dest];
        PRINT_DATA(@"CreateSymblic",@"",str)
    }
}



#define Function_removeitematpathorurl__________________________
#if __cplusplus
extern "C"
#endif
void LogNSFileManagerRemoveItemAtPath(NSString *funcName,id pathorurl, void *returnAddress)
{
    NSString *str;
        if ([pathorurl isKindOfClass:[NSURL class]]) {
            str = [NSString stringWithFormat:@"NSFileManager_%@,%@",funcName,[(NSURL*)pathorurl absoluteURL]];
#ifdef PRINT_PATH_MODE
            PRINT_DATA(@"RemoveItem",@"",str)
#endif
        }
        else{
            str = [NSString stringWithFormat:@"NSFileManager_%@,%@",funcName,pathorurl];
#ifdef PRINT_PATH_MODE
        PRINT_DATA(@"RemoveItem",@"",str)
#endif
        }
}



#define Function_replaceItemAtURL_withItemAtURL_backupItemName_options_resultingItemURL_error___________________________
#if __cplusplus
extern "C"
#endif
void LogNSFileManagerreplaceItemAtURL_withItemAtURL_backupItemName_options_resultingItemURL_error_(NSString *funcName,id source, void *dest, void *returnAddress)
{
    NSString *str;

        str = [NSString stringWithFormat:@"NSFileManager_%@,%@:%@",funcName,[(NSURL*)source absoluteURL],[(NSURL*)dest absoluteURL]];
#ifdef PRINT_PATH_MODE
    PRINT_DATA(@"replaceItem",@"",str)
#endif
}


#define Function_copyItemAtpathorurl_moveItemAtpathorlurl__________________________
#if __cplusplus
extern "C"
#endif
void LogNSFileManagerCopyItem(NSString *funcName,id souce,id  dest, void *returnAddress)
{
    NSString *str;
    if ([souce isKindOfClass:[NSURL class]]) {
        str = [NSString stringWithFormat:@"NSFileManager_%@,%@:%@",funcName,[(NSURL*)souce absoluteURL],[(NSURL*)dest absoluteURL]];
#ifdef PRINT_PATH_MODE
        PRINT_DATA(@"copy_move",@"",str)
#endif
    }
    else
    {
        str = [NSString stringWithFormat:@"NSFileManager_%@,%@:%@",funcName,souce ,dest];
#ifdef PRINT_PATH_MODE
        PRINT_DATA(@"copy_move",@"",str)
#endif
    }
}


#if __cplusplus
extern "C"
#endif
int main()
{
//   traceStorage = [[SQLiteStorage alloc] initWithDefaultDBFilePathAndLogToConsole: 1];
//   _LogLine();
//   _LogStack();
	return 0;
}

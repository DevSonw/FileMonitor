
//
#import <vector>
#import <algorithm>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
//可选项
//#define PRINT_FILTERINFO //自动过滤多余的信息 如 加载nib等
#define PRINT_PATH_MODE  //动态观看日志信息
//#define DEBUG_MODE

#define PRINT_DATA(mode,funcname,pathordata) NSLog(@"---FileMonitor---%@ : %@ : %@",mode,funcname,pathordata);


#define ____________________________________________________________________________________________________md5

void LogHash(NSString * funcName,NSString *source,NSString *dest, void *returnAddress)
{
    NSString *filepath;
    static NSString *_logDir = nil;
    static int s_index=0,s_index2 = 0,s_index3 = 0,s_index4 = 0,s_index5 = 0,s_index6 = 0;
    
    if (_logDir == nil)
    {
        _logDir = [[NSString alloc] initWithFormat:@"/var/root/tmp/%@.filemon", NSProcessInfo.processInfo.processName];
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }

    NSDictionary *dicData = [NSDictionary dictionaryWithObject:dest forKey:source];
#ifdef PRINT_PATH_MODE
    PRINT_DATA(funcName,source,dest)
#endif
    
    if (dicData == nil) {
        return;
    }
    if ([funcName isEqualToString:@"CC_MD5"]) {
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index++];
    }
    else if([funcName isEqualToString:@"CC_SHA1"]) {
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index2++];
    }
    else{
        NSLog(@"error~~~  %@",funcName);
        return;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:dicData forKey:funcName];
    [dic writeToFile:filepath  atomically:YES];
}



#define ____________________________________________________________________________________________________base64
void LogBase64(NSString * funcName,NSData *data1,id data2, void *returnAddress)
{
    NSString *filepath;
    static NSString *_logDir = nil;
    static int s_index=0,s_index2 = 0,s_index3 = 0,s_index4 = 0,s_index5 = 0,s_index6 = 0;
    
    if (_logDir == nil)
    {
        _logDir = [[NSString alloc] initWithFormat:@"/var/root/tmp/%@.filemon", NSProcessInfo.processInfo.processName];
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
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index++];
    }
    else if ([funcName isEqualToString:@"base64EncodedDataWithOptions_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index2++];
    }
    else if ([funcName isEqualToString:@"base64EncodedStringWithOptions_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index3++];
    }//
    else if ([funcName isEqualToString:@"initWithBase64EncodedData_options_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index4++];
    }
    else if ([funcName isEqualToString:@"initWithBase64EncodedString_options_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index5++];
    }
    else if ([funcName isEqualToString:@"initWithBase64Encoding_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index6++];
    }
    else{
        NSLog(@"error~~~ LogBase64");
        return;
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:dicData forKey:funcName];
    [dic writeToFile:filepath  atomically:YES];
}

#define ____________________________________________________________________________________________________CommonCrypto
void LogCommonCypto(NSString * funcName,CCOperation op, CCAlgorithm alg, CCOptions options, const void *key, const void *dataIn, size_t dataInLength, void *dataOut, size_t dataOutAvailable, size_t *dataOutMoved, void *returnAddress)
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
        _logDir = [[NSString alloc] initWithFormat:@"/var/root/tmp/%@.filemon", NSProcessInfo.processInfo.processName];
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
    NSData *Cypto_dataIn = [NSData dataWithBytes:dataIn length:dataInLength];
    NSData *Cypto_dataOut = [NSData dataWithBytes:dataOut length:dataOutAvailable];
    NSNumber *Cypto_Moved = [NSNumber numberWithInt:*dataOutMoved];
    //NSString *data = [NSString stringWithFormat:@"%@_%@_%@_%@_%@_%@_%@",Cypto_op,Cypto_alg,Cypto_options,Cypto_key,Cypto_dataIn,Cypto_dataOut,Cypto_Moved];
    NSArray *arryData = [NSArray arrayWithObjects:Cypto_op,              Cypto_alg,      Cypto_options,   Cypto_key,   Cypto_dataIn,     Cypto_dataOut,   Cypto_Moved, nil];
    NSArray *arryDataKeys = [NSArray arrayWithObjects:@"Encrypt_or_Decrypt",@"Cypto_alg",@"Cypto_options",@"Cypto_key",@"Cypto_dataIn",@"Cypto_dataOut",@"Cypto_Moved",nil];
    
    NSDictionary *dicData = [NSDictionary dictionaryWithObjects:arryData forKeys:arryDataKeys];
    
    
#ifdef PRINT_PATH_MODE
    PRINT_DATA(@"Cypto",funcName,dicData)
#endif
    
    if (dicData == nil) {
        return;
    }
    if ([funcName isEqualToString:@"CCCrypt"]) {
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index++];
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
    [dic writeToFile:filepath  atomically:YES];
}


#define ____________________________________________________________________________________________________NSUserDefaults

void LogNSUserDefaults(NSString * funcName,id data, void *returnAddress)
{
    NSString *filepath;
    static NSString *_logDir = nil;
    static int s_index=0,s_index2 = 0,s_index3 = 0,s_index4 = 0,s_index5 = 0,s_index6 = 0,s_index7 = 0,s_index8 = 0,s_index9 = 0,s_index10 = 0,s_index11 = 0,s_index12 = 0,s_index13 = 0,s_index14 = 0,s_index15 = 0,s_index16 = 0,s_index17 = 0,s_index18 = 0,s_index20 = 0,s_index21 = 0,s_index22 = 0,s_index23 = 0,s_index24 = 0,s_index25 = 0,s_index26 = 0,s_index27 = 0,s_index28 = 0,s_index29 = 0;
    
    
    if (_logDir == nil)
    {
        _logDir = [[NSString alloc] initWithFormat:@"/var/root/tmp/%@.filemon", NSProcessInfo.processInfo.processName];
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    
    if (data == nil) {
#ifdef PRINT_PATH_MODE
        PRINT_DATA(@"NSUserDefaults",funcName,@"")
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
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index++];
    }
    else if ([funcName isEqualToString:@"arrayForKey_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index2++];
    }
    else if ([funcName isEqualToString:@"boolForKey_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index3++];
    }
    else if ([funcName isEqualToString:@"dictionaryForKey_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index4++];
    }
    else if ([funcName isEqualToString:@"floatForKey_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index5++];
    }
    else if ([funcName isEqualToString:@"integerForKey_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index6++];
    }
    else if ([funcName isEqualToString:@"objectForKey_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index7++];
    }
    else if ([funcName isEqualToString:@"stringArrayForKey_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index8++];
    }
    else if ([funcName isEqualToString:@"stringForKey_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index9++];
    }
    else if ([funcName isEqualToString:@"doubleForKey_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index10++];
    }
    else if ([funcName isEqualToString:@"URLForKey_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index11++];
    }
    else if ([funcName isEqualToString:@"setBool_forKey_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index12++];
    }
    else if ([funcName isEqualToString:@"setFloat_forKey_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index13++];
    }
    else if ([funcName isEqualToString:@"setInteger_forKey_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index14++];
    }
    else if ([funcName isEqualToString:@"setObject_forKey_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index15++];
    }
    else if ([funcName isEqualToString:@"setDouble_forKey_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index16++];
    }
    else if ([funcName isEqualToString:@"setURL_forKey_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index17++];
    }
    else if ([funcName isEqualToString:@"removeObjectForKey_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index18++];
    }
    else if ([funcName isEqualToString:@"persistentDomainForName_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index20++];
    }
    else if ([funcName isEqualToString:@"persistentDomainNames_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index21++];
    }
    else if ([funcName isEqualToString:@"removePersistentDomainForName_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index22++];
    }
    else if ([funcName isEqualToString:@"setPersistentDomain_forName_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index23++];
    }
    else if ([funcName isEqualToString:@"objectIsForcedForKey_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index24++];
    }
    else if ([funcName isEqualToString:@"objectIsForcedForKey_inDomain_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index25++];
    }
    else if ([funcName isEqualToString:@"dictionaryRepresentation"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index26++];
    }
    else if ([funcName isEqualToString:@"removeVolatileDomainForName_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index27++];
    }
    else if ([funcName isEqualToString:@"setVolatileDomain_forName_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index28++];
    }
    else if ([funcName isEqualToString:@"volatileDomainForName_"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index29++];
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
    [dic writeToFile:filepath  atomically:YES];
}



#define ____________________________________________________________________________________________________sqlite3
void Logsqlite3(NSString * funcName,NSString *data, void *returnAddress)
{
    NSString *filepath;
    static NSString *_logDir = nil;
    static int s_index=0,s_index2 = 0,s_index3 = 0,s_index4 = 0,s_index5 = 0,s_index6 = 0,s_index7 = 0,s_index8 = 0,s_index9 = 0,s_index10 = 0,s_index11 = 0;
  
    if (_logDir == nil)
    {
        _logDir = [[NSString alloc] initWithFormat:@"/var/root/tmp/%@.filemon", NSProcessInfo.processInfo.processName];
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
         filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index++];
    }
    else if ([funcName isEqualToString:@"sqlite3_sql"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index2++];
    }
    else if ([funcName isEqualToString:@"sqlite3_prepare"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index3++];
    }
    else if ([funcName isEqualToString:@"sqlite3_prepare_v2"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index4++];
    }
    else if ([funcName isEqualToString:@"sqlite3_prepare16"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index5++];
    }
    else if ([funcName isEqualToString:@"sqlite3_prepare16_v2"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index6++];
    }
    else if ([funcName isEqualToString:@"sqlite3_open"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index7++];
    }
    else if ([funcName isEqualToString:@"sqlite3_open16"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index8++];
    }
    else if ([funcName isEqualToString:@"sqlite3_open_v2"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index9++];
    }
    else if ([funcName isEqualToString:@"sqlite3_exec"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index10++];
    }
    else if ([funcName isEqualToString:@"sqlite3_create_function"]){
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index11++];
    }
    else{
        NSLog(@"error~~~ Logsqlite3");
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
    [dic writeToFile:filepath  atomically:YES];
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
        _logDir = [[NSString alloc] initWithFormat:@"/var/root/tmp/%@.filemon", NSProcessInfo.processInfo.processName];
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
//        NSLog(@"_logDir = %@",_logDir);
//        NSLog(@"isDirExist = %d",isDirExist);
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    
    if ([funcName isEqualToString:@"SecItemCopyMatching_"]) {
         filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index++];
#ifdef PRINT_PATH_MODE
         PRINT_DATA(@"Keychain",funcName,data)
#endif
    }
    else if ([funcName isEqualToString:@"SecItemAdd_"])
    {
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index2++];
#ifdef PRINT_PATH_MODE
        PRINT_DATA(@"Keychain",funcName,data)
#endif
    }
    else if ([funcName isEqualToString:@"SecItemUpdate_"])
    {
        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index3++];
#ifdef PRINT_PATH_MODE
        PRINT_DATA(@"Keychain",funcName,data)
#endif
    }
    else if([funcName isEqualToString:@"SecItemDelete_"])
    {

        filepath = [NSString stringWithFormat:@"%@/%@_%03d.plist",_logDir,funcName, s_index4++];
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
        [dic writeToFile:filepath  atomically:YES];
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
        PRINT_DATA(@"Write",path,[@"NSDictionary_" stringByAppendingString:funcName])
#endif
        return;
    }
    static NSString *_logDir = nil;
    static int s_index=0,s_index2 = 0;
    
    if (_logDir == nil)
    {
        _logDir = [[NSString alloc] initWithFormat:@"/var/root/tmp/%@.filemon", NSProcessInfo.processInfo.processName];
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    //NSString *tmpPath = [[path description] stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *filepath;
    
    if ([funcName isEqualToString:@"writeToFile_atomically_"]) {
        filepath = [NSString stringWithFormat:@"%@/NSDictionary_%@_%03d.plist",_logDir,funcName, s_index++];
    }
    else if([funcName isEqualToString:@"writeToURL_atomically_"])
    {
        filepath = [NSString stringWithFormat:@"%@/NSDictionary_%@_%03d.plist",_logDir,funcName, s_index2++];
    }

#ifdef DEBUG_MODE
    NSLog(@"filepath=%@",filepath);
    NSLog(@"[[data description] class] = %@",[[data description] class]);
    NSLog(@"data = %@",data);
#endif
    
#ifdef PRINT_PATH_MODE
    PRINT_DATA(@"Write",path,[@"NSDictionary_" stringByAppendingString:funcName])
#endif
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:data forKey:path];
    
//    FILE *fp;
//    fp=fopen([filepath UTF8String], "w");
//        if ([dic description]) {
//        fprintf(fp,"%s", [[dic description] UTF8String]);
//    }
//    fclose(fp);
    if (filepath) {
            [dic writeToFile:filepath  atomically:YES];
    }
}


#define ____________________________________________________________________________________________________NSData
#if __cplusplus
extern "C"
#endif
void LogNSDataWrite(NSString *funcName,id data,NSString *path, void *returnAddress)
{
#ifdef DEBUG_MODE
    NSLog(@"data = %@",data);
    NSLog(@"path = %@",path);
#endif
    if (data == nil) {
#ifdef PRINT_PATH_MODE
        PRINT_DATA(@"Write",path,[@"NSData_" stringByAppendingString:funcName])
#endif
        return;
    }
    static NSString *_logDir = nil;
    static int s_index=0,s_index2 = 0,s_index3 = 0,s_index4 = 0;
    
    if (_logDir == nil)
    {
        _logDir = [[NSString alloc] initWithFormat:@"/var/root/tmp/%@.filemon", NSProcessInfo.processInfo.processName];
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    
    //NSString *tmpPath = [[path description] stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *filepath = nil;
    
    if ([funcName isEqualToString:@"writeToFile_atomically_"]) {
        filepath = [NSString stringWithFormat:@"%@/NSData_%@_%03d.plist",_logDir,funcName, s_index++];
    }
    else if([funcName isEqualToString:@"writeToFile_options_error_"])
    {
        filepath = [NSString stringWithFormat:@"%@/NSData_%@_%03d.plist",_logDir,funcName, s_index2++];
    }
    else if([funcName isEqualToString:@"writeToURL_atomically_"])
    {
        if ([path hasPrefix:@"file://"]) {
            return;
        }
        filepath = [NSString stringWithFormat:@"%@/NSData_%@_%03d.plist",_logDir,funcName, s_index3++];
    }
    else
    {
        if ([path hasPrefix:@"file://"]) {
            return;
        }
        filepath = [NSString stringWithFormat:@"%@/NSData_%@_%03d.plist",_logDir,funcName, s_index4++];
    }

#ifdef DEBUG_MODE
    NSLog(@"filepath=%@",filepath);
    NSLog(@"[[data description] class] = %@",[[data description] class]);
    NSLog(@"data = %@",data);
#endif

#ifdef PRINT_PATH_MODE
    PRINT_DATA(@"Write",path,[@"NSData_" stringByAppendingString:funcName])
#endif
    NSDictionary *dic = [NSDictionary dictionaryWithObject:data forKey:path];

    
//    FILE *fp;
//    fp=fopen([filepath UTF8String], "w");
//    if ([dic description]) {
//        fprintf(fp, "%s",[[dic description] UTF8String]);
//    }
//    fclose(fp);
    if (filepath) {
        [dic writeToFile:filepath  atomically:YES];
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
        PRINT_DATA(@"Write",path,[@"NSString_" stringByAppendingString:funcName])
#endif
        return;
    }
    static NSString *_logDir = nil;
    static int s_index=0,s_index2 = 0,s_index3 = 0,s_index4 = 0;
    
    if (_logDir == nil)
    {
        _logDir = [[NSString alloc] initWithFormat:@"/var/root/tmp/%@.filemon", NSProcessInfo.processInfo.processName];
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    
    //NSString *tmpPath = [[path description] stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *filepath= nil;
    
    if ([funcName isEqualToString:@"writeToFile_atomically_encoding_error_"]) {
        filepath = [NSString stringWithFormat:@"%@/NSString_%@_%03d.plist",_logDir,funcName, s_index++];
    }
    else if([funcName isEqualToString:@"writeToFile_atomically_"])
    {
        filepath = [NSString stringWithFormat:@"%@/NSString_%@_%03d.plist",_logDir,funcName, s_index2++];
    }
    else if([funcName isEqualToString:@"writeToURL_atomically_encoding_error_"])
    {

        filepath = [NSString stringWithFormat:@"%@/NSString_%@_%03d.plist",_logDir,funcName, s_index3++];
    }
    else
    {
        filepath = [NSString stringWithFormat:@"%@/NSString_%@_%03d.plist",_logDir,funcName, s_index4++];
    }
    
#ifdef DEBUG_MODE
    NSLog(@"filepath=%@",filepath);
    NSLog(@"[[data description] class] = %@",[[data description] class]);
    NSLog(@"data = %@",data);
#endif
    
#ifdef PRINT_PATH_MODE
    PRINT_DATA(@"Write",path,[@"NSString_" stringByAppendingString:funcName])
#endif
    NSDictionary *dic = [NSDictionary dictionaryWithObject:data forKey:path];
    
    
//    FILE *fp;
//    fp=fopen([filepath UTF8String], "w");
//    if ([dic description]) {
//        fprintf(fp,  "%s",[[dic description] UTF8String]);
//    }
//    fclose(fp);
    if (filepath) {
        [dic writeToFile:filepath  atomically:YES];
    }
}


#define ____________________________________________________________________________________________________Thecommon
void LoginitWithContentsOffileorurl(NSString *funcName,id data,id pathorurl, void *returnAddress)
{
    NSString *str;
    NSDictionary *dic;
    NSString *filepath = nil;
    NSString *prefix;
    static NSString *_logDir = nil;
    static int s_index=0,s_index2 = 0;
    
// NSString *jsonString = [[NSString alloc] initWithData:data_ encoding:NSUTF8StringEncoding];
//    NSLog(@"filemonitor~~~~~~~~~~data = %s",[data bytes]);
    if (data == nil) {
        return;
    }
    
    if (_logDir == nil)
    {
        _logDir = [[NSString alloc] initWithFormat:@"/var/root/tmp/%@.filemon", NSProcessInfo.processInfo.processName];
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }

    if ([data isKindOfClass:[NSString class]]) {
        prefix = @"NSString";
    }
    else if ([data isKindOfClass:[NSDictionary class]])
    {
        prefix = @"NSDictionary";

    }
    else if ([data isKindOfClass:[NSData class]])
    {
        prefix = @"NSData";
    }
    
    if ([pathorurl isKindOfClass:[NSURL class]]) {
        str = [NSString stringWithFormat:@"%@_%@,%@",prefix,funcName,[(NSURL*)pathorurl absoluteURL]];
#ifdef PRINT_PATH_MODE
        PRINT_DATA(@"init",@"",str)
#endif
        filepath = [NSString stringWithFormat:@"%@/%@_%@_%03d.plist",_logDir,prefix,funcName, s_index++];
           dic = [NSDictionary dictionaryWithObject:data forKey:pathorurl];
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
        filepath = [NSString stringWithFormat:@"%@/%@_%@_%03d.plist",_logDir,prefix,funcName, s_index2++];
           dic = [NSDictionary dictionaryWithObject:data forKey:pathorurl];
    }

//    FILE *fp;
//    fp=fopen([filepath UTF8String], "w");
//    if ([dic description]) {
//        fprintf(fp, "%s",[[dic description] UTF8String]);
//    }
//    fclose(fp);
    if (filepath) {
        [dic writeToFile:filepath  atomically:YES];
    }
    
}

void LogComparedata(NSString *funcName,id data,id data2, void *returnAddress)
{
    NSString *str;
    NSDictionary *dic;
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
        _logDir = [[NSString alloc] initWithFormat:@"/var/root/tmp/%@.filemon", NSProcessInfo.processInfo.processName];
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    
    if ([data isKindOfClass:[NSString class]]) {
        prefix = @"NSString";
        
        str = [NSString stringWithFormat:@"%@_%@_%@_%@",prefix,funcName,data,data2];
#ifdef PRINT_PATH_MODE
        PRINT_DATA(@"Compare",@"",str)
#endif
        filepath = [NSString stringWithFormat:@"%@/%@_%@_%03d.plist",_logDir,prefix,funcName, s_index++];

         }
    else if ([data isKindOfClass:[NSDictionary class]])
    {
        prefix = @"NSDictionary";
        
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
        filepath = [NSString stringWithFormat:@"%@/%@_%@_%03d.plist",_logDir,prefix,funcName, s_index2++];

    }
    else if ([data isKindOfClass:[NSData class]])
    {
        prefix = @"NSData";
        
        str = [NSString stringWithFormat:@"%@_%@_%@_%@",prefix,funcName,data,data2];
#ifdef PRINT_PATH_MODE
        PRINT_DATA(@"Compare",@"",str)
#endif
        filepath = [NSString stringWithFormat:@"%@/%@_%@_%03d.plist",_logDir,prefix,funcName, s_index3++];
    }
    else
    {
        prefix = @"UnKonw";
        
        str = [NSString stringWithFormat:@"%@_%@_%@_%@",prefix,funcName,data,data2];
#ifdef PRINT_PATH_MODE
        PRINT_DATA(@"Compare",@"",str)
#endif
        filepath = [NSString stringWithFormat:@"%@/%@_%@_%03d.plist",_logDir,prefix,funcName, s_index4++];
    }

    dic = [NSDictionary dictionaryWithObject:data forKey:data2];

//    FILE *fp;
//    fp=fopen([filepath UTF8String], "w");
//    if ([dic description]) {
//        fprintf(fp,  "%s",[[dic description] UTF8String]);
//    }
//    fclose(fp);
    if (filepath) {
        [dic writeToFile:filepath  atomically:YES];
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
        _logDir = [[NSString alloc] initWithFormat:@"/var/root/tmp/%@.filemon", NSProcessInfo.processInfo.processName];
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
        filepath = [NSString stringWithFormat:@"%@/NSFileManager_%@_%03d.plist",_logDir,funcName, s_index++];
    }
    else
    {
        PRINT_DATA(@"Create",path,[@"NSFileManager_" stringByAppendingString:funcName])
         filepath = [NSString stringWithFormat:@"%@/NSFileManager_%@_%03d.plist",_logDir,funcName, s_index2++];
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
        NSDictionary *dic = [NSDictionary dictionaryWithObject:data forKey:path];
        
//        FILE *fp;
//        fp=fopen([filepath UTF8String], "w");
//        if ([dic description]) {
//             fprintf(fp,  "%s",[[dic description] UTF8String]);
//        }
//        fclose(fp);
        [dic writeToFile:filepath  atomically:YES];
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
	//_LogLine();
	return 0;
}

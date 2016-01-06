#import "FileMonTracer.h"
#import "SQLiteStorage.h"

#import "IFHOOK.h"
#ifdef NSData_IF_HOOK


// Nice global
extern SQLiteStorage *traceStorage;
extern NSString *objectTypeNotSupported;
extern int WRITE_GLOBAL_COUNT;
extern BOOL SQLITERECORD;
extern int PRINT_GLOBAL_COUNT;


extern NSRegularExpression *regex;

#define PRINT_DATA(mode,funcname,pathordata) {PRINT_GLOBAL_COUNT++;NSLog(@"%-5d---FileMonitor---%@ : %@ : %@",PRINT_GLOBAL_COUNT,mode,funcname,pathordata);}



//Jul 31 19:19:38 360de-iPhone UserDefaults[2328] <Warning>: ---FileMonitor---init :  : NSData_initWithContentsOfFile_,/var/mobile/Applications/5F6DBEAB-7115-43F2-B430-21E7599569C9/UserDefaults.app/Base.lproj/Main.storyboardc/Info.plist


//#define PRINT_DATA(mode,funcname,pathordata) {PRINT_GLOBAL_COUNT++;NSLog(@"%-5d---FileMonitor---%@ : %@ : %@",PRINT_GLOBAL_COUNT,mode,funcname,pathordata);}

HOOK_MESSAGE(BOOL, UIApplication, openURL_, NSURL *URL)
{
	//NSLog(@"%s: %@", __FUNCTION__, URL);
//    PRINT_DATA(@"URL",URL,@"openURL_");
	return _UIApplication_openURL_(self, sel, URL);
}

//
HOOK_MESSAGE(BOOL, UIApplication, canOpenURL_, NSURL *URL)//- (BOOL)canOpenURL:(NSURL *)url
{
    //NSLog(@"~_~12%s: %@", __FUNCTION__, URL);
//    PRINT_DATA(@"URL",URL,@"canOpenURL_");
	return _UIApplication_canOpenURL_(self, sel, URL);
}

HOOK_MESSAGE(BOOL,NSData,writeToFile_atomically_,NSString *path,BOOL atomically)
{
    @try {
        NSRange range = [path rangeOfString:@"filemon"];
        if (range.location == NSNotFound) {
            NSString *pathexten = [path pathExtension];
            NSArray *checkingResults  = [regex matchesInString:pathexten options:0 range:NSMakeRange(0, [pathexten length])];
            if ([checkingResults count] != 0) {
                
            }else
            _LogNSDataWrite(@"writeToFile_atomically_",self,path);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"error exception reason= %@ ",exception.reason);
    }
    return _NSData_writeToFile_atomically_(self,sel,path,atomically);
}
HOOK_MESSAGE(BOOL,NSData,writeToFile_options_error_,NSString *path,NSDataWritingOptions mask,NSError** errorPtr)
{
    NSString *pathexten = [path pathExtension];
    NSArray *checkingResults  = [regex matchesInString:pathexten options:0 range:NSMakeRange(0, [pathexten length])];
    if ([checkingResults count] != 0) {
        
    }else
    _LogNSDataWrite(@"writeToFile_options_error_",self,path);
    return _NSData_writeToFile_options_error_(self,sel,path,mask,errorPtr);
}

HOOK_MESSAGE(BOOL,NSData,writeToURL_atomically_,NSURL *aURL,BOOL atomically)
{
    _LogNSDataWrite(@"writeToURL_atomically_",self,[aURL absoluteString]);
    return _NSData_writeToURL_atomically_(self,sel,aURL,atomically);
}
HOOK_MESSAGE(BOOL,NSData,writeToURL_options_error_,NSString *path,NSDataWritingOptions mask,NSError** errorPtr)
{
    NSString *pathexten = [path pathExtension];
    NSArray *checkingResults  = [regex matchesInString:pathexten options:0 range:NSMakeRange(0, [pathexten length])];
    if ([checkingResults count] != 0) {
        
    }else
    _LogNSDataWrite(@"writeToURL_options_error_",self,path);
    return _NSData_writeToURL_options_error_(self,sel,path,mask,errorPtr);
}

//file
HOOK_MESSAGE(NSData*,NSData,initWithContentsOfURL_,NSURL *aURL)
{
    NSLog(@"aURL = %@",aURL);
    NSData *data = _NSData_initWithContentsOfURL_(self,sel,aURL);//
    
        NSString *pathexten = [[aURL absoluteString] pathExtension];
        NSArray *checkingResults  = [regex matchesInString:pathexten options:0 range:NSMakeRange(0, [pathexten length])];
        if ([checkingResults count] != 0) {
            PRINT_DATA(@"loadfile",@"initWithContentsOfURL_",@"")
        }else{
            _LoginitWithContentsOffileorurl(@"initWithContentsOfURL_",data,aURL);
        }
    return data;
}

HOOK_MESSAGE(NSData*,NSData,initWithContentsOfFile_,NSString *path)
{
    NSData *data = _NSData_initWithContentsOfFile_(self,sel,path);
    NSRange range =[path rangeOfString:@"Info.plist"];
    NSRange range2 =[path rangeOfString:@".nib"];
    NSRange range3 =[path rangeOfString:@"/var/mobile/Library/ConfigurationProfiles/"];
    NSRange range4 =[path rangeOfString:@"/System/Library/CoreServices/"];
    NSRange range5 =[path rangeOfString:@"/var/mobile/Library/SyncedPreferences/"];
    
        if (range.location != NSNotFound || range2.location != NSNotFound || range3.location != NSNotFound || range4.location != NSNotFound || range5.location!= NSNotFound) {
        }
        else
        {
            NSString *pathexten = [path pathExtension];
            NSArray *checkingResults  = [regex matchesInString:pathexten options:0 range:NSMakeRange(0, [pathexten length])];
            if ([checkingResults count] != 0) {
                
            }else
            _LoginitWithContentsOffileorurl(@"initWithContentsOfFile_",data,path);
        }
        return data;
}

//compare
HOOK_MESSAGE(BOOL,NSData,isEqualToData_,NSData *otherData)
{
//    _LogComparedata(@"isEqualToData_",self,otherData);
    return _NSData_isEqualToData_(self,sel,otherData);
}


//base64
HOOK_MESSAGE(NSString *,NSData,base64Encoding)
{
    //    _LogComparedata(@"isEqualToData_",self,otherData);
    NSString  * str_base64 = _NSData_base64Encoding(self,sel);
//    NSLog(@"self = %@   ->=   %@",self,str_base64);
    _LogBase64(@"base64Encoding",str_base64,self);
    return str_base64;
}

HOOK_MESSAGE(NSData *,NSData,base64EncodedDataWithOptions_,NSDataBase64EncodingOptions options)
{
    //    _LogComparedata(@"isEqualToData_",self,otherData);
    NSData* tmpdata = _NSData_base64EncodedDataWithOptions_(self,sel,options);
    
     _LogBase64(@"base64EncodedDataWithOptions_",[self description],tmpdata);
    return tmpdata;
}


HOOK_MESSAGE(NSString *,NSData,base64EncodedStringWithOptions_,NSDataBase64EncodingOptions options)
{
    //    _LogComparedata(@"isEqualToData_",self,otherData);
    NSString *str_base64 = _NSData_base64EncodedStringWithOptions_(self,sel,options);
    
    _LogBase64(@"base64EncodedStringWithOptions_",str_base64,self);
    return str_base64;
}

//base64 init
HOOK_MESSAGE(NSData*,NSData,initWithBase64EncodedData_options_,NSData *base64Data,NSDataBase64DecodingOptions options)
{
    //    _LogComparedata(@"isEqualToData_",self,otherData);
    NSData* data = _NSData_initWithBase64EncodedData_options_(self,sel,base64Data,options);
    if (data != nil) {
        _LogBase64(@"initWithBase64EncodedData_options_",[base64Data description], data);
    }
    return data;
}

HOOK_MESSAGE(NSData*,NSData,initWithBase64EncodedString_options_,NSString *base64String,NSDataBase64DecodingOptions options)
{
    //    _LogComparedata(@"isEqualToData_",self,otherData);
    id data = _NSData_initWithBase64EncodedString_options_(self,sel,base64String,options);
    
    if (SQLITERECORD) {
//        FileMonTracer *tracer = [[FileMonTracer alloc] initWithClass:@"NSData" andMethod:@"initWithBase64EncodedString_options_" andBehavior:@"Encrypt"];
//        [tracer addArgFromPlistObject:base64String withKey:@"base64String"];
//        [tracer addReturnValueFromPlistObject:data];
//        [traceStorage saveFileMonTracer: tracer];
//        [tracer release];
    }
    else
    {
        if (data !=nil) {
            _LogBase64(@"initWithBase64EncodedString_options_",base64String,data);
        }
    }
    return data;
}


HOOK_MESSAGE(id,NSData,initWithBase64Encoding_,NSString *base64String)
{
    //    _LogComparedata(@"isEqualToData_",self,otherData);
    id data = _NSData_initWithBase64Encoding_(self,sel,base64String);
    
    if (SQLITERECORD) {
//        FileMonTracer *tracer = [[FileMonTracer alloc] initWithClass:@"NSData" andMethod:@"initWithBase64Encoding_:" andBehavior:@"Encrypt"];
//        [tracer addArgFromPlistObject:base64String withKey:@"base64String"];
//        [tracer addReturnValueFromPlistObject:data];
//        [traceStorage saveFileMonTracer: tracer];
//        [tracer release];
    }
    else
    {
    if (data) {
        _LogBase64(@"initWithBase64Encoding_",base64String,data);
    }
    }
    return data;
}

//QHFoundationDynamic thir_lib



//////////////////////////////////////////////////////////////////////////////////////////////////// 类函数
HOOK_META(id, NSData, initWithContentsOfFile_options_error_,NSString *path,NSDataReadingOptions mask,NSError **errorPtr)
{
    NSData* data = _NSData_initWithContentsOfFile_options_error_(self,sel,path,mask,errorPtr);
    
    if (SQLITERECORD) {
//        FileMonTracer *tracer = [[FileMonTracer alloc] initWithClass:@"NSData" andMethod:@"initWithContentsOfFile_options_error_:" andBehavior:@"loadfile"];
//        [tracer addArgFromPlistObject:path withKey:@"path"];
//        [tracer addReturnValueFromPlistObject:data];
//        [traceStorage saveFileMonTracer: tracer];
//        [tracer release];
    }
    else
    {
    if (data) {
        _LogNSDataWrite(@"initWithContentsOfFile_options_error_",data,path);
    }
    }
    return data;
}
HOOK_META(id, NSData, initWithContentsOfURL_options_error_,NSString *path)
{
    NSData* data = _NSData_initWithContentsOfURL_options_error_(self,sel,path);
    
    if (SQLITERECORD) {
//        FileMonTracer *tracer = [[FileMonTracer alloc] initWithClass:@"NSData" andMethod:@"initWithContentsOfURL_options_error_:" andBehavior:@"loadfile"];
//        [tracer addArgFromPlistObject:path withKey:@"path"];
//        [tracer addReturnValueFromPlistObject:data];
//        [traceStorage saveFileMonTracer: tracer];
//        [tracer release];
    }
    else
    {
        if (data) {
            NSString *pathexten = [path pathExtension];
            NSArray *checkingResults  = [regex matchesInString:pathexten options:0 range:NSMakeRange(0, [pathexten length])];
            if ([checkingResults count] != 0) {
                
            }else
                _LogNSDataWrite(@"initWithContentsOfURL_options_error_",data,path);
        }
    }
    return data;
}

HOOK_META(id, NSData, dataWithContentsOfURL_options_error_,NSURL *aURL,NSDataReadingOptions mask,NSError **errorPtr)
{
    NSData* data = _NSData_dataWithContentsOfURL_options_error_(self,sel,aURL,mask,errorPtr);
    
    if (SQLITERECORD) {
//        FileMonTracer *tracer = [[FileMonTracer alloc] initWithClass:@"NSData" andMethod:@"dataWithContentsOfURL_options_error_:" andBehavior:@"loadfile"];
//        [tracer addArgFromPlistObject:aURL withKey:@"URL"];
//        [tracer addReturnValueFromPlistObject:data];
//        [traceStorage saveFileMonTracer: tracer];
//        [tracer release];
    }
    else
    {
        if (data) {
            _LogNSDataWrite(@"dataWithContentsOfURL_options_error_",data,aURL);
        }
    }
    return data;
}
HOOK_META(id, NSData, dataWithContentsOfURL_,NSURL *aURL)
{
    NSData* data = _NSData_dataWithContentsOfURL_(self,sel,aURL);
    
    if (SQLITERECORD) {
//        FileMonTracer *tracer = [[FileMonTracer alloc] initWithClass:@"NSData" andMethod:@"dataWithContentsOfURL_:" andBehavior:@"loadfile"];
//        [tracer addArgFromPlistObject:aURL withKey:@"URL"];
//        [tracer addReturnValueFromPlistObject:data];
//        [traceStorage saveFileMonTracer: tracer];
//        [tracer release];
    }
    else{
        if (data) {
            _LogNSDataWrite(@"dataWithContentsOfURL_",data,aURL);
        }
    }
    return data;
}

HOOK_META(id, NSData, dataWithContentsOfFile_options_error_,NSString *path,NSDataReadingOptions mask,NSError **errorPtr)
{
    NSData* data = _NSData_dataWithContentsOfFile_options_error_(self,sel,path,mask,errorPtr);
    
    if (SQLITERECORD) {
//        FileMonTracer *tracer = [[FileMonTracer alloc] initWithClass:@"NSData" andMethod:@"dataWithContentsOfFile_options_error_:" andBehavior:@"loadfile"];
//        [tracer addArgFromPlistObject:path withKey:@"path"];
//        [tracer addReturnValueFromPlistObject:data];
//        [traceStorage saveFileMonTracer: tracer];
//        [tracer release];
    }
    else
    {
        if ([path rangeOfString:@"/System/Library/TextInput/"].location == NSNotFound) {
            if (data) {
                NSString *pathexten = [path pathExtension];
                NSArray *checkingResults  = [regex matchesInString:pathexten options:0 range:NSMakeRange(0, [pathexten length])];
                if ([checkingResults count] != 0) {
                    
                }else
                _LogNSDataWrite(@"dataWithContentsOfFile_options_error_",data,path);
            }
        }
    }
    return data;
}



id $NSData_dataWithContentsOfFile_(id self, SEL sel, NSString *path);\
id (*_NSData_dataWithContentsOfFile_)(id self, SEL sel,NSString *path);\
__attribute__((constructor)) void _Init_NSData_dataWithContentsOfFile_()
{\
    _HookMessage(objc_getMetaClass("NSData"), "dataWithContentsOfFile_", (void *)$NSData_dataWithContentsOfFile_, (void **)&_NSData_dataWithContentsOfFile_);
}\
id $NSData_dataWithContentsOfFile_(id self, SEL sel, NSString *path)
//HOOK_META(id, NSData, dataWithContentsOfFile_,NSString *path)
{
    NSData* data = _NSData_dataWithContentsOfFile_(self,sel,path);
    if (SQLITERECORD) {
//               FileMonTracer *tracer = [[FileMonTracer alloc] initWithClass:@"NSData" andMethod:@"dataWithContentsOfFile_:" andBehavior:@"loadfile"];
//        [tracer addArgFromPlistObject:path withKey:@"path"];
//        [tracer addReturnValueFromPlistObject:data];
//        [traceStorage saveFileMonTracer: tracer];
//        [tracer release];
    }
    else
    {
        if (data) {
            NSString *pathexten = [path pathExtension];
            NSArray *checkingResults  = [regex matchesInString:pathexten options:0 range:NSMakeRange(0, [pathexten length])];
            if ([checkingResults count] != 0) {
                
            }else
            _LogNSDataWrite(@"dataWithContentsOfFile_",data,path);
        }
    }
    return data;
}


#endif
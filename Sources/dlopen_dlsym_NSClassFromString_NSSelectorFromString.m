

#import "IFHOOK.h"


#ifdef dlopen_IF_HOOK

#define IF_PRINT_PATH //print the log path
extern int print_once;

#define IFHOOK_PrivateAPIindexdlopen
#define IFHOOK_PrivateAPIindexdlsym
#define IFHOOK_PrivateAPIindexobjc_getClass
#define IFHOOK_PrivateAPIindexobjc_NSClassFromString
#define IFHOOK_PrivateAPIindexobjc_NSSelectorFromString
#define IFHOOK_PrivateAPIindexobjc_noninstance_performSelector_
#define IFHOOK_PrivateAPIindexobjc_noninstance_performSelector_withObject_
#define IFHOOK_PrivateAPIindexobjc_noninstance_performSelector_withObject_withObject_
#define IFHOOK_PrivateAPIindexobjc_performSelector_
#define IFHOOK_PrivateAPIindexobjc_performSelector_withObject_
#define IFHOOK_PrivateAPIindexobjc_performSelector_withObject_withObject_
#define IFHOOK_PrivateAPIindexobjc_performSelector_withObject_afterDelay_
#define IFHOOK_PrivateAPIindexobjc_performSelector_withObject_afterDelay_inModes_
#define IFHOOK_PrivateAPIindexobjc_performSelectorOnMainThread_withObject_waitUntilDone_
#define IFHOOK_PrivateAPIindexobjc_performSelectorOnMainThread_withObject_waitUntilDone_modes_
#define IFHOOK_PrivateAPIindexobjc_performSelector_onThread_withObject_waitUntilDone_
#define IFHOOK_PrivateAPIindexobjc_performSelector_onThread_withObject_waitUntilDone_modes_
#define IFHOOK_PrivateAPIindexobjc_performSelectorInBackground_withObject_


extern NSString *PrivateAPIPath;

extern int PrivateAPIindexdlopen;
extern NSMutableArray *dlopen_excludeArray;

extern int PrivateAPIindexdlsym;
extern NSMutableArray *dlsym_excludeArray;

extern int PrivateAPIindexobjc_getClass;
extern NSMutableArray *objc_getClass_excludeArray;

extern int PrivateAPIindexobjc_NSClassFromString;
extern NSMutableArray *NSClassFromString_excludeArray;

extern int PrivateAPIindexobjc_NSSelectorFromString;
extern NSMutableArray *NSSelectorFromString_excludeArray;

//noninstance:
extern int PrivateAPIindexobjc_noninstance_performSelector_;
extern NSMutableArray *noninstance_performSelector_excludeArray;

extern int PrivateAPIindexobjc_noninstance_performSelector_withObject_;
extern NSMutableArray *noninstance_performSelector_withObject_excludeArray;

extern int PrivateAPIindexobjc_noninstance_performSelector_withObject_withObject_;
extern NSMutableArray *noninstance_performSelector_withObject_withObject_excludeArray;


//instance:
//protocol
extern int PrivateAPIindexobjc_performSelector_;
extern NSMutableArray *performSelector_excludeArray;

extern int PrivateAPIindexobjc_performSelector_withObject_;
extern NSMutableArray *performSelector_withObject_excludeArray;

extern int PrivateAPIindexobjc_performSelector_withObject_withObject_;
extern NSMutableArray *performSelector_withObject_withObject_excludeArray;

//normal
extern int PrivateAPIindexobjc_performSelector_withObject_afterDelay_;
extern NSMutableArray *performSelector_withObject_afterDelay_excludeArray;

extern int PrivateAPIindexobjc_performSelector_withObject_afterDelay_inModes_;
extern NSMutableArray *performSelector_withObject_afterDelay_inModes_excludeArray;

extern int PrivateAPIindexobjc_performSelectorOnMainThread_withObject_waitUntilDone_;
extern NSMutableArray *performSelectorOnMainThread_withObject_waitUntilDone_excludeArray;

extern int PrivateAPIindexobjc_performSelectorOnMainThread_withObject_waitUntilDone_modes_;
extern NSMutableArray *performSelectorOnMainThread_withObject_waitUntilDone_modes_excludeArray;

extern int PrivateAPIindexobjc_performSelector_onThread_withObject_waitUntilDone_;
extern NSMutableArray *performSelector_onThread_withObject_waitUntilDone_excludeArray;

extern int PrivateAPIindexobjc_performSelector_onThread_withObject_waitUntilDone_modes_;
extern NSMutableArray *performSelector_onThread_withObject_waitUntilDone_modes_excludeArray;

extern int PrivateAPIindexobjc_performSelectorInBackground_withObject_;
extern NSMutableArray *performSelectorInBackground_withObject_excludeArray;



#define PRINT_DATA(mode,funcname,pathordata,filepath) {NSLog(@"---APIMonitor---%@:%@ : %@\n%@",mode,funcname,pathordata,filepath);}





//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#import "substrate.h"

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

BOOL wasCalledByApp()
{
    NSString *appProcessName = [[NSProcessInfo processInfo] processName];
    NSRange callerAtIndex;
    
    @try {
        NSArray *syms = [NSThread callStackSymbols];
        if ([syms count] >1) {
            callerAtIndex = [[syms objectAtIndex:2] rangeOfString: appProcessName];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"[NSThread callStackSymbols] = %@",[NSThread callStackSymbols]);
    }
    @finally {
    }
    
    if (callerAtIndex.location == NSNotFound) {
        return false;
    }
    return true;
}

//NSObject~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Conforms to None noninstance

#define ____________________________________________________________________________________________________NonInstance_performSelector_meta
#ifdef IFHOOK_PrivateAPIindexobjc_noninstance_performSelector_

HOOK_MyMETA(id, NSObject,performSelector_,SEL aSelector )
{
    if (wasCalledByApp() == false) {
        //        NSLog(@"not in the stack");
        return _NSObject_performSelector__meta(self,sel,aSelector);
    }
    id retdata = _NSObject_performSelector__meta(self,sel,aSelector);
    
    NSString *FuncName = @"NonInstance_performSelector_";
    //NSString *RetData = [NSString stringWithFormat:@"RetData:%@",retdata];
    NSString *SELAddress =  [NSString stringWithFormat:@"SELAddress:0x%llx",aSelector];
    NSString *SELName = [NSString stringWithFormat:@"SELName:%@",NSStringFromSelector(aSelector)];
    
    NSArray *array = [NSArray arrayWithObjects:SELAddress,SELName,nil];
    //        NSLog(@"array = %@",array);
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:array forKey:FuncName];
    //        NSLog(@"dict = %@",dict);
    
    static NSString *_logDir = nil;
    
    if (_logDir == nil)
    {
                _logDir = [[NSString alloc] initWithFormat:PrivateAPIPath];
#ifdef IF_PRINT_PATH
        if (print_once) {
            print_once = 0;
            NSLog(@"PrivateAPIPath = %@",PrivateAPIPath);
        }
#endif
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    NSString *filepath = [NSString stringWithFormat:@"%@/%d_%@.plist",_logDir,PrivateAPIindexobjc_noninstance_performSelector_,FuncName];
    PrivateAPIindexobjc_noninstance_performSelector_++;
    
    PRINT_DATA(@"",FuncName,array,filepath);
    
    BOOL flag = [dict writeToFile:filepath atomically:YES];
    if (flag != 1) {
        NSLog(@"%@  not write success~~~~~~~~~~~~~~~",FuncName);
    }
    return retdata;
}
#endif
#define ____________________________________________________________________________________________________NonInstance_performSelector_metaover


#define ____________________________________________________________________________________________________NonInstance_performSelector_withObject_meta
#ifdef IFHOOK_PrivateAPIindexobjc_noninstance_performSelector_withObject_

HOOK_MyMETA(id, NSObject, performSelector_withObject_,SEL aSelector,id anObject)
{
    if (wasCalledByApp() == false) {
        //        NSLog(@"not in the stack");
        return _NSObject_performSelector_withObject__meta(self,sel,aSelector,anObject);
    }
    
    id retdata = _NSObject_performSelector_withObject__meta(self,sel,aSelector,anObject);
    
    NSString *FuncName = @"NonInstance_performSelector_withObject_";
    //NSString *RetData = [NSString stringWithFormat:@"RetData:%@",retdata];
    NSString *SELAddress =  [NSString stringWithFormat:@"SELAddress:0x%llx",aSelector];
    NSString *AnObject =  [NSString stringWithFormat:@"AnObject:%@",anObject];
    NSString *SELName = [NSString stringWithFormat:@"SELName:%@",NSStringFromSelector(aSelector)];

    NSArray *array = [NSArray arrayWithObjects:SELAddress,SELName,AnObject,nil];
    //        NSLog(@"array = %@",array);
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:array forKey:FuncName];
    //        NSLog(@"dict = %@",dict);
    
    static NSString *_logDir = nil;
    
    if (_logDir == nil)
    {
                _logDir = [[NSString alloc] initWithFormat:PrivateAPIPath];
#ifdef IF_PRINT_PATH
        if (print_once) {
            print_once = 0;
            NSLog(@"PrivateAPIPath = %@",PrivateAPIPath);
        }
#endif
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    NSString *filepath = [NSString stringWithFormat:@"%@/%d_%@.plist",_logDir,PrivateAPIindexobjc_noninstance_performSelector_withObject_,FuncName];
    PrivateAPIindexobjc_noninstance_performSelector_withObject_++;
    
    PRINT_DATA(@"",FuncName,array,filepath);
    
    BOOL flag = [dict writeToFile:filepath atomically:YES];
    if (flag != 1) {
        NSLog(@"%@  not write success~~~~~~~~~~~~~~~",FuncName);
    }
    return retdata;
}
#endif
#define ____________________________________________________________________________________________________NonInstance_performSelector_withObject_metaover


#define ____________________________________________________________________________________________________NonInstance_performSelector_withObject_withObject_meta
#ifdef IFHOOK_PrivateAPIindexobjc_noninstance_performSelector_withObject_withObject_

HOOK_MyMETA(id, NSObject, performSelector_withObject_withObject_,SEL aSelector,id anObject,id anotherObject)
{
    if (wasCalledByApp() == false) {
        //        NSLog(@"not in the stack");
        return _NSObject_performSelector_withObject_withObject__meta(self,sel,aSelector,anObject,anotherObject);
    }
    
    id retdata = _NSObject_performSelector_withObject_withObject__meta(self,sel,aSelector,anObject,anotherObject);
    
   
    
    NSString *FuncName = @"NonInstance_performSelector_withObject_withObject_";
    //NSString *RetData = [NSString stringWithFormat:@"RetData:%@",retdata];
    NSString *SELAddress =  [NSString stringWithFormat:@"SELAddress:0x%llx",aSelector];
    NSString *SELName = [NSString stringWithFormat:@"SELName:%@",NSStringFromSelector(aSelector)];
    NSString *AnObject =  [NSString stringWithFormat:@"AnObject:%@",anObject];
    NSString *AnotherObject =  [NSString stringWithFormat:@"AnotherObject:%@",anotherObject];
    
    
    NSArray *array = [NSArray arrayWithObjects:SELAddress,SELName,AnObject,AnotherObject,nil];
    //        NSLog(@"array = %@",array);
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:array forKey:FuncName];
    //        NSLog(@"dict = %@",dict);
    
    static NSString *_logDir = nil;
    
    if (_logDir == nil)
    {
                _logDir = [[NSString alloc] initWithFormat:PrivateAPIPath];
#ifdef IF_PRINT_PATH
        if (print_once) {
            print_once = 0;
            NSLog(@"PrivateAPIPath = %@",PrivateAPIPath);
        }
#endif
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    NSString *filepath = [NSString stringWithFormat:@"%@/%d_%@.plist",_logDir,PrivateAPIindexobjc_noninstance_performSelector_withObject_withObject_,FuncName];
    PrivateAPIindexobjc_noninstance_performSelector_withObject_withObject_++;
    
    PRINT_DATA(@"",FuncName,array,filepath);
    
    BOOL flag = [dict writeToFile:filepath atomically:YES];
    if (flag != 1) {
        NSLog(@"%@  not write success~~~~~~~~~~~~~~~",FuncName);
    }
    return retdata;
}
#endif
#define ____________________________________________________________________________________________________NonInstance_performSelector_withObject_withObject_metaover



//NSObject~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Conforms to None
#define ____________________________________________________________________________________________________Instance_performSelector_
#ifdef IFHOOK_PrivateAPIindexobjc_performSelector_
HOOK_MESSAGE(id, NSObject, performSelector_,SEL aSelector)
{
    if (wasCalledByApp() == false) {
        //        NSLog(@"not in the stack");
        return _NSObject_performSelector_(self,sel,aSelector);
    }
    
    NSString *excludeInfo = [NSString stringWithFormat:@"%@_%@",NSStringFromClass([self class]),NSStringFromSelector(aSelector)];
//    NSLog(@"excludeInfo = %@",excludeInfo);
    for (NSString * tmp in performSelector_excludeArray) {
        if ([tmp isEqualToString:excludeInfo]) {
            return _NSObject_performSelector_(self,sel,aSelector);
        }
    }
    [performSelector_excludeArray addObject:excludeInfo];
    
    
    id retdata = _NSObject_performSelector_(self,sel,aSelector);
//    id retdata2;
//    
//    @try {
//        NSLog(@"switch Class type~~~");
//        retdata2 = [NSString stringWithFormat:@"%s",retdata];
//        if ([retdata2 isEqualToString:@""]) {
//            retdata2 = retdata = [NSString stringWithFormat:@"%lx",retdata];
//        }
//    }
//    @catch (NSException *exception) {
//        NSLog(@"error~~~");
//        return _NSObject_performSelector_(self,sel,aSelector);
//    }
//    retdata = retdata2;
    
    NSString *SELFName = [NSString stringWithFormat:@"SELFName:%@",NSStringFromClass([self class])];
    NSString *FuncName = @"Instance_performSelector_";
    //NSString *RetData = [NSString stringWithFormat:@"RetData:%@",retdata];
    NSString *SELAddress =  [NSString stringWithFormat:@"SELAddress:0x%llx",aSelector];
    NSString *SELName = [NSString stringWithFormat:@"SELName:%@",NSStringFromSelector(aSelector)];
    
    NSArray *array = [NSArray arrayWithObjects:SELFName,SELAddress,SELName,nil];
    //        NSLog(@"array = %@",array);
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:array forKey:FuncName];
    //        NSLog(@"dict = %@",dict);
    
    static NSString *_logDir = nil;
    
    if (_logDir == nil)
    {
                _logDir = [[NSString alloc] initWithFormat:PrivateAPIPath];
#ifdef IF_PRINT_PATH
        if (print_once) {
            print_once = 0;
            NSLog(@"PrivateAPIPath = %@",PrivateAPIPath);
        }
#endif
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    NSString *filepath = [NSString stringWithFormat:@"%@/%d_%@.plist",_logDir,PrivateAPIindexobjc_performSelector_,FuncName];
    PrivateAPIindexobjc_performSelector_++;
    
    PRINT_DATA(@"",FuncName,array,filepath);
    
    BOOL flag = [dict writeToFile:filepath atomically:YES];
    if (flag != 1) {
        NSLog(@"%@  not write success~~~~~~~~~~~~~~~",FuncName);
    }
    return retdata;
}
#endif
#define ____________________________________________________________________________________________________Instance_performSelector_over



#define ____________________________________________________________________________________________________Instance_performSelector_withObject_
#ifdef IFHOOK_PrivateAPIindexobjc_performSelector_withObject_
HOOK_MESSAGE(id, NSObject, performSelector_withObject_,SEL aSelector,id anObject)
{
    if (wasCalledByApp() == false) {
        //        NSLog(@"not in the stack");
        return _NSObject_performSelector_withObject_(self,sel,aSelector,anObject);
    }
    
    NSString *excludeInfo = [NSString stringWithFormat:@"%@_%@",NSStringFromClass([self class]),NSStringFromSelector(aSelector)];
    for (NSString * tmp in performSelector_withObject_excludeArray) {
        if ([tmp isEqualToString:excludeInfo]) {
            return _NSObject_performSelector_withObject_(self,sel,aSelector,anObject);
        }
    }
    [performSelector_withObject_excludeArray addObject:excludeInfo];
    id retdata = _NSObject_performSelector_withObject_(self,sel,aSelector,anObject);
    
    NSString *SELFName = [NSString stringWithFormat:@"SELFName:%@",NSStringFromClass([self class])];
    NSString *FuncName = @"Instance_performSelector_withObject_";
    //NSString *RetData = [NSString stringWithFormat:@"RetData:%@",retdata];
    NSString *SELAddress =  [NSString stringWithFormat:@"SELAddress:0x%llx",aSelector];
    NSString *SELName = [NSString stringWithFormat:@"SELName:%@",NSStringFromSelector(aSelector)];
    NSString *AnObject =  [NSString stringWithFormat:@"AnObject:%@",anObject];
    
    NSArray *array = [NSArray arrayWithObjects:SELFName,SELAddress,SELName,AnObject,nil];
    //        NSLog(@"array = %@",array);
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:array forKey:FuncName];
    //        NSLog(@"dict = %@",dict);
    
    static NSString *_logDir = nil;
    
    if (_logDir == nil)
    {
                _logDir = [[NSString alloc] initWithFormat:PrivateAPIPath];
#ifdef IF_PRINT_PATH
        if (print_once) {
            print_once = 0;
            NSLog(@"PrivateAPIPath = %@",PrivateAPIPath);
        }
#endif
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    NSString *filepath = [NSString stringWithFormat:@"%@/%d_%@.plist",_logDir,PrivateAPIindexobjc_performSelector_withObject_,FuncName];
    PrivateAPIindexobjc_performSelector_withObject_++;
    
    PRINT_DATA(@"",FuncName,array,filepath);
    
    BOOL flag = [dict writeToFile:filepath atomically:YES];
    if (flag != 1) {
        NSLog(@"%@  not write success~~~~~~~~~~~~~~~",FuncName);
    }
    return retdata;
}
#endif
#define ____________________________________________________________________________________________________Instance_performSelector_withObject_over

#define ____________________________________________________________________________________________________Instance_performSelector_withObject_withObject_
#ifdef IFHOOK_PrivateAPIindexobjc_performSelector_withObject_withObject_
HOOK_MESSAGE(id, NSObject, performSelector_withObject_withObject_,SEL aSelector,id anObject,id anotherObject)
{
    if (wasCalledByApp() == false) {
        //        NSLog(@"not in the stack");
        return _NSObject_performSelector_withObject_withObject_(self,sel,aSelector,anObject,anotherObject);
    }
    
    NSString *excludeInfo = [NSString stringWithFormat:@"%@_%@",NSStringFromClass([self class]),NSStringFromSelector(aSelector)];
    for (NSString * tmp in performSelector_withObject_withObject_excludeArray) {
        if ([tmp isEqualToString:excludeInfo]) {
            return  _NSObject_performSelector_withObject_withObject_(self,sel,aSelector,anObject,anotherObject);
        }
    }
    [performSelector_withObject_withObject_excludeArray addObject:excludeInfo];
    
    
    id retdata = _NSObject_performSelector_withObject_withObject_(self,sel,aSelector,anObject,anotherObject);
    
   
    
    NSString *SELFName = [NSString stringWithFormat:@"SELFName:%@",NSStringFromClass([self class])];
    NSString *FuncName = @"Instance_performSelector_withObject_withObject_";
    //NSString *RetData = [NSString stringWithFormat:@"RetData:%@",retdata];
    NSString *SELAddress =  [NSString stringWithFormat:@"SELAddress:0x%llx",aSelector];
    NSString *SELName = [NSString stringWithFormat:@"SELName:%@",NSStringFromSelector(aSelector)];
    NSString *AnObject =  [NSString stringWithFormat:@"AnObject:%@",anObject];
    NSString *AnotherObject =  [NSString stringWithFormat:@"AnotherObject:%@",anotherObject];
    
    
    NSArray *array = [NSArray arrayWithObjects:SELFName,SELAddress,SELName,AnObject,AnotherObject,nil];
    //        NSLog(@"array = %@",array);
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:array forKey:FuncName];
    //        NSLog(@"dict = %@",dict);
    
    static NSString *_logDir = nil;
    
    if (_logDir == nil)
    {
                _logDir = [[NSString alloc] initWithFormat:PrivateAPIPath];
#ifdef IF_PRINT_PATH
        if (print_once) {
            print_once = 0;
            NSLog(@"PrivateAPIPath = %@",PrivateAPIPath);
        }
#endif
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    NSString *filepath = [NSString stringWithFormat:@"%@/%d_%@.plist",_logDir,PrivateAPIindexobjc_performSelector_withObject_withObject_,FuncName];
    PrivateAPIindexobjc_performSelector_withObject_withObject_++;
    
    PRINT_DATA(@"",FuncName,array,filepath);
    
    BOOL flag = [dict writeToFile:filepath atomically:YES];
    if (flag != 1) {
        NSLog(@"%@  not write success~~~~~~~~~~~~~~~",FuncName);
    }
    return retdata;
}
#endif
#define ____________________________________________________________________________________________________Instance_performSelector_withObject_withObject_over



//NSObject~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Conforms to NSObject
#define ____________________________________________________________________________________________________Instance_performSelector_withObject_afterDelay_
#ifdef IFHOOK_PrivateAPIindexobjc_performSelector_withObject_afterDelay_
HOOK_MESSAGE(void, NSObject, performSelector_withObject_afterDelay_,SEL aSelector,id anArgument,NSTimeInterval delay)
{
    if (wasCalledByApp() == false) {
        //        NSLog(@"not in the stack");
        return _NSObject_performSelector_withObject_afterDelay_(self,sel,aSelector,anArgument,delay);
    }
   
    NSString *excludeInfo = [NSString stringWithFormat:@"%@_%@",NSStringFromClass([self class]),NSStringFromSelector(aSelector)];
    for (NSString * tmp in performSelector_withObject_afterDelay_excludeArray) {
        if ([tmp isEqualToString:excludeInfo]) {
            return _NSObject_performSelector_withObject_afterDelay_(self,sel,aSelector,anArgument,delay);
        }
    }
    [performSelector_withObject_afterDelay_excludeArray addObject:excludeInfo];
    
    
    
    NSString *SELFName = [NSString stringWithFormat:@"SELFName:%@",NSStringFromClass([self class])];
    NSString *FuncName = @"Instance_performSelector_withObject_afterDelay_";
    NSString *SELAddress =  [NSString stringWithFormat:@"SELAddress:0x%llx",aSelector];
    NSString *SELName = [NSString stringWithFormat:@"SELName:%@",NSStringFromSelector(aSelector)];
    NSString *AnArgument =  [NSString stringWithFormat:@"AnArgument:%@",anArgument];
    NSString *Delay =  [NSString stringWithFormat:@"Delay:%f",delay];
    
    NSArray *array = [NSArray arrayWithObjects:SELFName,SELAddress,SELName,AnArgument,Delay,nil];
    //        NSLog(@"array = %@",array);
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:array forKey:FuncName];
    //        NSLog(@"dict = %@",dict);
    
    static NSString *_logDir = nil;
    
    if (_logDir == nil)
    {
                _logDir = [[NSString alloc] initWithFormat:PrivateAPIPath];
#ifdef IF_PRINT_PATH
        if (print_once) {
            print_once = 0;
            NSLog(@"PrivateAPIPath = %@",PrivateAPIPath);
        }
#endif
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    NSString *filepath = [NSString stringWithFormat:@"%@/%d_%@.plist",_logDir,PrivateAPIindexobjc_performSelector_withObject_afterDelay_,FuncName];
    PrivateAPIindexobjc_performSelector_withObject_afterDelay_++;
    
    PRINT_DATA(@"",FuncName,array,filepath);
    
    BOOL flag = [dict writeToFile:filepath atomically:YES];
    if (flag != 1) {
        NSLog(@"%@  not write success~~~~~~~~~~~~~~~",FuncName);
    }
    return _NSObject_performSelector_withObject_afterDelay_(self,sel,aSelector,anArgument,delay);;
}
#endif
#define ____________________________________________________________________________________________________Instance_performSelector_withObject_afterDelay_over


#define ____________________________________________________________________________________________________Instance_performSelector_withObject_afterDelay_inModes_
#ifdef IFHOOK_PrivateAPIindexobjc_performSelector_withObject_afterDelay_inModes_
HOOK_MESSAGE(void, NSObject, performSelector_withObject_afterDelay_inModes_,SEL aSelector,id anArgument,NSTimeInterval delay,NSArray *modes)
{
    if (wasCalledByApp() == false) {
        //        NSLog(@"not in the stack");
        return _NSObject_performSelector_withObject_afterDelay_inModes_(self,sel,aSelector,anArgument,delay,modes);
    }
   
    NSString *excludeInfo = [NSString stringWithFormat:@"%@_%@",NSStringFromClass([self class]),NSStringFromSelector(aSelector)];
    for (NSString * tmp in performSelector_withObject_afterDelay_inModes_excludeArray) {
        if ([tmp isEqualToString:excludeInfo]) {
            return _NSObject_performSelector_withObject_afterDelay_inModes_(self,sel,aSelector,anArgument,delay,modes);
        }
    }
    [performSelector_withObject_afterDelay_inModes_excludeArray addObject:excludeInfo];
    
    
    
    
    NSString *SELFName = [NSString stringWithFormat:@"SELFName:%@",NSStringFromClass([self class])];
    NSString *FuncName = @"Instance_performSelector_withObject_afterDelay_inModes_";
    NSString *SELAddress =  [NSString stringWithFormat:@"SELAddress:0x%llx",aSelector];
    NSString *SELName = [NSString stringWithFormat:@"SELName:%@",NSStringFromSelector(aSelector)];
    NSString *AnArgument =  [NSString stringWithFormat:@"AnArgument:%@",anArgument];
    NSString *Delay =  [NSString stringWithFormat:@"Delay:%f",delay];
    NSString *Modes =  [NSString stringWithFormat:@"Modes:%@",modes];
    
    
    NSArray *array = [NSArray arrayWithObjects:SELFName,SELAddress,SELName,AnArgument,Delay,Modes,nil];
    //        NSLog(@"array = %@",array);
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:array forKey:FuncName];
    //        NSLog(@"dict = %@",dict);
    
    static NSString *_logDir = nil;
    
    if (_logDir == nil)
    {
                _logDir = [[NSString alloc] initWithFormat:PrivateAPIPath];
#ifdef IF_PRINT_PATH
        if (print_once) {
            print_once = 0;
            NSLog(@"PrivateAPIPath = %@",PrivateAPIPath);
        }
#endif
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    NSString *filepath = [NSString stringWithFormat:@"%@/%d_%@.plist",_logDir,PrivateAPIindexobjc_performSelector_withObject_afterDelay_inModes_,FuncName];
    PrivateAPIindexobjc_performSelector_withObject_afterDelay_inModes_++;
    
    PRINT_DATA(@"",FuncName,array,filepath);
    
    BOOL flag = [dict writeToFile:filepath atomically:YES];
    if (flag != 1) {
        NSLog(@"%@  not write success~~~~~~~~~~~~~~~",FuncName);
    }
    return _NSObject_performSelector_withObject_afterDelay_inModes_(self,sel,aSelector,anArgument,delay,modes);
}
#endif
#define ____________________________________________________________________________________________________Instance_performSelector_withObject_afterDelay_inModes_over

#define ____________________________________________________________________________________________________Instance_performSelectorOnMainThread_withObject_waitUntilDone_
#ifdef IFHOOK_PrivateAPIindexobjc_performSelectorOnMainThread_withObject_waitUntilDone_
HOOK_MESSAGE(void, NSObject, performSelectorOnMainThread_withObject_waitUntilDone_,SEL aSelector,id arg,BOOL wait)
{
    if (wasCalledByApp() == false) {
        //        NSLog(@"not in the stack");
        return _NSObject_performSelectorOnMainThread_withObject_waitUntilDone_(self,sel,aSelector,arg,wait);
    }
   
    NSString *excludeInfo = [NSString stringWithFormat:@"%@_%@",NSStringFromClass([self class]),NSStringFromSelector(aSelector)];
    for (NSString * tmp in performSelectorOnMainThread_withObject_waitUntilDone_excludeArray) {
        if ([tmp isEqualToString:excludeInfo]) {
            return _NSObject_performSelectorOnMainThread_withObject_waitUntilDone_(self,sel,aSelector,arg,wait);
        }
    }
    [performSelectorOnMainThread_withObject_waitUntilDone_excludeArray addObject:excludeInfo];
    
    NSString *SELFName = [NSString stringWithFormat:@"SELFName:%@",NSStringFromClass([self class])];
    NSString *FuncName = @"Instance_performSelectorOnMainThread_withObject_waitUntilDone_";
    NSString *SELAddress =  [NSString stringWithFormat:@"SELAddress:0x%llx",aSelector];
    NSString *SELName = [NSString stringWithFormat:@"SELName:%@",NSStringFromSelector(aSelector)];
    NSString *Arg =  [NSString stringWithFormat:@"Arg:%@",arg];
    NSString *Wait =  [NSString stringWithFormat:@"Wait:%d",wait];
    
    
    NSArray *array = [NSArray arrayWithObjects:SELFName,SELAddress,SELName,Arg,Wait,nil];
    //        NSLog(@"array = %@",array);
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:array forKey:FuncName];
    //        NSLog(@"dict = %@",dict);
    
    static NSString *_logDir = nil;
    
    if (_logDir == nil)
    {
                _logDir = [[NSString alloc] initWithFormat:PrivateAPIPath];
#ifdef IF_PRINT_PATH
        if (print_once) {
            print_once = 0;
            NSLog(@"PrivateAPIPath = %@",PrivateAPIPath);
        }
#endif
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    NSString *filepath = [NSString stringWithFormat:@"%@/%d_%@.plist",_logDir,PrivateAPIindexobjc_performSelectorOnMainThread_withObject_waitUntilDone_,FuncName];
    PrivateAPIindexobjc_performSelectorOnMainThread_withObject_waitUntilDone_++;
    
    PRINT_DATA(@"",FuncName,array,filepath);
    
    BOOL flag = [dict writeToFile:filepath atomically:YES];
    if (flag != 1) {
        NSLog(@"%@  not write success~~~~~~~~~~~~~~~",FuncName);
    }
    return _NSObject_performSelectorOnMainThread_withObject_waitUntilDone_(self,sel,aSelector,arg,wait);
}
#endif
#define ____________________________________________________________________________________________________Instance_performSelectorOnMainThread_withObject_waitUntilDone_over



#define ____________________________________________________________________________________________________Instance_performSelectorOnMainThread_withObject_waitUntilDone_modes_
#ifdef IFHOOK_PrivateAPIindexobjc_performSelectorOnMainThread_withObject_waitUntilDone_modes_
HOOK_MESSAGE(void, NSObject, performSelectorOnMainThread_withObject_waitUntilDone_modes_,SEL aSelector,id arg,BOOL wait,NSArray *array0)
{
    if (wasCalledByApp() == false) {
        //        NSLog(@"not in the stack");
        return _NSObject_performSelectorOnMainThread_withObject_waitUntilDone_modes_(self,sel,aSelector,arg,wait,array0);
    }
    
    
    NSString *excludeInfo = [NSString stringWithFormat:@"%@_%@",NSStringFromClass([self class]),NSStringFromSelector(aSelector)];
    for (NSString * tmp in performSelectorOnMainThread_withObject_waitUntilDone_modes_excludeArray) {
        if ([tmp isEqualToString:excludeInfo]) {
            return _NSObject_performSelectorOnMainThread_withObject_waitUntilDone_modes_(self,sel,aSelector,arg,wait,array0);
        }
    }
    [performSelectorOnMainThread_withObject_waitUntilDone_modes_excludeArray addObject:excludeInfo];
    
    NSString *SELFName = [NSString stringWithFormat:@"SELFName:%@",NSStringFromClass([self class])];
    NSString *FuncName = @"Instance_performSelectorOnMainThread_withObject_waitUntilDone_modes_";
    NSString *SELAddress =  [NSString stringWithFormat:@"SELAddress:0x%llx",aSelector];
    NSString *SELName = [NSString stringWithFormat:@"SELName:%@",NSStringFromSelector(aSelector)];
    NSString *Arg =  [NSString stringWithFormat:@"Arg:%@",arg];
    NSString *Wait =  [NSString stringWithFormat:@"Wait:%d",wait];
    
    
    NSArray *array = [NSArray arrayWithObjects:SELFName,SELAddress,SELName,Arg,Wait,array0,nil];
    //        NSLog(@"array = %@",array);
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:array forKey:FuncName];
    //        NSLog(@"dict = %@",dict);
    
    static NSString *_logDir = nil;
    
    if (_logDir == nil)
    {
                _logDir = [[NSString alloc] initWithFormat:PrivateAPIPath];
#ifdef IF_PRINT_PATH
        if (print_once) {
            print_once = 0;
            NSLog(@"PrivateAPIPath = %@",PrivateAPIPath);
        }
#endif
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    NSString *filepath = [NSString stringWithFormat:@"%@/%d_%@.plist",_logDir,PrivateAPIindexobjc_performSelectorOnMainThread_withObject_waitUntilDone_modes_,FuncName];
    PrivateAPIindexobjc_performSelectorOnMainThread_withObject_waitUntilDone_modes_++;
    
    PRINT_DATA(@"",FuncName,array,filepath);
    
    BOOL flag = [dict writeToFile:filepath atomically:YES];
    if (flag != 1) {
        NSLog(@"%@  not write success~~~~~~~~~~~~~~~",FuncName);
    }
    return _NSObject_performSelectorOnMainThread_withObject_waitUntilDone_modes_(self,sel,aSelector,arg,wait,array0);
}
#endif
#define ____________________________________________________________________________________________________Instance_performSelectorOnMainThread_withObject_waitUntilDone_modes_over





#define ____________________________________________________________________________________________________Instance_performSelector_onThread_withObject_waitUntilDone_
#ifdef IFHOOK_PrivateAPIindexobjc_performSelector_onThread_withObject_waitUntilDone_
HOOK_MESSAGE(void, NSObject, performSelector_onThread_withObject_waitUntilDone_,SEL aSelector,NSThread *thread,id arg,BOOL wait)
{
    if (wasCalledByApp() == false) {
        //        NSLog(@"not in the stack");
        return _NSObject_performSelector_onThread_withObject_waitUntilDone_(self,sel,aSelector,thread,arg,wait);
    }
   
    NSString *excludeInfo = [NSString stringWithFormat:@"%@_%@",NSStringFromClass([self class]),NSStringFromSelector(aSelector)];
    for (NSString * tmp in performSelector_onThread_withObject_waitUntilDone_excludeArray) {
        if ([tmp isEqualToString:excludeInfo]) {
            return _NSObject_performSelector_onThread_withObject_waitUntilDone_(self,sel,aSelector,thread,arg,wait);
        }
    }
    [performSelector_onThread_withObject_waitUntilDone_excludeArray addObject:excludeInfo];
    
    
    NSString *SELFName = [NSString stringWithFormat:@"SELFName:%@",NSStringFromClass([self class])];
    NSString *FuncName = @"Instance_performSelector_onThread_withObject_waitUntilDone_";
    NSString *SELAddress =  [NSString stringWithFormat:@"SELAddress:0x%llx",aSelector];
    NSString *SELName = [NSString stringWithFormat:@"SELName:%@",NSStringFromSelector(aSelector)];
    NSString *Arg =  [NSString stringWithFormat:@"Arg:%@",arg];
    NSString *Wait =  [NSString stringWithFormat:@"Wait:%d",wait];
    
    
    NSArray *array = [NSArray arrayWithObjects:SELFName,SELAddress,SELName,Arg,Wait,nil];
    //        NSLog(@"array = %@",array);
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:array forKey:FuncName];
    //        NSLog(@"dict = %@",dict);
    
    static NSString *_logDir = nil;
    
    if (_logDir == nil)
    {
                _logDir = [[NSString alloc] initWithFormat:PrivateAPIPath];
#ifdef IF_PRINT_PATH
        if (print_once) {
            print_once = 0;
            NSLog(@"PrivateAPIPath = %@",PrivateAPIPath);
        }
#endif
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    NSString *filepath = [NSString stringWithFormat:@"%@/%d_%@.plist",_logDir,PrivateAPIindexobjc_performSelector_onThread_withObject_waitUntilDone_,FuncName];
    PrivateAPIindexobjc_performSelector_onThread_withObject_waitUntilDone_++;
    
    PRINT_DATA(@"",FuncName,array,filepath);
    
    BOOL flag = [dict writeToFile:filepath atomically:YES];
    if (flag != 1) {
        NSLog(@"%@  not write success~~~~~~~~~~~~~~~",FuncName);
    }
    return _NSObject_performSelector_onThread_withObject_waitUntilDone_(self,sel,aSelector,thread,arg,wait);
}
#endif
#define ____________________________________________________________________________________________________Instance_performSelector_onThread_withObject_waitUntilDone_over


#define ____________________________________________________________________________________________________Instance_performSelector_onThread_withObject_waitUntilDone_modes_
#ifdef IFHOOK_PrivateAPIindexobjc_performSelector_onThread_withObject_waitUntilDone_modes_
HOOK_MESSAGE(void, NSObject, performSelector_onThread_withObject_waitUntilDone_modes_,SEL aSelector,NSThread *thread,id arg,BOOL wait,NSArray *modes)
{
    if (wasCalledByApp() == false) {
        //        NSLog(@"not in the stack");
        return _NSObject_performSelector_onThread_withObject_waitUntilDone_modes_(self,sel,aSelector,thread,arg,wait,modes);
    }
   
    NSString *excludeInfo = [NSString stringWithFormat:@"%@_%@",NSStringFromClass([self class]),NSStringFromSelector(aSelector)];
    for (NSString * tmp in performSelector_onThread_withObject_waitUntilDone_modes_excludeArray) {
        if ([tmp isEqualToString:excludeInfo]) {
            return _NSObject_performSelector_onThread_withObject_waitUntilDone_modes_(self,sel,aSelector,thread,arg,wait,modes);
        }
    }
    [performSelector_onThread_withObject_waitUntilDone_modes_excludeArray addObject:excludeInfo];
    
    
    
    NSString *SELFName = [NSString stringWithFormat:@"SELFName:%@",NSStringFromClass([self class])];
    NSString *FuncName = @"Instance_performSelector_onThread_withObject_waitUntilDone_modes_";
    NSString *SELAddress =  [NSString stringWithFormat:@"SELAddress:0x%llx",aSelector];
    NSString *SELName = [NSString stringWithFormat:@"SELName:%@",NSStringFromSelector(aSelector)];
    NSString *Arg =  [NSString stringWithFormat:@"Arg:%@",arg];
    NSString *Wait =  [NSString stringWithFormat:@"Wait:%d",wait];
    NSString *Modes =  [NSString stringWithFormat:@"Array0%@",modes];
    
    
    NSArray *array = [NSArray arrayWithObjects:SELFName,SELAddress,SELName,Arg,Wait,Modes,nil];
    //        NSLog(@"array = %@",array);
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:array forKey:FuncName];
    //        NSLog(@"dict = %@",dict);
    
    static NSString *_logDir = nil;
    
    if (_logDir == nil)
    {
                _logDir = [[NSString alloc] initWithFormat:PrivateAPIPath];
#ifdef IF_PRINT_PATH
        if (print_once) {
            print_once = 0;
            NSLog(@"PrivateAPIPath = %@",PrivateAPIPath);
        }
#endif
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    NSString *filepath = [NSString stringWithFormat:@"%@/%d_%@.plist",_logDir,PrivateAPIindexobjc_performSelector_onThread_withObject_waitUntilDone_modes_,FuncName];
    PrivateAPIindexobjc_performSelector_onThread_withObject_waitUntilDone_modes_++;
    
    PRINT_DATA(@"",FuncName,array,filepath);
    
    BOOL flag = [dict writeToFile:filepath atomically:YES];
    if (flag != 1) {
        NSLog(@"%@  not write success~~~~~~~~~~~~~~~",FuncName);
    }
    return _NSObject_performSelector_onThread_withObject_waitUntilDone_modes_(self,sel,aSelector,thread,arg,wait,modes);
}
#endif
#define ____________________________________________________________________________________________________Instance_performSelector_onThread_withObject_waitUntilDone_modes_over




#define ____________________________________________________________________________________________________Instance_performSelectorInBackground_withObject_
#ifdef IFHOOK_PrivateAPIindexobjc_performSelectorInBackground_withObject_
HOOK_MESSAGE(void, NSObject, performSelectorInBackground_withObject_,SEL aSelector,id arg)
{
    if (wasCalledByApp() == false) {
        //        NSLog(@"not in the stack");
        return _NSObject_performSelectorInBackground_withObject_(self,sel,aSelector,arg);
    }
   
    NSString *excludeInfo = [NSString stringWithFormat:@"%@_%@",NSStringFromClass([self class]),NSStringFromSelector(aSelector)];
    for (NSString * tmp in performSelectorInBackground_withObject_excludeArray) {
        if ([tmp isEqualToString:excludeInfo]) {
            return _NSObject_performSelectorInBackground_withObject_(self,sel,aSelector,arg);
        }
    }
    [performSelectorInBackground_withObject_excludeArray addObject:excludeInfo];
    
    NSString *SELFName = [NSString stringWithFormat:@"SELFName:%@",NSStringFromClass([self class])];
    NSString *FuncName = @"Instance_performSelectorInBackground_withObject_";
    NSString *SELAddress =  [NSString stringWithFormat:@"SELAddress:0x%llx",aSelector];
    NSString *SELName = [NSString stringWithFormat:@"SELName:%@",NSStringFromSelector(aSelector)];
    NSString *Arg =  [NSString stringWithFormat:@"Arg:%@",arg];

    NSArray *array = [NSArray arrayWithObjects:SELFName,SELAddress,SELName,Arg,nil];
    //        NSLog(@"array = %@",array);
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:array forKey:FuncName];
    //        NSLog(@"dict = %@",dict);
    
    static NSString *_logDir = nil;
    
    if (_logDir == nil)
    {
                _logDir = [[NSString alloc] initWithFormat:PrivateAPIPath];
#ifdef IF_PRINT_PATH
        if (print_once) {
            print_once = 0;
            NSLog(@"PrivateAPIPath = %@",PrivateAPIPath);
        }
#endif
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    NSString *filepath = [NSString stringWithFormat:@"%@/%d_%@.plist",_logDir,PrivateAPIindexobjc_performSelectorInBackground_withObject_,FuncName];
    PrivateAPIindexobjc_performSelectorInBackground_withObject_++;
    
    PRINT_DATA(@"",FuncName,array,filepath);
    
    BOOL flag = [dict writeToFile:filepath atomically:YES];
    if (flag != 1) {
        NSLog(@"%@  not write success~~~~~~~~~~~~~~~",FuncName);
    }
    return _NSObject_performSelectorInBackground_withObject_(self,sel,aSelector,arg);
}
#endif
#define ____________________________________________________________________________________________________Instance_performSelectorInBackground_withObject_over



#define ____________________________________________________________________________________________________NSSelectorFromString
#ifdef IFHOOK_PrivateAPIindexobjc_NSSelectorFromString
SEL (*original_NSSelectorFromString)(NSString *aSelectorName);
SEL replaced_NSSelectorFromString(NSString *aSelectorName)
{
    if (wasCalledByApp() == false) {
        //        NSLog(@"not in the stack");
        return original_NSSelectorFromString(aSelectorName);
    }
    
    
    SEL sel = original_NSSelectorFromString(aSelectorName);
    
//    NSString *excludeInfo = [NSString stringWithFormat:@"%@_%@",NSStringFromSelector(sel),aSelectorName];
//    for (NSString * tmp in NSClassFromString_excludeArray) {
//        if ([tmp isEqualToString:excludeInfo]) {
//            return sel;
//        }
//    }
//    [NSSelectorFromString_excludeArray addObject:excludeInfo];
    
    if (sel == nil) {
        return sel;
    }
   
    
    NSString *SelectorName = [NSString stringWithFormat:@"%@",aSelectorName];
    NSString *excludeInfo = SelectorName;
    for (NSString * tmp in NSSelectorFromString_excludeArray) {
        if ([tmp isEqualToString:excludeInfo]) {
            return sel;
        }
    }
    [NSSelectorFromString_excludeArray addObject:excludeInfo];
    
    NSString *SELAddress =  [NSString stringWithFormat:@"SELAddress:0x%llx",sel];
    
    
    
    NSArray *array = [NSArray arrayWithObjects:SelectorName,SELAddress,nil];
    //        NSLog(@"array = %@",array);
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:array forKey:@"NSSelectorFromString"];
    //        NSLog(@"dict = %@",dict);
    
    static NSString *_logDir = nil;
    
    if (_logDir == nil)
    {
                _logDir = [[NSString alloc] initWithFormat:PrivateAPIPath];
#ifdef IF_PRINT_PATH
        if (print_once) {
            print_once = 0;
            NSLog(@"PrivateAPIPath = %@",PrivateAPIPath);
        }
#endif
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    NSString *filepath = [NSString stringWithFormat:@"%@/%d_%@.plist",_logDir,PrivateAPIindexobjc_NSSelectorFromString,@"NSSelectorFromString"];
    PrivateAPIindexobjc_NSSelectorFromString++;
    
    PRINT_DATA(@"",@"NSSelectorFromString",array,filepath);
    
    BOOL flag = [dict writeToFile:filepath atomically:YES];
    if (flag != 1) {
        NSLog(@"%@  not write success~~~~~~~~~~~~~~~",@"NSSelectorFromString");
    }
    return sel;
}
#endif
#define ____________________________________________________________________________________________________NSSelectorFromStringover



#define ____________________________________________________________________________________________________NSClassFromString
#ifdef IFHOOK_PrivateAPIindexobjc_NSClassFromString
//Class NSClassFromString(NSString *aClassName);
const Class (*original_NSClassFromString)(NSString *aClassName);
const Class replaced_NSClassFromString(NSString *aClassName)
{
    if (wasCalledByApp() == false) {
        //        NSLog(@"not in the stack");
        return original_NSClassFromString(aClassName);
    }
    
    Class class = original_NSClassFromString(aClassName);
//    NSString *excludeInfo = [NSString stringWithFormat:@"%@_%@",NSStringFromClass(class),aClassName];
//    for (NSString * tmp in NSClassFromString_excludeArray) {
//        if ([tmp isEqualToString:excludeInfo]) {
//            return class;
//        }
//    }
//    [NSSelectorFromString_excludeArray addObject:excludeInfo];
//    
//    
//    if (class == nil) {
//        return class;
//    }
    
    NSString *ClassName = [NSString stringWithFormat:@"%@",aClassName];
    NSString *excludeInfo = ClassName;
    for (NSString * tmp in NSClassFromString_excludeArray) {
        if ([tmp isEqualToString:excludeInfo]) {
            return class;
        }
    }
    [NSClassFromString_excludeArray addObject:excludeInfo];

    
    NSString *ClassStructAddress =  [NSString stringWithFormat:@"ClassAddress:0x%llx",class];
    NSArray *array = [NSArray arrayWithObjects:ClassName,ClassStructAddress,nil];
    //        NSLog(@"array = %@",array);
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:array forKey:@"NSClassFromString"];
    //        NSLog(@"dict = %@",dict);
    
    static NSString *_logDir = nil;
    
    if (_logDir == nil)
    {
                _logDir = [[NSString alloc] initWithFormat:PrivateAPIPath];
#ifdef IF_PRINT_PATH
        if (print_once) {
            print_once = 0;
            NSLog(@"PrivateAPIPath = %@",PrivateAPIPath);
        }
#endif
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    NSString *filepath = [NSString stringWithFormat:@"%@/%d_%@.plist",_logDir,PrivateAPIindexobjc_NSClassFromString,@"NSClassFromString"];
    PrivateAPIindexobjc_NSClassFromString++;
    
    PRINT_DATA(@"",@"NSClassFromString",array,filepath);
    
    BOOL flag = [dict writeToFile:filepath atomically:YES];
    if (flag != 1) {
        NSLog(@"%@  not write success~~~~~~~~~~~~~~~",@"NSClassFromString");
    }
    return class;
}
#endif
#define ____________________________________________________________________________________________________NSClassFromStringover


#define ____________________________________________________________________________________________________objc_getClass
#ifdef IFHOOK_PrivateAPIindexobjc_getClass
const void * (*original_objc_getClass)(const char *name);
const void * replaced_objc_getClass(const char *name)
{
    if (wasCalledByApp() == false) {
        //        NSLog(@"not in the stack");
        return original_objc_getClass(name);
    }
    
    Class class = original_objc_getClass(name);
    if (class == nil) {
        return class;
    }
   
    
    NSString *ClassName = [NSString stringWithFormat:@"%s",name];
    NSString *ClassStructAddress =  [NSString stringWithFormat:@"ClassAddress:  0x%llx",class];
    
    NSString *excludeInfo = ClassName;
    for (NSString * tmp in objc_getClass_excludeArray) {
        if ([tmp isEqualToString:excludeInfo]) {
            return class;
        }
    }
    [objc_getClass_excludeArray addObject:excludeInfo];
    
    
    NSArray *array = [NSArray arrayWithObjects:ClassName,ClassStructAddress,nil];
    //        NSLog(@"array = %@",array);
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:array forKey:@"objc_getClass"];
    //        NSLog(@"dict = %@",dict);
    
    static NSString *_logDir = nil;
    
    if (_logDir == nil)
    {
                _logDir = [[NSString alloc] initWithFormat:PrivateAPIPath];
#ifdef IF_PRINT_PATH
        if (print_once) {
            print_once = 0;
            NSLog(@"PrivateAPIPath = %@",PrivateAPIPath);
        }
#endif
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    NSString *filepath = [NSString stringWithFormat:@"%@/%d_%@.plist",_logDir,PrivateAPIindexobjc_getClass,@"objc_getClass"];
    PrivateAPIindexobjc_getClass++;
    
    PRINT_DATA(@"",@"objc_getClass",array,filepath);
    
    BOOL flag = [dict writeToFile:filepath atomically:YES];
    if (flag != 1) {
        NSLog(@"%@  not write success~~~~~~~~~~~~~~~",@"objc_getClass");
    }
    return class;
}
#endif
#define ____________________________________________________________________________________________________objc_getClassover


#define ____________________________________________________________________________________________________dlsym
#ifdef IFHOOK_PrivateAPIindexdlsym
const void * (*original_dlsym)(void * __handle, const char * __symbol);
const void * replaced_dlsym(void * __handle, const char * __symbol)
{
    if (wasCalledByApp() == false) {
        //        NSLog(@"not in the stack");
        return original_dlsym(__handle,__symbol);
    }
    
    void * addr_func = original_dlsym(__handle,__symbol);
    if (addr_func == nil) {
        return addr_func;
    }
//    NSLog(@"original_dlsymover addr_func = %llx",addr_func);
    
    NSString *FuncName = [NSString stringWithFormat:@"%s",__symbol];
    NSString *handle =  [NSString stringWithFormat:@"handle:0x%llx",__handle];
    NSString *FuncAddress = [NSString stringWithFormat:@"funcaddr:0x%llx",addr_func];
    
    NSString *excludeInfo = [NSString stringWithFormat:@"%@_%@",FuncName,handle];
    for (NSString * tmp in dlsym_excludeArray) {
        if ([tmp isEqualToString:excludeInfo]) {
            return addr_func;
        }
    }
    [dlsym_excludeArray addObject:excludeInfo];
    
    
    NSArray *array = [NSArray arrayWithObjects:FuncName,handle,FuncAddress,nil];
//        NSLog(@"array = %@",array);
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:array forKey:@"dlsym"];
//        NSLog(@"dict = %@",dict);
    
    static NSString *_logDir = nil;
    
    if (_logDir == nil)
    {
                _logDir = [[NSString alloc] initWithFormat:PrivateAPIPath];
#ifdef IF_PRINT_PATH
        if (print_once) {
            print_once = 0;
            NSLog(@"PrivateAPIPath = %@",PrivateAPIPath);
        }
#endif
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    NSString *filepath = [NSString stringWithFormat:@"%@/%d_%@.plist",_logDir, PrivateAPIindexdlsym,@"dlsym"];
    PrivateAPIindexdlsym++;
    
    PRINT_DATA(@"",@"dlsym",array,filepath);
    
    BOOL flag = [dict writeToFile:filepath atomically:YES]; //dlsym
    if (flag != 1) {
        NSLog(@"%@  not write success~~~~~~~~~~~~~~~",@"dlsym");
    }
    return addr_func;
}
#endif
#define ____________________________________________________________________________________________________dlsymover


#define ____________________________________________________________________________________________________dlopen
#ifdef IFHOOK_PrivateAPIindexdlopen
const char * (*original_dlopen)(const char *  __path,int __mode);
const char * replaced_dlopen(const char *  __path,int __mode)
{
    if (wasCalledByApp() == false) {
//        NSLog(@"not in the stack");
        return original_dlopen(__path,__mode);
    }
    
     void * addr_Module = original_dlopen(__path,__mode);
//     NSLog(@"original_dlopenover addr_Module = %llx",addr_Module);
    if (addr_Module == nil) {
        return addr_Module;
    }
    
    NSString *mode = nil;
    switch(__mode)
    {
        case 1:
            mode = @"RTLD_LAZY";
            break;
        case 2:
            mode = @"RTLD_NOW";
            break;
        case 3:
            mode = @"RTLD_LAZY|RTLD_NOW";
            break;
        case 4:
            mode = @"RTLD_LOCAL";
            break;
        case 5:
            mode = @"RTLD_LAZY|RTLD_LOCAL";
            break;
        case 6:
            mode = @"RTLD_NOW|RTLD_LOCAL";
            break;
        case 7:
            mode = @"RTLD_LAZY|RTLD_NOW|RTLD_LOCAL";
            break;
        case 8:
            mode = @"RTLD_GLOBAL";
            break;
        case 9:
            mode = @"RTLD_LAZY|RTLD_GLOBAL";
            break;
    }
    
    NSString *path = [NSString stringWithFormat:@"modulepath:%s",__path];
    NSString *module =  [NSString stringWithFormat:@"addr_Module:0x%llx",addr_Module];
    
    NSString *excludeInfo = [NSString stringWithFormat:@"%@_%@",path,module];
    for (NSString * tmp in dlopen_excludeArray) {
        if ([tmp isEqualToString:excludeInfo]) {
            return addr_Module;
        }
    }
    [dlopen_excludeArray addObject:excludeInfo];
    
    NSArray *array = [NSArray arrayWithObjects:path,module,mode,nil];
//    NSLog(@"array = %@",array);
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:array forKey:@"dlopen"];
//    NSLog(@"dict = %@",dict);
    
    static NSString *_logDir = nil;
    
    if (_logDir == nil)
    {
                _logDir = [[NSString alloc] initWithFormat:PrivateAPIPath];
#ifdef IF_PRINT_PATH
        if (print_once) {
            print_once = 0;
            NSLog(@"PrivateAPIPath = %@",PrivateAPIPath);
        }
#endif
        BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
        
        if (!isDirExist) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    NSString *filepath = [NSString stringWithFormat:@"%@/%d_%@.plist",_logDir,PrivateAPIindexdlopen,@"dlopen"];
    PrivateAPIindexdlopen++;

    PRINT_DATA(@"",@"dlopen",array,filepath);

    BOOL flag = [dict writeToFile:filepath atomically:YES]; //dlopen
    if (flag != 1) {
        NSLog(@"%@  not write success~~~~~~~~~~~~~~~",@"dlopen");
    }
    return addr_Module;
}
#endif
#define ____________________________________________________________________________________________________dlsymover


 //        - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
static void (*oldapplication_didFinishLaunchingWithOptions_)(id self, SEL _cmd,UIApplication* application,NSDictionary * launchOptions);
static void newapplication_didFinishLaunchingWithOptions_(id self, SEL _cmd,UIApplication* application,NSDictionary * launchOptions) {
    NSLog(@"application:didFinishLaunchingWithOptions:");
    //Hook here~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    MSHookFunction((void *)&dlopen,
                   (void *)&replaced_dlopen,
                   (void **)&original_dlopen);
    
    MSHookFunction((void *)&dlsym,
                   (void *)&replaced_dlsym,
                   (void **)&original_dlsym);
    
    MSHookFunction((void *)&objc_getClass,
                   (void *)&replaced_objc_getClass,
                   (void **)&original_objc_getClass);
    
    MSHookFunction((void *)&NSClassFromString,
                   (void *)&replaced_NSClassFromString,
                   (void **)&original_NSClassFromString);
    
    MSHookFunction((void *)&NSSelectorFromString,
                   (void *)&replaced_NSSelectorFromString,
                   (void **)&original_NSSelectorFromString);
    
    oldapplication_didFinishLaunchingWithOptions_(self,_cmd,application,launchOptions);
}


// 应用程序将要激活
//static void (*oldApplicationDidBecomeActive)(id self, SEL _cmd,id application);
//// implicit self and _cmd are explicit with IMP ABI
//static void newApplicationDidBecomeActive(id self, SEL _cmd,id application) {
//    NSLog(@"目标应用将激活");
////        C_HookFunction((void *)0xFFFFFFFF, "dlopen", (void *)$dlopen, (void **)&_dlopen);
//    oldApplicationDidBecomeActive(self,_cmd,application);
//}

// UIApplication将设置delegate
static void (*oldApplicationSetDelegate)(id self, SEL _cmd,id delegate);
// implicit self and _cmd are explicit with IMP ABI
static void newApplicationSetDelegate(id self, SEL _cmd,id delegate) {
    NSLog(@"目标应用将设置delegate~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
//    MSHookMessageEx(
//                    [delegate class], @selector(applicationDidBecomeActive:),
//                    (IMP)&newApplicationDidBecomeActive, (IMP *)&oldApplicationDidBecomeActive
//                    );
    
    MSHookMessageEx(NSStringFromClass([delegate class]), @selector(application:didFinishLaunchingWithOptions:),
                    (IMP)&newapplication_didFinishLaunchingWithOptions_, (IMP *)&oldapplication_didFinishLaunchingWithOptions_);
    oldApplicationSetDelegate(self,_cmd,delegate);
}
static int (*original_UIApplicationMain)(int argc, char *argv[], NSString * __nullable principalClassName, NSString * __nullable delegateClassName);
static int replaced_UIApplicationMain(int argc, char *argv[], NSString * __nullable principalClassName, NSString * __nullable delegateClassName)
{
    NSLog(@"===== Hook了UIApplicationMain =====");
    NSLog(@"===== principalClassName：%@,delegateClassName：%@ =====",principalClassName,delegateClassName);
    // 如果为nil，那么程序将使用默认的UIApplication
    if (!delegateClassName) {
        MSHookMessageEx(
                        [UIApplication class], @selector(setDelegate:),
                        (IMP)&newApplicationSetDelegate, (IMP *)&oldApplicationSetDelegate
                        );
    }
    else
    {
//        MSHookMessageEx(
//                        NSClassFromString(delegateClassName), @selector(applicationDidBecomeActive:),
//                        (IMP)&newApplicationDidBecomeActive, (IMP *)&oldApplicationDidBecomeActive
//                        );
        
        MSHookMessageEx(
                        NSClassFromString(delegateClassName), @selector(application:didFinishLaunchingWithOptions:),
                        (IMP)&newapplication_didFinishLaunchingWithOptions_, (IMP *)&oldapplication_didFinishLaunchingWithOptions_);

        //        - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    }
    
    
    return original_UIApplicationMain(argc,argv,principalClassName,delegateClassName);
}


    
__attribute__((constructor)) void _log_UIApplicationMain()
{
    NSLog(@"_log_UIApplicationMain");
    MSHookFunction((void *)&UIApplicationMain,
                   (void *)&replaced_UIApplicationMain,
                   (void **)&original_UIApplicationMain);
    
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#endif










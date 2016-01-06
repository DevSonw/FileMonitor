
//#define HOOK_SECURITY(RET, ...) HOOK_FUNCTION(RET, /System/Library/Frameworks/Security.framework/Security, __VA_ARGS__)
//
////
//HOOK_SECURITY(OSStatus, SSLRead, SSLContextRef context, void *data, size_t dataLength, size_t *processed)
//{
//	OSStatus ret = _SSLRead(context, data, dataLength, processed);
//	_LogData(data, dataLength);
//	return ret;
//}
//
////
//HOOK_SECURITY(OSStatus, SSLWrite, SSLContextRef context, const void *data, size_t dataLength, size_t *processed)
//{
//	OSStatus ret = _SSLWrite(context, data, dataLength, processed);
//	_LogData(data, dataLength);
//	return ret;
//}
//
////
//HOOK_SECURITY(OSStatus, SSLSetSessionOption, SSLContextRef context, SSLSessionOption option, Boolean value)
//{
//    // Remove the ability to modify the value of the kSSLSessionOptionBreakOnServerAuth option
//    if (option == kSSLSessionOptionBreakOnServerAuth)
//        return noErr;
//    else
//        return _SSLSetSessionOption(context, option, value);
//}
//
////
//HOOK_SECURITY(SSLContextRef, SSLCreateContext, CFAllocatorRef allocator, SSLProtocolSide protocolSide, SSLConnectionType connectionType)
//{
//	SSLContextRef ret = _SSLCreateContext(allocator, protocolSide, connectionType);
//    
//    // Immediately set the kSSLSessionOptionBreakOnServerAuth option in order to disable cert validation
//    _SSLSetSessionOption(ret, kSSLSessionOptionBreakOnServerAuth, true);
//    return ret;
//}
//
////
//HOOK_SECURITY(OSStatus, SSLHandshake, SSLContextRef context)
//{
//	OSStatus ret = _SSLHandshake(context);
//    return (ret == errSSLServerAuthCompleted) ? _SSLHandshake(context) : ret;
//}

/*
 void _HookMessage(Class cls, const char *msg, void *hook, void **old)
 {
 //
 char name[1024];
 int i = 0;
 do
 {
 name[i] = (msg[i] == '_') ? ':' : msg[i];
 }
 while (msg[i++]);
 SEL sel = sel_registerName(name);
 
 //
 static void (*_MSHookMessageEx)(Class cls, SEL sel, void *hook, void **old) = NULL;
 if (_MSHookMessageEx == nil)
 {
 _MSHookMessageEx = dlsym(dlopen("/Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate", RTLD_LAZY), "MSHookMessageEx");
 }
 
 //
 if (_MSHookMessageEx)
 {
 _MSHookMessageEx(cls, sel, hook, old);
 }
 else
 {
 *old = method_setImplementation(class_getInstanceMethod(cls, sel), hook);
 }
 }
*/
// MSHookMessageEx([UIView class], @selector(setFrame:), (IMP)replaced_UIView_setFrame_,(IMP *)&original_UIView_setFrame_);
// MSHookMessageEx(objc_getMetaClass("UIView"), @selector(commitAnimations), replaced_UIView_commitAnimations, (IMP *)&original_UIView_commitAnimations);

// NSString *(*oldDescription)(id self, SEL _cmd);
// 
// // implicit self and _cmd are explicit with IMP ABI
// NSString *newDescription(id self, SEL _cmd) {
// NSString *description = (*oldDescription)(self, _cmd);
// description = [description stringByAppendingString:@"!"];
// return description;





//Jul 31 19:19:38 360de-iPhone UserDefaults[2328] <Warning>: ---FileMonitor---NSUserDefaults : init :
//Jul 31 19:19:38 360de-iPhone UserDefaults[2328] <Warning>: ---FileMonitor---NSUserDefaults : objectForKey_ : {
//    UIDisableLegacyTextView = 1;
//}

//Jul 31 19:19:38 360de-iPhone UserDefaults[2328] <Warning>: ---FileMonitor---NSUserDefaults : objectForKey_ : {
//    hasAccessibilityBeenMigrated = 1;
//}


#import "IFHOOK.h"
#ifdef NSUserDefaults_IF_HOOK

#define PRINT_FILTERINFO //自动过滤多余的信息 如 加载nib等

//#define DEBUG_INFO


HOOK_MESSAGE(NSArray *, NSUserDefaults, arrayForKey_,NSString *defaultName)
{
    NSArray * array =  _NSUserDefaults_arrayForKey_(self,sel,defaultName);
    
    
#ifdef PRINT_FILTERINFO
    if (strcmp([defaultName UTF8String],"UIDisableLegacyTextView")==0 || strcmp([defaultName UTF8String],"hasAccessibilityBeenMigrated")==0 || \
        strcmp([defaultName UTF8String],"AppleLanguages")==0) {
        return array;
    }
#endif
    
    NSDictionary *dic=nil;
    if (array) {
        dic = [NSDictionary dictionaryWithObject:array forKey:defaultName];
    }
    
#ifdef DEBUG_INFO
    NSLog(@"2222222222222--2");
#endif
    if (dic) {
    _LogNSUserDefaults(@"arrayForKey_",dic);
    }
    
    return array;
}

//HOOK_MESSAGE(BOOL, NSUserDefaults, boolForKey_,NSString *defaultName)
//{
//    
//    BOOL flag =  _NSUserDefaults_boolForKey_(self,sel,defaultName);
//     NSNumber *num = [NSNumber numberWithInt:(int)flag];
//    
//    NSDictionary *dic = [NSDictionary dictionaryWithObject:num forKey:defaultName];
//    
//#ifdef DEBUG_INFO
//    NSLog(@"2222222222222--3");
//#endif
//    if (dic) {
//    _LogNSUserDefaults(@"boolForKey_",dic);
//    }
//
//    return flag;
//}

HOOK_MESSAGE(NSData *, NSUserDefaults, dataForKey_,NSString *defaultName)
{
    
    NSData * data =  _NSUserDefaults_dataForKey_(self,sel,defaultName);
    
    NSDictionary *dic=nil;
    if (data) {
        dic = [NSDictionary dictionaryWithObject:data forKey:defaultName];
    }
#ifdef DEBUG_INFO
    NSLog(@"2222222222222--4");
#endif
    if (dic) {
    _LogNSUserDefaults(@"defaultName",dic);
    }

    
    return data;
}

HOOK_MESSAGE(NSDictionary *, NSUserDefaults, dictionaryForKey_,NSString *defaultName)
{
    
    NSDictionary * dictmp =  _NSUserDefaults_dictionaryForKey_(self,sel,defaultName);
    
    NSDictionary *dic=nil;
    if (dictmp) {
        dic = [NSDictionary dictionaryWithObject:dictmp forKey:defaultName];
    }
    
#ifdef DEBUG_INFO
    NSLog(@"2222222222222--5");
#endif
    if (dic) {
    _LogNSUserDefaults(@"dictionaryForKey_",dic);
    }

    
    return dictmp;
}

//HOOK_MESSAGE(float, NSUserDefaults, floatForKey_,NSString *defaultName)
//{
//    
//    float tmp =  _NSUserDefaults_floatForKey_(self,sel,defaultName);
//    NSNumber *num = [NSNumber numberWithInt:(int)tmp];
//    NSDictionary *dic = [NSDictionary dictionaryWithObject:num forKey:defaultName];
//    
//#ifdef DEBUG_INFO
//    NSLog(@"2222222222222--6");
//#endif
//    if (dic) {
//    _LogNSUserDefaults(@"floatForKey_",dic);
//    }
//
//    return tmp;
//}

HOOK_MESSAGE(NSInteger, NSUserDefaults, integerForKey_,NSString *defaultName)
{
    NSInteger tmp =  _NSUserDefaults_integerForKey_(self,sel,defaultName);
    
    if (strcmp([defaultName UTF8String],"NSStringDrawingLongTermCacheSize") ==0  || strcmp([defaultName UTF8String],"NSStringDrawingLongTermThreshold") ==0 || \
        strcmp([defaultName UTF8String],"NSStringDrawingShortTermCacheSize") ==0 || strcmp([defaultName UTF8String],"NSUndoManagerDefaultLevelsOfUndo") ==0 || \
         strcmp([defaultName UTF8String],"NSCorrectionUnderlineBehavior") ==0 ) {
        return tmp;
    }
    
    NSNumber * num = [NSNumber numberWithInteger:tmp];
    
        NSDictionary *dic = nil;
    if (num) {
        dic = [NSDictionary dictionaryWithObject:num forKey:defaultName];
    }
    
#ifdef DEBUG_INFO
    NSLog(@"2222222222222--7");
#endif
    if (dic) {
    _LogNSUserDefaults(@"integerForKey_",dic);
    }
    return tmp;
}

HOOK_MESSAGE(id, NSUserDefaults, objectForKey_,NSString *defaultName)
{
    
    id tmp = _NSUserDefaults_objectForKey_(self,sel,defaultName);
    
#ifdef PRINT_FILTERINFO
    if (strcmp([defaultName UTF8String],"UIDisableLegacyTextView")==0 || strcmp([defaultName UTF8String],"hasAccessibilityBeenMigrated")==0 || \
        strcmp([defaultName UTF8String],"AppleLanguages")==0) {
        return tmp;
    }
#endif
    
        NSDictionary *dic =nil;
    if (tmp) {
        dic = [NSDictionary dictionaryWithObject:tmp forKey:defaultName];
    }
    
#ifdef DEBUG_INFO
    NSLog(@"defaultName = %@",defaultName);
    NSLog(@"2222222222222--8");
    NSLog(@"dic = %@",dic);
#endif
    

    if (dic) {
    _LogNSUserDefaults(@"objectForKey_",dic);
    }
    return tmp;
}

HOOK_MESSAGE(NSArray *, NSUserDefaults, stringArrayForKey_,NSString *defaultName)
{
    
    NSArray * tmp = _NSUserDefaults_stringArrayForKey_(self,sel,defaultName);
    
    
#ifdef PRINT_FILTERINFO
    if (strcmp([defaultName UTF8String],"UIDisableLegacyTextView")==0 || strcmp([defaultName UTF8String],"hasAccessibilityBeenMigrated")==0 || \
        strcmp([defaultName UTF8String],"AppleLanguages")==0) {
        return tmp;
    }
#endif
    
    
        NSDictionary *dic = nil;
    if (tmp) {
        dic = [NSDictionary dictionaryWithObject:tmp forKey:defaultName];
    }
    
#ifdef DEBUG_INFO
    NSLog(@"2222222222222--9");
#endif
    if (dic) {
    _LogNSUserDefaults(@"stringArrayForKey_",dic);
    }

    
    return tmp;
}


HOOK_MESSAGE(NSString *, NSUserDefaults, stringForKey_,NSString *defaultName)
{
    NSString *tmp =  _NSUserDefaults_stringForKey_(self,sel,defaultName);
        NSDictionary *dic = nil;
    if (tmp) {
        dic = [NSDictionary dictionaryWithObject:tmp forKey:defaultName];
    }

#ifdef DEBUG_INFO
    NSLog(@"2222222222222--11");
#endif
    if (dic) {
    _LogNSUserDefaults(@"stringForKey_",dic);
    }

    return tmp;
}

HOOK_MESSAGE(double, NSUserDefaults, doubleForKey_,NSString *defaultName)
{
    
    double tmp =  _NSUserDefaults_doubleForKey_(self,sel,defaultName);
    
    NSNumber *num = [NSNumber numberWithInt:tmp];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:num forKey:defaultName];
    
#ifdef DEBUG_INFO
    NSLog(@"2222222222222--12");
#endif
    if (dic) {
    _LogNSUserDefaults(@"doubleForKey_",dic);
    }

    return tmp;
}

HOOK_MESSAGE(NSURL *, NSUserDefaults, URLForKey_,NSString *defaultName)
{
    
    NSURL * tmp =  _NSUserDefaults_URLForKey_(self,sel,defaultName);
    
        NSDictionary *dic = nil;
    if (tmp) {
        dic = [NSDictionary dictionaryWithObject:tmp forKey:defaultName];
    }
    
#ifdef DEBUG_INFO
    NSLog(@"2222222222222--13");
#endif
    if (dic) {
    _LogNSUserDefaults(@"URLForKey_",dic);
    }

    
    return tmp;
}

HOOK_MESSAGE(void, NSUserDefaults, setBool_forKey_,BOOL value,NSString *defaultName)
{
    NSNumber* tmp = [NSNumber numberWithBool:value];
        NSDictionary *dic = nil;
    if (tmp) {
        dic = [NSDictionary dictionaryWithObject:tmp forKey:defaultName];
    }
    
#ifdef DEBUG_INFO
    NSLog(@"2222222222222--14");
#endif
    if (dic) {
    _LogNSUserDefaults(@"setBool_forKey_",dic);
    }

    return _NSUserDefaults_setBool_forKey_(self,sel,value,defaultName);
    
}

HOOK_MESSAGE(void, NSUserDefaults, setFloat_forKey_,float value,NSString *defaultName)
{
    NSNumber *num = [NSNumber numberWithFloat:value];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:num forKey:defaultName];
    
#ifdef DEBUG_INFO
    NSLog(@"2222222222222--15");
#endif
    if (dic) {
    _LogNSUserDefaults(@"setFloat_forKey_",dic);
    }

    return _NSUserDefaults_setFloat_forKey_(self,sel,value,defaultName);
    
}

HOOK_MESSAGE(void, NSUserDefaults, setInteger_forKey_,NSInteger value,NSString *defaultName)
{
    NSNumber *num = [NSNumber numberWithInteger:value];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:num forKey:defaultName];
    
#ifdef DEBUG_INFO
    NSLog(@"2222222222222--16");
#endif
    if (dic) {
    _LogNSUserDefaults(@"setInteger_forKey_",dic);
    }

    return _NSUserDefaults_setInteger_forKey_(self,sel,value,defaultName);
}

HOOK_MESSAGE(void, NSUserDefaults, setObject_forKey_,id value,NSString *defaultName)
{
    NSDictionary *dic=nil;
    if (value !=nil && defaultName!=nil) {
       dic = [NSDictionary dictionaryWithObject:value forKey:defaultName];
    }
    
    
#ifdef DEBUG_INFO
    NSLog(@"2222222222222--21");
#endif
    if (dic) {
    _LogNSUserDefaults(@"setObject_forKey_",dic);
    }

    return _NSUserDefaults_setObject_forKey_(self,sel,value,defaultName);
}

HOOK_MESSAGE(void, NSUserDefaults, setDouble_forKey_,double value ,NSString *defaultName)
{
    NSNumber *num = [NSNumber numberWithDouble:value];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:num forKey:defaultName];
    
#ifdef DEBUG_INFO
    NSLog(@"2222222222222--22");
#endif
    if (dic) {
    _LogNSUserDefaults(@"setDouble_forKey_",dic);
    }

    return _NSUserDefaults_setDouble_forKey_(self,sel,value,defaultName);
}

HOOK_MESSAGE(void, NSUserDefaults, setURL_forKey_,NSURL *url,NSString *defaultName)
{
    NSDictionary *dic=nil;
    if (url) {
         dic = [NSDictionary dictionaryWithObject:url forKey:defaultName];
    }
    
#ifdef DEBUG_INFO
    NSLog(@"2222222222222--23");
#endif
    if (dic) {
    _LogNSUserDefaults(@"setURL_forKey_",dic);
    }

    return _NSUserDefaults_setURL_forKey_(self,sel,url,defaultName);
}


HOOK_MESSAGE(void, NSUserDefaults, removeObjectForKey_,NSString *defaultName)
{
#ifdef DEBUG_INFO
    NSLog(@"2222222222222--24");
#endif
    if (defaultName) {
        _LogNSUserDefaults(@"removeObjectForKey_",defaultName);
    }
    return _NSUserDefaults_removeObjectForKey_(self,sel,defaultName);
}

HOOK_MESSAGE(BOOL, NSUserDefaults, synchronize)
{
#ifdef DEBUG_INFO
    NSLog(@"2222222222222--25");
#endif
//    _LogNSUserDefaults(@"synchronize",@"");

    return _NSUserDefaults_synchronize(self,sel);
}

HOOK_MESSAGE(NSDictionary *, NSUserDefaults, persistentDomainForName_,NSString *defaultName)
{
    
    NSDictionary *dictmp = _NSUserDefaults_persistentDomainForName_(self,sel,defaultName);
    
    if ([defaultName rangeOfString:@"com.apple.UIKit"].location == NSNotFound) {
        NSDictionary *dic=nil;
        if (dictmp) {
            dic = [NSDictionary dictionaryWithObject:dictmp forKey:defaultName];
        }
        
#ifdef DEBUG_INFO
        NSLog(@"2222222222222--26");
#endif
        if (dic) {
            _LogNSUserDefaults(@"persistentDomainForName_",dic);
        }
    }
    return dictmp;
}

//HOOK_MESSAGE(NSArray *, NSUserDefaults, persistentDomainNames_)
//{
//    
//    NSArray *tmp = _NSUserDefaults_persistentDomainNames_(self,sel);
//#ifdef DEBUG_INFO
//    NSLog(@"2222222222222--31");
//#endif
//    if (tmp) {
//    _LogNSUserDefaults(@"persistentDomainNames_",tmp);
//    }
//    return tmp;
//}



HOOK_MESSAGE(void, NSUserDefaults, removePersistentDomainForName_,NSString *defaultName)
{
    
#ifdef DEBUG_INFO
    NSLog(@"2222222222222--32");
#endif
    if (defaultName) {
    _LogNSUserDefaults(@"removePersistentDomainForName_",defaultName);
    }
    return _NSUserDefaults_removePersistentDomainForName_(self,sel,defaultName);
}


HOOK_MESSAGE(void, NSUserDefaults, setPersistentDomain_forName_,NSDictionary *domain,NSString *domainName)
{
    NSDictionary *dic=nil;
    if (domain) {
        dic = [NSDictionary dictionaryWithObject:domain forKey:domainName];
    }
    
#ifdef DEBUG_INFO
    NSLog(@"2222222222222--33");
#endif
    if (dic) {
    _LogNSUserDefaults(@"setPersistentDomain_forName_",dic);
    }

    return _NSUserDefaults_setPersistentDomain_forName_(self,sel,domain,domainName);
}

HOOK_MESSAGE(BOOL, NSUserDefaults, objectIsForcedForKey_,NSString *key)
{
    BOOL flag = _NSUserDefaults_objectIsForcedForKey_(self,sel,key);
    NSNumber *num = [NSNumber numberWithInt:flag];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:num forKey:key];
    
#ifdef DEBUG_INFO
    NSLog(@"2222222222222--34");
#endif
    if (dic) {
    _LogNSUserDefaults(@"objectIsForcedForKey_",key);
    }
    return flag;
}


HOOK_MESSAGE(BOOL, NSUserDefaults, objectIsForcedForKey_inDomain_,NSString *key,NSString *domain)
{
    BOOL flag = _NSUserDefaults_objectIsForcedForKey_inDomain_(self,sel,key,domain);
    NSNumber *num = [NSNumber numberWithBool:flag];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:key forKey:domain];
    
#ifdef DEBUG_INFO
    NSLog(@"2222222222222--35");
#endif
    if (dic) {
    _LogNSUserDefaults(@"objectIsForcedForKey_inDomain_",dic);
    }
    return flag;
}

HOOK_MESSAGE(NSDictionary *, NSUserDefaults, dictionaryRepresentation)
{
    NSDictionary *dic = _NSUserDefaults_dictionaryRepresentation(self,sel);
    
#ifdef DEBUG_INFO
    NSLog(@"2222222222222--36");
#endif
    if (dic) {
    _LogNSUserDefaults(@"dictionaryRepresentation",dic);
    }

    return dic;
}

HOOK_MESSAGE(void, NSUserDefaults,removeVolatileDomainForName_, NSString *domainName)
{
#ifdef DEBUG_INFO
    NSLog(@"2222222222222--37");
#endif
    if (domainName) {
    _LogNSUserDefaults(@"removeVolatileDomainForName_",domainName);
    }
    return _NSUserDefaults_removeVolatileDomainForName_(self,sel,domainName);;
}

HOOK_MESSAGE(void, NSUserDefaults,setVolatileDomain_forName_, NSDictionary *domain,NSString *domainName)
{
    NSDictionary *dic = [NSDictionary dictionaryWithObject:domain forKey:domainName];
#ifdef DEBUG_INFO
    NSLog(@"2222222222222--41");
#endif
    if (dic) {
    _LogNSUserDefaults(@"setVolatileDomain_forName_",dic);
    }

    return _NSUserDefaults_setVolatileDomain_forName_(self,sel,domain,domainName);;
}


HOOK_MESSAGE(NSDictionary *, NSUserDefaults,volatileDomainForName_,NSString *domainName)
{
    NSDictionary *dictmp = _NSUserDefaults_volatileDomainForName_(self,sel,domainName);;
    NSDictionary *dic=nil;
    if (dictmp) {
     dic = [NSDictionary dictionaryWithObject:dictmp forKey:domainName];
    }
#ifdef DEBUG_INFO
    NSLog(@"2222222222222--42");
#endif
    if (dic) {
    _LogNSUserDefaults(@"setVolatileDomain_forName_",dic);
    }

    return dictmp;
}
//NSUserDefaults
//NSKeyedUnarchiver


#endif
































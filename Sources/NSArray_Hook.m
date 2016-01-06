

//- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)flag
//- (BOOL)writeToURL:(NSURL *)aURL atomically:(BOOL)flag
//+ (NSArray *)arrayWithContentsOfFile:(NSString *)aPath
//+ (NSArray *)arrayWithContentsOfURL:(NSURL *)aURL


/*
 define _HOOK_MESSAGE_(MOD, RET, CLS, MSG, META, ...)	RET $##CLS##_##MSG(id self, SEL sel, ##__VA_ARGS__);\
 RET (*_##CLS##_##MSG)(id self, SEL sel, ##__VA_ARGS__);\
 __attribute__((MOD)) void _Init_##CLS##_##MSG() {_HookMessage(objc_get##META##Class(#CLS), #MSG, (void *)$##CLS##_##MSG, (void **)&_##CLS##_##MSG);}\
 RET $##CLS##_##MSG(id self, SEL sel, ##__VA_ARGS__)

 */


//there seem to be a problem with using +load in static libraries on iOS.  However, __attribute__ ((constructor)) does work correctly.
//__attribute__((constructor)) 在main() 之前执行,__attribute__((destructor)) 在main()执行结束之后执行.


#import "IFHOOK.h"
#ifdef NSArray_IF_HOOK

extern NSRegularExpression *regex;



HOOK_META(NSArray*,NSArray,arrayWithContentsOfURL_,NSURL *aURL)
{
    NSArray* tmp =  _NSArray_arrayWithContentsOfURL_(self,sel,aURL);
    if (tmp != nil && aURL != nil) {
        _LogNSArrayWrite(@"arrayWithContentsOfURL_",tmp,[aURL absoluteString]);
    }
    return tmp;
}

HOOK_META(NSArray*,NSArray,arrayWithContentsOfFile_,NSString *aPath)
{
    NSArray* tmp =  _NSArray_arrayWithContentsOfFile_(self,sel,aPath);
    
    if (tmp != nil && aPath != nil) {
        NSString *pathexten = [aPath pathExtension];
        NSArray *checkingResults  = [regex matchesInString:pathexten options:0 range:NSMakeRange(0, [pathexten length])];
        if ([checkingResults count] != 0) {
            
        }else
        _LogNSArrayWrite(@"arrayWithContentsOfFile_",tmp,aPath);
    }
    return tmp;
}

HOOK_MESSAGE(BOOL,NSArray,writeToURL_atomically_,NSURL *aURL,BOOL flag)
{
    BOOL flag2 = _NSArray_writeToURL_atomically_(self,sel,aURL,flag);
    if (flag2) {
        _LogNSArrayWrite(@"writeToURL_atomically_",self,[aURL absoluteString]);
    }
    return flag2;
}


BOOL $NSArray_writeToFile_atomically_(id self, SEL sel, NSString *path,BOOL flag);
BOOL (*_NSArray_writeToFile_atomically_)(id self, SEL sel, NSString *path,BOOL flag);
__attribute__((constructor)) void _Init_NSArray_writeToFile_atomically_()
{
    _HookMessage(objc_getClass("NSArray"),"writeToFile_atomically_", (void *)$NSArray_writeToFile_atomically_, (void **)&_NSArray_writeToFile_atomically_);
}
BOOL $NSArray_writeToFile_atomically_(id self, SEL sel, NSString *path, BOOL flag)
//HOOK_MESSAGE(BOOL,NSArray,writeToFile_atomically_,NSString *path,BOOL flag)
{
    BOOL flag2 = _NSArray_writeToFile_atomically_(self,sel,path,flag);
    if(flag2)
    {
        NSString *pathexten = [path pathExtension];
        NSArray *checkingResults  = [regex matchesInString:pathexten options:0 range:NSMakeRange(0, [pathexten length])];
        if ([checkingResults count] != 0) {
            
        }else
        _LogNSArrayWrite(@"writeToFile_atomically_",self,path);
    }
    return flag2;
}



//objectAtIndex
id $NSArray_objectAtIndex_(id self, SEL sel, NSUInteger index);
id (*_NSArray_objectAtIndex_)(id self, SEL sel,NSUInteger index);
__attribute__((constructor)) void _Init_NSArray_objectAtIndex_()
{
    _HookMessage(objc_getClass("__NSArrayI"),"objectAtIndex_", (void *)$NSArray_objectAtIndex_, (void **)&_NSArray_objectAtIndex_);
}
id $NSArray_objectAtIndex_(id self, SEL sel, NSUInteger index)
//HOOK_MESSAGE(id, NSArray, objectAtIndex_,NSUInteger index)
{
    if ([self count] <= 0 || index >[self count] ) {
        _LogLine();
        _LogStack();
        exit(0);
//        return nil;
//        _NSArray_objectAtIndex_(self,sel,index);
    }
    return _NSArray_objectAtIndex_(self,sel,index);
}

//NSMutableArray
id $NSMutableArray_objectAtIndex_(id self, SEL sel, NSUInteger index);
id (*_NSMutableArray_objectAtIndex_)(id self, SEL sel,NSUInteger index);
__attribute__((constructor)) void _Init_NSMutableArray_objectAtIndex_()
{
    _HookMessage(objc_getClass("__NSArrayM"),"objectAtIndex_", (void *)$NSMutableArray_objectAtIndex_, (void **)&_NSMutableArray_objectAtIndex_);
}
id $NSMutableArray_objectAtIndex_(id self, SEL sel, NSUInteger index)
//HOOK_MESSAGE(id, NSArray, objectAtIndex_,NSUInteger index)
{
    if (self != nil) {
        if ([self count] <= 0 || index >[self count] ) {
               _LogLine();
               _LogStack();
            exit(0);
//            return nil;
        }
    }
    return _NSMutableArray_objectAtIndex_(self,sel,index);
}

#endif

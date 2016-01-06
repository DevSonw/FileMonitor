#line 1 "/Users/panda/Downloads/FileMonitorForAduit/testhook/testhook/testhook.xm"










#import <substrate.h>

#import "sqlite3.h"
#import <objc/runtime.h>

#include <dlfcn.h>






int (*old__sqlite3_open)(const char *filename,sqlite3 **ppDb);

int new__sqlite3_open(const char *filename,sqlite3 **ppDb){
    NSLog(@"sqlite3_open hooked");
    return old__sqlite3_open(filename,ppDb);
}

#include <logos/logos.h>
#include <substrate.h>
@class UIApplicationMain; 


#line 30 "/Users/panda/Downloads/FileMonitorForAduit/testhook/testhook/testhook.xm"





static __attribute__((constructor)) void _logosLocalCtor_e95efde9() {
    @autoreleasepool {
        {}
        
        void *symbol  = dlsym(RTLD_DEFAULT, "sqlite3_open");
        NSLog(@"[+] symbol = 0x%llx",symbol);
        MSHookFunction(symbol, (void *)&new__sqlite3_open, (void**)&old__sqlite3_open);
    }
}








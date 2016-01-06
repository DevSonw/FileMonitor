
// Logos by Dustin Howett
// See http://iphonedevwiki.net/index.php/Logos

//#error iOSOpenDev post-project creation from template requirements (remove these lines after completed) -- \
//	Link to libsubstrate.dylib: \
//	(1) go to TARGETS > Build Phases > Link Binary With Libraries and add /opt/iOSOpenDev/lib/libsubstrate.dylib \
//	(2) remove these lines from *.xm files (not *.mm files as they're automatically generated from *.xm files)


#import <substrate.h>

#import "sqlite3.h"
#import <objc/runtime.h>

#include <dlfcn.h>

//SQLITE_API int sqlite3_open(
//                            const char *filename,   /* Database filename (UTF-8) */
//                            sqlite3 **ppDb          /* OUT: SQLite db handle */
//);

int (*old__sqlite3_open)(const char *filename,sqlite3 **ppDb);

int new__sqlite3_open(const char *filename,sqlite3 **ppDb){
    NSLog(@"sqlite3_open hooked");
    return old__sqlite3_open(filename,ppDb);
}

%hook UIApplicationMain

%end


%ctor {
    @autoreleasepool {
        %init;
        
        void *symbol  = dlsym(RTLD_DEFAULT, "sqlite3_open");
        NSLog(@"[+] symbol = 0x%llx",symbol);
        MSHookFunction(symbol, (void *)&new__sqlite3_open, (void**)&old__sqlite3_open);
    }
}








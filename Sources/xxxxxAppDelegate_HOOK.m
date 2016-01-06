//
//  xxxxxAppDelegate_HOOK.m
//  httpeekdylib
//
//  Created by panda on 22/12/15.
//
//

#import <IFHOOK.h>

#ifdef xxxxxAppDelegate_IF_HOOK

#import "substrate.h"


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 应用程序将要激活
static void (*oldApplicationDidBecomeActive)(id self, SEL _cmd,id application);

// implicit self and _cmd are explicit with IMP ABI
static void newApplicationDidBecomeActive(id self, SEL _cmd,id application) {
    NSLog(@"目标应用将激活");
    oldApplicationDidBecomeActive(self,_cmd,application);
}

// 应用程序将要失去激活
static void (*oldApplicationWillResignActive)(id self, SEL _cmd,id application);

// implicit self and _cmd are explicit with IMP ABI
static void newApplicationWillResignActive(id self, SEL _cmd,id application) {
    NSLog(@"目标应用将失去激活");
    oldApplicationWillResignActive(self,_cmd,application);
}

// 将进入前台
static void (*oldApplicationWillEnterForeground)(id self, SEL _cmd,id application);

// implicit self and _cmd are explicit with IMP ABI
static void newApplicationWillEnterForeground(id self, SEL _cmd,id application) {
    NSLog(@"目标应用将进入前台");
    oldApplicationWillEnterForeground(self,_cmd,application);
}

// 将进入后台
static void (*oldApplicationDidEnterBackground)(id self, SEL _cmd,id application);

// implicit self and _cmd are explicit with IMP ABI
static void newApplicationDidEnterBackground(id self, SEL _cmd,id application) {
    NSLog(@"目标应用将进入后台");
    oldApplicationDidEnterBackground(self,_cmd,application);
}

// 将关闭
static void (*oldApplicationWillTerminate)(id self, SEL _cmd,id application);
// implicit self and _cmd are explicit with IMP ABI
static void newApplicationWillTerminate(id self, SEL _cmd,id application) {
    NSLog(@"目标应用将关闭");
    oldApplicationWillTerminate(self,_cmd,application);
}

// UIApplication将设置delegate
static void (*oldApplicationSetDelegate)(id self, SEL _cmd,id delegate);

// implicit self and _cmd are explicit with IMP ABI
static void newApplicationSetDelegate(id self, SEL _cmd,id delegate) {
    
    NSLog(@"目标应用将设置delegate");
    
    MSHookMessageEx(
                    [delegate class], @selector(applicationDidBecomeActive:),
                    (IMP)&newApplicationDidBecomeActive, (IMP *)&oldApplicationDidBecomeActive
                    );
    MSHookMessageEx(
                    [delegate class], @selector(applicationWillResignActive:),
                    (IMP)&newApplicationWillResignActive, (IMP *)&oldApplicationWillResignActive
                    );
    MSHookMessageEx(
                    [delegate class], @selector(applicationDidEnterBackground:),
                    (IMP)&newApplicationDidEnterBackground, (IMP *)&oldApplicationDidEnterBackground
                    );
    MSHookMessageEx(
                    [delegate class], @selector(applicationWillEnterForeground:),
                    (IMP)&newApplicationWillEnterForeground, (IMP *)&oldApplicationWillEnterForeground
                    );
    MSHookMessageEx(
                    [delegate class], @selector(applicationWillTerminate:),
                    (IMP)&newApplicationWillTerminate, (IMP *)&oldApplicationWillTerminate
                    );
    
    
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
        MSHookMessageEx(
                        NSClassFromString(delegateClassName), @selector(applicationDidBecomeActive:),
                        (IMP)&newApplicationDidBecomeActive, (IMP *)&oldApplicationDidBecomeActive
                        );
        MSHookMessageEx(
                        NSClassFromString(delegateClassName), @selector(applicationWillResignActive:),
                        (IMP)&newApplicationWillResignActive, (IMP *)&oldApplicationWillResignActive
                        );
        MSHookMessageEx(
                        NSClassFromString(delegateClassName), @selector(applicationDidEnterBackground:),
                        (IMP)&newApplicationDidEnterBackground, (IMP *)&oldApplicationDidEnterBackground
                        );
        MSHookMessageEx(
                        NSClassFromString(delegateClassName), @selector(applicationWillEnterForeground:),
                        (IMP)&newApplicationWillEnterForeground, (IMP *)&oldApplicationWillEnterForeground
                        );
        MSHookMessageEx(
                        NSClassFromString(delegateClassName), @selector(applicationWillTerminate:),
                        (IMP)&newApplicationWillTerminate, (IMP *)&oldApplicationWillTerminate
                        );
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

#endif


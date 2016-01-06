//
//  AppDelegate.m
//  testPrivateAPI
//
//  Created by panda on 22/12/15.
//  Copyright (c) 2015年 360. All rights reserved.
//

#import "AppDelegate.h"
#import <sys/sysctl.h>

#import <IOKit/IOKitLib.h>


#import <dlfcn.h>


#include <objc/runtime.h>

#import "UIDevice+IOKitDeviceInfo.h"


#import "LB_DeviceInfo.h"

@interface AppDelegate ()
@end

void*all_module = nil;

@implementation AppDelegate

+ (NSString *)getBatteryInfo
{
    mach_port_t master_device_port;
    kern_return_t kr;
    CFArrayRef battery_info;
    NSString *ret = nil;
    
//    kr = IOMasterPort(bootstrap_port,&master_device_port);
    static kern_return_t (*IOMasterPort)( mach_port_t	bootstrapPort,mach_port_t *	masterPort );
    
    all_module= dlopen("/System/Library/Frameworks/IOKit.framework/IOKit",2);
    
    
    void * module =all_module;
    IOMasterPort  = dlsym(module,"IOMasterPort");

    kr = IOMasterPort(bootstrap_port,&master_device_port);
    
    if ( kr == kIOReturnSuccess )
    {
        static IOReturn (*IOPMCopyBatteryInfo)( mach_port_t masterPort, CFArrayRef * info );
        IOPMCopyBatteryInfo = dlsym(dlopen("/System/Library/Frameworks/IOKit.framework/IOKit",2),"IOPMCopyBatteryInfo");
        

        if(kIOReturnSuccess != IOPMCopyBatteryInfo(master_device_port,
                                                   &battery_info))
        {
            NSLog(@"Are you sure that this computer has a battery?\n");
        }
        else
        {
            ret = [NSString stringWithFormat:@"%@", (NSDictionary *)CFArrayGetValueAtIndex(battery_info, 0)];
            CFRelease(battery_info);
        }
    }
    return ret;
}


+(void)getInfo{
//    NSLog(@"[LB_DeviceInfo deviceNamesByCode] = %@",[LB_DeviceInfo deviceNamesByCode]);
//    NSLog(@"[LB_DeviceInfo deviceVersion] = %d",[LB_DeviceInfo deviceVersion]);
//    NSLog(@"[LB_DeviceInfo deviceSize] = %d",[LB_DeviceInfo deviceSize]);
//    NSLog(@"[LB_DeviceInfo deviceName] = %@",[LB_DeviceInfo deviceName]);
//    NSLog(@"[LB_DeviceInfo isDevicePhone] = %d",[LB_DeviceInfo isDevicePhone]);
//    NSLog(@"[LB_DeviceInfo isDevicePad] = %d",[LB_DeviceInfo isDevicePad]);
    
        NSLog(@"[UIDevice IOSerialNumber] = %@",[UIDevice IOSerialNumber]);
        NSLog(@"[UIDevice IOPlatformUUID] = %@",[UIDevice IOPlatformUUID]);
        NSLog(@"[UIDevice deviceIMEI] = %@",[UIDevice deviceIMEI]);
        NSLog(@"[UIDevice IODeviceIMEI] = %@",[UIDevice IODeviceIMEI]);
}

+ (BOOL) wasCalledByApp{
    //NSLog(@"%@",[NSThread callStackSymbols]);
    NSString *appProcessName = [[NSProcessInfo processInfo] processName];
    NSArray *callStack = [NSThread callStackSymbols];
    
    // Not ideal: Check if the app's process name is close enough in the call stack
    NSRange callerAtIndex = [[callStack objectAtIndex:1] rangeOfString: appProcessName];
    
    if (callerAtIndex.location == NSNotFound) {
        return false;
    }
    return true;
}
//Selector执行
- (void)test:(id)obj
{
    NSLog(@"%@ - %@",obj, [NSThread currentThread]);
}

//在新线程中创建并开始一个NSRunLoop
- (void)newThread:(id)obj
{
    @autoreleasepool
    {
        NSRunLoop *currentRunLoop = [NSRunLoop currentRunLoop];
        
        [currentRunLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        
        NSLog(@"线程停止");
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [AppDelegate getBatteryInfo];
    
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace"); //用私有API得到iOS系统里安装的所有APP
    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    
    
    NSArray *apps =[workspace performSelector:@selector(allApplications)];
    NSLog(@"apps: %@", apps);
    
    NSArray *apps2 =[workspace performSelector:@selector(allInstalledApplications)];
    NSLog(@"apps: %@", apps2);
    
    
    NSLog(@"shortVer = %@",[apps[0] performSelector:NSSelectorFromString(@"shortVersionString")]);
    
    //机身颜色可以通过软件识别吗
    UIDevice *device = [UIDevice currentDevice];
    SEL selector = NSSelectorFromString(@"deviceInfoForKey:");
    if (![device respondsToSelector:selector]) {
        selector = NSSelectorFromString(@"_deviceInfoForKey:");
    }
    if ([device respondsToSelector:selector]) {
        NSLog(@"DeviceColor: %@ DeviceEnclosureColor: %@", [device performSelector:selector withObject:@"DeviceColor"], [device performSelector:selector withObject:@"DeviceEnclosureColor"]);
    }
    
    
// Override point for customization after application launch.
//    NSLog(@"runprocess = %@",[AppDelegate runningProcesses]);
    NSLog(@"getBatteryInfo = %@", [AppDelegate getBatteryInfo]);
    NSLog(@"wasCalledByApp = %d", [AppDelegate wasCalledByApp]);
    
//    [AppDelegate getInfo];
//    int numClasses = objc_getClassList(NULL, 0);
//    
//    Class* list = (Class*)malloc(sizeof(Class) * numClasses);
//    objc_getClassList(list, numClasses);
//    
//    for (int i = 0; i < numClasses; i++)
//    {
//        id tmp1 =  @protocol(NSObject);//tmp1	Protocol *	0x1700b71c0	0x00000001700b71c0
//        SEL tmp2 = @selector(performSelector:);
//        if (class_conformsToProtocol(list[i], tmp1) &&
//            class_getInstanceMethod(list[i], tmp2 ))
//        {
////            MSHookMessageEx(list[i], @selector(performSelector:), (IMP)&replaced_performSelector, (IMP*)&original_performSelector);
//            NSLog(@"hook protocol performSelector:");
//           
////            return;
//        }
//    }
//    free(list);
    
    
    
//    NSLog(@"NSClassFromString = %@ ",NSClassFromString(@"NSString"));
//    extern int PrivateAPIindexobjc_NSClassFromString;
//    NSLog(@"NSSelectorFromString = %llx ",NSSelectorFromString(@"copy"));
//    extern int PrivateAPIindexobjc_NSSelectorFromString;
//    
//    
//    //noninstance:
//    extern int PrivateAPIindexobjc_noninstance_performSelector_;
//    NSLog(@"%@",[NSString performSelector:@selector(copy)]);
//    
//    NSLog(@"%@",[NSString performSelector:@selector(stringWithFormat:) withObject:@"12345"]);
//    extern int PrivateAPIindexobjc_noninstance_performSelector_withObject_;
    
//    extern int PrivateAPIindexobjc_noninstance_performSelector_withObject_withObject_;
//    
//    
//    
//    //instance:
//    //protocol
//    extern int PrivateAPIindexobjc_performSelector_;
          NSLog(@"%s",[@"12345" performSelector:@selector(UTF8String)]);
//    extern int PrivateAPIindexobjc_performSelector_withObject_;
          NSLog(@"%@",[@"12345" performSelector:@selector(writeToFile:atomically:) withObject:@"123"]);
//    extern int PrivateAPIindexobjc_performSelector_withObject_withObject_;
//    
//    //normal
//    extern int PrivateAPIindexobjc_performSelector_withObject_afterDelay_;
          [@"12345" performSelector:@selector(writeToFile:atomically:) withObject:@"123" afterDelay:1];//->00
//    extern int PrivateAPIindexobjc_performSelector_withObject_afterDelay_inModes_;
    [@"12345" performSelector:@selector(writeToFile:atomically:) withObject:@"123" afterDelay:1 inModes:nil];//00
//    extern int PrivateAPIindexobjc_performSelectorOnMainThread_withObject_waitUntilDone_;
    [@"12345" performSelectorOnMainThread:@selector(writeToFile:atomically:) withObject:@"123" waitUntilDone:1];//->11
//    extern int PrivateAPIindexobjc_performSelectorOnMainThread_withObject_waitUntilDone_modes_;
    [@"12345" performSelectorOnMainThread:@selector(writeToFile:atomically:) withObject:@"123" waitUntilDone:1 modes:nil];//->11
    
    
    
//    extern int PrivateAPIindexobjc_performSelector_onThread_withObject_waitUntilDone_;
//    [@"12345" performSelector:@selector(writeToFile:atomically:) onThread:nil withObject:@"12" waitUntilDone:1];//->11
//    extern int PrivateAPIindexobjc_performSelector_onThread_withObject_waitUntilDone_modes_;
//    [@"12345" performSelector:@selector(writeToFile:atomically:) onThread:nil withObject:@"12" waitUntilDone:1 modes:nil];//11
//    extern int PrivateAPIindexobjc_performSelectorInBackground_withObject_;

    BOOL _isNewThreadAborted = NO;
    NSThread *_thread = [[NSThread alloc] initWithTarget:self selector:@selector(newThread:) object:nil];
    //开始线程
    [_thread start];
    
     [self performSelector:@selector(test:) onThread:_thread withObject:nil waitUntilDone:NO];

    [self performSelector:@selector(abc:) withObject:(id)@"123" afterDelay:1];
    
    
    
//    [self performSelectorInBackground:@selector(abc:) withObject:@"123"];
    
    

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.360.testPrivateAPI" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"testPrivateAPI" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"testPrivateAPI.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end

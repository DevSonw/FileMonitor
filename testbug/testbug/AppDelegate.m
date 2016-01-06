//
//  AppDelegate.m
//  testbug
//
//  Created by panda on 9/12/15.
//  Copyright (c) 2015年 360. All rights reserved.
//

#import "AppDelegate.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#import "dlfcn.h"

const NSUInteger kPBKDFRounds = 10000;  // ~80ms on an iPhone 4


@interface AppDelegate ()

@end

@implementation AppDelegate

#define FileMonitorPath @"%@uiautomation/%@_%@.filemon",NSTemporaryDirectory(),NSProcessInfo.processInfo.processName,GET_TIME_APPVERSION()

#define GET_TIME_APPVERSION() [NSString stringWithFormat:@"%@__%@_%@",[AppDelegate getBackgroundRealDateString],\
[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"],\
[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]]


+(NSString *)getBackgroundRealDateString
{
    NSDate *date = [NSDate date];
    date = [date dateByAddingTimeInterval:8*3600]; //东八区
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy_MM_dd_HH_mm_ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]]; //北京时间
    NSString *datestr =  [dateFormatter stringFromDate:date];
    NSString *ret = [NSString stringWithString:datestr];
    return ret;
}


+(NSString *)hmacsha1:(NSString *)data secret:(NSString *)key {
    
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    NSLog(@"CCHmac = 0x%llx",CCHmac);
    
//    void CCHmac(
//                CCHmacAlgorithm algorithm,  /* kCCHmacSHA1, kCCHmacMD5 */
//                const void *key,
//                size_t keyLength,           /* length of key in bytes */
//                const void *data,
//                size_t dataLength,          /* length of data in bytes */
//                void *macOut)               /* MAC written here */
    
    void *symbol = dlsym(RTLD_DEFAULT, "CCHmac");
    
    NSLog(@"symbol = 0x%llx",symbol);
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    NSString *hash = [HMAC base64Encoding];
    
    NSLog(@"Hash: %@", hash);
    return hash;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSArray *FileNamesfilter = [NSMutableArray arrayWithObjects:@"jpg",@"gif",@"png",@"mov",@"mp4",@"wmv",@"mp3",nil];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", @"Ansel"];
    NSArray *filteredArray = [FileNamesfilter filteredArrayUsingPredicate:predicate];
    
    
    // Override point for customization after application launch.
//    NSArray *arryData = [NSArray arrayWithObjects:@"1",              @"2",      @"3",   @"4",@"5",   @"6",     @"7",   @"8", nil];
//    NSArray *arryDataKeys = [NSArray arrayWithObjects:@"Encrypt_or_Decrypt",@"Cypto_alg",@"Cypto_options",@"Cypto_key",@"Cypto_iv",@"Cypto_dataIn",@"Cypto_dataOut",@"Cypto_Moved",nil];
//    
//    NSDictionary *dicData = [NSDictionary dictionaryWithObjects:arryData forKeys:arryDataKeys];
//    
//    BOOL flag = [dicData writeToFile:@"/var/root/tmp/SecurityRouter.filemon/1.plist" atomically:YES];
//    
//    NSLog(@"flag = %d",flag);
//    NSLog(@"flag = %d",flag);
    
//    NSString *_logDir = [NSString stringWithFormat:FileMonitorPath];
//    NSLog(@"_logDir  = %@",_logDir);
//    
//    BOOL isDirExist = [[NSFileManager defaultManager] fileExistsAtPath:_logDir];
//    
//    if (!isDirExist) {
//        [[NSFileManager defaultManager] createDirectoryAtPath:_logDir withIntermediateDirectories:YES attributes:nil error:nil];
//    }
    
//    char *data = "1234567890";
    
//    NSString *str = @"0000000000123123";
//    //NSString *str = @"2345678901";
//    char *str1 =  [str UTF8String];
//    
//    char str2[30];
//    strcpy(str2, str1);
//    
//    for (int i=0 ;i<10 ;i++ ) {
//        if (str2[i] != '0') {
//            str2[i] += 1;
//        }
//    }
//    NSString *str3 = [NSString stringWithFormat:@"%s",str2];
//    NSLog(@"str3 = %@",str3);
    
//    CCHmacContext    ctx;
//    char             *key = "12345678";
//    char             buf[ 8192 ] = "12345678";
//    unsigned char    mac[ CC_MD5_DIGEST_LENGTH ];
//    char             hexmac[ 2 * CC_MD5_DIGEST_LENGTH + 1 ];
//    char             *p;
//    int              fd;
//    int              rr, i;
//    
//    CCHmacInit( &ctx, kCCHmacAlgMD5, key, strlen( key ));
//    
//    rr = sizeof(buf);
//    CCHmacUpdate( &ctx, buf, rr );
//
//    CCHmacFinal( &ctx, mac );
//    
//    p = hexmac;
//    for ( i = 0; i < CC_MD5_DIGEST_LENGTH; i++ ) {
//        snprintf( p, 3, "%02x", mac[ i ] );
//        p += 2;
//    }
//    
//    NSLog(@"%s\n", hexmac );
//    
//    
//    NSData *data = [NSData dataWithBytes:"12345678" length:8];
//    NSString *str = [AppDelegate hmacsha1:@"12345678" secret:@"12345678"];
//    NSLog(@"str = %@",str);
    
    
//    NSLog(@"GETAPPVERSION()  = %@",GETAPPVERSION());
//    NSData *data = [NSData dataWithBytes:"123" length:3];
//    
//    NSString *base64str = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//    
//    NSData *data0 = [base64str dataUsingEncoding:NSASCIIStringEncoding];
//    
//    NSData *data2 =  [[NSData alloc] initWithBase64EncodedString:data0
//                                                         options:NSDataBase64DecodingIgnoreUnknownCharacters];
//    
//    NSData *data3 = [[NSData alloc] initWithBase64EncodedData:data0 options:NSDataBase64DecodingIgnoreUnknownCharacters];
//    
//    NSData *data4 = [[NSData alloc]initWithBase64Encoding:data0];
//    
//    NSError *error = nil;
//    NSData *data5 = [[NSData alloc] initWithContentsOfFile:@"123.txt" options:NSDataReadingMappedIfSafe error:&error];
//    
////    NSData *data6 = [NSData dataWithContentsOfURL:@"123.txt"];
//    
//    NSData *data7 = [NSData dataWithContentsOfFile:@"123.txt" options:NSDataReadingMappedIfSafe error:&error];
//    
//    NSData *data8 = [NSData dataWithContentsOfFile:@"1.txt" options:NSDataReadingMappedIfSafe error:&error];
    
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
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.360.testbug" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"testbug" withExtension:@"momd"];
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
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"testbug.sqlite"];
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

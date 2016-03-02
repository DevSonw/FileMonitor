//
//  ViewController.m
//  rootApp
//
//  Created by kivlara on 11/3/14.
//  Copyright (c) 2014 kivlara. All rights reserved.
//

#import "ViewController.h"
#import "AppDB.h"
#import "MyAdditions.h"
#import "Reachability.h"
#import "SendPacket.h"
#import <pthread.h>
#import <CommonCrypto/CommonDigest.h>

#import <notify.h>

SendPacket *sendpacket = nil;
//#define NSLog(...)

//NSString *ip_and_port = @"http://192.168.36.107:8080";
NSString *ip_and_port = @"https://sec.corp.qihoo.net/iOS/";

#define Timedelay 3

//记录格式
#import "NSMutableArray+QueueAdditions.h"
NSMutableArray *ChatData = nil;

void *LogData(void *data) {
    NSLog(@"enter a thread");
    if (!sendpacket) {
        sendpacket = [[SendPacket alloc] init];
    }
    int IF_RecordInfo = 0;
    while (1) {
        //        [NSThread sleepForTimeInterval:2];
        sleep(2);
        NSDictionary *all_dic = nil;
        
//        if ([sendpacket isConnectIP:SEND_IP needPort:SEND_PORT]) {
            all_dic = [ViewController GetOrStore:nil FLAG:0];
            //        NSLog(@"all_dic = %@",all_dic);
            if (all_dic) {
                NSError *error = nil;
//                NSLog(@"all_dic = %@",all_dic);
                NSData *data = [NSJSONSerialization dataWithJSONObject:all_dic options:NSJSONWritingPrettyPrinted error:&error];
                NSLog(@"start to Send");
                if ([sendpacket SendDataToURL:ip_and_port sendData:data]) {
                    NSLog(@"send success");
                }
                else{
                    NSLog(@"send failed");
                    [ViewController GetOrStore:all_dic FLAG:1];
                    notify_post("ErrorMessage");
                }
            }
            else
            {
                IF_RecordInfo++;
                if (IF_RecordInfo % Timedelay == 0) {
                    IF_RecordInfo=0;
                    sleep(3);
                    NSLog(@"queue clear");
                }
            }
//        }
//        else
//        {
//            NSLog(@"not connect IP:%@ PORT:%@",SEND_IP,SEND_PORT);
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请确定能连通sec.corp.qihoo.net网络" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
//            [alert show];
            //can not get this
//        }
    }
}

@interface NSString (URLEncoding)

- (NSString *)urlEncodedUTF8String;

@end
@implementation NSString (URLEncoding)

- (NSString *)urlEncodedUTF8String {
    return (id)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(0, (CFStringRef)self, 0,
                                                                         (CFStringRef)@"", kCFStringEncodingUTF8));
}
//http://stackoverflow.com/questions/10759291/is-there-a-quick-way-to-post-an-nsdictionary-to-a-python-django-server
@end


@interface ViewController ()

@end

@implementation ViewController
@synthesize dataList;
@synthesize myTableView,global_index,but,but2,viewtmp;


+(id)GetOrStore: (NSDictionary *)dic FLAG:(int)flag
{
    @synchronized(ChatData)//互斥
    {
        if (flag) {
            [ChatData enqueue:dic];
            return @"YES";
        }
        else
            return [ChatData dequeue];
    }
}


//-(BOOL)isConnectNetworkandwarnning
//{
//    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
//    switch ([r currentReachabilityStatus]) {
//        case NotReachable:// 没有网络连接
//        {
//         NSLog(@"nonetwork");
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请检查网络，目前没有网络连接" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
//            [alert show];
//            return NO;
//            break;
//        }
//        case ReachableViaWWAN:// 使用3G网络
//        {
//            NSLog(@"3g");
//            return YES;
//            break;
//        }
//        case ReachableViaWiFi:// 使用WiFi网络
//        {
//            NSLog(@"wifi");
//            return YES;
//            break;
//        }
//    }
//}

//监听消息
void LogEvent(CFNotificationCenterRef center,
              void *observer,
              CFStringRef name,
              const void *object,
              CFDictionaryRef userInfo)
{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"发送数据失败，请确定能联通sec.corp.qihoo.net网络"] message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
}

- (void)viewDidLoad
{
    NSLog(@"Filemonitor~~~~~~~~~~~~~~~~~~~~");
    [super viewDidLoad];
    // 初始化tableView的数据
    //NSMutableArray *list = [NSArray arrayWithObjects:@"武汉",@"上海",@"北京",@"深圳",@"广州",@"重庆",@"香港",@"台海",@"天津", nil];
    setuid(0);
//    NSString * command = [NSString stringWithFormat:@"dpkg -i /open.deb"];
//    system([command UTF8String]);
    
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL direc = NO;
    [manager fileExistsAtPath:@"/var/root/tmp" isDirectory:&direc];
    if (!direc) {
        NSString *command = [NSString stringWithFormat:@"mkdir /var/root/tmp"];
        system([command UTF8String]);
        
        command = [NSString stringWithFormat:@"chown mobile:mobile /var/root/tmp"];
        system([command UTF8String]);
    }
    
    
    float SysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(SysVer < 8.0)
    {
        self.dataList = [ViewController iOS7GetApplist];
        
        CGRect tmp =self.view.frame;
        tmp.origin.y += 20;
        tmp.size.height -= 70;
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:tmp style:UITableViewStylePlain];
        // 设置tableView的数据源
        tableView.dataSource = self;
        // 设置tableView的委托
        tableView.delegate = self;
        // 设置tableView的背景图
        //    tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.png"]];
        
        self.myTableView = tableView;
        [self.view addSubview:myTableView];
        
        but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(0,self.view.frame.size.height-50, self.view.frame.size.width /2,50);
        [but setTitle:@"选择APP" forState:UIControlStateNormal];
        but.backgroundColor = [UIColor colorWithWhite:0.648 alpha:1.000];
        [but.titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [but addTarget:self action:@selector(clickAudit:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:but];
        
        but2 = [UIButton buttonWithType:UIButtonTypeCustom];
        but2.frame = CGRectMake(self.view.frame.size.width /2,self.view.frame.size.height-50, self.view.frame.size.width /2,50);
        [but2 setTitle:@"刷新列表" forState:UIControlStateNormal];
        but2.backgroundColor = [UIColor colorWithWhite:0.648 alpha:1.000];
        [but2.titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [but2 addTarget:self action:@selector(refreshTable:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:but2];
        
        NSLog(@"bundle = %@",[[self.dataList objectAtIndex:1] appBundle]);
        NSLog(@"DisplayName = %@",[[self.dataList objectAtIndex:1] appDisplayName]);
        NSLog(@"path = %@",[[self.dataList objectAtIndex:1] appPath]);
        NSLog(@"Name = %@",[[self.dataList objectAtIndex:1] appName]);
        
        //        NSString *command = [NSString stringWithFormat:@"rm -r /var/root/tmp/*.req"];
        //        system([command UTF8String]);
        [ViewController cleanPlist];
    }
    else
    {
        self.dataList = [ViewController iOS8GetApplist];
        
        CGRect tmp =self.view.frame;
        tmp.origin.y += 20;
        tmp.size.height -= 70;
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:tmp style:UITableViewStylePlain];
        // 设置tableView的数据源
        tableView.dataSource = self;
        // 设置tableView的委托
        tableView.delegate = self;
        // 设置tableView的背景图
        //    tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Background.png"]];
        
        self.myTableView = tableView;
        [self.view addSubview:myTableView];
        
        but = [UIButton buttonWithType:UIButtonTypeCustom];
        but.frame = CGRectMake(0,self.view.frame.size.height-50, self.view.frame.size.width /2,50);
        [but setTitle:@"选择APP" forState:UIControlStateNormal];
        but.backgroundColor = [UIColor colorWithWhite:0.648 alpha:1.000];
        [but.titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [but addTarget:self action:@selector(clickAudit:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:but];
        
        but2 = [UIButton buttonWithType:UIButtonTypeCustom];
        but2.frame = CGRectMake(self.view.frame.size.width /2,self.view.frame.size.height-50, self.view.frame.size.width /2,50);
        [but2 setTitle:@"刷新列表" forState:UIControlStateNormal];
        but2.backgroundColor = [UIColor colorWithWhite:0.648 alpha:1.000];
        [but2.titleLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [but2 addTarget:self action:@selector(refreshTable:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:but2];
        
        //        NSString *command = [NSString stringWithFormat:@"rm -r /var/root/tmp/*.req"];
        [ViewController cleanPlist];
        //        system([command UTF8String]);
        //                NSLog(@"bundle = %@",[[self.dataList objectAtIndex:1] appBundle]);
        //                NSLog(@"DisplayName = %@",[[self.dataList objectAtIndex:1] appDisplayName]);
        //                NSLog(@"path = %@",[[self.dataList objectAtIndex:1] appPath]);
        //                NSLog(@"Name = %@",[[self.dataList objectAtIndex:1] appName]);
    }
    
    self->global_flag = 0;
    
    //    NSLog(@"self.view.bounds.size.height = %f",self.view.bounds.size.height);
    //    NSLog(@"self.view.bounds.size.width  = %f",self.view.bounds.size.width);
    
    CGRect rect = self.view.bounds;
    rect.origin.x    = rect.size.width /2;
    rect.size.width  = rect.size.width /2;
    rect.size.height = rect.size.height/2;
    
    NSLog(@"rect.origin.x = %f",   rect.origin.x);
    NSLog(@"rect.size.width  = %f",rect.size.width);
    NSLog(@"rect.size.height  = %f",rect.size.height);
    
    UIView *view =[[UIView alloc] initWithFrame:self.view.bounds];
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:rect];
    [backImageView setImage:[UIImage imageNamed:@"nirvanteam.jpg"]];
    NSLog(@"backImageView = %@",backImageView);
    [view addSubview:backImageView];
    NSLog(@"view = %@",view);
    self.myTableView.backgroundView = view;
    
    /*
     经常遇到要给tableView设置背景图片的问题,但如果直接设置背景  backgroundView的话,背景图不会显示,原因是  tableView上的cell默认是不透明的颜色,所以解决方法是 让  cell透明即可:
     [cpp] view plaincopyprint?
     1.给tableView设置背景view
     UIImageView *backImageView=[[UIImageViewalloc]initWithFrame:self.view.bounds];
     [backImageView setImage:[UIImageimageNamed:@"liaotianbeijing"]];
     self.tableView.backgroundView=backImageView;
     
     2.让cell透明
     -(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
     {
     
     
     MyCell  *cell = [tableViewdequeueReusableCellWithIdentifier:@"METext"forIndexPath:indexPath];
     cell.backgroundColor=[UIColor clearColor];//关键语句
     [cell setCellInfo:dic];//自定义类目方法
     return cell;
     
     }
     */
    //    [self isConnectNetworkandwarnning];
    
    
    NSLog(@"register a message");
    CFNotificationCenterAddObserver(
                                    CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    LogEvent,
                                    (CFStringRef)@"ErrorMessage",
                                    NULL,
                                    CFNotificationSuspensionBehaviorDeliverImmediately
                                    );
    
    
    
    NSLog(@"create a thread");
    
    if (!sendpacket) {
        sendpacket = [[SendPacket alloc] init];
    }
    
    ChatData = [NSMutableArray arrayWithCapacity:10];
    pthread_t thread;
    //创建一个线程并自动执行
    pthread_create(&thread, NULL, LogData, NULL);//处理信息
//    NSLog(@"create a thread");
    setuid(0);
}

+(void) writeToPlist:(NSString *)plist_name
{
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *plist_path = [NSString stringWithFormat:@"/Library/MobileSubstrate/DynamicLibraries/%@",plist_name];
    
    [fileManager removeItemAtPath:plist_path error:&error];
    
    NSMutableDictionary *iadbPlist = [NSMutableDictionary dictionary];
    NSMutableDictionary *filter = [NSMutableDictionary dictionary];
    [iadbPlist setObject:filter forKey:@"Filter"];
    [iadbPlist writeToFile:plist_path atomically:TRUE];
}
+(void) cleanPlist
{
    setuid(0);
    float SysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(SysVer < 8.0)
    {
        NSLog(@"cleanPlist");
        //        NSError *error;
        //        NSFileManager *fileManager = [NSFileManager defaultManager];
        //        [fileManager removeItemAtPath:@"/Library/MobileSubstrate/DynamicLibraries/libFileMonitor7.plist" error:&error];
        //
        //        NSMutableDictionary *iadbPlist = [NSMutableDictionary dictionary];
        //        NSMutableDictionary *filter = [NSMutableDictionary dictionary];
        //        [iadbPlist setObject:filter forKey:@"Filter"];
        //        [iadbPlist writeToFile:@"/Library/MobileSubstrate/DynamicLibraries/libFileMonitor7.plist.plist" atomically:TRUE];
        [ViewController writeToPlist:@"libFileMonitor7.plist"];
        //        [ViewController writeToPlist:@"libhttpeekdylibiOS7.plist"];
    }
    else
    {
        NSLog(@"cleanPlist");
        //        NSError *error;
        //        NSFileManager *fileManager = [NSFileManager defaultManager];
        //        [fileManager removeItemAtPath:@"/Library/MobileSubstrate/DynamicLibraries/libFileMonitor8.plist" error:&error];
        //
        //        NSMutableDictionary *iadbPlist = [NSMutableDictionary dictionary];
        //        NSMutableDictionary *filter = [NSMutableDictionary dictionary];
        //        [iadbPlist setObject:filter forKey:@"Filter"];
        //        [iadbPlist writeToFile:@"/Library/MobileSubstrate/DynamicLibraries/libFileMonitor8.plist" atomically:TRUE];
        [ViewController writeToPlist:@"libFileMonitor8.plist"];
        //        [ViewController writeToPlist:@"libhttpeekdylibiOS8.plist"];
    }
    setuid(0);
}

+(void)DelAndAddAppToPlist:(NSString *)bundle
{
    setuid(0);
    float SysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(SysVer < 8.0)
    {
        NSMutableDictionary *currentPList = [NSMutableDictionary dictionaryWithContentsOfFile:@"/Library/MobileSubstrate/DynamicLibraries/libFileMonitor7.plist"];
        
        NSError *error;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:@"/Library/MobileSubstrate/DynamicLibraries/libFileMonitor7.plist" error:&error];
        NSMutableDictionary *filter = [currentPList objectForKey:@"Filter"];
        
        // if we don't have an existing bundles key in our dictionary
        if([filter objectForKey:@"Bundles"] == nil)
        {
            NSMutableArray *bundles = [[NSMutableArray alloc] init];
            [bundles addObject:bundle];
            [filter setObject:bundles forKey:@"Bundles"];
        }
        else {
            // otherwise use the existing bundle key
            NSMutableArray *bundles = [filter objectForKey:@"Bundles"];
            // check if the bundle already exists and add if not
            if(![bundles containsObject:bundle])
                [bundles addObject:bundle];
        }
        NSLog(@"currentPList = %@",currentPList);
        [currentPList writeToFile:@"/Library/MobileSubstrate/DynamicLibraries/libFileMonitor7.plist" atomically:TRUE];
    }
    else
    {
        NSMutableDictionary *currentPList = [NSMutableDictionary dictionaryWithContentsOfFile:@"/Library/MobileSubstrate/DynamicLibraries/libFileMonitor8.plist"];
        
        NSError *error;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:@"/Library/MobileSubstrate/DynamicLibraries/libFileMonitor8.plist" error:&error];
        
        NSMutableDictionary *filter = [currentPList objectForKey:@"Filter"];
        
        // if we don't have an existing bundles key in our dictionary
        if([filter objectForKey:@"Bundles"] == nil)
        {
            NSMutableArray *bundles = [[NSMutableArray alloc] init];
            [bundles addObject:bundle];
            [filter setObject:bundles forKey:@"Bundles"];
        }
        else {
            // otherwise use the existing bundle key
            NSMutableArray *bundles = [filter objectForKey:@"Bundles"];
            // check if the bundle already exists and add if not
            if(![bundles containsObject:bundle])
                [bundles addObject:bundle];
        }
        BOOL  flag = [currentPList writeToFile:@"/Library/MobileSubstrate/DynamicLibraries/libFileMonitor8.plist" atomically:TRUE];
        NSLog(@"write flag = %d",flag);
    }
    //NSLog(@"now currentPList = %@",[currentPList objectForKey:@"Filter"]);
    setuid(0);
}

+(NSMutableArray *)iOS8GetApplist{
    setuid(0);
    static NSString *const path = @"/private/var/mobile/Containers/Bundle/Application/";
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray * arrary = [filemanager contentsOfDirectoryAtPath:path error:&error];
    
    //NSLog(@"arrary = %@",arrary);
    NSMutableArray *appList = [NSMutableArray arrayWithCapacity:10];
    for(NSString *PathTmp_ in arrary)
    {
        NSString * PathTmp = [path stringByAppendingString:PathTmp_];
        NSFileManager *filemanager2 = [NSFileManager defaultManager];
        NSArray * FilesArrary = [filemanager2 contentsOfDirectoryAtPath:PathTmp error:&error];
        
        //NSLog(@"FilesArrary = %@",FilesArrary);
        for(NSString *FileName in FilesArrary)
        {
            // NSLog(@"[FileName pathExtension] = %@",[FileName pathExtension]);
            if ([[FileName pathExtension] isEqualToString:@"app"] == YES) {
                
                NSString * AppPath = [NSString stringWithFormat:@"%@/%@",PathTmp,FileName];
                // NSLog(@"AppPath = %@",AppPath);
                NSString * AppInfoPList = [AppPath stringByAppendingString:@"/Info.plist"];
                NSDictionary *appplstDict = [NSDictionary dictionaryWithContentsOfFile:AppInfoPList];
                
                AppDB *appDB = [[AppDB alloc] init];
                appDB.appPath = AppPath;
                
                appDB.appPackageID = [PathTmp substringFromIndex:50];
                //NSLog(@"appDB.appPackageID = %@",appDB.appPackageID);
                
                appDB.appName = [appplstDict valueForKey:@"CFBundleExecutable"];
                appDB.appBundle = [appplstDict valueForKey:@"CFBundleIdentifier"];
                appDB.appDisplayName = [appplstDict valueForKey:@"CFBundleDisplayName"];
                if ([appDB.appDisplayName length] == 0) {
                    appDB.appDisplayName = [appplstDict valueForKey:@"CFBundleName"];
                }
                appDB.appShortVersionString = [appplstDict valueForKey:@"CFBundleShortVersionString"];
                
                [appList addObject:appDB];
            }
        }
    }
    setuid(0);
    return appList;
}

+(NSMutableArray *)iOS7GetApplist{
    setuid(0);
    static NSString *const cacheFileName = @"com.apple.mobile.installation.plist";
    NSString *relativeCachePath = [[@"Library" stringByAppendingPathComponent: @"Caches"] stringByAppendingPathComponent: cacheFileName];
    NSDictionary *cacheDict = nil;
    NSString *path = nil;
    
    for (short i = 0; 1; i++)
    {
        
        switch (i) {
            case 0:
                path = [NSHomeDirectory() stringByAppendingPathComponent: relativeCachePath];
                break;
            case 1:
                path = [[NSHomeDirectory() stringByAppendingPathComponent: @"../.."] stringByAppendingPathComponent: relativeCachePath];
                break;
            case 2:
                path = [@"/var/mobile" stringByAppendingPathComponent: relativeCachePath];
                break;
            default:
                break;
        }
        
        BOOL isDir = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath: path isDirectory: &isDir] && !isDir)
            cacheDict = [NSDictionary dictionaryWithContentsOfFile: path];
        
        if (cacheDict)
            break;
    }
    
    NSMutableArray *appList = [NSMutableArray arrayWithCapacity:10];
    NSDictionary *user = [cacheDict objectForKey: @"User"];
    for(NSDictionary *key in user)
    {
        AppDB *appDB = [[AppDB alloc] init];
        //        [appDB setPath:[[user objectForKey:key] valueForKey:@"Path"]];
        //        [appDB setName:[[user objectForKey:key] valueForKey:@"CFBundleExecutable"]];
        //        [appDB setBundle:[[user objectForKey:key] valueForKey:@"CFBundleIdentifier"]];
        //        [appDB setDisplayName:[[user objectForKey:key] valueForKey:@"CFBundleDisplayName"]];
        appDB.appPath = [[user objectForKey:key] valueForKey:@"Path"];
        appDB.appName = [[user objectForKey:key] valueForKey:@"CFBundleExecutable"];
        appDB.appBundle = [[user objectForKey:key] valueForKey:@"CFBundleIdentifier"];
        appDB.appDisplayName = [[user objectForKey:key] valueForKey:@"CFBundleDisplayName"];
        if ([appDB.appDisplayName length] == 0) {
            appDB.appDisplayName = [[user objectForKey:key] valueForKey:@"CFBundleName"];
        }
        appDB.appShortVersionString = [[user objectForKey:key] valueForKey:@"CFBundleShortVersionString"];
        
        //NSLog(@"appShortVersionString = %@",appDB.appShortVersionString);
        
        NSString * appPackageID = [[user objectForKey:key] valueForKey:@"Container"];
        NSRange range = [appPackageID rangeOfString:@"Applications"];
        appDB.appPackageID = [appPackageID substringFromIndex:range.location+13];
        //NSLog(@"appPackageID = %@",appDB.appPackageID);
        [appList addObject:appDB];
    }
    
    setuid(0);
    return appList;
}


#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
    }
    
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [[self.dataList objectAtIndex:row] appDisplayName];
    cell.backgroundColor = [UIColor clearColor];
    //cell.imageView.image = [UIImage imageNamed:@"green.png"];
    //cell.detailTextLabel.text = @"详细信息";
    //cell.accessoryType = UITableViewCellSelectionStyleGray;
    return cell;
}
//Button事件
-(void)refreshTable:(id)sender{
    float SysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(SysVer < 8.0)
    {
        self.dataList = [ViewController iOS7GetApplist];
    }
    else
    {
        self.dataList = [ViewController iOS8GetApplist];
    }
    //    [self isConnectNetworkandwarnning];
    [self.myTableView reloadData];
}


//-(void)ConstructPacket:(NSString *)app_name :(NSString *) app_version :(NSString *)app_package_id :(NSString *) device_tag :(NSArray *)paramSum
//{
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//
//    //token：生成算法$token=md5(md5($app_name.$ app_version.$ app_package_id.$device_tag)."SeC0riTy")
//    NSString * Params = [NSString stringWithFormat:@"%@%@%@%@",app_name,app_version,app_package_id,device_tag];
//    NSLog(@"Params = %@",Params);
//    NSString *token = [[[Params md5] stringByAppendingString:@"SeC0riTy"] md5];
//
//    //NSString * adust = [NSString stringWithFormat:@"{\"method\":\"%@\",\"url\":\"%@\",\"host\":\"%@\",\"cookie\":\"%@\",\"mime\":\"%@\",\"data\":\"%@\"}",method,url,host,cookie,@"application/json",@"id=1&type=3"];
//    //NSData * param = adust.JSONValue;
//
//    NSError * error = [[NSError alloc] init];
//    NSData *urls =[ NSJSONSerialization dataWithJSONObject:paramSum
//                                                   options:NSJSONWritingPrettyPrinted
//                                                     error:&error];
//
//    NSString *jsonString = [[NSString alloc] initWithData:urls encoding:NSUTF8StringEncoding];
//
//    jsonString = [jsonString stringByDecodingHTMLEntities];//转义 &amp; 等转移字符
//    jsonString = [jsonString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
//
//    NSString* post = [NSString stringWithFormat:@"app_name=%@&app_version=%@&app_package_id=%@&device_tag=%@&token=%@&urls=%@",\
//                      [app_name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],app_version,app_package_id,device_tag,token,[jsonString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//
//    postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//    NSString *postLength = [NSString stringWithFormat:@"%d",(int)[postData length]];
//
////    [request setURL:[NSURL URLWithString:@"http://pcap.0kee.com/ios.php"]];
//
//    [request setURL:[NSURL URLWithString:@"http://192.168.36.107:8080"]];
//    [request setHTTPMethod:@"POST"];
//    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    [request setHTTPBody:postData];
//    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];///
//    if(conn) {
//        NSLog(@"Connection Successful");
//        [conn start];
//    } else {
//        NSLog(@"Connection could not be made");
//    }
//}


// This method is used to receive the data which we get using post method.
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
//{
//    NSLog(@"cuit:~_~");
////    id message = [data toArrayOrNSDictionary];
////    int tmp = [[[message valueForKey:@"errno"] description] intValue];
//
//    NSString *appName = [[self.dataList objectAtIndex:[self.global_index row]] appName];
//    NSString *path = [NSString stringWithFormat:@"/var/root/tmp/%@.req",appName];
//    NSString *command = [NSString stringWithFormat:@"rm -r %@",path];
//
//    if (self->global_flag  == 3) {
////        if (tmp == 0) {
//
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"发送成功,发送了 %d 条URL包\n",self->CountOfParams] message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
//            [alert show];
//
//            setuid(0);
//            if ([command length] !=0) {
//                system([command UTF8String]);
//            }
//            setuid(0);
//            NSLog(@"cuit:~_~2");
//            self->postData = nil;
////        }
////        else
////        {
////            NSString *FilePath = [NSString stringWithFormat:@"/var/root/tmp/%@_error_.txt",appName];
////            NSString *error = [NSString stringWithFormat:@"发送错误,%d,%@\n",tmp,[message valueForKey:@"message"]];
////            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:error message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
////            [alert show];
////            setuid(0);
////
////            [error writeToFile:FilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
////            NSFileHandle *filehandle = [NSFileHandle fileHandleForUpdatingAtPath:FilePath];
////            [filehandle seekToEndOfFile];
////            [filehandle writeData:self->postData];
////            setuid(0);
////            NSLog(@"cuit:~_~3");
////            self->postData = nil;
////        }
//        self->global_flag = 0;
//    }
//    else
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"SomeThing error self->global_flag: %d",self->global_flag ] message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
//        [alert show];
//        NSLog(@"cuit:~_~4");
//    }
//    NSLog(@"cuit:~_~5");
//}




//Button事件
-(void)clickAudit:(id)sender{
    //    if ([self isConnectNetworkandwarnning] == NO) {
    

    
    //    if([sendpacket isConnectIP:SEND_IP needPort:SEND_PORT] == NO){
    //
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"请确定能联通sec.corp.qihoo.net网络"] message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    //        [alert show];
    //        return;
    //    }
    if (self->global_flag == 1) {//已经选择了APP，等待点击审计
        [but setTitle:@"停止文件监控,结束APP" forState:UIControlStateNormal];
        
        NSString *clearcommand = [NSString stringWithFormat:@"rm -r /var/root/tmp/*"];
        system([clearcommand UTF8String]);
        
        NSString *bundle = [[NSString alloc] initWithString:[[self.dataList objectAtIndex:[self.global_index row]] appBundle]];
        [ViewController DelAndAddAppToPlist:bundle];
        
        NSString * command = [NSString stringWithFormat:@"open %@",[[self.dataList objectAtIndex:[self.global_index row]] appBundle]];
        
        NSString * killcommand = [NSString stringWithFormat:@"killall %@",[[self.dataList objectAtIndex:[self.global_index row]] appName]];
        
        setuid(0);
        NSLog(@"command = %@",killcommand);
        NSLog(@"command = %@",command);
        system([killcommand UTF8String]);
        system([command UTF8String]);
        setuid(0);
        
        [NSThread sleepForTimeInterval:5];
        [ViewController cleanPlist];
        
        self->global_flag = 2;
    }
    else if(self->global_flag  == 2)        // 正在审计的状态
    {
        NSString *appName = [[self.dataList objectAtIndex:[self.global_index row]] appName];
        NSString * command = [NSString stringWithFormat:@"killall %@",appName];
        
        setuid(0);
        system([command UTF8String]);
        NSError *error =nil;
        NSFileManager *filemanager = [NSFileManager defaultManager];
        NSArray * filessarrary = [filemanager contentsOfDirectoryAtPath:@"/var/root/tmp/" error:&error];
        
        NSString *path = nil;
        for (NSString *filePath in filessarrary) {
            if ([[filePath pathExtension] isEqualToString:@"filemon"] ) {
                path = [NSString stringWithFormat:@"/var/root/tmp/%@",filePath];
            }
        }
        //        NSString *path = [NSString stringWithFormat:@"/var/root/tmp/%@.req",appName];
        
        NSLog(@"path = %@",path);
        NSArray * arrary = [filemanager contentsOfDirectoryAtPath:path error:&error];
        
        NSLog(@"arrary = %@",arrary);
        
//        NSMutableArray * paramSum = [NSMutableArray arrayWithCapacity:10];
        NSMutableArray * paramSum = [NSMutableArray  arrayWithCapacity:10];
        [filemanager changeCurrentDirectoryPath:path];
        
        for (NSString *indexPath in arrary) {
            NSDictionary * dic = [NSDictionary dictionaryWithContentsOfFile:indexPath];
            
            if (dic != nil) {
//                [paramSum addObject:[[dic description] urlEncodedUTF8String]];
//                [paramSum addObject:[dic description]];
                @try {
                    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
                    [paramSum addObject:dic];
                } @catch (NSException *exception) {
                    NSLog(@"exception = %@,%@",[exception name],[exception reason]);
                    NSDictionary * dicttmp = [NSDictionary dictionaryWithObject:[[dic allValues][0] description] forKey:[dic allKeys][0]];
                    [paramSum addObject:dicttmp];
                }
            }
        }
        
        //NSLog(@"paramSum = %@",paramSum);
        self->CountOfParams = [paramSum count];
        if (self->CountOfParams == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"获取 0 条HTTP包"] message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
            self->global_flag  = 0;
            NSString *Title = [NSString stringWithFormat:@"开始文件监控"];
            [but setTitle:Title forState:UIControlStateNormal];
            
            return;
        }
        
        NSString *appname = [[self.dataList objectAtIndex:[self.global_index row]] appName];// stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
        NSString *appversion = [[self.dataList objectAtIndex:[self.global_index row]] appShortVersionString];
        NSString *apppackage_id =[[self.dataList objectAtIndex:[self.global_index row]] appPackageID];
        NSLog(@"\nappname: %@\nappversion: %@\napppackage_id : %@\n",appname, appversion, apppackage_id);
        
 
        //        if ([sendpacket isConnectIP:SEND_IP needPort:SEND_PORT]) {
        NSDictionary *dic_send = [NSDictionary dictionaryWithObject:paramSum forKey:path];
        
        if ([[ViewController GetOrStore:dic_send FLAG:1] isEqualToString:@"YES"]) {
            NSLog(@"store success");
        }
        else
        {
            NSLog(@"store failed");
        }
        self->global_flag  = 0;
        
        
        NSString *Title = [NSString stringWithFormat:@"开始文件监控"];
        [but setTitle:Title forState:UIControlStateNormal];
        //        }
        //        else
        //        {
        //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"请确定能连通sec.corp.qihoo.net网络"] message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        //            [alert show];
        //            NSLog(@"not send packet");
        //        }
        setuid(0);
    }
    else if(self->global_flag == 0)//开始选择APP
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请选择APP 进行文件监控" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSLog(@"error somewhere??????,self->global_flag  = %d",self->global_flag );
    }
}

-(void)clickremoveview:(id)sender
{
    [UIView animateWithDuration:0.2
                     animations:^{self.viewtmp.alpha = 0.0;}
                     completion:^(BOOL finished){ [self.viewtmp removeFromSuperview];}];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSAutoreleasePool *p = [[NSAutoreleasePool alloc] init];
    @autoreleasepool {
        if(self->global_flag == 0)//开始选择APP
        {
            self.global_index = indexPath;
            [but setTitle:@"开始文件监控" forState:UIControlStateNormal];
            
            self->global_flag = 1;
        }
        else if(self->global_flag == 1){//已经选择了APP，等待点击审计
            self.global_index = indexPath;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请点击开始文件监控" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
        }
        else if(self->global_flag == 2)// 正在审计的状态
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请点击停止文件监控" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

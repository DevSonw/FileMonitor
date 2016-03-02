//
//  SendPacket.m
//  
//
//  Created by panda on 18/1/16.
//
//

#import "SendPacket.h"
#import "Reachability.h"
#include <arpa/inet.h>


@implementation SendPacket


-(BOOL)isConnectIP:(NSString*)ip needPort:(NSString*)port
{
    NSLog(@"try to check network ip=%@ port=%@",ip,port);
    int sock = socket(AF_INET, SOCK_STREAM, 0);
    if(sock == -1)
        NSLog(@"socket error~");
    
    struct in_addr server_addr;
    if(!inet_aton([ip UTF8String],&server_addr))
        NSLog(@"inet_aton error~");
    
    struct sockaddr_in connection;
    connection.sin_family = AF_INET;
    memcpy(&connection.sin_addr, &server_addr, sizeof(server_addr));
    connection.sin_port = htons([port intValue]);
    
    int connected = connect(sock, (const struct sockaddr*) &connection, sizeof(connection));
    //Upon successful completion, a value of 0 is returned.  Otherwise, a value of -1
    
    if (connected == -1) {
        NSLog(@"not connect to %@:%@",ip,port);
        close(sock);
        return NO;
    }
    NSLog(@"connect to %@:%@",ip,port);
    close(sock);
    return YES;
}

//-(BOOL)isConnectNetworkandwarnning
//{
//    Reachability *r = [Reachability reachabilityWithHostName:@"http://101.199.126.121:8001"];
//    switch ([r currentReachabilityStatus]) {
//        case NotReachable:// 没有网络连接
//        {
//            NSLog(@"nonetwork");
////            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请检查网络，目前没有网络连接" message:nil delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
////            [alert show];
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

-(BOOL)SendDataToURL:(NSString*)ip_and_port sendData:(NSData *)SendData
{
    //创建URL对象
//    NSString *urlStr = @"http://101.199.126.121:8001";
//NSString *urlStr = [NSString stringWithFormat:@"http://%@:%@",ip,port];
    
//    NSString *urlStr = @"http://192.168.36.107:8080";
//    NSString *urlStr = @"https://sec.corp.qihoo.net/iOS/";
    NSString *urlStr = ip_and_port;
    
    NSLog(@"urlStr = %@",ip_and_port);
    
    NSURL *url = [[NSURL alloc] initWithString:urlStr];
    
    //创建HTTP请求
    //方法1（注：NSURLRequest只支持Get请求，NSMutableURLRequest可支持Get和Post请求）
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    //方法2，使用工厂方法创建
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    //同时设置缓存策略和超时时间
//    NSMutableURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    
    //设置Http头
    NSDictionary *headers = [request allHTTPHeaderFields];
    [headers setValue:@"application/json" forKey:@"Content-Type"];

    //设置请求方法
//    [request setHTTPMethod:@"GET"];
    [request setHTTPMethod:@"POST"];
    
    //设置要发送的正文内容（适用于Post请求）
//    NSString *content = @"username=stanyung&password=123";
//    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:SendData];
    NSLog(@"request = %@",request);
    //同步执行Http请求，获取返回数据
    NSURLResponse *response;
    NSError *error;
    NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    NSLog(@"result = %@",result);
    //返数据转成字符串
    NSString *html = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    NSLog(@"html = %@",html);
    //（如果有错误）错误描述
//    NSString *errorDesc = [error localizedDescription];
//    NSLog(@"errorDesc = %@",errorDesc);
    //获取状态码和HTTP响应头信息
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSInteger statusCode = [httpResponse statusCode];
    NSLog(@"statusCode = %d",statusCode);
    
    if (statusCode == 200) {
        return YES;
    }
    else{
        NSLog(@"error = %@",error);
        return NO;
    }
//    NSDictionary *responseHeaders = [httpResponse allHeaderFields];
//    NSLog(@"responseHeaders = %@",responseHeaders);
    
//    NSString *cookie = [responseHeaders valueForKey:@"Set-Cookie"];
//    NSLog(@"cookie = %@",cookie);
    
//    NSString *URLPath = [NSString stringWithFormat:@"http://127.0.0.1:8000"];
//    NSURL *URL = [NSURL URLWithString:URLPath];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
//    
//    [request setHTTPBody:SendData];
//    [request setHTTPMethod:@"POST"];
//    [request setTimeoutInterval:3.0];
//    
//    NSURLConnection *conn = [NSURLConnection connectionWithRequest:request delegate:self];
//    [conn start];


}
//- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace{
//    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
//    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
//        if ([trustedHosts containsObject:challenge.protectionSpace.host])
//            [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
//    
//    [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
//}


//
//- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response
//{
//    NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
//    NSLog(@"response length=%lld  statecode%d", [response expectedContentLength],responseCode);
//}
//
//
//- (void)connection:(NSURLConnection *)Connection didReceiveData:(NSData *)data
//{
//    NSMutableData *mData = [[NSMutableData alloc] initWithData:data];
//    NSLog(@"response connection  %@",mData);
//}
//
//
//- (void)connection:(NSURLConnection *)theConnectionco didFailWithError:(NSError *)error
//{
//    NSLog(@"response error%@", [error localizedFailureReason]);
//}
//
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//}

@end

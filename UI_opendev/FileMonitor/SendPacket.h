//
//  SendPacket.h
//  
//
//  Created by panda on 18/1/16.
//
//

#import <Foundation/Foundation.h>

@interface SendPacket : NSObject
//-(BOOL)isConnectNetworkandwarnning;
-(BOOL)isConnectIP:(NSString*)ip needPort:(NSString*)port;
-(BOOL)SendDataToURL:(NSString*)ip needPort:(NSString*)port sendData:(NSData *)SendData;
//- (void)connection:(NSURLConnection *)theConnection didReceiveResponse:(NSURLResponse *)response;
//- (void)connection:(NSURLConnection *)Connection didReceiveData:(NSData *)data;
//- (void)connection:(NSURLConnection *)theConnectionco didFailWithError:(NSError *)error;
//- (void)didReceiveMemoryWarning;

@end

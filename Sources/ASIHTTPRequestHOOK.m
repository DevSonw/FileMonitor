//#import "ASIHTTPRequest.h"
//#import "ASINetworkQueue.h"
/*
 
 // Should be an HTTP or HTTPS url, may include username and password if appropriate
 - (id)initWithURL:(NSURL *)newURL;
 
 // Convenience constructor
 + (id)requestWithURL:(NSURL *)newURL;
 + (id)requestWithURL:(NSURL *)newURL usingCache:(id <ASICacheDelegate>)cache;
 + (id)requestWithURL:(NSURL *)newURL usingCache:(id <ASICacheDelegate>)cache andCachePolicy:(ASICachePolicy)policy;
 
 // Run a request synchronously, and return control when the request completes or fails
 - (void)startSynchronous;
 // Run request in the background
 - (void)startAsynchronous;
 // Response data, automatically uncompressed where appropriate
 - (NSData *)responseData;
 - (NSString *)responseString;

 
 // Called when a request starts, lets the delegate know via didStartSelector
 - (void)requestStarted;
 // Called when a request completes successfully, lets the delegate know via didFinishSelector
 - (void)requestFinished;
 
 // Run a request synchronously, and return control when the request completes or fails
 - (void)startSynchronous;
 
 // Run request in the background
 - (void)startAsynchronous;


HOOK_MESSAGE(void, ASIHTTPRequest,requestStarted)
{
    _Log(@"~_~22%s: %@", __FUNCTION__, self);
    
    _ASIHTTPRequest_requestStarted(self, sel);
    //_LogRequest([self currentRequest]);
}
 
 NSLog(@"self.requestMethod : %@\nself.url : %@\nself.originalURL : %@\nself.proxyHost : %@\nself.requestCookies : %@\nself.postBody : %@\nself.buildPostBody: %@\nself.HEADRequest : %@\nself.postLength : %d",\
 [self requestMethod],   [self url],       [self originalURL],       [self proxyHost],    [self requestCookies],    [self postBody],     [self buildPostBody],  [self HEADRequest],    [self postLength]);
*/


#include "IFHOOK.h"

#ifdef ASIHTTPRequest_IF_HOOK

HOOK_MESSAGE(void, ASIHTTPRequest,requestFinished)
{//[NSArray arrayWithObjects:@"method", @"url", @"host",@"cookie", @"mime",@"data",nil];
    //_Log(@"~_~%s: %@", __FUNCTION__, self);
    _LogRequestASIHTTPRequest(self);
    _ASIHTTPRequest_requestFinished(self, sel);
    //_LogRequest([self currentRequest]);
}
#endif
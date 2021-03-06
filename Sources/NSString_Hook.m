

#import "IFHOOK.h"
#ifdef NSString_IF_HOOK

extern NSRegularExpression *regex;


HOOK_MESSAGE(BOOL,NSString,writeToFile_atomically_encoding_error_,NSString *path,BOOL useAuxiliaryFile,NSStringEncoding enc,NSError **error)
{
    _LogNSStringWrite(@"writeToFile_atomically_encoding_error_",self,path);
    NSString *pathexten = [path pathExtension];
    NSArray *checkingResults  = [regex matchesInString:pathexten options:0 range:NSMakeRange(0, [pathexten length])];
    if ([checkingResults count] != 0) {
        
    }else
    return _NSString_writeToFile_atomically_encoding_error_(self,sel,path,useAuxiliaryFile,enc,error);
}
HOOK_MESSAGE(BOOL,NSString,writeToFile_atomically_,NSString *path,BOOL useAuxiliaryFile)
{
    _LogNSStringWrite(@"writeToFile_atomically_",self,path);
    NSString *pathexten = [path pathExtension];
    NSArray *checkingResults  = [regex matchesInString:pathexten options:0 range:NSMakeRange(0, [pathexten length])];
    if ([checkingResults count] != 0) {
        
    }else
    return _NSString_writeToFile_atomically_(self,sel,path,useAuxiliaryFile);
}
HOOK_MESSAGE(BOOL,NSString,writeToURL_atomically_encoding_error_,NSURL *url,BOOL useAuxiliaryFile,NSStringEncoding enc,NSError **error)
{
    _LogNSStringWrite(@"writeToURL_atomically_encoding_error_",self,[url absoluteString]);
    return _NSString_writeToURL_atomically_encoding_error_(self,sel,url,useAuxiliaryFile,enc,error);
}
HOOK_MESSAGE(BOOL,NSString,writeToURL_atomically_,NSURL *url,BOOL atomically)
{
    _LogNSStringWrite(@"writeToURL_atomically_",self,[url absoluteString]);
    return _NSString_writeToURL_atomically_(self,sel,url,atomically);
}


//file
HOOK_MESSAGE(NSString*,NSString,initWithContentsOfFile_,NSString *path)
{
    NSString *str = _NSString_initWithContentsOfFile_(self,sel,path);
    NSString *pathexten = [path pathExtension];
    NSArray *checkingResults  = [regex matchesInString:pathexten options:0 range:NSMakeRange(0, [pathexten length])];
    if ([checkingResults count] != 0) {
        
    }else
    _LoginitWithContentsOffileorurl(@"initWithContentsOfFile_",str,path);
    return str;
}

HOOK_MESSAGE(NSString*,NSString,initWithContentsOfURL_,NSURL *url)
{
    NSString *str = _NSString_initWithContentsOfURL_(self,sel,url);
    _LoginitWithContentsOffileorurl(@"initWithContentsOfURL_",str,url);
    
    return str;
}


#endif
//HOOK_MESSAGE(NSString*,NSString,stringByAppendingString_,NSString *aString)
//{
//    if (aString == nil) {
////        NSLog(@"stack = %@",[NSThread callStackSymbols]);
//        return @"";
//    }
//    NSString *str = _NSString_stringByAppendingString_(self,sel,aString);
//    
//    
//    return str;
//}

////compare
//HOOK_MESSAGE(BOOL,NSString,isEqualToString_,NSString  *aString)
//{
//    orig_NSString_isEqualToString_ = _NSString_isEqualToString_;
//    
//    if (orig_NSString_isEqualToString_(self,sel,aString) ) {
//        
//    }
//    if ([self isEqualToString:@""] &&[aString isEqualToString:@""]) {
//        return _NSString_isEqualToString_(self,sel,aString);
//    }
//    else
//    {
//        _LogComparedata(@"isEqualToString_",self,aString);
//        return _NSString_isEqualToString_(self,sel,aString);
//    }
//}

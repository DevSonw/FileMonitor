
HOOK_MESSAGE(BOOL,NSString,writeToFile_atomically_encoding_error_,NSString *path,BOOL useAuxiliaryFile,NSStringEncoding enc,NSError **error)
{
    _LogNSStringWrite(@"writeToFile_atomically_encoding_error_",self,path);
    return _NSString_writeToFile_atomically_encoding_error_(self,sel,path,useAuxiliaryFile,enc,error);
}
HOOK_MESSAGE(BOOL,NSString,writeToFile_atomically_,NSString *path,BOOL useAuxiliaryFile)
{
    _LogNSStringWrite(@"writeToFile_atomically_",self,path);
    return _NSString_writeToFile_atomically_(self,sel,path,useAuxiliaryFile);
}
HOOK_MESSAGE(BOOL,NSString,writeToURL_atomically_encoding_error_,NSURL *url,BOOL useAuxiliaryFile,NSStringEncoding enc,NSError **error)
{
    _LogNSStringWrite(@"writeToURL_atomically_encoding_error_",self,url);
    return _NSString_writeToURL_atomically_encoding_error_(self,sel,url,useAuxiliaryFile,enc,error);
}
HOOK_MESSAGE(BOOL,NSString,writeToURL_atomically_,NSURL *url,BOOL atomically)
{
    _LogNSStringWrite(@"writeToURL_atomically_",self,url);
    return _NSString_writeToURL_atomically_(self,sel,url,atomically);
}


//file
HOOK_MESSAGE(NSString*,NSString,initWithContentsOfFile_,NSString *path)
{
    NSString *str = _NSString_initWithContentsOfFile_(self,sel,path);
    _LoginitWithContentsOffileorurl(@"initWithContentsOfFile_",str,path);
    return str;
}

HOOK_MESSAGE(NSString*,NSString,initWithContentsOfURL_,NSURL *url)
{
    NSString *str = _NSString_initWithContentsOfURL_(self,sel,url);
    _LoginitWithContentsOffileorurl(@"initWithContentsOfURL_",str,url);
    return str;
}
/*
//compare
HOOK_MESSAGE(BOOL,NSDictionary,isEqualToString_,NSString  *aString)
{
    _LogComparedata(@"isEqualToString_",self,aString);
    _NSDictionary_isEqualToString_(self,sel,aString);
}
*/
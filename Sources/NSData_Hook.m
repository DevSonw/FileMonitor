//Jul 31 19:19:38 360de-iPhone UserDefaults[2328] <Warning>: ---FileMonitor---init :  : NSData_initWithContentsOfFile_,/var/mobile/Applications/5F6DBEAB-7115-43F2-B430-21E7599569C9/UserDefaults.app/Base.lproj/Main.storyboardc/Info.plist


#define PRINT_DATA(mode,path,funcname) NSLog(@"---FileMonitor---%@ : %@ : %@",mode,path,funcname);


HOOK_MESSAGE(BOOL, UIApplication, openURL_, NSURL *URL)
{
	//NSLog(@"%s: %@", __FUNCTION__, URL);
    PRINT_DATA(@"URL",URL,@"openURL_");
	return _UIApplication_openURL_(self, sel, URL);
}

//
HOOK_MESSAGE(BOOL, UIApplication, canOpenURL_, NSURL *URL)//- (BOOL)canOpenURL:(NSURL *)url
{
    //NSLog(@"~_~12%s: %@", __FUNCTION__, URL);
    PRINT_DATA(@"URL",URL,@"canOpenURL_");
	return _UIApplication_canOpenURL_(self, sel, URL);
}

HOOK_MESSAGE(BOOL,NSData,writeToFile_atomically_,NSString *path,BOOL atomically)
{
    NSRange range = [path rangeOfString:@"filemon"];
    if (range.location == NSNotFound) {
    _LogNSDataWrite(@"writeToFile_atomically_",self,path);
    }
    return _NSData_writeToFile_atomically_(self,sel,path,atomically);
}
HOOK_MESSAGE(BOOL,NSData,writeToFile_options_error_,NSString *path,NSDataWritingOptions mask,NSError** errorPtr)
{
    _LogNSDataWrite(@"writeToFile_options_error_",self,path);
    return _NSData_writeToFile_options_error_(self,sel,path,mask,errorPtr);
}

HOOK_MESSAGE(BOOL,NSData,writeToURL_atomically_,NSURL *aURL,BOOL atomically)
{
    _LogNSDataWrite(@"writeToURL_atomically_",self,[aURL absoluteString]);
    return _NSData_writeToURL_atomically_(self,sel,aURL,atomically);
}
HOOK_MESSAGE(BOOL,NSData,writeToURL_options_error_,NSString *path,NSDataWritingOptions mask,NSError** errorPtr)
{
    _LogNSDataWrite(@"writeToURL_options_error_",self,path);
    return _NSData_writeToURL_options_error_(self,sel,path,mask,errorPtr);
}

//file
HOOK_MESSAGE(NSData*,NSData,initWithContentsOfURL_,NSURL *aURL)
{
    NSData *data = _NSData_initWithContentsOfURL_(self,sel,aURL);
    NSRange range =[[aURL absoluteString] rangeOfString:@"Info.plist"];
    if (range.location == NSNotFound) {
        _LoginitWithContentsOffileorurl(@"initWithContentsOfURL_",data,aURL);
    }
    return data;
}

HOOK_MESSAGE(NSData*,NSData,initWithContentsOfFile_,NSString *path)
{
    
    NSData *data = _NSData_initWithContentsOfFile_(self,sel,path);
    NSRange range =[path rangeOfString:@"Info.plist"];
    NSRange range2 =[path rangeOfString:@".nib"];
    if (range.location != NSNotFound || range2.location != NSNotFound ) {
        
    }
    else
    {
        _LoginitWithContentsOffileorurl(@"initWithContentsOfFile_",data,path);
    }
    return data;
}

//compare
HOOK_MESSAGE(BOOL,NSData,isEqualToData_,NSData *otherData)
{
//    _LogComparedata(@"isEqualToData_",self,otherData);
    return _NSData_isEqualToData_(self,sel,otherData);
}


//base64
HOOK_MESSAGE(NSString *,NSData,base64Encoding)
{
    //    _LogComparedata(@"isEqualToData_",self,otherData);
    NSString  * str_base64 = _NSData_base64Encoding(self,sel);
//    NSLog(@"self = %@   ->=   %@",self,str_base64);
    _LogBase64(@"base64Encoding",self,str_base64);
    return str_base64;
}

HOOK_MESSAGE(NSData *,NSData,base64EncodedDataWithOptions_,NSDataBase64EncodingOptions options)
{
    //    _LogComparedata(@"isEqualToData_",self,otherData);
    NSData* tmpdata = _NSData_base64EncodedDataWithOptions_(self,sel,options);
    
     _LogBase64(@"base64EncodedDataWithOptions_",self,tmpdata);
    return tmpdata;
}


HOOK_MESSAGE(NSString *,NSData,base64EncodedStringWithOptions_,NSDataBase64EncodingOptions options)
{
    //    _LogComparedata(@"isEqualToData_",self,otherData);
    NSString *str_base64 = _NSData_base64EncodedStringWithOptions_(self,sel,options);
    
    _LogBase64(@"base64EncodedStringWithOptions_",self,str_base64);
    return str_base64;
}

//base64 init
HOOK_MESSAGE(NSData*,NSData,initWithBase64EncodedData_options_,NSData *base64Data,NSDataBase64DecodingOptions options)
{
    //    _LogComparedata(@"isEqualToData_",self,otherData);
    NSData* data = _NSData_initWithBase64EncodedData_options_(self,sel,base64Data,options);
    if (data != nil) {
        _LogBase64(@"initWithBase64EncodedData_options_",base64Data, data);
    }
    return data;
}

HOOK_MESSAGE(NSData*,NSData,initWithBase64EncodedString_options_,NSString *base64String,NSDataBase64DecodingOptions options)
{
    //    _LogComparedata(@"isEqualToData_",self,otherData);
    id data = _NSData_initWithBase64EncodedString_options_(self,sel,base64String,options);
    if (data !=nil) {
        _LogBase64(@"initWithBase64EncodedString_options_",base64String,data);
    }
    return data;
}


HOOK_MESSAGE(id,NSData,initWithBase64Encoding_,NSString *base64String)
{
    //    _LogComparedata(@"isEqualToData_",self,otherData);
    id data = _NSData_initWithBase64Encoding_(self,sel,base64String);
    if (data) {
        _LogBase64(@"initWithBase64Encoding_",base64String,data);
    }
    return data;
}



//Jul 31 19:19:38 360de-iPhone UserDefaults[2328] <Warning>: ---FileMonitor---init :  : NSData_initWithContentsOfFile_,/var/mobile/Applications/5F6DBEAB-7115-43F2-B430-21E7599569C9/UserDefaults.app/Base.lproj/Main.storyboardc/Info.plist





//HOOK_MESSAGE(BOOL, UIApplication, openURL_, NSURL *URL)
//{
//	//NSLog(@"~_~13%s: %@", __FUNCTION__, URL);
//    
//	return _UIApplication_openURL_(self, sel, URL);
//}
//
////
//HOOK_MESSAGE(BOOL, UIApplication, canOpenURL_, NSURL *URL)//- (BOOL)canOpenURL:(NSURL *)url
//{
//    //NSLog(@"~_~12%s: %@", __FUNCTION__, URL);
//	return _UIApplication_canOpenURL_(self, sel, URL);
//}


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
    _LogNSDataWrite(@"writeToURL_atomically_",self,aURL);
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
    NSRange range =[[aURL description] rangeOfString:@"Info.plist"];
    if (range.location == NSNotFound) {
        _LoginitWithContentsOffileorurl(@"initWithContentsOfURL_",data,aURL);
    }
    

    return data;
}

HOOK_MESSAGE(NSData*,NSData,initWithContentsOfFile_,NSString *path)
{
    
    NSData *data = _NSData_initWithContentsOfFile_(self,sel,path);
    NSRange range =[path rangeOfString:@"Info.plist"];
    if (range.location == NSNotFound) {
        _LoginitWithContentsOffileorurl(@"initWithContentsOfFile_",data,path);
    }
    return data;
}

//compare
HOOK_MESSAGE(BOOL,NSDictionary,isEqualToData_,NSData *otherData)
{
    _LogComparedata(@"isEqualToData_",self,otherData);
    _NSDictionary_isEqualToData_(self,sel,otherData);
}

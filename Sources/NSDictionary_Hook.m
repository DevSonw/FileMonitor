//Jul 31 19:19:38 360de-iPhone UserDefaults[2328] <Warning>: ---FileMonitor---Compare :  : NSDictionary_isEqualToDictionary__{
//    "objectForKey_" =     {
//        UIDisableLegacyTextView = 1;
//    };
//}_{
//    UIDisableLegacyTextView = 1;
//}

//    hasAccessibilityBeenMigrated = 1;
//}
//Jul 31 19:19:38 360de-iPhone UserDefaults[2328] <Warning>: ---FileMonitor---Compare :  : NSDictionary_isEqualToDictionary__{
//    "objectForKey_" =     {
//        hasAccessibilityBeenMigrated = 1;
//    };
//}_{
//    hasAccessibilityBeenMigrated = 1;
//}


HOOK_MESSAGE(BOOL,NSDictionary,writeToFile_atomically_,NSString *path,BOOL flag)
{
    NSRange range = [path rangeOfString:@"filemon"];
    if (range.location == NSNotFound) {
        _LogNSDictionaryWrite(@"writeToFile_atomically_",self,path);
    }

    _NSDictionary_writeToFile_atomically_(self,sel,path,flag);
}
HOOK_MESSAGE(BOOL,NSDictionary,writeToURL_atomically_,NSURL *aURL,BOOL atomically)
{
    NSRange range = [[aURL description] rangeOfString:@"filemon"];
    if (range.location == NSNotFound) {
    _LogNSDictionaryWrite(@"writeToURL_atomically_",self,aURL);
    }
    _NSDictionary_writeToURL_atomically_(self,sel,aURL,atomically);
}


//file
HOOK_MESSAGE(BOOL,NSDictionary,initWithContentsOfFile_,NSString *path)
{
    NSDictionary *dic =    _NSDictionary_initWithContentsOfFile_(self,sel,path);
    _LoginitWithContentsOffileorurl(@"initWithContentsOfFile_",self,path);
    return dic;
}

HOOK_MESSAGE(BOOL,NSDictionary,initWithContentsOfURL_,NSURL *aURL)
{
    NSDictionary *dic =  _NSDictionary_initWithContentsOfURL_(self,sel,aURL);
    _LoginitWithContentsOffileorurl(@"initWithContentsOfURL_",dic,aURL);
    return dic;
   
}

//compare
HOOK_MESSAGE(BOOL,NSDictionary,isEqualToDictionary_,NSDictionary *otherDictionary)
{
    if ([otherDictionary objectForKey:@"UIDisableLegacyTextView"] ||[otherDictionary objectForKey:@"hasAccessibilityBeenMigrated"]) {
    
    }
    else
        _LogComparedata(@"isEqualToDictionary_",self,otherDictionary);
    _NSDictionary_isEqualToDictionary_(self,sel,otherDictionary);
}


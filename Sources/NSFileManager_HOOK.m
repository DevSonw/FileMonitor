//
//  NSFileManager_HOOK.m
//  FileMonitor
//
//  Created by panda on 24/7/15.
//
//


//Jul 31 19:19:38 360de-iPhone UserDefaults[2328] <Warning>: ---FileMonitor---Create : /var/root/tmp/UserDefaults.filemon : NSFileManager_createDirectoryAtPath_withIntermediateDirectories_attributes_error
//Jul 31 19:19:38 360de-iPhone UserDefaults[2328] <Warning>: ---FileMonitor---Change_Attributes : /var/root/tmp/UserDefaults.filemon : NSFileManager_setAttributes_ofItemAtPath_error,(null)
//Jul 31 19:19:38 360de-iPhone UserDefaults[2328] <Warning>: ---FileMonitor---Create : /var/root/tmp/UserDefaults.filemon : NSFileManager_createDirectoryAtPath_withIntermediateDirectories_attributes_error


//write file__________________________

//HOOK_MESSAGE(BOOL,NSFileManager,createFileAtPath_contents_attributes_,NSString  *path,NSData *contents,NSDictionary *attributes)
//{
//    _LogNSFileManagerWrite(@"createFileAtPath_contents_attributes_",contents,path);
//    return _NSFileManager_createFileAtPath_contents_attributes_(self,sel,path,contents,attributes);
//}  == NSData_writeToFile_atomically_

//#define DEBUG_INFO



#define Function_readcontent__________________________
HOOK_MESSAGE(BOOL,NSFileManager,contentsAtPath_,NSString  *path)
{
#ifdef DEBUG_INFO
    NSLog(@"~~~~~~~~~~~~~~~~~~~1");
#endif
    
    NSData * data = _NSFileManager_contentsAtPath_(self,sel,path);
    _LogNSFileManagerWrite(@"contentsAtPath_",data,path);
    return data;
}

#define Function_compare_filecontent__________________________
HOOK_MESSAGE(BOOL,NSFileManager,contentsEqualAtPath_andPath_,NSString  *path1,NSString *path2)
{
#ifdef DEBUG_INFO
    NSLog(@"~~~~~~~~~~~~~~~~~~~2");
#endif
    
    _LogComparedata(@"contentsEqualAtPath_andPath_",path1,path2);
    return _NSFileManager_contentsEqualAtPath_andPath_(self,sel,path1,path2);
}

#define Function_create_directiory__________________________
HOOK_MESSAGE(BOOL,NSFileManager,createDirectoryAtURL_withIntermediateDirectories_attributes_error_,NSURL  *url,BOOL *createIntermediates,NSDictionary *attributes,NSError **error)
{
#ifdef DEBUG_INFO
    NSLog(@"~~~~~~~~~~~~~~~~~~~3");
#endif
    
    _LogNSFileManagerWrite(@"createDirectoryAtURL_withIntermediateDirectories_attributes_error_",@"",url);
    return _NSFileManager_createDirectoryAtURL_withIntermediateDirectories_attributes_error_(self,sel,url,createIntermediates,attributes,error);
}

HOOK_MESSAGE(BOOL,NSFileManager,createDirectoryAtPath_withIntermediateDirectories_attributes_error_,NSString *path,BOOL createIntermediates,NSDictionary *attributes,NSError **error)
{
#ifdef DEBUG_INFO
    NSLog(@"~~~~~~~~~~~~~~~~~~~4");
#endif
    
    _LogNSFileManagerWrite(@"createDirectoryAtPath_withIntermediateDirectories_attributes_error",@"",path);
    return _NSFileManager_createDirectoryAtPath_withIntermediateDirectories_attributes_error_(self,sel,path,createIntermediates,attributes,error);
}

HOOK_MESSAGE(BOOL,NSFileManager,createDirectoryAtPath_attributes_,NSString  *path,NSDictionary *attributes)
{
#ifdef DEBUG_INFO
    NSLog(@"~~~~~~~~~~~~~~~~~~~5");
#endif
    
    _LogNSFileManagerWrite(@"createDirectoryAtPath_attributes_",@"",path);
    return _NSFileManager_createDirectoryAtPath_attributes_(self,sel,path,attributes);
}


#define Function_Change_Attributes__________________________
HOOK_MESSAGE(BOOL,NSFileManager,changeFileAttributes_atPath_,NSDictionary  *attributes,NSString *path)
{
    _LogNSFileManagerChange_Attributes(@"changeFileAttributes_atPath_",path,attributes);
    return _NSFileManager_changeFileAttributes_atPath_(self,sel,attributes,path);
}

HOOK_MESSAGE(BOOL,NSFileManager,setAttributes_ofItemAtPath_error_,NSDictionary  *attributes,NSString *path,NSError **error)
{
    _LogNSFileManagerChange_Attributes(@"setAttributes_ofItemAtPath_error",path,attributes);
    return _NSFileManager_setAttributes_ofItemAtPath_error_(self,sel,attributes,path,error);
}


#define Function_create_SymbolicLink__________________________
HOOK_MESSAGE(BOOL,NSFileManager,createSymbolicLinkAtURL_withDestinationURL_error_,NSURL  *url,NSURL *destURL,NSError **error)
{
    _LogNSFileManagerCreateSymblic(@"createSymbolicLinkAtURL_withDestinationURL_error_",url,destURL);
    return _NSFileManager_createSymbolicLinkAtURL_withDestinationURL_error_(self,sel,url,destURL,error);
}

HOOK_MESSAGE(BOOL,NSFileManager,createSymbolicLinkAtPath_withDestinationPath_error_,NSString *path,NSString *destPath,NSError **error)
{
    _LogNSFileManagerCreateSymblic(@"createSymbolicLinkAtPath_withDestinationPath_error_",path,destPath);
    return _NSFileManager_createSymbolicLinkAtPath_withDestinationPath_error_(self,sel,path,destPath,error);
}

HOOK_MESSAGE(BOOL,NSFileManager,linkItemAtURL_toURL_error_,NSString *path,NSString *destPath,NSError **error)
{
    _LogNSFileManagerCreateSymblic(@"linkItemAtURL_toURL_error_",path,destPath);
    return _NSFileManager_linkItemAtURL_toURL_error_(self,sel,path,destPath,error);
}


HOOK_MESSAGE(BOOL,NSFileManager,linkItemAtPath_toPath_error_,NSString *path,NSString *destPath,NSError **error)
{
    _LogNSFileManagerCreateSymblic(@"linkItemAtPath_toPath_error_",path,destPath);
    return _NSFileManager_linkItemAtPath_toPath_error_(self,sel,path,destPath,error);
}



#define Function_removeitematpathorurl__________________________

HOOK_MESSAGE(BOOL,NSFileManager,removeItemAtPath_error_,NSString *path,NSError **error)
{
    _LogNSFileManagerRemoveItemAtPath(@"removeItemAtPath_error_",path);
    return _NSFileManager_removeItemAtPath_error_(self,sel,path,error);
}

HOOK_MESSAGE(BOOL,NSFileManager,removeItemAtURL_error_,NSURL *URL,NSError **error)
{
    _LogNSFileManagerRemoveItemAtPath(@"removeItemAtURL_error_",URL);
    return _NSFileManager_removeItemAtURL_error_(self,sel,URL,error);
}

#define Function_replaceItemAtURL_withItemAtURL_backupItemName_options_resultingItemURL_error___________________________
HOOK_MESSAGE(BOOL,NSFileManager,replaceItemAtURL_withItemAtURL_backupItemName_options_resultingItemURL_error_,NSURL *originalItemURL,NSURL *newItemURL,NSString *backupItemName,NSFileManagerItemReplacementOptions options,NSURL **resultingURL,NSError **error)
{
_LogNSFileManagerreplaceItemAtURL_withItemAtURL_backupItemName_options_resultingItemURL_error_(@"replaceItemAtURL_withItemAtURL_backupItemName_options_resultingItemURL_error_",originalItemURL,newItemURL);
    return _NSFileManager_replaceItemAtURL_withItemAtURL_backupItemName_options_resultingItemURL_error_(self,sel,originalItemURL,newItemURL,backupItemName,options,resultingURL,error);
}

#define Function_copyItemAtpathorurl_moveItemAtpathorlurl__________________________
HOOK_MESSAGE(BOOL,NSFileManager,copyItemAtURL_toURL_error_,NSURL  *url,NSURL *destURL,NSError **error)
{
    _LogNSFileManagerCopyItem(@"copyItemAtURL_toURL_error_",url,destURL);
    return _NSFileManager_copyItemAtURL_toURL_error_(self,sel,url,destURL,error);
}

HOOK_MESSAGE(BOOL,NSFileManager,copyItemAtPath_toPath_error_,NSString *srcPath,NSString *dstPath,NSError **error)
{
    _LogNSFileManagerCopyItem(@"copyItemAtPath_toPath_error_",srcPath,dstPath);
    return _NSFileManager_copyItemAtPath_toPath_error_(self,sel,srcPath,dstPath,error);
}


HOOK_MESSAGE(BOOL,NSFileManager,moveItemAtURL_toURL_error_,NSURL *srcURL,NSURL *dstURL,NSError **error)
{
    _LogNSFileManagerCopyItem(@"moveItemAtURL_toURL_error_",srcURL,dstURL);
    return _NSFileManager_moveItemAtURL_toURL_error_(self,sel,srcURL,dstURL,error);
}

HOOK_MESSAGE(BOOL,NSFileManager,moveItemAtPath_toPath_error_,NSString *srcPath,NSString *dstPath,NSError **error)
{
    _LogNSFileManagerCopyItem(@"moveItemAtPath_toPath_error_",srcPath,dstPath);
    return _NSFileManager_moveItemAtPath_toPath_error_(self,sel,srcPath,dstPath,error);
}



/*
 NSFileAppendOnly: 文件是否只读
 NSFileBusy: 文件是否繁忙
 NSFileCreationDate: 文件创建日期
 NSFileOwnerAccountName: 文件所有者的名字
 NSFileGroupOwnerAccountName: 文件所有组的名字
 NSFileDeviceIdentifier: 文件所在驱动器的标示符
 NSFileExtensionHidden: 文件后缀是否隐藏
 NSFileGroupOwnerAccountID: 文件所有组的group ID
 NSFileHFSCreatorCode: 文件的HFS创建者的代码
 NSFileHFSTypeCode: 文件的HFS类型代码
 NSFileImmutable: 文件是否可以改变
 NSFileModificationDate: 文件修改日期
 NSFileOwnerAccountID: 文件所有者的ID
 NSFilePosixPermissions: 文件的Posix权限
 NSFileReferenceCount: 文件的链接数量
 NSFileSize: 文件的字节
 NSFileSystemFileNumber: 文件在文件系统的文件数量
 NSFileType: 文件类型
 NSDirectoryEnumerationSkipsSubdirectoryDescendants: 浅层的枚举，不会枚举子目录
 NSDirectoryEnumerationSkipsPackageDescendants: 不会扫描pakages的内容
 NSDirectoryEnumerationSkipsHiddenFile: 不会扫描隐藏文件
 */
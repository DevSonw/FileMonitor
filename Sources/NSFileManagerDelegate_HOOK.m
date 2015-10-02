//
//  NSFileManagerDelegate_HOOK.m
//  FileMonitor
//
//  Created by panda on 27/7/15.
//
//
HOOK_MESSAGE(BOOL,NSFileManagerDelegate,fileManager_shouldCopyItemAtPath_toPath_,NSFileManager *fileManager,NSString *srcPath,NSString *dstPath)
{
    _LogNSFileManagerDelegate(@"fileManager_shouldCopyItemAtPath_toPath_",srcPath,dstPath);
    return _NSFileManagerDelegate_fileManager_shouldCopyItemAtPath_toPath_(self,sel,fileManager,srcPath,dstPath);
}

HOOK_MESSAGE(BOOL,NSFileManagerDelegate,fileManager_shouldCopyItemAtURL_toURL_,NSFileManager *fileManager,NSURL *srcURL,NSURL *dstURL)
{
    _LogNSFileManagerDelegate(@"fileManager_shouldCopyItemAtURL_toURL_",[srcURL absoluteString],[dstURL absoluteString]);
    return _NSFileManagerDelegate_fileManager_shouldCopyItemAtURL_toURL_(self,sel,fileManager,srcURL,dstURL);
}


HOOK_MESSAGE(BOOL,NSFileManagerDelegate,fileManager_shouldMoveItemAtURL_toURL_,NSFileManager *fileManager,NSString *srcURL,NSString *dstURL)
{
    _LogNSFileManagerDelegate(@"fileManager_shouldMoveItemAtURL_toURL_",srcURL,dstURL);
    return _NSFileManagerDelegate_fileManager_shouldMoveItemAtURL_toURL_(self,sel,fileManager,srcURL,dstURL);
}


HOOK_MESSAGE(BOOL,NSFileManagerDelegate,fileManager_shouldMoveItemAtPath_toPath_,NSFileManager *fileManager,NSString *srcPath,NSString *dstPath)
{
    _LogNSFileManagerDelegate(@"fileManager_shouldMoveItemAtPath_toPath_",srcPath,dstPath);
    return _NSFileManagerDelegate_fileManager_shouldCopyItemAtPath_toPath_(self,sel,fileManager,srcPath,dstPath);
}

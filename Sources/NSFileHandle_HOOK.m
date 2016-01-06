




#import "FileMonTracer.h"
#import "SQLiteStorage.h"

#import "IFHOOK.h"
#ifdef NSFileHandle_IF_HOOK //

// Nice global
extern SQLiteStorage *traceStorage;
extern NSString *objectTypeNotSupported;


HOOK_META(id, NSFileHandle, fileHandleForReadingAtPath_,NSString *path)
{
    id filehandle = _NSFileHandle_fileHandleForReadingAtPath_(self,sel,path);
    
    //    CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSFileHandle" andMethod:@"fileHandleForWritingAtPath:"];
    //    [tracer addArgFromPlistObject:path withKey:@"path"];
    //    [tracer addReturnValueFromPlistObject: objectTypeNotSupported];
    //    [traceStorage saveTracedCall: tracer];
    //    [tracer release];
    if (filehandle) {
        _LogNSFileHandle(@"_NSFileHandle_fileHandleForReadingAtPath_",path);
    }
    return filehandle;
}

HOOK_META(id, NSFileHandle, fileHandleForReadingFromURL_error_,NSURL *url,NSError **error)
{
    id filehandle = _NSFileHandle_fileHandleForReadingFromURL_error_(self,sel,url,error);
    
    //    CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSFileHandle" andMethod:@"fileHandleForWritingAtPath:"];
    //    [tracer addArgFromPlistObject:path withKey:@"path"];
    //    [tracer addReturnValueFromPlistObject: objectTypeNotSupported];
    //    [traceStorage saveTracedCall: tracer];
    //    [tracer release];
    if (filehandle) {
        _LogNSFileHandle(@"_NSFileHandle_fileHandleForReadingFromURL_error_",url);
    }
    
    return filehandle;
}
HOOK_META(id, NSFileHandle, fileHandleForUpdatingAtPath_,NSString* path)
{
    id filehandle = _NSFileHandle_fileHandleForUpdatingAtPath_(self,sel,path);
    
    //    CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSFileHandle" andMethod:@"fileHandleForWritingAtPath:"];
    //    [tracer addArgFromPlistObject:path withKey:@"path"];
    //    [tracer addReturnValueFromPlistObject: objectTypeNotSupported];
    //    [traceStorage saveTracedCall: tracer];
    //    [tracer release];
    if (filehandle) {
        _LogNSFileHandle(@"NSFileHandle_fileHandleForUpdatingAtPath_",path);
    }
    
    return filehandle;
}

HOOK_META(id, NSFileHandle, fileHandleForUpdatingAtPath_error_,NSString* path,NSError **error)
{
    id filehandle = _NSFileHandle_fileHandleForUpdatingAtPath_error_(self,sel,path,error);
    
    //    CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSFileHandle" andMethod:@"fileHandleForWritingAtPath:"];
    //    [tracer addArgFromPlistObject:path withKey:@"path"];
    //    [tracer addReturnValueFromPlistObject: objectTypeNotSupported];
    //    [traceStorage saveTracedCall: tracer];
    //    [tracer release];
    if (filehandle) {
        _LogNSFileHandle(@"_NSFileHandle_fileHandleForUpdatingAtPath_",path);
    }
    
    return filehandle;
}


HOOK_META(id, NSFileHandle, fileHandleForWritingAtPath_,NSString *path)
{
    id filehandle = _NSFileHandle_fileHandleForWritingAtPath_(self,sel,path);
    
    //    CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSFileHandle" andMethod:@"fileHandleForWritingAtPath:"];
    //    [tracer addArgFromPlistObject:path withKey:@"path"];
    //    [tracer addReturnValueFromPlistObject: objectTypeNotSupported];
    //    [traceStorage saveTracedCall: tracer];
    //    [tracer release];
    if (filehandle) {
        _LogNSFileHandle(@"_NSFileHandle_fileHandleForWritingAtPath_",path);
    }
    
    return filehandle;
}

HOOK_META(id, NSFileHandle, fileHandleForWritingToURL_error_,NSURL *url,NSError **error)
{
    id filehandle = _NSFileHandle_fileHandleForWritingToURL_error_(self,sel,url,error);
    
    //    CallTracer *tracer = [[CallTracer alloc] initWithClass:@"NSFileHandle" andMethod:@"fileHandleForWritingAtPath:"];
    //    [tracer addArgFromPlistObject:path withKey:@"path"];
    //    [tracer addReturnValueFromPlistObject: objectTypeNotSupported];
    //    [traceStorage saveTracedCall: tracer];
    //    [tracer release];
    if (filehandle) {
        _LogNSFileHandle(@"NSFileHandle_fileHandleForWritingAtPath_error_",url);
    }
    
    return filehandle;
}


#endif

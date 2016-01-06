#import "sqlite3.h"
#import "substrate.h"


#import "IFHOOK.h"
#ifdef sqlite3_IF_HOOK

//#define DEBUG_INFO   //启动调试信息



//
HOOK_CFUNCTION(const unsigned char *, RTLD_DEFAULT, sqlite3_column_text, sqlite3_stmt* stmt, int iCol)
{
#ifdef DEBUG_INFO
    NSLog(@"~~~~~~~~~~~~~~~~~~~1");
#endif
    const char *str = _sqlite3_column_text(stmt, iCol);
    NSString *data = nil;
    if (str) {
        data = [[NSString alloc] initWithUTF8String:str];
    }
    _Logsqlite3(@"sqlite3_column_text",data);
    return str;
}
////SQLITE_API const unsigned char *sqlite3_column_text(sqlite3_stmt*, int iCol);
//
//
HOOK_CFUNCTION(int, RTLD_DEFAULT, sqlite3_create_function,  sqlite3 *db, const char *zFunctionName, int nArg, int eTextRep, void *pApp, void (*xFunc)(sqlite3_context* context,int,sqlite3_value** value), void (*xStep)(sqlite3_context*,int,sqlite3_value**), void (*xFinal)(sqlite3_context*))
{
#ifdef DEBUG_INFO
    NSLog(@"~~~~~~~~~~~~~~~~~~~15");
#endif
    if ( zFunctionName) {
        NSString*  funcName = [[NSString alloc] initWithFormat:@"%s nArg:%d", zFunctionName,nArg];
        if ([funcName rangeOfString:@"fts3_tokenizer"].location == NSNotFound &&
            [funcName rangeOfString:@"rtreenode"].location == NSNotFound &&
            [funcName rangeOfString:@"rtreedepth"].location == NSNotFound &&
            [funcName rangeOfString:@"NSCoreData"].location == NSNotFound) {
            _Logsqlite3(@"sqlite3_create_function",funcName);
        }
    }
    return _sqlite3_create_function(db,zFunctionName,nArg,eTextRep,pApp,xFunc,xStep,xFinal);
}



HOOK_CFUNCTION(const char *, RTLD_DEFAULT, sqlite3_sql,sqlite3_stmt *pStmt)
{
#ifdef DEBUG_INFO
    NSLog(@"~~~~~~~~~~~~~~~~~~~2");
#endif
    const  char * str = _sqlite3_sql(pStmt);
    NSString *data = nil;
    
    if (str) {
        data = [[NSString alloc] initWithUTF8String:str];
    }
    _Logsqlite3(@"sqlite3_sql",data);
    return str;
}
//SQLITE_API const char *sqlite3_sql(sqlite3_stmt *pStmt);



HOOK_CFUNCTION(int,RTLD_DEFAULT , sqlite3_prepare_v2, sqlite3* db, const char *zSql,int nByte, sqlite3_stmt **ppStmt,const char **pzTail )
{
#ifdef DEBUG_INFO
    NSLog(@"~~~~~~~~~~~~~~~~~~~4");
#endif
    NSString *data = nil;
    if (zSql) {
        data = [[NSString alloc] initWithUTF8String:zSql];
    }
    _Logsqlite3(@"sqlite3_prepare_v2",data);
    return _sqlite3_prepare_v2(db, zSql,nByte,ppStmt,pzTail);
}
//
//
int $sqlite3_open(const char *filename, sqlite3 **ppDb);\
int (*_sqlite3_open)(const char *filename, sqlite3 **ppDb);\
__attribute__((constructor)) void _Init_sqlite3_open() {C_HookFunction((void *)0xFFFFFFFF, "sqlite3_open", (void *)$sqlite3_open, (void **)&_sqlite3_open);}\
int $sqlite3_open(const char *filename, sqlite3 **ppDb)
//HOOK_CFUNCTION(int, (void *)0xFFFFFFFF, sqlite3_open, const char *filename, sqlite3 **ppDb)
{
#ifdef DEBUG_INFO
    NSLog(@"~~~~~~~~~~~~~~~~~~~777");
#endif
    NSString *data = nil;
    if (filename) {
        data = [[NSString alloc] initWithUTF8String:filename];
    }
    _Logsqlite3(@"sqlite3_open",data);
    
    return _sqlite3_open(filename, ppDb);
}


////SQLITE_API int sqlite3_open(
////                            const char *filename,   /* Database filename (UTF-8) */
////                            sqlite3 **ppDb          /* OUT: SQLite db handle */
////);
//

typedef int (*CALLBACK)(void*,int,char**,char**);
HOOK_CFUNCTION(int, (void *)0xFFFFFFFF, sqlite3_exec, sqlite3* database, const char *sql,CALLBACK callback,void *arg, char **errmsg)
{
    //    NSLog(@"~~~~~~~~~~~~~~~~~~~10");
#ifdef DEBUG_INFO
    NSLog(@"~~~~~~~~~~~~~~~~~~~10");
#endif
    
    if (sql) {
        NSString *data = [[NSString alloc] initWithUTF8String:sql];
        if ([data rangeOfString:@"rootpage"].location == NSNotFound) {
            _Logsqlite3(@"sqlite3_exec",data);
        }
    }
    return _sqlite3_exec(database, sql,callback,arg,errmsg);
}


#endif
//SQLITE_API int sqlite3_exec(
//                            sqlite3*,                                  /* An open database */
//                            const char *sql,                           /* SQL to be evaluated */
//                            int (*callback)(void*,int,char**,char**),  /* Callback function */
//                            void *arg,                                 /* 1st argument to callback */
//                            char **errmsg                              /* Error msg written here */
//);


//HOOK_CFUNCTION( const unsigned char *, RTLD_DEFAULT, sqlite3_value_text, sqlite3_value* value)
//{
//#ifdef DEBUG_INFO
//    NSLog(@"~~~~~~~~~~~~~~~~~~~110");
//#endif
//    
//    const unsigned char * tmp = _sqlite3_value_text(value);
//    if (tmp) {
//       NSString* data = [[NSString alloc] initWithFormat:@"%s",tmp];
//        _Logsqlite3(@"sqlite3_value_text", data);
//    }
//    return tmp;
//}
//SQLITE_API const unsigned char *sqlite3_value_text(sqlite3_value *);


/*
 SQLITE_API int sqlite3_create_function(
 sqlite3 *db,
 const char *zFunctionName,
 int nArg,
 int eTextRep,
 void *pApp,
 void (*xFunc)(sqlite3_context*,int,sqlite3_value**),
 void (*xStep)(sqlite3_context*,int,sqlite3_value**),
 void (*xFinal)(sqlite3_context*)
 );
 */
//
//HOOK_CFUNCTION(const unsigned char *, RTLD_DEFAULT, sqlite3_column_blob, sqlite3_stmt* stmt, int iCol)
//{
//#ifdef DEBUG_INFO
//    NSLog(@"~~~~~~~~~~~~~~~~~~~16");
//#endif
//    const char *str = _sqlite3_column_blob(stmt,iCol);
//    NSString *data;
//    if (str) {
//        data = [[NSString alloc] initWithUTF8String:str];
//    }
//    return str;
//}
//SQLITE_API const void *sqlite3_column_blob(sqlite3_stmt*, int iCol);









//HOOK_CFUNCTION(int,  /usr/lib/libsqlite3.dylib, sqlite3_prepare,sqlite3 *db,const char *zSql,int nByte,sqlite3_stmt **ppStmt,const char **pzTail)
//{
//#ifdef DEBUG_INFO
//    NSLog(@"~~~~~~~~~~~~~~~~~~~3");
//#endif
//    NSString *data = nil;
//    if (zSql) {
//        data = [[NSString alloc] initWithUTF8String:zSql];
//    }
//    _Logsqlite3(@"sqlite3_prepare",data);
//    return _sqlite3_prepare(db, zSql,nByte,ppStmt,pzTail);
//}
////SQLITE_API int sqlite3_prepare(
////                               sqlite3 *db,            /* Database handle */
////                               const char *zSql,       /* SQL statement, UTF-8 encoded */
////                               int nByte,              /* Maximum length of zSql in bytes. */
////                               sqlite3_stmt **ppStmt,  /* OUT: Statement handle */
////                               const char **pzTail     /* OUT: Pointer to unused portion of zSql */
////);


//////SQLITE_API int sqlite3_prepare_v2(
//////                                  sqlite3 *db,            /* Database handle */
//////                                  const char *zSql,       /* SQL statement, UTF-8 encoded */
//////                                  int nByte,              /* Maximum length of zSql in bytes. */
//////                                  sqlite3_stmt **ppStmt,  /* OUT: Statement handle */
//////                                  const char **pzTail     /* OUT: Pointer to unused portion of zSql */
//////);
//
//
//HOOK_CFUNCTION(int,/usr/lib/libsqlite3.dylib , sqlite3_prepare16, sqlite3 *db, const void *zSql,int nByte, sqlite3_stmt **ppStmt,const void **pzTail)
//{
//#ifdef DEBUG_INFO
//    NSLog(@"~~~~~~~~~~~~~~~~~~~5");
//#endif
//    NSString *data = nil;
//    if (zSql) {
//        data = [[NSString alloc] initWithUTF8String:zSql];
//    }
//    _Logsqlite3(@"sqlite3_prepare16",data);
//    return _sqlite3_prepare16(db, zSql,nByte,ppStmt,pzTail);
//}
//////SQLITE_API int sqlite3_prepare16(
//////                                 sqlite3 *db,            /* Database handle */
//////                                 const void *zSql,       /* SQL statement, UTF-16 encoded */
//////                                 int nByte,              /* Maximum length of zSql in bytes. */
//////                                 sqlite3_stmt **ppStmt,  /* OUT: Statement handle */
//////                                 const void **pzTail     /* OUT: Pointer to unused portion of zSql */
//////);
//
//
//HOOK_CFUNCTION(int, /usr/lib/libsqlite3.dylib , sqlite3_prepare16_v2, sqlite3 *db,const void *zSql, int nByte, sqlite3_stmt **ppStmt,  const void **pzTail)
//{
//#ifdef DEBUG_INFO
//    NSLog(@"~~~~~~~~~~~~~~~~~~~6");
//#endif
//    NSString *data = nil;
//    if (zSql) {
//        data = [[NSString alloc] initWithUTF8String:zSql];
//    }
//    _Logsqlite3(@"sqlite3_prepare16_v2",data);
//    
//    return _sqlite3_prepare16_v2(db, zSql,nByte,ppStmt,pzTail);
//}
////SQLITE_API int sqlite3_prepare16_v2(
////                                    sqlite3 *db,            /* Database handle */
////                                    const void *zSql,       /* SQL statement, UTF-16 encoded */
////                                    int nByte,              /* Maximum length of zSql in bytes. */
////                                    sqlite3_stmt **ppStmt,  /* OUT: Statement handle */
////                                    const void **pzTail     /* OUT: Pointer to unused portion of zSql */
////);









/*
 int (*old__sqlite3_open)(const char *filename,sqlite3 **ppDb);
 
 int new__sqlite3_open(const char *filename,sqlite3 **ppDb){
 NSLog(@"sqlite3_open hooked");
 old__sqlite3_open(filename,ppDb);
 }
 %ctor {
 @autoreleasepool {
 void *symbol  = dlsym(RTLD_DEFAULT, "sqlite3_open");
 NSLog(@"[+] symbol = 0x%llx",symbol);
 MSHookFunction(symbol, (void *)&new__sqlite3_open, (void**)&old__sqlite3_open);
 }
 }
*/

//HOOK_CFUNCTION(int, (void *)0xFFFFFFFF, sqlite3_open16, const void *filename,sqlite3 **ppDb)
//{
//#ifdef DEBUG_INFO
//    NSLog(@"~~~~~~~~~~~~~~~~~~~8");
//#endif
//    NSString *data = nil;
//    if (filename) {
//    data = [[NSString alloc] initWithUTF8String:filename];
//    }
//    _Logsqlite3(@"sqlite3_open16",data);
//    
//    return _sqlite3_open16(filename, ppDb);
//}
////SQLITE_API int sqlite3_open16(
////                              const void *filename,   /* Database filename (UTF-16) */
////                              sqlite3 **ppDb          /* OUT: SQLite db handle */
////);


//HOOK_CFUNCTION(int, (void *)0xFFFFFFFF, sqlite3_open_v2, const void *filename,sqlite3 **ppDb,int flags,const char *zVfs )
//{
//#ifdef DEBUG_INFO
//    NSLog(@"~~~~~~~~~~~~~~~~~~~9");
//#endif
//    NSString *data = nil;
//    if (filename) {
//        NSString *data = [[NSString alloc] initWithUTF8String:filename];
//    }
//    _Logsqlite3(@"sqlite3_open_v2",data);
//    
//    return _sqlite3_open_v2(filename, ppDb,flags,zVfs);
//}
////SQLITE_API int sqlite3_open_v2(
////                               const char *filename,   /* Database filename (UTF-8) */
////                               sqlite3 **ppDb,         /* OUT: SQLite db handle */
////                               int flags,              /* Flags */
////                               const char *zVfs        /* Name of VFS module to use */
////);



//HOOK_CFUNCTION(int, (void *)0xFFFFFFFF, sqlite3_close,sqlite3 *database)
//{
//#ifdef DEBUG_INFO
//    NSLog(@"~~~~~~~~~~~~~~~~~~~11");
//#endif
//    _Logsqlite3(@"sqlite3_close",@"");
//    return _sqlite3_close(database);
//}
////SQLITE_API int sqlite3_close(sqlite3 *);


//HOOK_CFUNCTION(int, (void *)0xFFFFFFF, sqlite3_reset, sqlite3_stmt *pStmt)
//{
//#ifdef DEBUG_INFO
//    NSLog(@"~~~~~~~~~~~~~~~~~~~13");
//#endif
////        _Logsqlite3(@"sqlite3_reset",@"");
//    return _sqlite3_reset(pStmt);
//}
////SQLITE_API int sqlite3_reset(sqlite3_stmt *pStmt);


//HOOK_CFUNCTION(int, (void *)0xFFFFFFF, sqlite3_step, sqlite3_stmt *pStmt)
//{
//#ifdef DEBUG_INFO
//    NSLog(@"~~~~~~~~~~~~~~~~~~~14");
//#endif
////    _Logsqlite3(@"sqlite3_step",@"");
//    return _sqlite3_step(pStmt);
//}


////SQLITE_API int sqlite3_step(sqlite3_stmt*);



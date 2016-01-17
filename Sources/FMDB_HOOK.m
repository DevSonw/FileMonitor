/*
FMDatabase
 
- (BOOL)open;
 
 
- (BOOL)openWithFlags:(int)flags vfs:(NSString *)vfsName;
 
+ (instancetype)databaseWithPath:(NSString*)inPath;

- (instancetype)initWithPath:(NSString*)inPath;

- (FMResultSet *)executeQuery:(NSString *)sql 
         withArgumentsInArray:(NSArray*)arrayArgs
                 orDictionary:(NSDictionary *)dictionaryArgs
                     orVAList:(va_list)args;
 
- (BOOL)executeUpdate:(NSString*)sql 
                error:(NSError**)outErr 
 withArgumentsInArray:(NSArray*)arrayArgs
         orDictionary:(NSDictionary *)dictionaryArgs orVAList:(va_list)args;
 
- (BOOL)executeStatements:(NSString *)sql withResultBlock:(FMDBExecuteStatementsCallbackBlock)block
 */

#import "IFHOOK.h"
#import "FMDatabase.h"

#ifdef FMDB_IF_HOOK

HOOK_MESSAGE(BOOL,FMDatabase,open)
{
    BOOL flag = _FMDatabase_open(self,sel);
    
    if (flag) {
        NSString *open_file = [NSString stringWithFormat:@"%s",[self databasePath]];
        NSDictionary *dic0 = [NSDictionary dictionaryWithObject:open_file forKey:@"open_file_name"];
        NSDictionary *dic = [NSDictionary dictionaryWithObject:dic0 forKey:@"_FMDatabase_open"];
        _LogFMDB(dic,@"_FMDatabase_open");
    }
    return flag;
}

HOOK_MESSAGE(BOOL,FMDatabase,openWithFlags_,int flags)
{
    BOOL flag = _FMDatabase_openWithFlags_(self,sel,flag);
    
    if (flag) {
        NSString *open_file = [NSString stringWithFormat:@"%s",[self databasePath]];
        NSDictionary *dic0 = [NSDictionary dictionaryWithObjectsAndKeys:open_file,@"open_file_name",nil];
        NSDictionary *dic = [NSDictionary dictionaryWithObject:dic0 forKey:@"_FMDatabase_openWithFlags_vfs_"];
        _LogFMDB(dic,@"_FMDatabase_openWithFlags_vfs_");
    }
    return flag;
}

HOOK_META(id,FMDatabase,databaseWithPath_,NSString *inPath)
{
    id tmp = _FMDatabase_databaseWithPath_(self,sel,inPath);

    if (tmp) {
        NSString *open_file = [NSString stringWithString:inPath];
        NSDictionary *dic0 = [NSDictionary dictionaryWithObjectsAndKeys:open_file,@"open_file_name",nil];
        NSDictionary *dic = [NSDictionary dictionaryWithObject:dic0 forKey:@"_FMDatabase_databaseWithPath_"];
        _LogFMDB(dic,@"_FMDatabase_databaseWithPath_");
    }
    return tmp;
}

HOOK_MESSAGE(id, FMDatabase, initWithPath_,NSString*inPath)
{
    id tmp = _FMDatabase_initWithPath_(self,sel,inPath);
    
    if (tmp) {
        NSString *open_file = [NSString stringWithString:inPath];
        NSDictionary *dic0 = [NSDictionary dictionaryWithObjectsAndKeys:open_file,@"open_file_name",nil];
        NSDictionary *dic = [NSDictionary dictionaryWithObject:dic0 forKey:@"_FMDatabase_initWithPath_"];
        _LogFMDB(dic,@"_FMDatabase_initWithPath_");
    }
    return tmp;
}
HOOK_MESSAGE(FMResultSet *,FMDatabase,executeQuery_withArgumentsInArray_orDictionary_orVAList_,NSString *sql, NSArray* arrayArgs,NSDictionary *dictionaryArgs,va_list args)
{
    id tmpset = _FMDatabase_executeQuery_withArgumentsInArray_orDictionary_orVAList_(self,sel,sql,arrayArgs,dictionaryArgs,args);
    
    if (tmpset) {
        NSDictionary *sqldic = [NSDictionary dictionaryWithObjectsAndKeys:sql,@"sql_name",nil];
        NSDictionary *dic    = [NSDictionary dictionaryWithObject:sqldic
                                                           forKey:@"_FMDatabase_executeQuery_withArgumentsInArray_orDictionary_orVAList_"];
        _LogFMDB(dic,@"_FMDatabase_executeQuery_withArgumentsInArray_orDictionary_orVAList_");
    }
    return tmpset;
}
HOOK_MESSAGE(BOOL,FMDatabase,executeUpdate_error_withArgumentsInArray_orDictionary_orVAList_,NSString *sql,NSError**outErr , NSArray* arrayArgs,NSDictionary *dictionaryArgs,va_list args)
{
    BOOL flag = _FMDatabase_executeUpdate_error_withArgumentsInArray_orDictionary_orVAList_(self,sel,sql,outErr,arrayArgs,dictionaryArgs,args);
    
    if (flag) {
        NSDictionary *sqldic = [NSDictionary dictionaryWithObjectsAndKeys:sql,@"sql_name",nil];
        NSDictionary *dic = [NSDictionary dictionaryWithObject:sqldic
                                                        forKey:@"_FMDatabase_executeUpdate_error_withArgumentsInArray_orDictionary_orVAList_"];
        _LogFMDB(dic,@"_FMDatabase_executeUpdate_error_withArgumentsInArray_orDictionary_orVAList_");
    }
    return flag;
}

HOOK_MESSAGE(BOOL,FMDatabase,executeStatements_withResultBlock_,NSString *sql,FMDBExecuteStatementsCallbackBlock block)
{
    BOOL flag = _FMDatabase_executeStatements_withResultBlock_(self,sel,sql,block);
    
    if (flag) {
        NSDictionary *sqldic = [NSDictionary dictionaryWithObjectsAndKeys:sql,@"sql_name",nil];
        NSDictionary *dic = [NSDictionary dictionaryWithObject:sqldic
                                                        forKey:@"_FMDatabase_executeStatements_withResultBlock_"];
        
        _LogFMDB(dic,@"_FMDatabase_executeStatements_withResultBlock_");
    }
    return flag;
}

#endif


























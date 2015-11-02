


/*
 - (NSString *)localizedStringForKey:(NSString *)key
 value:(NSString *)value
 table:(NSString *)tableName
 */
HOOK_MESSAGE(NSString*,NSBundle,localizedStringForKey_value_table_,NSString *key,NSString *value,NSString *tableName)
{
    NSString *str = _NSBundle_localizedStringForKey_value_table_(self,sel,key,value,tableName);
    NSArray *array = [NSArray arrayWithObjects:key,value,nil];
    _LoginitWithContentsOffileorurl(@"localizedStringForKey_value_table_",str,array);
    
    return str;
}

//- (NSString *)pathForAuxiliaryExecutable:(NSString *)executableName
HOOK_MESSAGE(NSString*,NSBundle,pathForAuxiliaryExecutable_,NSString *executableName)
{
    NSString *str = _NSBundle_pathForAuxiliaryExecutable_(self,sel,executableName);
    _LoginitWithContentsOffileorurl(@"pathForAuxiliaryExecutable",str,executableName);
    return str;
}

//- (NSURL *)URLForAuxiliaryExecutable:(NSString *)executableName
HOOK_MESSAGE(NSURL*,NSBundle,URLForAuxiliaryExecutable_,NSString *executableName)
{
    NSURL *url = _NSBundle_URLForAuxiliaryExecutable_(self,sel,executableName);
    _LoginitWithContentsOffileorurl(@"URLForAuxiliaryExecutable_",url,executableName);
    return url;
}

//- (id)objectForInfoDictionaryKey:(NSString *)key
HOOK_MESSAGE(id,NSBundle,objectForInfoDictionaryKey_,NSString *key)
{
    id data = _NSBundle_objectForInfoDictionaryKey_(self,sel,key);
    _LoginitWithContentsOffileorurl(@"objectForInfoDictionaryKey_",data,key);
    return data;
}

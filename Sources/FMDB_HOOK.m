/*
JSONDecoder
 
 JKParseOptionNone                     = 0,
 JKParseOptionStrict                   = 0,
 JKParseOptionComments                 = (1 << 0),
 JKParseOptionUnicodeNewlines          = (1 << 1),
 JKParseOptionLooseUnicode             = (1 << 2),
 JKParseOptionPermitTextAfterValidJSON = (1 << 3),
 JKParseOptionValidFlags               = (JKParseOptionComments | JKParseOptionUnicodeNewlines | JKParseOptionLooseUnicode | JKParseOptionPermitTextAfterValidJSON),
 
 NSData
 - (id)objectFromJSONDataWithParseOptions:(JKParseOptionFlags)parseOptionFlags error:(NSError **)error
 
 NSString
 - (id)objectFromJSONStringWithParseOptions:(JKParseOptionFlags)parseOptionFlags error:(NSError **)error
 */

#import "IFHOOK.h"

#ifdef JSONKit_IF_HOOK
//解密
HOOK_MESSAGE(id,NSData,objectFromJSONDataWithParseOptions_error_,JKParseOptionFlags parseOptionFlags,NSError **error)
{
    id tmp = _NSData_objectFromJSONDataWithParseOptions_error_(self,sel,parseOptionFlags,error);

    if (tmp != nil &&self != nil) {
        _LogNSJSONSerialization(@"JSONLit_objectFromJSONDataWithParseOptions_error_",self,tmp);
    }
    return tmp;
}

//解密
HOOK_MESSAGE(id,NSString,objectFromJSONStringWithParseOptions_error_,JKParseOptionFlags parseOptionFlags,NSError **error)
{
    id tmp = _NSString_objectFromJSONStringWithParseOptions_error_(self,sel,parseOptionFlags,error);

    if (tmp != nil &&self != nil) {
        _LogNSJSONSerialization(@"JSONLit_objectFromJSONStringWithParseOptions_error_",self,tmp);
    }
    return tmp;
}
#endif

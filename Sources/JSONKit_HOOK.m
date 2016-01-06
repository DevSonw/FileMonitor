/*
 enum {
 NSJSONReadingMutableContainers = (1UL << 0),
 NSJSONReadingMutableLeaves = (1UL << 1),
 NSJSONReadingAllowFragments = (1UL << 2)
 };
 typedef NSUInteger NSJSONReadingOptions;
 
 
 + (id)JSONObjectWithData:(NSData *)data
 options:(NSJSONReadingOptions)opt
 error:(NSError **)error
 
 + (id)JSONObjectWithStream:(NSInputStream *)stream
 options:(NSJSONReadingOptions)opt
 error:(NSError **)error
 
 + (NSData *)dataWithJSONObject:(id)obj
 options:(NSJSONWritingOptions)opt
 error:(NSError **)error
 
 + (NSInteger)writeJSONObject:(id)obj
 toStream:(NSOutputStream *)stream
 options:(NSJSONWritingOptions)opt
 error:(NSError **)error
 */
HOOK_META(id,NSJSONSerialization,JSONObjectWithData_options_error_,NSData *data,NSJSONWritingOptions opt,NSError ** error)
{
    id tmp = _NSJSONSerialization_JSONObjectWithData_options_error_(nil,sel,data,opt,error);
    if (tmp != nil &&data != nil) {
        _LogNSJSONSerialization(@"JSONObjectWithData_options_error_",tmp,data);
    }
    return tmp;
}

//HOOK_MESSAGE(id,NSJSONSerialization,JSONObjectWithStream_options_error_,NSInputStream *stream,NSJSONWritingOptions opt,NSError ** error)
//{
//    id tmp = _NSJSONSerialization_JSONObjectWithStream_options_error_(nil,sel,stream,opt,error);
//    if (tmp != nil && stream != nil) {
//        _LogNSJSONSerialization(@"JSONObjectWithStream_options_error_",tmp,stream);
//    }
//    return tmp;
//}

HOOK_META(NSData *,NSJSONSerialization,dataWithJSONObject_options_error_,id obj,NSJSONWritingOptions opt,NSError ** error)
{
    NSData * tmp = _NSJSONSerialization_dataWithJSONObject_options_error_(nil,sel,obj,opt,error);
    if (tmp != nil && obj != nil) {
        _LogNSJSONSerialization(@"dataWithJSONObject_options_error_",tmp,obj);
    }
    return tmp;
}

//HOOK_MESSAGE(NSInteger,NSJSONSerialization,writeJSONObject_toStream_options_error_,id obj,NSOutputStream *stream,NSJSONWritingOptions opt,NSError ** error)
//{
//    NSInteger tmp = _NSJSONSerialization_writeJSONObject_toStream_options_error_(nil,sel,obj,stream,opt,error);
//    
//       if (tmp != nil && obj != nil) {
//            _LogNSJSONSerialization(@"writeJSONObject_toStream_options_error_",tmp,obj);
//        }
//    return tmp;
//}

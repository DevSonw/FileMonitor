#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

/*
 extern unsigned char *
 CC_MD5(const void *data, CC_LONG len, unsigned char *md);
 */
//HOOK_CFUNCTION(unsigned char *, (void *)0xFFFFFFFF, CC_MD5,const void *data, CC_LONG len, unsigned char *result)
//{
//    //data 输入  len 长度   result 输出
//    unsigned char * ret = _CC_MD5(data,len,result);
//    if (len) {
//        NSString *NS_data =[NSString stringWithFormat:@"%s",data];
//
//        NSString *NS_result =  [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",\
//         result[0], result[1], result[2], result[3],\
//         result[4], result[5], result[6], result[7],\
//         result[8], result[9], result[10], result[11],\
//         result[12], result[13], result[14], result[15]\
//         ];
//        if ([NS_data isEqualToString:@"MGCopyAnswerDeviceClassNumber"] || [NS_data isEqualToString:@"MGCopyAnswerUIParallaxCapability"]  || \
//            [NS_data isEqualToString:@"MGCopyAnswerRegionalBehaviorGB18030"] || [NS_data isEqualToString:@"MGCopyAnswerHasInternalSettingsBundle"] ||  \
//           [NS_data isEqualToString:@"MGCopyAnswerReleaseType"]) {
//            
//        }
//        else
//            _LogHash(@"CC_MD5",NS_data,NS_result);
//    }
//    return ret;
//}
//
//
//HOOK_CFUNCTION(unsigned char *, (void *)0xFFFFFFFF, CC_SHA1,const void *data, CC_LONG len, unsigned char *result)
//{
////    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
////    NSData *data = [NSData dataWithBytes:cstr length:self.length];
////    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
////    CC_SHA1(data.bytes, data.length, digest);
////    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
////    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
////        [output appendFormat:@"%02x", digest[i]];
////    return output;
//    
//    unsigned char* ret =  _CC_SHA1(data,len,result);
//    
//    if (len)
//        {
//            NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
////                for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
////                    [output appendFormat:@"%02x", md[i]];
//            NSString *NS_result =  [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",\
//                                    result[0], result[1], result[2], result[3],\
//                                    result[4], result[5], result[6], result[7],\
//                                    result[8], result[9], result[10], result[11],\
//                                    result[12], result[13], result[14], result[15],\
//                                    result[16], result[17], result[18], result[19]
//                                    ];
//            NSString *NS_data =[NSString stringWithFormat:@"%s",data];
//            _LogHash(@"CC_SHA1",NS_data,NS_result);
//        }
//    
//    return ret;
//}

//extern void * dlopen(const char * __path, int __mode);
//extern void * dlsym(void * __handle, const char * __symbol);

#define PRINT_DATA(mode,funcname,pathordata) NSLog(@"---FileMonitor---%@ : %@ : %@",mode,funcname,pathordata);


HOOK_FUNCTION(const char *, (void *)0xFFFFFFFF, dlopen,const char *  __path,int __mode)
{
    const char * addr_Module = _dlopen(__path,__mode);
    
//#define RTLD_LAZY	0x1
//#define RTLD_NOW	0x2
//#define RTLD_LOCAL	0x4
//#define RTLD_GLOBAL	0x8
    NSString *mode = nil;
    switch(__mode)
    {
        case 1:
            mode = @"RTLD_LAZY";
            break;
        case 2:
            mode = @"RTLD_NOW";
            break;
        case 3:
            mode = @"RTLD_LAZY|RTLD_NOW";
            break;
        case 4:
            mode = @"RTLD_LOCAL";
            break;
        case 5:
            mode = @"RTLD_LAZY|RTLD_LOCAL";
            break;
        case 6:
            mode = @"RTLD_NOW|RTLD_LOCAL";
            break;
        case 7:
            mode = @"RTLD_LAZY|RTLD_NOW|RTLD_LOCAL";
            break;
        case 8:
            mode = @"RTLD_GLOBAL";
            break;
        case 9:
            mode = @"RTLD_LAZY|RTLD_GLOBAL";
            break;
    }
    NSDictionary *dict = [NSDictionary dictionaryWithObject:__path forKey:mode];
    NSString *module =  [NSString stringWithFormat:@"0x%x",addr_Module];
    
     NSDictionary *dict2 = [NSDictionary dictionaryWithObject:module forKey:dict];
    PRINT_DATA(@"PrivateAPI",@"dlopen",dict2);
    
    return addr_Module;
}

HOOK_FUNCTION(const char *, (void *)0xFFFFFFFF, dlsym,void * __handle, const char * __symbol)
{
    const char * addr_func =  _dlsym(__handle,__symbol);
    
    const char * addr_Module = (const char * )__handle;
    
    NSString *module =  [NSString stringWithFormat:@"0x%x",addr_Module];
    NSString *FuncNmae = [NSString stringWithFormat:@"%s",__symbol];
    
     NSDictionary *dict = [NSDictionary dictionaryWithObject:module forKey:FuncNmae];
    PRINT_DATA(@"PrivateAPI",@"dlsym",dict);
    
    return addr_func;
}

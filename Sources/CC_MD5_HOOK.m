#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

/*
 extern unsigned char *
 CC_MD5(const void *data, CC_LONG len, unsigned char *md);
 */
HOOK_CFUNCTION(unsigned char *, (void *)0xFFFFFFFF, CC_MD5,const void *data, CC_LONG len, unsigned char *result)
{
    //data 输入  len 长度   result 输出
    unsigned char * ret = _CC_MD5(data,len,result);
    if (len) {
        NSString *NS_data =[NSString stringWithFormat:@"%s",data];

        NSString *NS_result =  [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",\
         result[0], result[1], result[2], result[3],\
         result[4], result[5], result[6], result[7],\
         result[8], result[9], result[10], result[11],\
         result[12], result[13], result[14], result[15]\
         ];
        if ([NS_data isEqualToString:@"MGCopyAnswerDeviceClassNumber"] || [NS_data isEqualToString:@"MGCopyAnswerUIParallaxCapability"]  || \
            [NS_data isEqualToString:@"MGCopyAnswerRegionalBehaviorGB18030"] || [NS_data isEqualToString:@"MGCopyAnswerHasInternalSettingsBundle"] ||  \
           [NS_data isEqualToString:@"MGCopyAnswerReleaseType"]) {
            
        }
        else
            _Logmd5(@"CC_MD5",NS_data,NS_result);
    }
    return ret;
}
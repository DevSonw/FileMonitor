
////
//HOOK_FUNCTION(void, /System/Library/Frameworks/CoreFoundation.framework/CoreFoundation, CFNotificationCenterPostNotification,
//			  CFNotificationCenterRef center,
//			  CFStringRef name,
//			  const void *object,
//			  CFDictionaryRef userInfo,
//			  Boolean deliverImmediately
//			  )
//{
//	//_Log(@"~_~3:%s: %@, %@, %@, object: %@, userInfo:%@, deliverImmediately:%d", __FUNCTION__, [NSThread callStackSymbols], center, name, object, userInfo, deliverImmediately);
//	return _CFNotificationCenterPostNotification(center, name, object, userInfo, deliverImmediately);
//}
//
////
//HOOK_FUNCTION(SInt32, /System/Library/Frameworks/CoreFoundation.framework/CoreFoundation, CFMessagePortSendRequest, CFMessagePortRef remote, SInt32 msgid, CFDataRef data, CFTimeInterval sendTimeout, CFTimeInterval rcvTimeout, CFStringRef replyMode, CFDataRef *returnData)
//{
//	//_Log(@"~_~4: %s: %@", __FUNCTION__, CFMessagePortGetName(remote));
//	return _CFMessagePortSendRequest(remote, msgid, data, sendTimeout, rcvTimeout, replyMode, returnData);
//}
//
////
//HOOK_MESSAGE(id, CPDistributedMessagingCenter, sendMessageAndReceiveReplyName_userInfo_, id a1, id a2)
//{
//	//_Log(@"~_~5：%s:%@, %@", __FUNCTION__, a1, a2);
//	return _CPDistributedMessagingCenter_sendMessageAndReceiveReplyName_userInfo_(self, sel, a1, a2);
//}
//
////
//HOOK_MESSAGE(void, NSNotificationCenter, postNotificationName_object_userInfo_, id a1, id a2, id a3)
//{
//	//_Log(@"~_~6：%s:%@, %@, %@", __FUNCTION__, a1, a2, a3);
//	_NSNotificationCenter_postNotificationName_object_userInfo_(self, sel, a1, a2, a3);
//}
//
////
//HOOK_MESSAGE(void, NSNotificationCenter, postNotificationName_object_, id a1, id a2)
//{
//	//_Log(@"~_~7：%s:%@, %@", __FUNCTION__, a1, a2);
//	_NSNotificationCenter_postNotificationName_object_(self, sel, a1, a2);
//}
//
////

HOOK_FUNCTION(OSStatus, /System/Library/Frameworks/Security.framework/Security, SecItemCopyMatching, CFNotificationCenterRef query, CFTypeRef *result)
{

    if ((NSMutableDictionary*)query) {
        _LogKeychainFunc(@"SecItemCopyMatching_",(NSMutableDictionary*)query);
    }
	return _SecItemCopyMatching(query, result);
}
//OSStatus SecItemCopyMatching ( CFDictionaryRef query, CFTypeRef *result );

HOOK_FUNCTION(OSStatus, /System/Library/Frameworks/Security.framework/Security, SecItemAdd, CFDictionaryRef attributes, CFTypeRef *result)
{

    if ((NSMutableDictionary*)attributes) {
        _LogKeychainFunc(@"SecItemAdd_",(NSMutableDictionary*)attributes);
    }
    return _SecItemAdd(attributes, result);
}
//OSStatus SecItemAdd ( CFDictionaryRef attributes, CFTypeRef *result );

HOOK_FUNCTION(OSStatus, /System/Library/Frameworks/Security.framework/Security, SecItemUpdate, CFDictionaryRef query, CFDictionaryRef attributesToUpdate)
{

    if ((NSMutableDictionary*)query || (NSMutableDictionary*)attributesToUpdate ) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:query forKey:attributesToUpdate];
        _LogKeychainFunc(@"SecItemUpdate_",dic);
    }
    return _SecItemUpdate(query, attributesToUpdate);
}
//OSStatus SecItemUpdate ( CFDictionaryRef query, CFDictionaryRef attributesToUpdate );

HOOK_FUNCTION(OSStatus, /System/Library/Frameworks/Security.framework/Security, SecItemDelete, CFDictionaryRef query)
{
    if ((NSMutableDictionary*)query) {
        _LogKeychainFunc(@"SecItemDelete_",(NSMutableDictionary*)query);
    }
    return _SecItemDelete(query);
}
//OSStatus SecItemDelete ( CFDictionaryRef query );
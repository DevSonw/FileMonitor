
#import <dlfcn.h>
#import "HookUtil.h"
#import <substrate.h>


//my~~~~~~
void C_HookFunction(const char *lib, const char *fun, void *hook, void **old)
{
    void *symbol = dlsym((void *)0xFFFFFFFF, fun);
    if (!symbol) {
        symbol = dlsym(RTLD_DEFAULT, fun);
        NSLog(@"RTLD_DEFAULT get symbol");
    }
    if (symbol ==nil) {
        NSLog(@"fun = %s   nil",fun);
    }
    static void (*_MSHookFunction)(void *symbol, void *hook, void **old) = NULL;
    if (_MSHookFunction == NULL)
    {
        _MSHookFunction = dlsym(dlopen("/Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate", RTLD_LAZY), "MSHookFunction");
    }
    //
    if (_MSHookFunction)
    {
        NSLog(@"CHooking name = %s",      fun);
        NSLog(@"CHooking symbol = 0x%llx",symbol);
        NSLog(@"CHooking old = 0x%llx",   old);
        _MSHookFunction(symbol, hook, old);
//        MSHookFunction(symbol, hook, old);
    }
    else
    {
        *old = NULL;
    }
}


//
void _HookFunction(const char *lib, const char *fun, void *hook, void **old)
{
	void *symbol = dlsym(dlopen(lib, RTLD_LAZY), fun);
    
    if (symbol ==nil) {
        NSLog(@"fun = %s   nil",fun);
    }

	static void (*_MSHookFunction)(void *symbol, void *hook, void **old) = NULL;
	if (_MSHookFunction == NULL)
	{
		_MSHookFunction = dlsym(dlopen("/Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate", RTLD_LAZY), "MSHookFunction");
	}

	//
	if (_MSHookFunction)
	{
        NSLog(@"Hooking name =   %s",      fun);
        NSLog(@"Hooking symbol = 0x%llx",symbol);
        NSLog(@"Hooking old =    0x%llx",   old);
        _MSHookFunction(symbol, hook, old);
//        MSHookFunction(symbol, hook, old);
    }
	else
	{
		*old = NULL;
	}
}

//
void _HookMessage(Class cls, const char *msg, void *hook, void **old)
{
    //
    char name[1024];
    int i = 0;
    do
    {
        name[i] = (msg[i] == '_') ? ':' : msg[i];
    }
    while (msg[i++]);
    
    
//    printf("name = %s",name);
//     NSLog(@"cls = %s",(char*)class_getName(name));
    
    SEL sel = sel_registerName(name);
    
    
//    NSLog(@"name = %s",name);
    //
    static void (*_MSHookMessageEx)(Class cls, SEL sel, void *hook, void **old) = NULL;
    if (_MSHookMessageEx == nil)
    {
        _MSHookMessageEx = dlsym(dlopen("/Library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate", RTLD_LAZY), "MSHookMessageEx");
    }
    
    //
    if (_MSHookMessageEx)
    {
        NSLog(@"Hooking class = %s name = %s",class_getName (cls),name);
        _MSHookMessageEx(cls, sel, hook, old);
        
    }
    else
    {
        NSLog(@"hook method_setImplementation ~");
        *old = method_setImplementation(class_getInstanceMethod(cls, sel), hook);
    }
//    NSLog(@"name = %s  over",name);
}







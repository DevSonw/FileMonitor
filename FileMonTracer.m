#import "FileMonTracer.h"
#import "SQLiteStorage.h"
#import "PlistObjectConverter.h"



@implementation FileMonTracer
@synthesize args;
@synthesize Behavior;
@synthesize className_methodName;
@synthesize argsAndReturnValue;

//LoadFile
//Encrypt
//Ddecrypt
//Json
//WriteData
//sqlite3
//Hash


- (FileMonTracer*)initWithClass:(NSString *)clazz andMethod:(NSString *)meth andBehavior:(NSString *)behavior{
	/* initialize the call tracer with class and method names */
	self = [super init];
	args = [[NSMutableDictionary alloc] init];
    className_methodName = [NSString stringWithFormat:@"%@_%@",clazz,meth];
	argsAndReturnValue = [[NSMutableDictionary alloc] init];
    Behavior = [NSString stringWithFormat:@"%@",behavior];
	[argsAndReturnValue setValue:args forKey:@"arguments"];
	return self;
}


- (void) addArgFromPlistObject:(id) arg withKey:(NSString *)key {
	if(arg == nil) {
		[args setValue:[PlistObjectConverter getSerializedNilValue] forKey:key];
	} 
	else {
		[args setValue:arg forKey:key];
	}
}


- (void) addReturnValueFromPlistObject:(id) result {
	if(result == nil) {
		[argsAndReturnValue setValue:[PlistObjectConverter getSerializedNilValue] forKey:@"returnValue"];
	}
	else {
		[argsAndReturnValue setValue:result forKey:@"returnValue"];
	}
}


- (NSData *) serializeArgsAndReturnValue {
    NSError *error;
    NSData *plist = [NSPropertyListSerialization dataWithPropertyList:(id)argsAndReturnValue
                                                               format:NSPropertyListXMLFormat_v1_0 
                                                              options:0
                                                                error:&error];
    return plist;
}


- (void)dealloc
{
	[args release];
	[argsAndReturnValue release];
	[className_methodName release];
	[super dealloc];
}

@end


@interface FileMonTracer: NSObject {
	int CountRank;
    NSString *Behavior;
    NSMutableDictionary* args;
    NSString* className_methodName;
    NSDictionary *argsAndReturnValue;
}

//CREATE TABLE FileMon (CountRank INTEGER,Behavior TEXT, className_methodName TEXT, argumentsAndReturnValueDict TEXT)";

@property (retain) NSString *Behavior;
@property (retain) NSDictionary *args;
@property (retain) NSString *className_methodName;
@property (retain) NSDictionary *argsAndReturnValue;

- (FileMonTracer*)initWithClass:(NSString *)clazz andMethod:(NSString *)meth andBehavior:(NSString *)behavior;

// Plist objects are string, number, boolean, date, data, dictionary and array.
- (void) addArgFromPlistObject:(id) arg withKey:(NSString *)key;
- (void) addReturnValueFromPlistObject:(id) result;

- (NSData *) serializeArgsAndReturnValue;


@end

#import <Foundation/Foundation.h>

@interface Constants : NSObject

extern NSString *const kCurrentLanguage;

+ (NSArray *) getGenders;
+ (NSArray *) getRaces;
+ (NSArray *) getPerfis;
@end

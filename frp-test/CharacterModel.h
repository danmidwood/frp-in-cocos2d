#import <Foundation/Foundation.h>

@class CCScheduler;

@interface CharacterModel : NSObject
@property(nonatomic, retain) CCScheduler *scheduler;
@property(nonatomic, retain) NSValue *playerLocation;
@property(nonatomic, retain) NSValue *scale;
@end
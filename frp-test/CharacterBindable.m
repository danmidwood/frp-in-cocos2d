#import <ReactiveCocoa/ReactiveCocoa/RACSignal.h>
#import <ReactiveCocoa/ReactiveCocoa/NSObject+RACPropertySubscribing.h>
#import <cocos2d/Support/CGPointExtension.h>
#import "CharacterModel.h"
#import "CCNode.h"


@implementation CCNode (CharacterBindable)

- (void)bind:(CharacterModel *)model {

  model.scale = [NSValue valueWithCGPoint:ccp([self scaleX], [self scaleY])];
  [RACObserve(self, scheduler)
    subscribeNext:^(CCScheduler *newScheduler) {
      model.scheduler = newScheduler;
    }];


  [RACObserve(model, playerLocation)
    subscribeNext:^(NSValue *newLocation) {
      CGPoint nextLocation;
      [newLocation getValue:&nextLocation];
      [self setPosition:nextLocation];
    }];

  [RACObserve(model, scale)
    subscribeNext:^(NSValue *newScale) {
      CGPoint scale;
      [newScale getValue:&scale];
      [self setScaleX:scale.x];
      [self setScaleY:scale.y];
    }];


}
@end
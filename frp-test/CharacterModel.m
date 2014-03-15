#import <cocos2d/CCSprite.h>
#import <cocos2d/Support/CGPointExtension.h>
#import <cocos2d/ccDeprecated.h>
#import "CharacterModel.h"


@implementation CharacterModel {
}
- (void)dealloc {
  [super dealloc];
}

- (void)setScheduler:(CCScheduler *)scheduler1 {
  _scheduler = scheduler1;
  [_scheduler scheduleSelector:@selector(upX) forTarget:self interval:(float) drand48() / 20 paused:NO];
  [_scheduler scheduleSelector:@selector(upY) forTarget:self interval:(float) drand48() / 20 paused:NO];
}


- (void)upX {
  CGPoint oldScale;
  [self.scale getValue:&oldScale];
  if (oldScale.x > 2) {
    [_scheduler unscheduleSelector:@selector(upX) forTarget:self];
    [_scheduler scheduleSelector:@selector(downX) forTarget:self interval:(float) drand48() / 20 paused:NO];
  }
  CGPoint newScale = ccp(oldScale.x + 0.02, oldScale.y);
  self.scale = [NSValue valueWithCGPoint:newScale];
}

- (void)downX {
  CGPoint oldScale;
  [self.scale getValue:&oldScale];
  if (oldScale.x < 1) {
    [_scheduler unscheduleSelector:@selector(downX) forTarget:self];
    [_scheduler scheduleSelector:@selector(upX) forTarget:self interval:(float) drand48() / 20 paused:NO];
  }
  CGPoint newScale = ccp(oldScale.x - 0.02, oldScale.y);
  self.scale = [NSValue valueWithCGPoint:newScale];
}

- (void)upY {
  CGPoint oldScale;
  [self.scale getValue:&oldScale];
  if (oldScale.y > 2) {
    [_scheduler unscheduleSelector:@selector(upY) forTarget:self];
    [_scheduler scheduleSelector:@selector(downY) forTarget:self interval:(float) drand48() / 20 paused:NO];
  }
  CGPoint newScale = ccp(oldScale.x, oldScale.y + .02);
  self.scale = [NSValue valueWithCGPoint:newScale];
}

- (void)downY {
  CGPoint oldScale;
  [self.scale getValue:&oldScale];
  if (oldScale.y < 1) {
    [_scheduler unscheduleSelector:@selector(downY) forTarget:self];
    [_scheduler scheduleSelector:@selector(upY) forTarget:self interval:(float) drand48() / 20 paused:NO];
  }
  CGPoint newScale = ccp(oldScale.x, oldScale.y - .02);
  self.scale = [NSValue valueWithCGPoint:newScale];
}


@end
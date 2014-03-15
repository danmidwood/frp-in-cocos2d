#import <cocos2d/Support/CGPointExtension.h>
#import "GameLayer.h"
#import "CCScene.h"
#import "CCSprite.h"
#import "CharacterModel.h"
#import "CCDirector.h"
#import "CCDirectorIOS.h"
#import "CCTouchDispatcher.h"
#import "CharacterBindable.h"


@implementation GameLayer {
}

+ (CCScene *)scene {
  CCScene *scene = [CCScene node];
  GameLayer *layer = [GameLayer node];
  [scene addChild:layer];
  return scene;
}

- (id)init {
  if ((self = [super init])) {
    [self setIsTouchEnabled:TRUE];
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];

    self.model = [[[CharacterModel alloc] init] autorelease];
    CCSprite *player = [[[CCSprite alloc] initWithFile:@"Icon.png"] autorelease];
    [player bind:self.model];

    [self addChild:player z:1];

    self.model.playerLocation = [NSValue valueWithCGPoint:ccp(
    [[CCDirector sharedDirector] winSize].width / 2,
    [[CCDirector sharedDirector] winSize].height / 2
    )];
    self.model.scale = [NSValue valueWithCGPoint:ccp(1, 1)];
  }
  return self;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
  CGPoint location = [touch locationInView:[touch view]];
  location = [[CCDirector sharedDirector] convertToGL:location];
  self.model.playerLocation = [NSValue valueWithCGPoint:location];
  return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
  CGPoint location = [touch locationInView:[touch view]];
  location = [[CCDirector sharedDirector] convertToGL:location];
  self.model.playerLocation = [NSValue valueWithCGPoint:location];
}

- (void)dealloc {
  [self.model release];
  [super dealloc];
}

@end

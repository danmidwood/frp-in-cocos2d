#import "WelcomeScreenLayer.h"
#import "AppDelegate.h"
#import "GameLayer.h"

@implementation WelcomeScreenLayer

+ (CCScene *)scene {
  CCScene *scene = [CCScene node];
  WelcomeScreenLayer *layer = [WelcomeScreenLayer node];
  [scene addChild:layer];
  return scene;
}

- (id)init {
  if ((self = [super init])) {
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"Cocos FRP" fontName:@"Marker Felt" fontSize:64];
    CGSize size = [[CCDirector sharedDirector] winSize];
    label.position = ccp( size.width / 2, size.height / 2 );
    [self addChild:label];
    [CCMenuItemFont setFontSize:28];
    CCMenuItem *play = [CCMenuItemFont itemWithString:@"Play!" block:^(id sender) {
      [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameLayer scene] withColor:ccWHITE]];
    }];
    CCMenu *menu = [CCMenu menuWithItems:play, nil];
    [menu alignItemsHorizontallyWithPadding:20];
    [menu setPosition:ccp( size.width / 2, size.height / 2 - 50)];
    [self addChild:menu];
  }
  return self;
}

// on "dealloc" you need to release all your retained objects
- (void)dealloc {
  // in case you have something to dealloc, do it in this method
  // in this particular example nothing needs to be released.
  // cocos2d will automatically release all the children (Label)

  // don't forget to call "super dealloc"
  [super dealloc];
}

#pragma mark GameKit delegate

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController {
  AppController *app = (AppController *) [[UIApplication sharedApplication] delegate];
  [[app navController] dismissModalViewControllerAnimated:YES];
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController {
  AppController *app = (AppController *) [[UIApplication sharedApplication] delegate];
  [[app navController] dismissModalViewControllerAnimated:YES];
}
@end

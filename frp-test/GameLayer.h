//
//  Scene.h
//  frp-test
//
//  Created by Dan Midwood on 05/05/2013.
//
//

#import <Foundation/Foundation.h>
#import "CCLayer.h"

@class CCScene;
@class CCSprite;
@class CharacterModel;

@interface GameLayer : CCLayer


@property(nonatomic, retain) CharacterModel *model;

+ (CCScene *)scene;


@end

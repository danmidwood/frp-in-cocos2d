#import <Foundation/Foundation.h>
#import <cocos2d/CCSprite.h>

@class CharacterModel;


@interface CCNode (CharacterBindable)
- (id)bind:(CharacterModel *)model;
@end


Reactive Cocos2d - a demo
=========================

This project shows a simple demo of Functional Reactive Programming with [Reactive Cocoa](https://github.com/ReactiveCocoa/ReactiveCocoa) in the [Cocos2d](http://www.cocos2d-iphone.org/) game engine.

Pero, this is not a game :)

## Get the demo and play along

The demo dependencies are managed using [Cocoa Pods](http://cocoapods.org/), follow the install instruction on the website if you don't have it already.

```shell
git clone https://github.com/darkesttimeline/frp-in-cocos2d.git
cd frp-in-cocos2d
pod install
```

## From the inside out

### Character Model

`CharacterModel` is a simple class, containing three properties

```objective-c
// CharacterModel.h
@interface CharacterModel : NSObject
@property(nonatomic, retain) CCScheduler *scheduler;
@property(nonatomic, retain) NSValue *playerLocation;
@property(nonatomic, retain) NSValue *scale;
@end
```

The scheduler is a cocos2d scheduler and allows the model to transform itself.

```objective-c
// CharacterModel.m
- (void)setScheduler:(CCScheduler *)scheduler1 {
  _scheduler = scheduler1;
  [_scheduler scheduleSelector:@selector(upX) forTarget:self interval:(float) drand48() / 20 paused:NO];
  [_scheduler scheduleSelector:@selector(upY) forTarget:self interval:(float) drand48() / 20 paused:NO];
}
```

`upX` and `upY` are both functions that change the value in `scale`. We'll return to them later.

### Character Bindable

`CharacterBindable` is a category that attaches itself to Cocos2d's `Node` object, adding a `bind` function.

The `bind` function takes in a model and attaches itself as a listen to the `scale` and `playerLocation` fields, it also adds a listener to it's own scheduler in order to populate the scheduler on the model.

```objective-c
// CharacterBindable.m
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
```

Now, any updates to the model's scale or position will be relfected in the image on screen.


### Putting it all together, a.k.a the Game Layer

The `GameLayer` object sets everything up.

```objective-c
self.model = [[[CharacterModel alloc] init] autorelease];
CCSprite *player = [[[CCSprite alloc] initWithFile:@"Icon.png"] autorelease];
[player bind:self.model];

[self addChild:player z:1];

self.model.playerLocation = [NSValue valueWithCGPoint:ccp(
  [[CCDirector sharedDirector] winSize].width / 2,
  [[CCDirector sharedDirector] winSize].height / 2
)];
self.model.scale = [NSValue valueWithCGPoint:ccp(1, 1)];
```

Here you can see that the Model is created and a `CCSprite` is created, and then the sprite is bound to the model and then added to the screen. The model location is set to the centre of the screen and the scale set to *1 on each dimension.

On the screen, that will be displayed as a single Cocos icon on a black screen.

![The Cocos 2d icon displayed in the centre of the screen](https://raw.github.com/darkesttimeline/frp-in-cocos2d/master/doc/start.png "Cocos Icon in the centre of the screen")


> There are other layers in the code, for this demo you can ignore them.

After the init block, the game layer goes on to implement touch handlers, updating the model's location based on where you have touched.

```objective-c
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
```

### And back to the model one last time

Earlier I mentioned the model's `upX` and `upY` methods. These methods increase the scale on the x and y dimensions up to a point, and then schedule alternative functions (`downX` and `downY`) to reduce it back down to 1. And then the cycle repeats.

That code is less important for this demo so I'm not going to reproduce it, but you can read it [in the repo](https://github.com/darkesttimeline/frp-in-cocos2d/blob/master/frp-test/CharacterModel.m#L20-L62).

## Wrap up

Running the app, the scaling will stretch the icon on the screen like so,

![The Cocos 2d icon stretching](https://raw.github.com/darkesttimeline/frp-in-cocos2d/master/doc/scale.gif "The Cocos 2d icon stretching")

And any touches on the screen will be followed by the icon,

![The Cocos 2d icon following touches](https://raw.github.com/darkesttimeline/frp-in-cocos2d/master/doc/touch.gif "The Cocos 2d icon following touches")


## More information

If you have any questions, I'm [@djmidwood](https://twitter.com/djmidwood) on Twitter.

## License

The MIT License (MIT)

Copyright (c) 2014 Dan Midwood

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

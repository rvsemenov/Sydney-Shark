//
//  GameScene.m
//  SydneyShark
//
//  Created by Roman on 7/26/13.
//  Copyright 2013 Roman. All rights reserved.
//

#import "GameScene.h"


@implementation GameScene

#pragma mark -
#pragma mark init metods
+ (CCScene *) scene
{
	CCScene *scene = [CCScene node];
	GameScene *layer = [GameScene node];
	[scene addChild: layer];
	return scene;
}

- (id)init
{
    if (self = [super init])
    {
        self.touchEnabled = YES;
        [self addBackground];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"GameObjectsSpriteSheet.plist"];
        m_objectBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"GameObjectsSpriteSheet.pvr.gz"];
        [self addChild:m_objectBatchNode];
        
        [self addShark];
    }
    return self;
}

- (void) onEnter
{
    [super onEnter];
    [self scheduleUpdate];
}
#pragma mark -
#pragma mark update

- (void) update:(ccTime)delta
{
    if (m_shark.position.y > m_heightOfSee){
        m_shark.inWater = NO;
    }else
        m_shark.inWater = YES;
    
}
#pragma mark -
#pragma mark add Objects

- (void) addBackground
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    CCSprite *sky = [CCSprite spriteWithFile:@"sky.png"];
    sky.scaleX = screenSize.width / sky.boundingBox.size.width;
    sky.anchorPoint = ccp(0, 1);
    sky.position = ccp(0, screenSize.height);
    [self addChild:sky];
    
    CCSprite *see = [CCSprite spriteWithFile:@"water.png"];
    see.scaleX = screenSize.width / see.boundingBox.size.width;
    see.anchorPoint = CGPointZero;
    see.position = CGPointZero;
    [self addChild:see];
    m_heightOfSee = see.boundingBox.size.height;
}

- (void) addShark
{
    m_shark = [Shark shark];
    [m_objectBatchNode addChild:m_shark];
}

#pragma mark -
#pragma mark Touches
- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView: [touch view]];
    location = [[CCDirector sharedDirector] convertToUI:location];
    m_shark.targetPoint = location;
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView: [touch view]];
    location = [[CCDirector sharedDirector] convertToUI:location];
    m_shark.targetPoint = location;
}
@end

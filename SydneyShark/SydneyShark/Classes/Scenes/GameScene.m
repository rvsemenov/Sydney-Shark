//
//  GameScene.m
//  SydneyShark
//
//  Created by Roman on 7/26/13.
//  Copyright 2013 Roman. All rights reserved.
//

#import "GameScene.h"
#import "Fish.h"
#import "Bird.h"
#import "GameOver.h"

#define speedShark 200
#define gameTime 60

@implementation GameScene

#pragma mark -
#pragma mark init and dealloc metods 
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
        m_gameTime = 0.0f;
        m_score = 0;
        [self addBackground];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"GameObjectsSpriteSheet.plist"];
        m_objectBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"GameObjectsSpriteSheet.pvr.gz"];
        [self addChild:m_objectBatchNode z:3];
        
        m_bonuses = [[CCArray alloc] init];
        m_bonusesToDelete = [[CCArray alloc] init];
        [self addShark];
        [self addGameObjects];
        [self addHUDLayer];
    }
    return self;
}

- (void) dealloc
{
    [m_gameObjects removeAllObjects];
    [m_gameObjects release];
    
    [m_bonuses removeAllObjects];
    [m_bonuses release];
    
    [m_bonusesToDelete release];
    [super dealloc];
}

- (void) onEnter
{
    [super onEnter];
    [self scheduleUpdate];
    [self schedule:@selector(spawnBonus) interval:0.2];
}
#pragma mark -
#pragma mark onther
- (CCNode*) getRandomObject
{
    int rand = arc4random() % m_gameObjects.count;
    CCNode *node = [m_gameObjects objectAtIndex:rand];
    if (node.visible)
        node = [self getRandomObject];
    
    return node;
}

-(ccColor3B)randomColor
{
    float r = arc4random() % 255;
    float g = arc4random() % 255;
    float b = arc4random() % 255;
    return ccc3(r,g,b);
}

#pragma mark -
#pragma mark update
- (void) spawnBonus
{
    if ((arc4random() % 100) < 20)
    {
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        CCSprite *sprite = (CCSprite*)[self getRandomObject];
        CGFloat height = sprite.boundingBox.size.height;
        CGFloat posY;
        if ([sprite isKindOfClass:[Fish class]])
        {
            posY = height/2 + arc4random() % (int)(m_heightOfSee - height);
        }else if ([sprite isKindOfClass:[Bird class]]){
            CGFloat heightOfSky = screenSize.height - m_heightOfSee;
            posY = m_heightOfSee + height/2 + arc4random() % (int)(heightOfSky - height);
        }
        sprite.color = [self randomColor];
        sprite.position = ccp(screenSize.width + sprite.boundingBox.size.width, posY);
        sprite.visible = YES;
        [m_bonuses addObject:sprite];
    }
}

- (void) update:(ccTime)delta
{
    if (m_shark.position.y > m_heightOfSee){
        if (!m_shark.inWater)
        {
            m_bubbles.position = m_shark.position;
            m_bubbles.speed = -m_shark.speedY * 14;
            m_bubbles.speedVar = -m_shark.speedY * 7;
            [m_bubbles resetSystem];
        }
        m_shark.inWater = NO;
    }else
        m_shark.inWater = YES;
    
    CCNode *bonus;
    CCARRAY_FOREACH(m_bonuses, bonus)
    {
        bonus.position = ccpAdd(bonus.position, ccp(-speedShark * delta, 0));
        if (bonus.position.x + bonus.boundingBox.size.width < 0)
            [m_bonusesToDelete addObject:bonus];

        if (CGRectContainsPoint([m_shark collisionRect], bonus.position))
        {
            [m_bonusesToDelete addObject:bonus];
            m_score++;
            [m_hudLayer updateScore:m_score];
        }
    }

    CCARRAY_FOREACH(m_bonusesToDelete, bonus)
    {
        bonus.visible = NO;
        [m_bonuses removeObject:bonus];
    }
    [m_bonusesToDelete removeAllObjects];
    
    m_gameTime += delta;
    CGFloat timeToEnd = gameTime - m_gameTime;
    if (timeToEnd > 0)
    {
        [m_hudLayer updateTime:timeToEnd];
    }else
        [self gameOver];
    
}
#pragma mark -
#pragma mark add Objects

- (void) addBackground
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    CCSprite *see = [CCSprite spriteWithFile:@"water.png"];
    see.scaleX = screenSize.width / see.boundingBox.size.width;
    see.anchorPoint = CGPointZero;
    see.position = CGPointZero;
    [self addChild:see];
    
    m_bubbles = [CCParticleSystemQuad particleWithFile:@"bubbles.plist"];
    [self addChild:m_bubbles];
    m_heightOfSee = see.boundingBox.size.height;
    
    CCSprite *sky = [CCSprite spriteWithFile:@"sky.png"];
    sky.scaleX = screenSize.width / sky.boundingBox.size.width;
    sky.anchorPoint = ccp(0, 1);
    sky.position = ccp(0, screenSize.height);
    [self addChild:sky z:2];
}

- (void) addShark
{
    m_shark = [Shark shark];
    [m_objectBatchNode addChild:m_shark z:2];
}

- (void) addGameObjects
{
    m_gameObjects = [[CCArray alloc] initWithCapacity:12];
    for (int i = 0; i < FISH_TYPE_MAX * 3; i++)
    {
        Fish *fish = [Fish fishWithType:i];
        [m_gameObjects addObject:fish];
        [m_objectBatchNode addChild:fish];
    }
    
    for (int i = 0; i < 3; i++)
    {
        Bird *bird = [Bird bird];
        [m_gameObjects addObject:bird];
        [m_objectBatchNode addChild:bird];
    }
}

- (void) addHUDLayer
{
    m_hudLayer = [HUDLayer node];
    [m_hudLayer updateTime:gameTime];
    [m_hudLayer updateScore:m_score];
    [self addChild:m_hudLayer z:5];
}

- (void) gameOver
{
    [self unscheduleAllSelectors];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameOver sceneWithScore:m_score]]];
}

#pragma mark -
#pragma mark Touches
- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView: [touch view]];
    location = [[CCDirector sharedDirector] convertToUI:location];
    if (location.x > m_shark.position.x) 
        m_shark.targetPoint = location;
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView: [touch view]];
    location = [[CCDirector sharedDirector] convertToUI:location];
    if (location.x > m_shark.position.x)
        m_shark.targetPoint = location;
}
@end

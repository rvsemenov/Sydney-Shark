//
//  GameScene.m
//  SydneyShark
//
//  Created by Roman on 7/26/13.
//  Copyright 2013 Roman. All rights reserved.
//

#import "GameScene.h"
#import "Fish.h"

#define speed 60
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
        [self addChild:m_objectBatchNode];
        
        m_bonuses = [[CCArray alloc] init];
        m_bonusesToDelete = [[CCArray alloc] init];
        [self addShark];
        [self addFishes];
        [self addHUDLayer];
    }
    return self;
}

- (void) dealloc
{
    [m_fishes removeAllObjects];
    [m_fishes release];
    
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
- (Fish*) getRandomFish
{
    //TODO: fish may end
    int rand = arc4random() % m_fishes.count;
    Fish *fish = [m_fishes objectAtIndex:rand];
    if (fish.visible)
        fish = [self getRandomFish];
    
    return fish;
}

#pragma mark -
#pragma mark update
- (void) spawnBonus
{
    if ((arc4random() % 100) < 20)
    {
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        Fish *fish = [self getRandomFish];
        CGFloat height = fish.boundingBox.size.height;
        CGFloat posY = height/2 + arc4random() % (int)(m_heightOfSee - height);
        
        fish.position = ccp(screenSize.width * 0.9, posY);
        fish.visible = YES;
        [m_bonuses addObject:fish];
    }
}

- (void) update:(ccTime)delta
{
    if (m_shark.position.y > m_heightOfSee){
        m_shark.inWater = NO;
    }else
        m_shark.inWater = YES;
    
    CCNode *bonus;
    CCARRAY_FOREACH(m_bonuses, bonus)
    {
        bonus.position = ccpAdd(bonus.position, ccp(-speed * delta, 0));
        if (bonus.position.x + bonus.boundingBox.size.width < 0)
            [m_bonusesToDelete addObject:bonus];

        if (CGRectContainsPoint(m_shark.boundingBox, bonus.position))
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
    [m_hudLayer updateTime:gameTime - m_gameTime];
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
    [m_objectBatchNode addChild:m_shark z:2];
}

- (void) addFishes
{
    m_fishes = [[CCArray alloc] initWithCapacity:12];
    for (int i = 0; i < FISH_TYPE_MAX * 3; i++)
    {
        Fish *fish = [Fish fishWithType:i];
        [m_fishes addObject:fish];
        [m_objectBatchNode addChild:fish];
    }
}

- (void) addHUDLayer
{
    m_hudLayer = [HUDLayer node];
    [m_hudLayer updateTime:gameTime];
    [m_hudLayer updateScore:m_score];
    [self addChild:m_hudLayer];
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

//
//  GameScene.h
//  SydneyShark
//
//  Created by Roman on 7/26/13.
//  Copyright 2013 Roman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Shark.h"
#import "HUDLayer.h"

@interface GameScene : CCLayer {
    NSInteger m_score;
    CGFloat m_gameTime;
    CCArray *m_gameObjects;
    CCArray *m_bonuses;
    CCArray *m_bonusesToDelete;
    CCSpriteBatchNode *m_objectBatchNode;
    Shark *m_shark;
    CGFloat m_heightOfSee;
    HUDLayer *m_hudLayer;
}
+(CCScene *) scene;
@end

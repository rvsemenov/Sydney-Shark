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

@interface GameScene : CCLayer {
    CCArray *m_fishes;
    CCSpriteBatchNode *m_objectBatchNode;
    Shark *m_shark;
    CGFloat m_heightOfSee;
}
+(CCScene *) scene;
@end

//
//  Shark.h
//  SydneyShark
//
//  Created by Roman on 7/26/13.
//  Copyright 2013 Roman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Shark : CCSprite {
    CGFloat m_speedY;
    CGFloat m_deltaAngle;
}
@property (nonatomic, assign) CGPoint targetPoint;
@property (nonatomic, assign) BOOL inWater;
+ (Shark*) shark;
@end

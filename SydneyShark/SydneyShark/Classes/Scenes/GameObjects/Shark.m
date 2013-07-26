//
//  Shark.m
//  SydneyShark
//
//  Created by Roman on 7/26/13.
//  Copyright 2013 Roman. All rights reserved.
//

#import "Shark.h"


@implementation Shark
@synthesize targetPoint;
@synthesize inWater;

+ (Shark*) shark
{
    return [[[Shark alloc] init] autorelease];
}

- (id)init
{
    if (self = [super initWithSpriteFrameName:@"shark.png"])
    {
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        self.position = ccp(screenSize.width * 0.15, screenSize.height / 2);
        self.targetPoint = ccp(screenSize.width / 2, screenSize.height / 2);
        m_speedY = 0;
        self.inWater = YES;
        [self scheduleUpdate];
    }
    return self;
}

- (void) update:(ccTime)delta
{
    if (self.inWater)
    {
        CGFloat distance = (self.position.y - self.targetPoint.y) / 10;
        distance = min(distance, 15);
        m_speedY -= distance * delta;
    }else
        m_speedY -= 12 * delta;
 
    m_speedY *= 0.97;
    CGFloat newYpos = self.position.y + m_speedY;
    newYpos = max(newYpos, self.boundingBox.size.height/4);
    self.position = ccp(self.position.x, newYpos);
    
    [self setRotation:self.rotation + m_deltaAngle * delta * 2];
    [self updateDeltaAngle];
}

- (void) updateDeltaAngle
{
    CGFloat finishAngle = -CC_RADIANS_TO_DEGREES(ccpToAngle(ccpSub(self.targetPoint, self.position)));
    
    if (self.rotation > 0)
        self.rotation = fmodf(self.rotation, 360.0f);
    else
        self.rotation = fmodf(self.rotation, -360.0f);
    
    m_deltaAngle = finishAngle - self.rotation;
    if (m_deltaAngle > 180)
        m_deltaAngle -= 360;
    if (m_deltaAngle < -180)
        m_deltaAngle += 360;
}

- (CGRect) collisionRect
{
    return CGRectMake(self.boundingBox.origin.x + self.boundingBox.size.width/2,
                      self.boundingBox.origin.y + self.boundingBox.size.height * 0.3,
                      self.boundingBox.size.width/2,
                      self.boundingBox.size.height * 0.6);
}
@end

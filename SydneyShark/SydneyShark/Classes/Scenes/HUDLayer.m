//
//  HUDLayer.m
//  SydneyShark
//
//  Created by Roman on 7/26/13.
//  Copyright 2013 Roman. All rights reserved.
//

#import "HUDLayer.h"


@implementation HUDLayer

- (id)init
{
    if (self = [super init])
    {
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        m_timeLabel = [CCLabelBMFont labelWithString:@"" fntFile:@"MyFont.fnt"];
        m_timeLabel.position = ccp(screenSize.width / 2, screenSize.height * 0.95);
        [self addChild:m_timeLabel];
        
        m_scoreLabel = [CCLabelBMFont labelWithString:@"" fntFile:@"MyFont.fnt"];
        m_scoreLabel.position = ccp(screenSize.width * 0.85, screenSize.height * 0.95);
        [self addChild:m_scoreLabel];
    }
    return self;
}

- (void) updateTime:(CGFloat) time
{
    int minutes = time / 60;
    int seconds = (int)time % 60;
    m_timeLabel.string = [NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
}

- (void) updateScore:(NSInteger) score
{
    m_scoreLabel.string = [NSString stringWithFormat:@"s:%02d",score];
}
@end

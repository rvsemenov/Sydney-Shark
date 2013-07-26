//
//  Shark.m
//  SydneyShark
//
//  Created by Roman on 7/26/13.
//  Copyright 2013 Roman. All rights reserved.
//

#import "Shark.h"


@implementation Shark

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
    }
    return self;
}
@end

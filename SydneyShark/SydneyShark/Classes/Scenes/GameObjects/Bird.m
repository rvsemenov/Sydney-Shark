//
//  Bird.m
//  SydneyShark
//
//  Created by Roman on 7/26/13.
//  Copyright 2013 Roman. All rights reserved.
//

#import "Bird.h"


@implementation Bird

+ (Bird*) bird
{
    return [[[self alloc] init] autorelease];
}

- (id)init
{
    if (self = [super initWithSpriteFrameName:@"bird.png"])
    {
        [self setVisible:NO];
    }
    return self;
}
@end

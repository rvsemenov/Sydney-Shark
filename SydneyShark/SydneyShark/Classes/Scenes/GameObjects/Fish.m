//
//  Fish.m
//  SydneyShark
//
//  Created by Roman on 7/26/13.
//  Copyright 2013 Roman. All rights reserved.
//

#import "Fish.h"


@implementation Fish
+ (Fish*) fishWithType:(FISH_TYPE) type
{
    return [[[Fish alloc] initWithType:type] autorelease];
}

- (id)initWithType:(FISH_TYPE) type
{
    if (type >= FISH_TYPE_MAX)
        type = type % FISH_TYPE_MAX;
    
    NSString *name = [NSString stringWithFormat:@"fish_%02d.png",type];
    if (self = [super initWithSpriteFrameName:name])
    {
        [self setVisible:NO];
    }
    return self;
}
@end

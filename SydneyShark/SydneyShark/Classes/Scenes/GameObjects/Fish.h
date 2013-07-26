//
//  Fish.h
//  SydneyShark
//
//  Created by Roman on 7/26/13.
//  Copyright 2013 Roman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum
{
	FISH_TYPE_ONE = 0,
	FISH_TYPE_TWO,
    FISH_TYPE_THREE,
    FISH_TYPE_FOUR,
    FISH_TYPE_FIVE,
    FISH_TYPE_SIX,
    
    FISH_TYPE_MAX,
} FISH_TYPE;

@interface Fish : CCSprite {
    
}
+ (Fish*) fishWithType:(FISH_TYPE) type;
@end

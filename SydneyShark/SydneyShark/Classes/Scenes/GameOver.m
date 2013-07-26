//
//  GameOver.m
//  SydneyShark
//
//  Created by Roman on 7/26/13.
//  Copyright 2013 Roman. All rights reserved.
//

#import "GameOver.h"
#import "GameScene.h"

@implementation GameOver
+ (CCScene*) sceneWithScore:(NSInteger) score
{
	CCScene *scene = [CCScene node];
	GameOver *layer = [[[GameOver alloc] initWithScore:score] autorelease];
	[scene addChild: layer];
	return scene;
}

- (id)initWithScore:(NSInteger) score
{
    if (self = [super init])
    {
        CCLayerGradient *background = [CCLayerGradient layerWithColor:ccc4(127, 218, 235, 255) fadingTo:ccc4(40, 105, 167, 255)];
        [self addChild:background];
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        NSString *scoreString = [NSString stringWithFormat:@"your score = %d",score];
        CCLabelBMFont *scoreLabel = [CCLabelBMFont labelWithString:scoreString fntFile:@"MyFont.fnt"];
        scoreLabel.position = ccp(screenSize.width / 2, screenSize.height * 0.6);
        [self addChild:scoreLabel];
        

        CCLabelBMFont *playAgain = [CCLabelBMFont labelWithString:@"play again" fntFile:@"MyFont.fnt"];
        CCMenuItemLabel *playAgainItem = [CCMenuItemLabel itemWithLabel:playAgain
                                                                 target:self
                                                               selector:@selector(playAgain)];
        playAgainItem.position = ccp(screenSize.width / 2, screenSize.height * 0.3);
        
        CCMenu *menu = [CCMenu menuWithItems:playAgainItem, nil];
        menu.position = CGPointZero;
        [self addChild:menu];
    }
    return self;
}

- (void) playAgain
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[GameScene scene]]];
}
@end

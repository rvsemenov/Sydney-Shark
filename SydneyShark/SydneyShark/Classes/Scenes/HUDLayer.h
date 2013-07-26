//
//  HUDLayer.h
//  SydneyShark
//
//  Created by Roman on 7/26/13.
//  Copyright 2013 Roman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface HUDLayer : CCLayer {
    CCLabelBMFont *m_timeLabel;
    CCLabelBMFont *m_scoreLabel;
}
- (void) updateTime:(CGFloat) time;
- (void) updateScore:(NSInteger) score;
@end

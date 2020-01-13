//
//  TouchLayer.h
//  DSYE
//
//  Created by DS2 on 13-1-27.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLayer.h"
@interface TouchLayer : CCLayer{
    //TODO:: need to download a bitmapFont
    CCLabelBMFont *theLabel;
    CGPoint screenCenter;
    GameLayer *gameLayer;
    CGSize screenSize;
    Boolean lowerLeftOn;
    Boolean upperLeftOn;
    Boolean lowerRightOn;
    Boolean upperRightOn;
}
@property GameLayer *gameLayer;
@end

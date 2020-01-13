//
//  menu.m
//  DSYE2
//
//  Created by DS2 on 13-1-29.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "menu.h"
#import "GameLayer.h"
#import "option.h"


@implementation menu
+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	menu *layer = [menu node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init{
    self=[super init];
    if(self){
        //creat menue background
        //CCSprite *a = [CCSprite spriteWithFile:@"Space.png"];
        //a.anchorPoint = CGPointZero;
        //[self addChild:a z:0 tag:1];
        
        //add menu
        [CCMenuItemFont setFontSize:25];
        CCMenuItem *newGame=[CCMenuItemFont itemWithString:@"New Game" target:self selector:@selector(newGame:)];
        CCMenuItem *option = [CCMenuItemFont itemWithString:@"Option" target:self selector:@selector(Option:)];
        CCMenu *mn = [CCMenu menuWithItems:newGame,option,nil];
        [mn alignItemsVertically];
        [self addChild:mn z:1 tag:2];
        
        
        
        
    }
    return self;
    
    
}


- (void) newGame:(id) sender
{
    //	CCScene *sc = [CCScene node];
    //	[sc addChild:[GameLayer node]];
	CCLOG((@"newGame"));
	[[CCDirector sharedDirector] replaceScene: [CCTransitionCrossFade transitionWithDuration:1.2f scene:[GameLayer scene]]];
	
}

- (void) Option:(id) sender{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:1.2f scene:[option scene]]];
}
- (void) dealloc
{
	[super dealloc];
}
@end






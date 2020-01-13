//
//  gameOverLayer.m
//  DSYE2
//
//  Created by DSLee on 13-4-27.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "gameOverLayer.h"
#import "menu.h"
#import "GameLayer.h"
#import "HudLayer.h"

@implementation gameOverLayer
static int theScore;
+(id) scene:(int)score
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
    theScore = score;
	// 'layer' is an autorelease object.
	gameOverLayer *layer = [gameOverLayer node];
	
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
        
        CCMenuItem *newGame=[CCMenuItemFont itemWithString:@"Play Again?" target:self selector:@selector(newGame:)];
        CCMenuItem *menuButton = [CCMenuItemFont itemWithString:@"Main Menu" target:self selector:@selector(returnToMenu)];
        CCMenu *mn = [CCMenu menuWithItems:newGame,menuButton,nil];
        [mn alignItemsVertically];
        [self addChild:mn z:1 tag:2];
        
        //score
    
        scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Marker Felt" fontSize:24];
        [scoreLabel setString:[NSString stringWithFormat:@"Score: %i", theScore]];
        scoreLabel.position = ccp(240, 260);
        [self addChild:scoreLabel z:2];
        
            
        
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

-(void) returnToMenu
{
    //Return to menu
    //    CCLayer *menuLayer =[[[menu alloc]init ]autorelease];
    //    [self.parent addChild:menuLayer z:10];
    //    [CCDirector sharedDirector] re
    
    //[self.parent removeChildByTag:kTagGameLayer cleanup:true];
    //[self.parent removeChildByTag:kTagHudLayer cleanup:true];
    //[self.parent removeChildByTag:kTagTouchLayer cleanup:true];
    //[self.parent removeChild:self cleanup:TRUE];
    //    [[CCTouchDispatcher sharedDispatcher] removeAllDelegates];
    [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:1.0 scene:[menu scene] withColor:ccWHITE]];
    [[CCDirector sharedDirector] resume];
    
    //[[CCDirector sharedDirector] stopAnimation];
    
}



@end










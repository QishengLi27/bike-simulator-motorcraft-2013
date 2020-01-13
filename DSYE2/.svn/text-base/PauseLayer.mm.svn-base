//
//  PauseLayer.m
//  DSYE2
//
//  Created by DS2 on 13-3-25.
//
//

#import "PauseLayer.h"

@implementation PauseLayer

-(id) init
{
	if( (self=[super initWithColor:ccc4(150,50,50,255)])) {
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        self.isTouchEnabled = YES;
        
        //HudLayer *gameHUD;
        //gameHUD = [HudLayer sharedHUD];
        
        
        
        CCMenuItem *replayButton=[CCMenuItemFont itemWithString:@"Contiune" target:self selector:@selector(continueLevel)];
        CCMenuItem *menuButton = [CCMenuItemFont itemWithString:@"Main Menu" target:self selector:@selector(returnToMenu)];
        CCMenu *menu;
        
        //replayButton = [CCMenuItemImage itemFromNormalImage:@"Buy.png" selectedImage:@"Buy.png" target:self selector:@selector(continueLevel)];
        
        //menuButton = [CCMenuItemImage itemFromNormalImage:@"Cancel.png" selectedImage:@"Cancel.png" target:self selector:@selector(returnToMenu)];
        menu = [CCMenu menuWithItems: replayButton, menuButton, nil];
        
		menu.position = ccp((winSize.width/2 + 50), (winSize.height/2-22));
		[menu alignItemsVerticallyWithPadding: 5.0f];
		[self addChild:menu];
        
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
        
	}
	return self;
}

-(void) continueLevel
{
    //Replay Game
    GameLayer* theGameLayer = [self.parent getChildByTag: kTagGameLayer];
    [theGameLayer scheduleUpdate];
    [self.parent removeChild:self cleanup:TRUE];
    [[CCDirector sharedDirector] resume];
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

-(void)dealloc
{
    [super dealloc];
}

@end


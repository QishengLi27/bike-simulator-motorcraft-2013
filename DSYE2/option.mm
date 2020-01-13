//
//  option.m
//  DSYE2
//
//  Created by DS2 on 13-1-29.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "option.h"
#import "menu.h"

@implementation option

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	option *layer = [option node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init{
    self=[super init];
    if(self){
        //CCSprite *a = [CCSprite spriteWithFile:@"Space.png"];
        //a.anchorPoint = CGPointZero;
        //[self addChild:a z:0 tag:1];
 
        CCMenuItemFont *title1 = [CCMenuItemFont itemWithString: @"音效"];
        [title1 setIsEnabled:NO];
        
        //add menu
        [CCMenuItemFont setFontSize:25];
        CCMenuItem *back=[CCMenuItemFont itemWithString:@"Back" target:self selector:@selector(back)];
        
        CCMenu *mn = [CCMenu menuWithItems:back,nil];
        [mn alignItemsVertically];
        [self addChild:mn z:1 tag:2];

    }
        return self;
    
}

-(void) back
{
    //Return to menu
    //    CCLayer *menuLayer =[[[menu alloc]init ]autorelease];
    //    [self.parent addChild:menuLayer z:10];
    //    [CCDirector sharedDirector] re
        [[CCDirector sharedDirector] replaceScene: [CCTransitionFade transitionWithDuration:1.0 scene:[menu scene] withColor:ccWHITE]];
    [[CCDirector sharedDirector] resume];
    
    //[[CCDirector sharedDirector] stopAnimation];
    
}

- (void) dealloc
{
	[super dealloc];
}


@end

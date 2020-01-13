//
//  TouchLayer.m
//  DSYE
//
//  Created by DS2 on 13-1-27.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "TouchLayer.h"
#import "GameLayer.h"

@implementation TouchLayer
@synthesize gameLayer;
-(id) init{
    lowerLeftOn = false;
    lowerRightOn = false;
    upperLeftOn = false;
    upperRightOn = false;
    screenSize= [[CCDirector sharedDirector] winSize];
    if(self = [super init]){
        self.isTouchEnabled = YES;
    }
return  self;
}

//-(void) onEnter{
//    [super onEnter];
//    [[[CCDirector sharedDirector] touchDispatcher] addStandardDelegate:self priority:1];
//}
//-(void) onExit{
//    [super onExit];
//    [[[CCDirector sharedDirector]touchDispatcher] removeDelegate:self];
//}

-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    CCLOG(@"Touch received");
    for (UITouch *currentTouch in touches) {
        CGPoint touchLoc= [currentTouch locationInView:[currentTouch view]];
        CCLOG(@"%0.2f,%0.2f", touchLoc.x, touchLoc.y);
        CCLOG(@"%0.2f,%0.2f", screenSize.width/2, screenSize.height/2);
        if( touchLoc.x < screenSize.width/2){
            if(touchLoc.y < screenSize.height/2){
                //turn on front engine backward
                lowerLeftOn = true;
                [gameLayer frontEngineOn];
            }else{
                upperLeftOn = true;
                [gameLayer rearEngineOn];
                //turn on rear engine forward
            }
        }else if(touchLoc.x> screenSize.width/2){
            if(touchLoc.y < screenSize.height/2){
                lowerRightOn = true;
                [gameLayer dash];
                //pitch up
            }else{
                upperRightOn = true;
                [gameLayer jump];
                //pitch down
            }
        }
    }
//    [gameLayer receiveTouchMessage: [touches.anyObject locationInView:[touches.anyObject view]]];
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    Boolean newLowerLeftOn = false;
    Boolean newUpperLeftOn = false;
    Boolean newLowerRightOn = false;
    Boolean newUpperRightOn = false;
    //if no touches are in the previously activated region, disable the activation.
    for (UITouch *currentTouch in touches) {
        CGPoint touchLoc= [currentTouch locationInView:[currentTouch view]];
        if( touchLoc.x < screenSize.width/2){
            if(touchLoc.y < screenSize.height/2){
                newLowerLeftOn = true;
            }else{
                newUpperLeftOn = true;
            }
        }else if(touchLoc.x> screenSize.width/2){
            if(touchLoc.y < screenSize.height/2){
                newLowerRightOn = true;
                [gameLayer dash];
            }else{
                newUpperRightOn = true;
            }
        }
    }
    //checking if anytouch has been moved away from its original regions
    if(lowerLeftOn && !newLowerLeftOn){
        lowerLeftOn = false;
        [gameLayer frontEngineOff];
    }
    if(upperLeftOn && !newUpperLeftOn){
        upperLeftOn = false;
        [gameLayer rearEngineOff];

    }
    if(lowerRightOn && !newLowerRightOn){
        [gameLayer dashOff];
        lowerLeftOn = false;
        
    }
    if(upperRightOn && !newUpperRightOn){
        [gameLayer jumpFinished];
        lowerLeftOn = false;
        
    }
}

-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    CCLOG(@"Touch relieved");
    for (UITouch *currentTouch in touches) {
        CGPoint touchLoc= [currentTouch locationInView:[currentTouch view]];
        if( touchLoc.x < screenSize.width/2){
            if(touchLoc.y < screenSize.height/2){
                //turn off the front engine
                lowerLeftOn = false;
                [gameLayer frontEngineOff];
            }else{
                //turn off rear engine
                upperLeftOn = false;
                [gameLayer rearEngineOff];
            }
        }else if(touchLoc.x> screenSize.width/2){
            if(touchLoc.y < screenSize.height/2){
                lowerRightOn = false;
                [gameLayer dashOff];
                //pitch up off
            }else{
                //pitch down off
                upperRightOn = false;
                [gameLayer jumpFinished];
            }
        }
    }
}

-(void) ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
 // used only process is interrupted by phone calls and so on
}

@end

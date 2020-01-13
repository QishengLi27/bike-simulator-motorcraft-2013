//
//  HelloWorldLayer.h
//  DSYE2
//
//  Created by DS2 on 13-1-29.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"

//Pixel to metres ratio. Box2D uses metres as the unit for measurement.
//This ratio defines how many pixels correspond to 1 Box2D "metre"
//Box2D is optimized for objects of 1x1 metre therefore it makes sense
//to define the ratio so that your most common object type is 1x1 metre.
#define PTM_RATIO 32
//constants
extern int kIsFuel;
extern int kIsEnergy;
//tags
extern int kTagParentNode;
extern int kTagGameLayer;
extern int kTagTouchLayer;
extern int kTagHudLayer;
//z orders
extern int kZOrder;
extern int kGameLayerZ;
extern int kHudLayerZ;
extern int kTouchLayerZ;
// HelloWorldLayer
@interface GameLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
	CCTexture2D *spriteTexture_;	// weak ref
	b2World* world;					// strong ref
	GLESDebugDraw *m_debugDraw;		// strong ref
    b2RevoluteJoint* rearEngine;
    b2RevoluteJoint* frontEngine;
    b2Body* cart;
    b2Body* rear1;
    b2Body* rear2;
    b2Body *front1;
    b2Body* front2;
    b2Body* handle;
    b2Body* frontArm;
    b2Body* frontAxle;
    b2Body* rearArm;
    b2Body* frontWheel;
    b2Body* rearWheel;
    b2Body* groundBody;
    b2Fixture* frontScencor;
    b2Fixture* rearScensor;
    bool frontWheelOnGround;
    bool backWheelOnGround;
    int fuel;
    int energy;
}
@property (assign) b2Body* frontWheel;
@property (assign) b2Body* rearWheel;
@property (assign) b2RevoluteJoint* rearEngine;
@property (assign) b2RevoluteJoint* frontEngine;
@property (assign, readwrite) bool frontWheelOnGround;
@property (assign, readwrite) bool backWheelOnGround;
@property (assign) int fuel;
@property (assign) int energy;
// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(void) rearEngineOn;
-(void) rearEngineOff;
-(void) frontEngineOn;
-(void) frontEngineOff;

-(void) jump;
-(void) jumpFinished;

-(void) dash;
-(void) dashOff;

-(void) refillFuel;
-(void) refillEnergy;

@end

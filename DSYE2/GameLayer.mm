//
//  HelloWorldLayer.mm
//  DSYE2
//
//  Created by DS2 on 13-1-29.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//

// Import the interfaces
#import "GameLayer.h"
#import "TouchLayer.h"
#import "HudLayer.h"
// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "PhysicsSprite.h"
#import "ContactListener.h"
#include <queue>
#import "PauseLayer.h"
#import "gameOverLayer.h"

using namespace std;

//negative number means no collision
static int kBackWheel = -1342;
static int kFrontWheel = -1324;
#pragma mark - HelloWorldLayer
//contants
int kIsFuel = 355;
int kIsEnergy = 356;
//tags
int kTagParentNode=1;
int kTagGameLayer=2;
 int kTagTouchLayer=3;
 int kTagHudLayer=4;
//z orders
 int kZOrder=1;
 int kGameLayerZ=2;
 int kHudLayerZ=3;
 int kTouchLayerZ=4;
@interface GameLayer()
-(void) initPhysics;
-(void) addNewSpriteAtPosition:(CGPoint)p;
-(void) createMenu;
@end

@implementation GameLayer
@synthesize frontWheel;
@synthesize rearWheel;
@synthesize frontEngine;
@synthesize rearEngine;
@synthesize frontWheelOnGround;
@synthesize backWheelOnGround;
@synthesize fuel;
@synthesize energy;
int CFullFuel = 1000;
int CFullEnergy = 1000;

float groundFriction = 1.0f;
HudLayer* theHud;
queue<b2Fixture*> fixtures;

CCSprite* fuelTank;
CCSprite* energyTank;
b2Body *fuelTankBody;
b2Body *energyTankBody;

+(CCScene *) scene
{
    while(!fixtures.empty()){
        fixtures.pop();
    }
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
    theHud = [HudLayer node];
    //    theHud.theGameLayer = self;
    [scene addChild: theHud z:kHudLayerZ tag:kTagHudLayer];
	// 'layer' is an autorelease object.
	GameLayer *layer = [GameLayer node];
	// add layer as a child to scene
	[scene addChild: layer z:kGameLayerZ tag:kTagGameLayer];
    TouchLayer *theTouchLayer = [TouchLayer node];
    theTouchLayer.gameLayer = layer;
	[scene addChild: theTouchLayer z:kTouchLayerZ tag:kTagTouchLayer];

    
	// return the scene
//    CCLOG(@"last tank location:%f",lastTankLocation);
	return scene;
}
-(id) init
{
	if( (self=[super init])) {
        //init variables here
		lastTankLocation=0.0f;
        
		// enable events
		
		self.isTouchEnabled = NO;
		self.isAccelerometerEnabled = NO;
		CGSize s = [CCDirector sharedDirector].winSize;
		
		// init physics
		[self initPhysics];
		// create reset button
		[self createMenu];
		
		//Set up sprite
		
#if 1
		// Use batch node. Faster
		CCSpriteBatchNode *parent = [CCSpriteBatchNode batchNodeWithFile:@"blocks.png" capacity:100];
		spriteTexture_ = [parent texture];
#else
		// doesn't use batch node. Slower
		spriteTexture_ = [[CCTextureCache sharedTextureCache] addImage:@"blocks.png"];
		CCNode *parent = [CCNode node];
#endif
		[self addChild:parent z:0 tag:kTagParentNode];
		
        
        //	[self addNewSpriteAtPosition:ccp(s.width/2, s.height/2)];
		
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"MotorCraft" fontName:@"Marker Felt" fontSize:32];
		[self addChild:label z:0];
		[label setColor:ccc3(0,0,255)];
		label.position = ccp( s.width/2, s.height-50);
		//schedule update must be after initPhysics, where we set up the world and bike. Otherwise, collisions and forces will happen while we are positioning our stuff.
     
        
        
		[self scheduleUpdate];
	}
	return self;
}

 
-(void) dealloc
{
	delete world;
	world = NULL;
	
	delete m_debugDraw;
	m_debugDraw = NULL;
	
	[super dealloc];
}

-(void) createMenu
{
	// Default font size will be 22 points.
	[CCMenuItemFont setFontSize:22];
	
	// Reset Button
	/*CCMenuItemLabel *reset = [CCMenuItemFont itemWithString:@"Reset" block:^(id sender){
        [self unscheduleUpdate];
		[[CCDirector sharedDirector] replaceScene: [GameLayer scene]];
	}];
	
	// Achievement Menu Item using blocks
	CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:@"Achievements" block:^(id sender) {
		
		
		GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
		achivementViewController.achievementDelegate = self;
		
		AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
		
		[[app navController] presentModalViewController:achivementViewController animated:YES];
		
		[achivementViewController release];
	}];
	
	// Leaderboard Menu Item using blocks
	CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
		
		
		GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
		leaderboardViewController.leaderboardDelegate = self;
		
		AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
		
		[[app navController] presentModalViewController:leaderboardViewController animated:YES];
		
		[leaderboardViewController release];
	}];
	
	CCMenu *menu = [CCMenu menuWithItems:itemAchievement, itemLeaderboard, reset, nil];
	
	[menu alignItemsVertically];
	
	CGSize size = [[CCDirector sharedDirector] winSize];
	[menu setPosition:ccp( size.width/2, size.height/2)];
	
	
	[self addChild: menu z:-1];*/
}

int screenHeight;
-(void) initPhysics
{
	
	CGSize s = [[CCDirector sharedDirector] winSize];
	screenHeight = s.height/PTM_RATIO;
	b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f);
	world = new b2World(gravity);
    ContactListener* thatCL = new ContactListener();
    world->SetContactListener(thatCL);
    thatCL->theGameLayer = self;
	// Do we want to let bodies sleep?
	world->SetAllowSleeping(true);
	
	world->SetContinuousPhysics(true);
	
	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
	world->SetDebugDraw(m_debugDraw);
	
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
	//		flags += b2Draw::e_jointBit;
	//		flags += b2Draw::e_aabbBit;
	//		flags += b2Draw::e_pairBit;
	//		flags += b2Draw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);
	
    [self initGround:s];
    [self initBike:s];
	
}
b2Vec2 preConnectionPoint;
b2Vec2 connectionPoint;
b2Vec2 lastLowHigh;
int lowHighChance = 10; // 100 is full chance
int lowHighX= 5;
int lowHighY = 96;
int fuelTankChance = 20;//100 is full 100% chance
int energyTankChance = 20;

b2Fixture* lastConnection;
-(void) initGround:(CGSize)s
{
//    lastTankLocation=0.0f;
    CCLOG(@"initGround()");
	// Define the ground body.
	b2BodyDef groundBodyDef;
    groundBodyDef.type = b2_staticBody;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
    groundBody = world->CreateBody(&groundBodyDef);
	
	// Define the ground box shape.
	b2EdgeShape groundBox;
	//TODO:: eventually, before creating a true level. we are going to eliminate all b2EdgeShape and replace them with chainShapes.
	// bottom
	
	groundBox.Set(b2Vec2(0,0), b2Vec2(s.width/PTM_RATIO,0));
//    b2FixtureDef* aFixtureDef = new b2Fixture
//    groundBody->CreateFixture(<#const b2FixtureDef *def#>)
	fixtures.push(groundBody->CreateFixture(&groundBox,0));
    fixtures.push(groundBody->CreateFixture(&groundBox,0));
	fixtures.push(groundBody->CreateFixture(&groundBox,0));
	fixtures.push(groundBody->CreateFixture(&groundBox,0));
	fixtures.push(groundBody->CreateFixture(&groundBox,0));
	fixtures.push(groundBody->CreateFixture(&groundBox,0));
	fixtures.push(groundBody->CreateFixture(&groundBox,0));
	fixtures.push(groundBody->CreateFixture(&groundBox,0));
	fixtures.push(groundBody->CreateFixture(&groundBox,0));
	fixtures.push(groundBody->CreateFixture(&groundBox,0));
	fixtures.push(groundBody->CreateFixture(&groundBox,0));
	fixtures.push(groundBody->CreateFixture(&groundBox,0));
	fixtures.push(groundBody->CreateFixture(&groundBox,0));
	fixtures.push(groundBody->CreateFixture(&groundBox,0));
	fixtures.push(groundBody->CreateFixture(&groundBox,0));
	fixtures.push(groundBody->CreateFixture(&groundBox,0));
	fixtures.push(groundBody->CreateFixture(&groundBox,0));
	fixtures.push(groundBody->CreateFixture(&groundBox,0));
	fixtures.push(groundBody->CreateFixture(&groundBox,0));
	fixtures.push(groundBody->CreateFixture(&groundBox,0));
    
	
	// top
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO));
	fixtures.push(groundBody->CreateFixture(&groundBox,0));
	
	// left
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(0,0));
	fixtures.push(groundBody->CreateFixture(&groundBox,0));
	
	// right
    //	groundBox.Set(b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,0));
    //	groundBody->CreateFixture(&groundBox,0);
    //left ramp
    groundBox.Set(b2Vec2(0,s.height/PTM_RATIO*0.4), b2Vec2(s.width/PTM_RATIO*0.4, 0));
    fixtures.push(groundBody->CreateFixture(&groundBox,0));
    //riht ramp
    preConnectionPoint = b2Vec2(s.width/PTM_RATIO*0.6,0);
    connectionPoint = b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO*0.4);
    lastLowHigh = connectionPoint;
    groundBox.Set(preConnectionPoint, connectionPoint);
    //part of soothing mechanism
    //    groundBox.m_hasVertex3 = true;
    fixtures.push(/*lastConnection=*/ groundBody->CreateFixture(&groundBox,0));
    
    //create dummy tanks for the first delete.
    groundBodyDef.type = b2_staticBody;
	groundBodyDef.position.Set(0, 0);
    fuelTankBody = world ->CreateBody(&groundBodyDef);
    energyTankBody = world ->CreateBody(&groundBodyDef);
    [self terrainChanging];
    
}

float32 distanceLowerBound=32;
//float32 distanceUpperBound=250;
float32 heightLowerBound=64; //   128 / 4 = 4 meters
//float32 heightUpperBound=300;
int lowHighGap = 50;
-(void) terrainChanging
{
    // Define the ground box shape.
	b2EdgeShape groundBox;
    
    //riht ramp
    //    groundBox.Set(b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO*0.4), b2Vec2(s.width/PTM_RATIO*0.6,0));
    b2Vec2 currentConnectionPoint;
    b2Vec2 nextConnection;
    bool lowHighMode = NO;
redo: {
    if((arc4random()%100)< lowHighChance &&connectionPoint.x - lastLowHigh.x > lowHighGap){
        lowHighMode = YES;
        if(arc4random()%100 < 50){
            nextConnection.Set(connectionPoint.x +(distanceLowerBound +arc4random()%lowHighX)/PTM_RATIO, connectionPoint.y+ (heightLowerBound+arc4random()%lowHighY)/PTM_RATIO);
        }else{
            nextConnection.Set(connectionPoint.x +(distanceLowerBound +arc4random()%lowHighX)/PTM_RATIO, connectionPoint.y-(heightLowerBound+arc4random()%lowHighY)/PTM_RATIO);
        }
    }else{
        lowHighMode = NO;
        nextConnection.Set(connectionPoint.x +(distanceLowerBound +arc4random()%150)/PTM_RATIO, connectionPoint.y+ (-60 + (int)(arc4random()%120))/PTM_RATIO);
    }
}
    if(nextConnection.y > screenHeight){
        goto redo;
    }else if(nextConnection.y < 0){
        goto redo;
    }
    currentConnectionPoint.Set(nextConnection.x,nextConnection.y);
    groundBox.Set(connectionPoint, currentConnectionPoint);
    connectionPoint = currentConnectionPoint;
//    [self generateTanks:connectionPoint.x];
    [self generateTanksAtX:connectionPoint.x Y:connectionPoint.y];
    if(lowHighMode){
        lastLowHigh = currentConnectionPoint;
    }
//    CCLOG(@"%i",lowHighMode);
    //TODO::soothing mechanism, broken.
    //    groundBox.m_hasVertex0 = true;
    //    groundBox.m_vertex0 = connectionPoint;
    //    groundBox.m_hasVertex3 = true;
    //    b2EdgeShape* lastEdge = (b2EdgeShape*)lastConnection->GetShape();
    ////    lastEdge->m_hasVertex3 = true;
    //    lastEdge->m_vertex3 = currentConnectionPoint;
    b2Fixture*temp = NULL;
    fixtures.push(temp = groundBody->CreateFixture(&groundBox,0));
    temp->SetFriction(groundFriction);
    [self deleteBackTerrain];
    //add points as u move on
    [theHud addPoint];
}
-(void) deleteBackTerrain
{
 //   CCLOG(@"delete back terrain called");
    groundBody->DestroyFixture(fixtures.front());
    fixtures.pop();
}
float armWidth = 0.4;
float armHeight = 0.15;

float forearmX =1.0f;
float forearmY =-0.3f;
float forearmAngle = M_PI/3;

float rearArmX = -forearmX;
float rearArmY= forearmY;
float rearArmAngle = -forearmAngle;

float cartLinearDamping = 0.1f;
float cartAngularDamping = 0.1f;

-(void) initBike:(CGSize)s
{
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
	bodyDef.position.Set((s.width/PTM_RATIO)/2, (s.height/PTM_RATIO)/2);
    //these two are used to simulate air friction. linearDamping may not be needed
    bodyDef.linearDamping = cartLinearDamping;
    bodyDef.angularDamping = cartAngularDamping;
    //TODO:: uncomment the following line if you want your bike to float
    //bodyDef.gravityScale = 0.0f;
    
    b2FixtureDef fixtureDef;
    //bike body,
	{//default cart
        cart = world->CreateBody(&bodyDef);
        b2PolygonShape polyShape;
        {//TODO:: do I need to delete this b2Vec2 array to save memory?
            int count = 5;
            b2Vec2 vects[] = {
                b2Vec2(-1.0f, 0.0f),
                b2Vec2(-0.8f,-0.5f),
                b2Vec2(0.2f,-0.5f),
                b2Vec2(1.3f,0.5f),
                b2Vec2(-0.4f,0.5f)
            };
            polyShape.Set(vects, count);
        }
        fixtureDef.shape = &polyShape;
        fixtureDef.density = 1.0f;
        fixtureDef.friction =0.9f;
        fixtureDef.restitution = 0.05f;
        cart->CreateFixture(&fixtureDef);
        
        //create back arm texture
        {
            int count =4;
            b2Vec2 vects[] = {
                b2Vec2(-0.5f, -0.25f),
                b2Vec2(-0.5f,-0.2f),
                b2Vec2(-2.1f,-0.475f),
                b2Vec2(-2.1f,-0.525f)
            };
            polyShape.Set(vects, count);
        }
        fixtureDef.shape = &polyShape;
        fixtureDef.density = 1.0f;
        fixtureDef.friction =0.9f;
        fixtureDef.restitution = 0.3f;
        fixtureDef.filter.groupIndex = kBackWheel;
        cart->CreateFixture(&fixtureDef);
        //create fore arm texture
        {
            int count =4;
            b2Vec2 vects[] = {
                b2Vec2(1.02f, 0.9f),
                b2Vec2(1.0f,0.875f),
                b2Vec2(1.975f,-0.525f),
                b2Vec2(2.025f,-0.515f)
            };
            polyShape.Set(vects, count);
        }
        fixtureDef.shape = &polyShape;
        fixtureDef.density = 1.0f;
        fixtureDef.friction =0.9f;
        fixtureDef.restitution = 0.3f;
        fixtureDef.filter.groupIndex = kFrontWheel;
        cart->CreateFixture(&fixtureDef);
        //vects = new b2Vec2[]{
        //
        //        };
    }
    
	{// Define a circle shape for our dynamic wheel body.
        bodyDef.position.Set(bodyDef.position.x - 2.0f, bodyDef.position.y-0.5f);
        rearWheel = world->CreateBody(&bodyDef);
        b2CircleShape dynamicCircle;
        dynamicCircle.m_p.Set(0, 0);
        dynamicCircle.m_radius = 0.75f;
        // Define the dynamic body fixture.
        fixtureDef.shape = &dynamicCircle;
        fixtureDef.density = 1.0f;
        fixtureDef.friction = 1.4f;
        fixtureDef.restitution = 0.5f;
        fixtureDef.filter.groupIndex = kBackWheel;
        fixtureDef.userData = (void*)4;
        rearWheel->CreateFixture(&fixtureDef);
        {//the revolution join between back wheel and back arm
            b2RevoluteJointDef revJointDef;
            revJointDef.maxMotorTorque = 2000.0f;
            revJointDef.motorSpeed = 20.0f;
            revJointDef.enableMotor = false;
            revJointDef.Initialize(rearWheel, cart, rearWheel->GetWorldCenter());
            rearEngine = (b2RevoluteJoint*)world->CreateJoint(&revJointDef);
        }
    }
    {//fore wheel
        bodyDef.position.Set(cart->GetPosition().x+2.0f , cart->GetPosition().y-0.5f);
        frontWheel = world->CreateBody(&bodyDef);
        b2CircleShape dynamicCircle;
        dynamicCircle.m_p.Set(0, 0);
        dynamicCircle.m_radius = 0.75f;
        // Define the dynamic body fixture.
        fixtureDef.shape = &dynamicCircle;
        fixtureDef.density = 0.5f;
        fixtureDef.friction = 1.0f;
        fixtureDef.restitution = 0.5f;
        fixtureDef.filter.groupIndex = kFrontWheel;
        
        //        fixtureDef.isSensor=true;
        fixtureDef.userData = (void *)3;
        frontWheel->CreateFixture(&fixtureDef);
        {//the revolution join between back wheel and back arm
            b2RevoluteJointDef revJointDef;
            revJointDef.maxMotorTorque = 150.0f;
            revJointDef.motorSpeed = -10.0f;
            revJointDef.enableMotor = false;
            revJointDef.Initialize(frontWheel, cart, frontWheel->GetWorldCenter());
            frontEngine = (b2RevoluteJoint*)world->CreateJoint(&revJointDef);
        }
        
    }
    {//init fuel and energy
        fuel = CFullFuel;
        energy =CFullEnergy;
        frontWheelOnGround =true;
        backWheelOnGround = true;
    }
}

-(void) draw
{
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommend to disable it
	//
	[super draw];
	
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	
	kmGLPushMatrix();
	
	world->DrawDebugData();
	
	kmGLPopMatrix();
}

-(void) addNewSpriteAtPosition:(CGPoint)p
{
    //	CCLOG(@"Add sprite %0.2f x %02.f",p.x,p.y);
    //	CCNode *parent = [self getChildByTag:kTagParentNode];
    //
    //	//We have a 64x64 sprite sheet with 4 different 32x32 images.  The following code is
    //	//just randomly picking one of the images
    //	int idx = (CCRANDOM_0_1() > .5 ? 0:1);
    //	int idy = (CCRANDOM_0_1() > .5 ? 0:1);
    //	PhysicsSprite *sprite = [PhysicsSprite spriteWithTexture:spriteTexture_ rect:CGRectMake(32 * idx,32 * idy,32,32)];
    //	[parent addChild:sprite];
    //
    //	sprite.position = ccp( p.x, p.y);
	
	// Define the dynamic body.
	//Set up a 1m squared box in the physics world
	b2BodyDef bodyDef;
	bodyDef.type = b2_dynamicBody;
	bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
	b2Body *body = world->CreateBody(&bodyDef);
	
	// Define another box shape for our dynamic body.
	b2PolygonShape dynamicBox;
	dynamicBox.SetAsBox(.5f, .5f);//These are mid points for our 1m box
	
	// Define the dynamic body fixture.
	b2FixtureDef fixtureDef;
	fixtureDef.shape = &dynamicBox;
	fixtureDef.density = 1.0f;
	fixtureDef.friction = 0.3f;
	body->CreateFixture(&fixtureDef);
	
    //	[sprite setPhysicsBody:body];
}
int updatingDistance = 480/PTM_RATIO;

int frontEngineCost=1;
int rearEngineCost=2;

int32 velocityIterations = 8;
int32 positionIterations = 1;
-(void) update: (ccTime) dt
{
//    CCLOG(@"update()");
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
    if(destroyFuelTank){
        destroyFuelTank = false;
        world->DestroyBody(fuelTankBody);
    }
    if(destroyEnergyTank){
        destroyEnergyTank = false;
        world->DestroyBody(energyTankBody);
    }
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
    
    //Iterate over the bodies in the physics world
	/*for (b2Body* b = world->GetBodyList(); b; b = b->GetNext()) {
     if (b->GetUserData() != NULL) {
     //Synchronize the AtlasSprites position and rotation with the corresponding body
     CCSprite *myActor = (CCSprite*)b->GetUserData();
     myActor.position = CGPointMake( b->GetPosition().x * PTM_RATIO,
     b->GetPosition().y * PTM_RATIO);
     myActor.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
     }
     }*/
	
	b2Vec2 pos = cart->GetPosition();
    
	CGPoint newPos = ccp( (-1)* pos.x * PTM_RATIO + 100, self.position.y );//* PTM_RATIO);
    
	[self setPosition:newPos];
    if(  connectionPoint.x- pos.x <updatingDistance){
        [self terrainChanging];
    }
    if(rearEngine->IsMotorEnabled()){
//        fuel -= rearEngineCost;
        [self costFuel:rearEngineCost];
    }
    if(frontEngine->IsMotorEnabled()){
//        fuel -= frontEngineCost;
        [self costFuel:frontEngineCost];
    }
  
    if(dashOn){
        float angle = cart->GetAngle();
        b2Vec2 impulse = b2Vec2(cos(angle)*dashMagnitude, sin(angle)*dashMagnitude);
        cart->ApplyLinearImpulse(impulse, cart->GetWorldCenter());
        [self costEnergy:dashCost];
        if(energy < 0){
            [self dashOff];
        }
    }
    if(jumpOn){
        float angle = cart->GetAngle()+M_PI_2;
        b2Vec2 impulse = b2Vec2(cos(angle)*jumpMagnitude, sin(angle)*jumpMagnitude);
        cart->ApplyLinearImpulse(impulse, cart->GetWorldCenter());
        [self costEnergy:jumpCost];
//        [self scheduleOnce:@selector(resetJump) delay:5];
    }
    if(fuel <=0 ){
        [self frontEngineOff];
        [self rearEngineOff];
        //transits to gameover layer
        [[CCDirector sharedDirector] replaceScene:[gameOverLayer scene:theHud.score]];
    }
  
}

float lastTankLocation;
float tankInterval = 15.0f;
- (void) generateTanksAtX:(float32)xCoor Y:(float32)yCoor
{
//    CCLOG(@"xCoor:%f",xCoor);
    if(xCoor -lastTankLocation < tankInterval){
        return;
    }
    yCoor += 1.0f;
    if((arc4random()%100)< fuelTankChance){
        if(!lastFuelPicked){
            world->DestroyBody(fuelTankBody);
        }
        lastFuelPicked = false;
//        destroyFuelTank = true;
        //generate a fuel tank
        b2BodyDef aBodyDef;//can reuse
        aBodyDef.position.Set(xCoor, yCoor);
        lastTankLocation = xCoor;
        fuelTankBody= world->CreateBody(&aBodyDef);
        b2PolygonShape aShapeDef;
        aShapeDef.SetAsBox(0.5f, 0.5f);
        b2FixtureDef aFixtureDef;
        aFixtureDef.shape = &aShapeDef;
        aFixtureDef.isSensor = true;
        aFixtureDef.userData = ((void*)(kIsFuel));
        // add to body
        fuelTankBody->CreateFixture(&aFixtureDef);
    }else if((arc4random()%100)< energyTankChance){
        //generate an energy tank
    }
}

/*- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
 {
 //Add a new body/atlas sprite at the touched location
 for( UITouch *touch in touches ) {
 CGPoint location = [touch locationInView: [touch view]];
 
 location = [[CCDirector sharedDirector] convertToGL: location];
 
 [self addNewSpriteAtPosition: location];
 }
 }*/

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) rearEngineOn{
    //    CCLOG(@"rearEngineOn()");
    //    rearEngine->SetMaxMotorTorque(100.0f);
    //    rearEngine->SetMotorSpeed(14.0f);
    if(fuel>0){
        rearEngine->EnableMotor(true);
    }
}
-(void) rearEngineOff{
    rearEngine->EnableMotor(false);
}
-(void) frontEngineOn{
    if(fuel >0){
        frontEngine->EnableMotor(true);
    }
}
-(void) frontEngineOff{
    
    frontEngine->EnableMotor(false);
}

int jumpMagnitude = 2;
int jumpCost = 1;
bool canJump = true;
bool jumpOn = false;
-(void) jump{
    if(energy<0||!canJump){
        return;
    }
//    if(frontWheelOnGround && backWheelOnGround){
    jumpOn = true;
    
//    if(canJump){
//        canJump = false;
//        float angle = cart->GetAngle()+M_PI_2;
//        b2Vec2 impulse = b2Vec2(cos(angle)*jumpMagnitude, sin(angle)*jumpMagnitude);
//        cart->ApplyLinearImpulse(impulse, cart->GetWorldCenter());
//        [self costEnergy:jumpCost];
//        [self scheduleOnce:@selector(resetJump) delay:5];
//    }
}

-(void) resetJump{
    canJump = true;
}

int dashMagnitude = 1;
int dashCost = 1;
bool dashOn = false;
-(void) dash{
    if(energy<0){
        return;
    }
    dashOn = true;
    //    while (dashOn) {
    //    b2Vec2 impulse = cart->GetWorldCenter() - rearWheel->GetWorldCenter();
    {
//        float angle = cart->GetAngle();
//        b2Vec2 impulse = b2Vec2(cos(angle)*dashMagnitude, sin(angle)*dashMagnitude);
//        cart->ApplyLinearImpulse(impulse, cart->GetWorldCenter());
//        [self costEnergy:dashCost];
    }
    //    }
}

-(void)costEnergy:(int)cost{
    energy -= cost;
    [theHud updateEnergy:((float)energy/(float)CFullEnergy)];
}
-(void)costFuel:(int)cost{
    fuel -= cost;
    [theHud updateFuel:((float)fuel/(float)CFullFuel)];
}

-(void) dashOff{
    dashOn = false;
}

bool destroyFuelTank= false;
bool destroyEnergyTank = false;
int fuelRefillAmount = 100;
int energyRefillAmount = 100;
bool lastFuelPicked = false;
-(void) refillFuel{
    fuel+= fuelRefillAmount;
    if(fuel >CFullFuel){
        fuel = CFullFuel;
    }
    [theHud updateFuel:((float)fuel/(float)CFullFuel)];
    destroyFuelTank = true;
    lastFuelPicked = true;
    [theHud addPoint];
}

-(void) refillEnergy{
  energy +=  energyRefillAmount;
    if(energy>CFullEnergy){
        energy = CFullEnergy;
    }
    [theHud updateEnergy:((float)energy/(float)CFullEnergy)];
    destroyEnergyTank = true;
}

-(void) jumpFinished{
    canJump = false;
    jumpOn = false;
    [self scheduleOnce:@selector(resetCanJump) delay:jumpInterval];
}

int jumpInterval = 5;
-(void) resetCanJump{
    canJump = true;
}

@end

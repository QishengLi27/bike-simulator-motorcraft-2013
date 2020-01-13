//
//  HudLayer.mm
//  


//this is a commit from eclipse
#import "HudLayer.h"
#import "GameLayer.h"
#import "PauseLayer.h"

@implementation HudLayer
@synthesize fuelBar;
@synthesize energyBar;
@synthesize score;
//@synthesize theGameLayer;
int fuelBarX;
int fuelBarY;
int energyBarX;
int energyBarY;


-(id) init{
    //TODO make use of this
    CGSize s = [[CCDirector sharedDirector] winSize];
    
    {
        fuelBarX = 25;
        energyBarX = s.width - fuelBarX;
        fuelBarY = s.height - 30;
        energyBarY = fuelBarY;
    }
    if(self = [super init]){
        self.isTouchEnabled = NO;
    }
    //set sprite bars
    fuelBar = [CCSprite spriteWithFile:@"greenBar.jpg"];
    energyBar = [CCSprite spriteWithFile:@"blueBar.jpg"];
    //set sprite bars' location
    fuelBar.position = ccp(fuelBarX, fuelBarY);
    energyBar.position = ccp(energyBarX,energyBarY);
    fuelBar.anchorPoint = ccp(0.0,0.5);
    energyBar.anchorPoint = ccp(1.0,0.5);
    
    //add sprite bars
    [self addChild:fuelBar];
    [self addChild:energyBar];
    
    //add pause...................
    CCMenuItemImage *pauseButton = [CCMenuItemImage itemFromNormalImage:@"Pause.png" selectedImage:@"Pause.png" target:self selector:@selector(pauseGame)];
    pauseButton.scale = 0.13;
    
    CCMenu *menu = [CCMenu menuWithItems:pauseButton, nil];
    menu.position = ccp(s.width-225, 15);
    [menu alignItemsVerticallyWithPadding: 20.0f];
    [self addChild:menu];
    //pause part..................
    
    //score.......................
    //Set the score to zero.
    score = 0;
    
    //Create and add the score label as a child.
    //TODO:: might change into another 
    scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Marker Felt" fontSize:24];
    scoreLabel.position = ccp(440, 260); 
    [self addChild:scoreLabel z:1];
    return  self;
}
-(void) pauseGame
{
    GameLayer* theGameLayer = [self.parent getChildByTag: kTagGameLayer];
    [theGameLayer unscheduleUpdate];
    CCLayerColor *pauseLayer =[[[PauseLayer alloc]init]autorelease];
    [self.parent addChild:pauseLayer z:10];
    [[CCDirector sharedDirector] pause];
}


- (void)addPoint
{
    score = score + 10; //I think: score++; will also work.
    [scoreLabel setString:[NSString stringWithFormat:@"%i", score]];
}

-(void) updateFuel:(float)fuelPercent
{
    fuelBar.scaleX = fuelPercent;
}

-(void) updateEnergy:(float)energyPercent
{
    energyBar.scaleX = energyPercent;
}

//-(void) onEnter{
//    [super onEnter];
//    [[[CCDirector sharedDirector] touchDispatcher] addStandardDelegate:self priority:1];
//}
//-(void) onExit{
//    [super onExit];
//    [[[CCDirector sharedDirector]touchDispatcher] removeDelegate:self];
//}


@end
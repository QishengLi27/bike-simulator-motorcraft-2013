//
//  HudLayer.h


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "GameLayer.h"
// HelloWorldLayer
@interface HudLayer : CCLayer
{
  CCSprite* fuelBar;
  CCSprite* energyBar;
 //   GameLayer* theGameLayer;
    //Score part
    int score;
    CCLabelTTF *scoreLabel;
}

@property int score;
@property (readwrite) CCSprite* fuelBar;
@property CCSprite* energyBar;
//@property GameLayer* theGameLayer;
-(void) updateFuel:(float)fuelPercent;
-(void) updateEnergy:(float)energyPercent;
-(void) addPoint;
@end

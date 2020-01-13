//
//  PauseLayer.h
//  DSYE2
//
//  Created by DS2 on 13-3-25.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameLayer.h"
#import "menu.h"
#import "HudLayer.h"

@interface PauseLayerProtocol: CCNode

-(void)pauseLayerDidPause;

-(void)pauseLayerDidUnpause;

@end

@interface PauseLayer : CCLayerColor {
    
    PauseLayerProtocol * delegate;
}

@property (nonatomic,assign)PauseLayerProtocol * delegate;

+ (id) layerWithColor:(ccColor4B)color delegate:(PauseLayerProtocol *)_delegate;

- (id) initWithColor:(ccColor4B)c delegate:(PauseLayerProtocol *)_delegate;

-(void)pauseDelegate;

@end

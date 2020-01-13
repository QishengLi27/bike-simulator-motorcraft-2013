//
//  ContactListener.h
//  DSYE2
//
//  Created by DS2 on 13-3-4.
//
//

#ifndef __DSYE2__ContactListener__
#define __DSYE2__ContactListener__

#include <iostream>
#import "Box2D.h"
#import <vector>
#import <algorithm>
#import "GameLayer.h"
//TODO:: do I even need this struct?
struct MyContact {
    b2Fixture *fixtureA;
    b2Fixture *fixtureB;
    bool operator==(const MyContact& other) const
    {
        return (fixtureA == other.fixtureA) && (fixtureB == other.fixtureB);
    }
};
    
class ContactListener : public b2ContactListener {
public:  //should this be private? works either way
    std::vector<MyContact>_contacts;   //not sure what this does but would be for using contactlistener in update elsewhere i think, works with or without
    GameLayer* theGameLayer;
    //ContactListener();   //not sure what this does but if uncommented fails: undefined symbol in gamelevel1layer
    //~ContactListener();   //not sure what this does but if uncommented breaks
    
    virtual void BeginContact(b2Contact* contact){
    //forewheel
//        if(contact->GetFixtureA()->GetUserData() == (void*)3||contact->GetFixtureB()->GetUserData()==(void*)3){
//            //contact begin
//            theGameLayer.frontWheelOnGround = true;
//        }
//        //backwheel
//        if(contact->GetFixtureA()->GetUserData() == (void*)4||contact->GetFixtureB()->GetUserData()==(void*)4){
//            //contact begin
//            theGameLayer.backWheelOnGround = true;
//        }
        
        //fuelTank
        if(contact->GetFixtureA()->GetUserData() == (void*)kIsFuel||contact->GetFixtureB()->GetUserData()==(void*)kIsFuel){
            [theGameLayer refillFuel];
        }
//        //energyTank
//        else if(contact->GetFixtureA()->GetUserData() == (void*)kIsEnergy||contact->GetFixtureB()->GetUserData()==(void*)kIsEnergy){
//            [theGameLayer refillEnergy];
//        }
    };
    virtual void EndContact(b2Contact* contact){      
//        if(contact->GetFixtureA()->GetUserData() == (void*)3||contact->GetFixtureB()->GetUserData()==(void*)3){
//            theGameLayer.frontWheelOnGround = false;
//        }
//        if(contact->GetFixtureA()->GetUserData() == (void*)4||contact->GetFixtureB()->GetUserData()==(void*)4){
//            theGameLayer.backWheelOnGround = false;
//        }
    };
};

#endif /* defined(__DSYE2__ContactListener__) */

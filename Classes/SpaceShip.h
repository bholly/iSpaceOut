//
//  SpaceShip.h
//  Cocos2DTest
//
//  Created by Dominik Fehn on 18.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChipmunkObject.h"

#define SPEED_FACTOR 5.0f;
#define MAX_LIFE 10

@interface SpaceShip : ChipmunkObject {
	int _life;
	float speedFactor;
	float afterburner;
	bool _shield;
}

@property(nonatomic, assign) float speedFactor;
@property(nonatomic, assign) float afterburner;

-(int)life;
-(void)setLife:(int)l;
-(id)initWithCpSpace: (cpSpace *)space X:(float)x Y:(float)y Sprite:(AtlasSprite *)atlasSprite;
-(void)updateWithJoystickVelocity:(cpVect)jv andAngle:(cpVect)va delta:(ccTime)d;
-(float)getRotation;
-(void)setRotation:(float)a;
-(BOOL)shield;
-(void)setShield:(BOOL)b;

@end

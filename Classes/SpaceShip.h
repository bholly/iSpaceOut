/*
 * iSpaceOut - a free Asteroids-clone for the iPhone
 *
 * Copyright (C) 2009-2010 Dominik Fehn
 *
 * This program is free software; you can redistribute it and/or modify 
 * it under the terms of the GNU General Public License as published by 
 * the Free Software Foundation; either version 3 of the License, or 
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, 
 * but WITHOUT ANY WARRANTY; without even the implied warranty of 
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU 
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License 
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 */

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

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

#import "SpaceShip.h"


@implementation SpaceShip

@synthesize speedFactor;
@synthesize afterburner;

-(id)initWithCpSpace: (cpSpace *)space X:(float)x Y:(float)y Sprite:(AtlasSprite *)atlasSprite
{
	if ((self = [super init]))
	{
		_life = MAX_LIFE;
		afterburner = 0.92f;
		speedFactor = 20.0f;
		_shield = NO;
		
		sprite = atlasSprite;
		sprite.position = cpv(x,y);
		
		cpVect verts[] = {
			cpv(-29,-13),
			cpv(-29, 13),
			cpv(29, 13),
			cpv(29,-13),
		};
		
		// 100 = body mass
		body = cpBodyNew(100.0f, INFINITY);
		body->p = cpv(x, y);
		body->v = cpv(0,0);
		
		cpSpaceAddBody(space, body);
		
		shape = cpPolyShapeNew(body, 4, verts, cpvzero);
		shape->e = 0.9f; shape->u = 0.9f;
		shape->data = self;
		shape->collision_type = 1; //New!
		cpSpaceAddShape(space, shape);
		
		destroyed = false;
	}
	return self;
	
}

-(void)updateWithJoystickVelocity:(cpVect)jv andAngle:(cpVect)va delta:(ccTime)d
{
	// Change velocity
	float newX = body->v.x + jv.x * d * speedFactor;
	float newY = body->v.y + jv.y * d * speedFactor;
	body->v =  ccp( newX, newY );
	
	// Check border
	if (body->p.x > 460)
	{
		body->p.x = 460;
	}
	if (body->p.x < 20)
	{
		body->p.x = 20;
	}
	if (body->p.y > 300)
	{
		body->p.y = 300;
	}
	if (body->p.y < 20)
	{
		body->p.y = 20;
	}
	
	// Rotate
	if (va.y > 0)
	{
		body->a =  -(2 * 3.14f * (va.x - 90.0f)) / 360.0f;
	}
	
	// Fade movement out
	body->v.x *= afterburner;
	body->v.y *= afterburner;
}

-(float)getRotation
{
	return body->a;
}

-(void)setRotation:(float)a
{
	body->a = a;
}

-(int)life
{
	return _life;
}

-(void)setLife:(int)l
{
	// Don't ask for shield, if we get plus life
	if (l > 0)
	{
		_life += l;
	}
	else // Otherwise check for shield protection
	{
		if (!_shield)
		{
			_life += l;
		}
	}
	if (_life > MAX_LIFE)
	{
		_life = MAX_LIFE;
	}
	if (_life < 0)
	{
		_life = 0;
	}
}

-(BOOL)shield
{
	return _shield;
}

-(void)setShield:(BOOL)b
{
	_shield = b;
	if (_shield)
	{
		sprite.color = ccc3(255, 255, 0);
	}
	else {
		sprite.color = ccc3(255,255,255);
	}
}

@end

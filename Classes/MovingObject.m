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

#import "MovingObject.h"


@implementation MovingObject

@synthesize ready;
@synthesize objectCollided;

-(void)initImplX:(float)x Y:(float)y Sprite:(AtlasSprite *)atlasSprite {
	startPosition = cpv(x,y);
	objectCollided = NO;
	ready = YES;
	sprite = atlasSprite;
	sprite.position = cpv(x,y);
	// Derived from ChipmunkObject
	destroyed = false;
}

-(void)update: (ccTime)delta {
	
	if((body->p.y > 420) | (body->p.y < -100) | 
	   (body->p.x > 580) | (body->p.x < -100) | objectCollided)
	{
		[self resetPosition];
		[self setReady: YES];
	}
}

-(void) resetPosition
{
	body->p = startPosition;
	body->v = cpv(0,0);
}

-(void) startMovingFromX:(float)x Y:(float)y velocity:(cpVect)v
{
	objectCollided = NO;
	body->p = cpv(x,y);
	body->v = v;
}

@end

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

#import "ChipmunkObject.h"

@implementation ChipmunkObject

@synthesize sprite;
@synthesize velocity;
@synthesize body;

-(void) dealloc:(id)caller inSpace:(cpSpace *)space {
	
	if (shape && !destroyed)
	{
		[sprite setVisible:NO];
		
		cpSpaceRemoveBody(space, shape->body);
		cpSpaceRemoveShape(space, shape);
		cpBodyFree(shape->body);
		cpShapeFree(shape);
		destroyed = TRUE;
		// NSLog(@"ChipmunkObject deallocated");
	}
	//[super dealloc];
}

-(cpVect)getPosition
{
	return body->p;
}

-(void)setPosition:(cpVect)p
{
	body->p = p;
}

-(cpVect)getVelocity
{
	return body->v;
}

-(void)setVelocity:(cpVect)v
{
	body->v = v;
}

@end

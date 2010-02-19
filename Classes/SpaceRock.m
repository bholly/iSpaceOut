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

#import "SpaceRock.h"


@implementation SpaceRock

@synthesize type;

-(id)initBigRockWithCpSpace: (cpSpace *)space X:(float)x Y:(float)y velocity:(cpVect)v Sprite:(AtlasSprite *)atlasSprite
{
	if ((self = [super init]))
	{
		// Inital implementation for all types
		[self initImplX:x Y:y Sprite:atlasSprite];
		
		type = BigSpaceRock;
		
		cpVect verts[] = {
			cpv(-23,-20),
			cpv(-23, 20),
			cpv(23, 20),
			cpv(23,-20),
		};
		
		body = cpBodyNew(200.0f, INFINITY);
		body->p = cpv(x, y);
		body->v = v;
			
		shape = cpPolyShapeNew(body, 4, verts, cpvzero);
		shape->e = 0.9f; shape->u = 0.9f;
		shape->data = self;
		shape->collision_type = 0; //New!
		cpSpaceAddShape(space, shape);
		cpSpaceAddBody(space, body);
	}
	return self;
}

-(id)initSmallRockWithCpSpace: (cpSpace *)space X:(float)x Y:(float)y velocity:(cpVect)v Sprite:(AtlasSprite *)atlasSprite {
	
	if ((self = [super init]))
	{
		// Inital implementation for all types
		[self initImplX:x Y:y Sprite:atlasSprite];
		
		type = SmallSpaceRock;
		
		cpVect verts[] = {
			cpv(-10,-12),
			cpv(-10, 12),
			cpv(10, 12),
			cpv(10,-12),
		};
		
		body = cpBodyNew(100.0f, INFINITY);
		body->p = cpv(x, y);
		body->v = v;
		
		shape = cpPolyShapeNew(body, 4, verts, cpvzero);
		shape->e = 0.9f; shape->u = 0.9f;
		shape->data = self;
		shape->collision_type = 0; //New!
		cpSpaceAddShape(space, shape);
		cpSpaceAddBody(space, body);
	}
	return self;
}

@end

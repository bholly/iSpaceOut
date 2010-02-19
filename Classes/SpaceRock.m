//
//  SpaceRock.m
//  Cocos2DTest
//
//  Created by Dominik Fehn on 14.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

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

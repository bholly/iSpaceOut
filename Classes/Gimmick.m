//
//  Gimmick.m
//  iSpaceOut
//
//  Created by Dominik Fehn on 13.10.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Gimmick.h"


@implementation Gimmick

@synthesize type;

-(id)initExtraLifeWithCpSpace: (cpSpace *)space X:(float)x Y:(float)y velocity:(cpVect)v Sprite:(AtlasSprite *)atlasSprite
{
	if ((self = [super init]))
	{
		// Inital implementation for all types
		[self initImplX:x Y:y Sprite:atlasSprite];
		
		type = ExtraLife;
		
		cpVect verts[] = {
			cpv(-15,-9),
			cpv(-15, 9),
			cpv(15, 9),
			cpv(15,-9),
		};
		
		body = cpBodyNew(10.0f, INFINITY);
		body->p = cpv(x, y);
		body->v = v;
		
		shape = cpPolyShapeNew(body, 4, verts, cpvzero);
		shape->e = 0.9f; shape->u = 0.9f;
		shape->data = self;
		shape->collision_type = 3; //New!
		cpSpaceAddShape(space, shape);
		cpSpaceAddBody(space, body);
	}
	return self;
}


-(id)initBonusPointsWithCpSpace: (cpSpace *)space X:(float)x Y:(float)y velocity:(cpVect)v Sprite:(AtlasSprite *)atlasSprite
{
	if ((self = [super init]))
	{
		// Inital implementation for all types
		[self initImplX:x Y:y Sprite:atlasSprite];
		
		type = BonusPoints;
		
		cpVect verts[] = {
			cpv(-15,-9),
			cpv(-15, 9),
			cpv(15, 9),
			cpv(15,-9),
		};
		
		body = cpBodyNew(10.0f, INFINITY);
		body->p = cpv(x, y);
		body->v = v;
		
		shape = cpPolyShapeNew(body, 4, verts, cpvzero);
		shape->e = 0.9f; shape->u = 0.9f;
		shape->data = self;
		shape->collision_type = 3; //New!
		cpSpaceAddShape(space, shape);
		cpSpaceAddBody(space, body);
	}
	return self;
}

-(id)initShieldWithCpSpace: (cpSpace *)space X:(float)x Y:(float)y velocity:(cpVect)v Sprite:(AtlasSprite *)atlasSprite
{
	if ((self = [super init]))
	{
		// Inital implementation for all types
		[self initImplX:x Y:y Sprite:atlasSprite];
		
		type = Shield;
		
		cpVect verts[] = {
			cpv(-15,-9),
			cpv(-15, 9),
			cpv(15, 9),
			cpv(15,-9),
		};
		
		body = cpBodyNew(10.0f, INFINITY);
		body->p = cpv(x, y);
		body->v = v;
		
		shape = cpPolyShapeNew(body, 4, verts, cpvzero);
		shape->e = 0.9f; shape->u = 0.9f;
		shape->data = self;
		shape->collision_type = 3; //New!
		cpSpaceAddShape(space, shape);
		cpSpaceAddBody(space, body);
	}
	return self;
}

-(id)initDoubleFireWithCpSpace: (cpSpace *)space X:(float)x Y:(float)y velocity:(cpVect)v Sprite:(AtlasSprite *)atlasSprite
{
	if ((self = [super init]))
	{
		// Inital implementation for all types
		[self initImplX:x Y:y Sprite:atlasSprite];
		
		type = DoubleFire;
		
		cpVect verts[] = {
			cpv(-15,-9),
			cpv(-15, 9),
			cpv(15, 9),
			cpv(15,-9),
		};
		
		body = cpBodyNew(10.0f, INFINITY);
		body->p = cpv(x, y);
		body->v = v;
		
		shape = cpPolyShapeNew(body, 4, verts, cpvzero);
		shape->e = 0.9f; shape->u = 0.9f;
		shape->data = self;
		shape->collision_type = 3; //New!
		cpSpaceAddShape(space, shape);
		cpSpaceAddBody(space, body);
	}
	return self;
}

@end

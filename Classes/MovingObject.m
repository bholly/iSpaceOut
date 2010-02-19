//
//  MovingObject.m
//  iSpaceOut
//
//  Created by Dominik Fehn on 13.10.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

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

//
//  Bullet.m
//  GameDemo
//
//  Created by Ronald Jett on 4/25/09.
//  http://morethanmachine.com/macdev
//	rlj3967@rit.edu
//

#import "Bullet.h"

#define pi 3.14159265f


@implementation Bullet

@synthesize ready;
@synthesize bulletUsed;

-(id)initWithCpSpace: (cpSpace *)space X:(float)x Y:(float)y velocity:(cpVect)v Sprite:(AtlasSprite *)atlasSprite;
{
	self = [super init];
	if(self != nil){
		
		startPosition = cpv(x,y);
		
		sprite = atlasSprite;
		sprite.position = cpv(x, y);
		
		cpVect verts[] = {
			cpv(-7,-10),
			cpv(-7, 10),
			cpv(7, 10),
			cpv(7,-10),
		};
		
		body = cpBodyNew(1.0f, INFINITY);
		body->p = cpv(x, y);
		body->v = v;
		
		cpSpaceAddBody(space, body);
		
		shape = cpPolyShapeNew(body, 4, verts, cpvzero);
		shape->e = 0.9f; shape->u = 0.9f;
		shape->data = self;
		shape->collision_type = 2; //this is new!
		
		// Don't add shape here like in other objects
		// to avoid collisions between "paused" bullets and other
		// objects
		// cpSpaceAddShape(space, shape);
		
		_space = space;
		
		ready = true;
		destroyed = false;
		
		bulletUsed = NO;
		
		_needsToBeSetBack = NO;
	}
	
	return self;
}
-(void) fireFromX: (float) x y:(float)y angle:(float)a levelFactor:(int)level
{
	// Start collision detection from this moment on
	cpSpaceAddShape(_space, shape);
	
	[self setBulletUsed:NO];
	float realA = a + (pi / 2.0f);
	body->a = a;
	body->p = cpv(x, y);
	body->v = cpv((200 + (level * 50)) * cos(realA), (200 + (level *50)) * sin(realA));
}
-(float) getX
{
	return body->p.x;
}
-(void) setX:(float)x
{
	body->p.x = x;
}
-(float) getY
{
	return body->p.y;
}
-(void) setY:(float)y
{
	body->p.y = y;
}
-(void) resetPosition
{
	body->p = startPosition;
	body->v = cpv(0,0);
	// Mark as red to show: we still need to remove this one
	// from Collision detection next update step
	sprite.color = ccc3(255,0,0);
}

-(void)update: (ccTime)delta 
{
	// Check if bullet is back "paused" and not ready by now (marked as red)
	if ((sprite.color.r == 255) && (sprite.color.g == 0) && (sprite.color.b == 0) && _needsToBeSetBack)
	{
		sprite.color = ccc3(255,255,255);
		// Remove shape from collision detection
		cpSpaceRemoveShape(_space, shape);
		[self setReady: YES];
		_needsToBeSetBack = NO;
	}
	// Check if bullet needs to be "paused"
	if(([self getY] > 320) | ([self getY] < 0) | 
	   ([self getX] > 480) | ([self getX] < 0) | bulletUsed) 
	{
		bulletUsed = NO;
		[self resetPosition];
		_needsToBeSetBack = YES;
	}
	// Avoid bullets getting into bullet depot
	// if (([self getY] < 20) && ([self getX] < 220))
	// {
	//	[self resetPosition];
	// }
}

@end

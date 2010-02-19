//
//  ChipmunkObject.m
//  Cocos2DTest
//
//  Created by Dominik Fehn on 18.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

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

//
//  ChipmunkObject.h
//  Cocos2DTest
//
//  Created by Dominik Fehn on 18.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "chipmunk.h"


@interface ChipmunkObject : NSObject {
	// Sprite for chipmunk body
	AtlasSprite *sprite;
	// Chipmunk body
	cpBody *body;
	// Chipmunk shape
	cpShape *shape;
	// Object velocity
	cpVect velocity;
	// Is object disposed?
	BOOL destroyed;
}

@property(nonatomic, retain) AtlasSprite *sprite;
@property(nonatomic, assign) cpVect velocity;
@property(nonatomic) cpBody *body;

-(void) dealloc:(id)caller inSpace:(cpSpace *)space; 

-(cpVect)getPosition;
-(void)setPosition:(cpVect)p;
-(cpVect)getVelocity;
-(void)setVelocity:(cpVect)v;

@end

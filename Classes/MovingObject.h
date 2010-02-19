//
//  MovingObject.h
//  iSpaceOut
//
//  Created by Dominik Fehn on 13.10.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChipmunkObject.h"


@interface MovingObject : ChipmunkObject {
	// Is object ready for use?
	bool ready;
	// Object start position, e.g. off screen
	cpVect startPosition;
	// Flag to indicate, if object has been 
	// destroyed in a collision
	bool objectCollided;

}

@property (readwrite) bool ready;
@property (readwrite) bool objectCollided;

// Init implementation for all objects, basically setting initial states
-(void)initImplX:(float)x Y:(float)y Sprite:(AtlasSprite *)atlasSprite;
// Update method
-(void)update: (ccTime)delta;
// Set Position back to start position
-(void) resetPosition;
// Start moving object
-(void) startMovingFromX:(float)x Y:(float)y velocity:(cpVect)v;

@end

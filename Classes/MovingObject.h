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

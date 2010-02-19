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

@interface Bullet : ChipmunkObject {
	bool ready;
	cpVect startPosition;
	bool bulletUsed;
	cpSpace *_space;
	bool _needsToBeSetBack;
}
-(id)initWithCpSpace: (cpSpace *)space X:(float)x Y:(float)y velocity:(cpVect)v Sprite:(AtlasSprite *)atlasSprite; 
-(void)update: (ccTime)delta;
-(void) fireFromX: (float) x y:(float)y angle:(float)a levelFactor:(int)level;
-(float) getX;
-(void) setX:(float)x;
-(float) getY;
-(void) setY:(float)y;
-(void) resetPosition;

@property(readwrite) bool ready;
@property(readwrite) bool bulletUsed;

@end

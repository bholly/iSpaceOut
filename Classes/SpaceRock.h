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
#import "MovingObject.h"

enum SpaceRockType {
	BigSpaceRock,
	SmallSpaceRock
};

@interface SpaceRock : MovingObject {
	enum SpaceRockType type;
}

@property (readwrite) enum SpaceRockType type;

-(id)initBigRockWithCpSpace: (cpSpace *)space X:(float)x Y:(float)y velocity:(cpVect)v Sprite:(AtlasSprite *)atlasSprite;
-(id)initSmallRockWithCpSpace: (cpSpace *)space X:(float)x Y:(float)y velocity:(cpVect)v Sprite:(AtlasSprite *)atlasSprite;

@end

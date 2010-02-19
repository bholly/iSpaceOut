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

#import "Level.h"


@implementation Level

@synthesize spaceRockSpeedDivisor;
@synthesize number;
@synthesize spaceRockGenerationDivisor;

-(id) init {
	if ((self = [super init]))
	{
		number = 1;
		spaceRockSpeedDivisor = 5.0f;
		spaceRockGenerationDivisor = 10.0f;
	}
	return self;
}

// Increase level and it's values
-(void) increase {
	number += 1;
	if (spaceRockSpeedDivisor > 0.5f)
	{
		spaceRockSpeedDivisor -= 0.5;
	}
	if (spaceRockGenerationDivisor > 1)
	{
		spaceRockGenerationDivisor -= 1;
	}
}

#pragma mark Serialization, NSCoding
-(void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeInt:number forKey:@"level_number"];
	[aCoder encodeFloat:spaceRockSpeedDivisor forKey:@"level_spaceRockSpeedDivisor"];
	[aCoder encodeFloat:spaceRockGenerationDivisor forKey:@"level_spaceRockGenerationDivisor"];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super init]))
	{
		number = [aDecoder decodeIntForKey:@"level_number"];
		spaceRockSpeedDivisor = [aDecoder decodeFloatForKey:@"level_spaceRockSpeedDivisor"];
		spaceRockGenerationDivisor = [aDecoder decodeFloatForKey:@"level_spaceRockGenerationDivisor"];
	}
	return self;
}

@end

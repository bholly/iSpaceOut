//
//  Level.m
//  iSpaceOut
//
//  Created by Dominik Fehn on 29.09.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

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

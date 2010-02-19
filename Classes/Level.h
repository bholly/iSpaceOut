//
//  Level.h
//  iSpaceOut
//
//  Created by Dominik Fehn on 29.09.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Level : NSObject <NSCoding> {
	int number;
	float spaceRockSpeedDivisor;
	float spaceRockGenerationDivisor;
}

@property (readonly) int number;
@property (readonly) float spaceRockSpeedDivisor;
@property (readonly) float spaceRockGenerationDivisor;

-(void)increase;

@end

//
//  BitmapFontAppearing.h
//  iSpaceOut
//
//  Created by Dominik Fehn on 04.11.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface BitmapFontAppearing : BitmapFontAtlas {
	// Save text for changing string
	// tick by tick
	NSString *text;
	// Position in string
	int textPosition;
	// Length of all text
	int textLength;
	// Flag to be able to break animation
	bool shouldStop;
}

// Init 
-(id)initWithString:(NSString *)string fntFile:(NSString *)fntFile;
// Tick for animating font
-(void)intervalTick;
// Start animation
-(void)startWithInterval:(float)t;
// Stop animation
-(void)stop;

@end

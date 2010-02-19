//
//  BitmapFontAppearing.m
//  iSpaceOut
//
//  Created by Dominik Fehn on 04.11.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BitmapFontAppearing.h"
#import "SimpleAudioEngine.h"


@implementation BitmapFontAppearing

-(id)initWithString:(NSString *)string fntFile:(NSString *)fntFile
{
	// Init with no text, cause we'll set that step by step
	self = [super initWithString:@"" fntFile:fntFile];
	if (self != nil)
	{
		textPosition = 0;
		text = [string retain];
		textLength = [text length];
	}
	return self;
}

-(void)startWithInterval:(float)t
{
	shouldStop = NO;
	// Start timer
	[self schedule:@selector(intervalTick) interval:t];
}

-(void)stop
{
	shouldStop = YES;
}

-(void)intervalTick
{
	// Do it as long as we're moving through string
	if ((!shouldStop) && (textPosition <= textLength))
	{
		[[SimpleAudioEngine sharedEngine] playEffect:@"keyHit.caf"];
		NSString *newString = [text substringToIndex:textPosition];
		[self setString:newString];
		textPosition++;
	} // Otherwise unschedule timer
	else {
		[self unschedule:@selector(intervalTick)];
	}

}

-(void)dealloc
{
	[text release];
	[super dealloc];
}

@end

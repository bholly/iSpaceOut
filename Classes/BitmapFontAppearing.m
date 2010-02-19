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

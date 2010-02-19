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

#import "PauseLayer.h"
#import "iSpaceOutAppDelegate.h"
#import "GameLayer.h"


@implementation PauseLayer

-(id)init 
{ 
	self = [super init]; 
	if(self != nil) 
	{ 
		Sprite *roundedFrame = [Sprite spriteWithFile:@"roundedMetalFrame.png"];
		roundedFrame.position = ccp(240, 160);
		[roundedFrame setOpacity:150];
		[self addChild:roundedFrame];  
		
		// Continue
		BitmapFontAtlas *continueLabel = [BitmapFontAtlas bitmapFontAtlasWithString:@"Continue" fntFile:@"punkGreen.fnt"];
		MenuItemLabel *continueItem = [MenuItemLabel itemWithLabel:continueLabel target:self selector:@selector(menuCallbackContinue:)];
		// Settings
		BitmapFontAtlas *exitLabel = [BitmapFontAtlas bitmapFontAtlasWithString:@"Quit Game" fntFile:@"punkGreen.fnt"];
		MenuItemLabel *exitItem = [MenuItemLabel itemWithLabel:exitLabel target:self selector:@selector(menuCallbackExit:)]; 
		Menu *menu = [Menu menuWithItems:continueItem, exitItem, nil]; 
		[menu alignItemsVertically]; 
		[self addChild:menu]; 
	} 
	return self; 
} 

-(void)menuCallbackContinue:(id)sender
{
	// Set GameLayer not paused
	[((GameLayer *)self.parent) setPaused:NO];
	// Remove this layer
	[self.parent removeChild:self cleanup:YES];
	// Restart director
	[[Director sharedDirector] resume];
}

-(void)menuCallbackExit:(id)sender
{
	iSpaceOutAppDelegate *appDelegate = (iSpaceOutAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate applicationWillTerminate:[UIApplication sharedApplication]];
	exit(0);
}

@end

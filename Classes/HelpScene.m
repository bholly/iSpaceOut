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

#import "HelpScene.h"
#import "MainMenuScene.h"


@implementation HelpScene

-(id)init
{
	if ((self = [super init]))
	{
		NSString *dir = [[NSBundle mainBundle] resourcePath];
		NSString *path = [dir stringByAppendingPathComponent:@"manual.txt"];
		NSString *helpText = [[NSString alloc] initWithContentsOfFile:path];
		Label *helpLabel = [Label labelWithString:helpText dimensions:CGSizeMake(460, 250) alignment:UITextAlignmentCenter fontName:@"Marker Felt" fontSize:16];
		
		
		helpLabel.position = ccp(240, 160);
		[self addChild:helpLabel z:0];
		[helpText release];
		
		// Quit
		BitmapFontAtlas *backLabel = [BitmapFontAtlas bitmapFontAtlasWithString:@"Back to main menu" fntFile:@"punkGreen.fnt"];
		MenuItemLabel *backItem = [MenuItemLabel itemWithLabel:backLabel target:self selector:@selector(menuCallbackBack:)];
		
		// Create menu one back item
		Menu *menu = [Menu menuWithItems:backItem, nil];
		[menu alignItemsHorizontally];
		[menu setPosition:ccp(240, 30)];
		[self addChild:menu z:1];
	}
	return self;
}

-(void)menuCallbackBack:(id)sender
{
	[[Director sharedDirector] replaceScene:[ShrinkGrowTransition transitionWithDuration:1.0f scene:[MainMenuScene node]]];
	
}

@end

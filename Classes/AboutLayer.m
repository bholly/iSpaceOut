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

#import "AboutLayer.h"


@implementation AboutLayer

-(id)init 
{ 
	self = [super init]; 
	if(self != nil) 
	{ 
		Sprite *roundedFrame = [Sprite spriteWithFile:@"roundedMetalFrame.png"];
		roundedFrame.position = ccp(240, 160);
		[roundedFrame setOpacity:200];
		[self addChild:roundedFrame]; 
		
		
		// Label with About info
		BitmapFontAtlas *developedLabel1 = [BitmapFontAtlas bitmapFontAtlasWithString:@"V1.2 Developed and written by" 
																			 fntFile:@"KrungthepGreen.fnt"];
		[developedLabel1 setColor:ccc3(255, 0, 200)];
		BitmapFontAtlas *developedLabel2 = [BitmapFontAtlas bitmapFontAtlasWithString:@"highestfloor.com" 
																			  fntFile:@"KrungthepGreen.fnt"];
		[developedLabel2 setColor:ccc3(255,0,200)];
		developedLabel1.position = ccp(240, 200);
		developedLabel2.position = ccp(240, 160);
		[self addChild:developedLabel1];
		[self addChild:developedLabel2];
		
		// BackToMainMenu label
		BitmapFontAtlas *continueLabel = [BitmapFontAtlas bitmapFontAtlasWithString:@"OK" fntFile:@"punkGreen.fnt"];
		MenuItemLabel *continueItem = [MenuItemLabel itemWithLabel:continueLabel target:self selector:@selector(menuCallbackContinue:)];

		Menu *menu = [Menu menuWithItems:continueItem, nil]; 
		[menu alignItemsVertically];
		menu.position = ccp(240, 100);
		[self addChild:menu]; 
	} 
	return self; 
}

-(void)menuCallbackContinue:(id)sender
{
	// Remove this layer
	[self.parent removeChild:self cleanup:YES];
}

@end

//
//  AboutLayer.m
//  iSpaceOut
//
//  Created by Dominik Fehn on 06.11.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

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
		BitmapFontAtlas *developedLabel1 = [BitmapFontAtlas bitmapFontAtlasWithString:@"Developed and written by" 
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

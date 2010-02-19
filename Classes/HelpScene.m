//
//  HelpScene.m
//  iSpaceOut
//
//  Created by Dominik Fehn on 03.11.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

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

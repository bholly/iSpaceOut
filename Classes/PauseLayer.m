//
//  PauseLayer.m
//  iSpaceOut
//
//  Created by Dominik Fehn on 16.10.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

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

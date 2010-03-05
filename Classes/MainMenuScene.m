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

#import "MainMenuScene.h"
#import "GameScene.h"
#import "SimpleAudioEngine.h"
#import "iSpaceOutAppDelegate.h"
#import "HelpScene.h"
#import "AboutLayer.h"
#import "OptionsScene.h"


@implementation MainMenuScene

-(void)dealloc
{
	[self removeAllChildrenWithCleanup:YES];
	[super dealloc];
}

#pragma mark Init
-(id) init {
	if ((self = [super init]))
	{
		// Background
		Sprite *bg = [[Sprite alloc] initWithFile:@"menu_background.png"];
		[bg setPosition:ccp(240,160)];
		[self addChild:bg z:0];
		[bg release];
		
		if (![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying])
		{
			[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"anabolic-haemorroids.mp3"];
		}
		
		// Particle emitter
		/*
		ParticleGalaxy *galaxy = [ParticleGalaxy node];
		ccColor4F startColor = {0.5f, 0.8f, 0.9f, 0.2f};
		[galaxy setStartColor:startColor];
		ccColor4F endColor = {0.2f, 0.7f, 0.5f, 0.05f};
		[galaxy setEndColor:endColor];
		[galaxy setPosition:ccp(240, 20)];
		[galaxy setRadialAccel:40.0f];
		// [galaxy setGravity:ccp(160,300)];
		[self addChild:galaxy z:1];
		 */
		ParticleSun *sun = [ParticleSun node];
		[sun setPosition:ccp(240,30)];
		[self addChild:sun z:1];
		
		// Play
		BitmapFontAtlas *playLabel = [BitmapFontAtlas bitmapFontAtlasWithString:@"Play" fntFile:@"punkGreen.fnt"];
		MenuItemLabel *playItem = [MenuItemLabel itemWithLabel:playLabel target:self selector:@selector(menuCallbackPlay:)];
		// Settings
		BitmapFontAtlas *helpLabel = [BitmapFontAtlas bitmapFontAtlasWithString:@"Help" fntFile:@"punkGreen.fnt"];
		MenuItemLabel *helpItem = [MenuItemLabel itemWithLabel:helpLabel target:self selector:@selector(menuCallbackHelp:)];
		// Options
		BitmapFontAtlas *optionsLabel = [BitmapFontAtlas bitmapFontAtlasWithString:@"Options" fntFile:@"punkGreen.fnt"];
		MenuItemLabel *optionItem = [MenuItemLabel itemWithLabel:optionsLabel target:self selector:@selector(menuCallbackOptions:)];
		// About
		BitmapFontAtlas *aboutLabel = [BitmapFontAtlas bitmapFontAtlasWithString:@"About" fntFile:@"punkGreen.fnt"];
		MenuItemLabel *aboutItem = [MenuItemLabel itemWithLabel:aboutLabel target:self selector:@selector(menuCallbackAbout:)];
		// Quit
		BitmapFontAtlas *quitLabel = [BitmapFontAtlas bitmapFontAtlasWithString:@"Quit" fntFile:@"punkGreen.fnt"];
		MenuItemLabel *quitItem = [MenuItemLabel itemWithLabel:quitLabel target:self selector:@selector(menuCallbackQuit:)];
		
		// Create menu with items and align it
		_menu = [Menu menuWithItems:playItem, helpItem, optionItem, aboutItem, quitItem, nil];
		[_menu alignItemsVertically];
		[_menu setPosition:ccp(240, 120)];
		[self addChild:_menu z:2];
	}
	return self;
}


#pragma mark Menu Callbacks
-(void)menuCallbackPlay:(id)sender {
	[[Director sharedDirector] replaceScene:[ShrinkGrowTransition transitionWithDuration:1.0f scene:[GameScene node]]];
}

-(void)menuCallbackHelp:(id)sender {
	[[Director sharedDirector] replaceScene:[ShrinkGrowTransition transitionWithDuration:1.0f scene:[HelpScene node]]];
}

-(void)menuCallbackOptions:(id)sender {
	[[Director sharedDirector] replaceScene:[ShrinkGrowTransition transitionWithDuration:1.0f scene:[OptionsScene node]]];
}

-(void)menuCallbackAbout:(id)sender {
	// Add About layer
	[self addChild:[AboutLayer node] z:2];
}

-(void)menuCallbackQuit:(id)sender {
	iSpaceOutAppDelegate *appDelegate = (iSpaceOutAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate applicationWillTerminate:[UIApplication sharedApplication]];
	exit(0);
}

@end

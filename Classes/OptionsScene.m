//
//  OptionsScene.m
//  iSpaceOut
//
//  Created by Dominik Fehn on 05.03.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "OptionsScene.h"
#import "MainMenuScene.h"


@implementation OptionsScene

-(id)init {
	if ((self = [super init]))
	{
		// Get music volume and Sound FX from user defaults
		buttonsLeft = [[NSUserDefaults standardUserDefaults] boolForKey:@"enable_buttonsLeft"];
		musicVolume = [[NSUserDefaults standardUserDefaults] integerForKey:@"musicVolume"];
		soundFxVolume = [[NSUserDefaults standardUserDefaults] integerForKey:@"soundFXVolume"];
		
		// Labels
		BitmapFontAtlas *optionsHeaderLabel = [BitmapFontAtlas bitmapFontAtlasWithString:@"Options" fntFile:@"punkGreen.fnt"];
		[optionsHeaderLabel setPosition:ccp(240, 280)];
		[self addChild:optionsHeaderLabel z:1];
		BitmapFontAtlas *buttonsLeftLabel = [BitmapFontAtlas bitmapFontAtlasWithString:@"Buttons left" fntFile:@"KrungthepGreen.fnt"];
		[buttonsLeftLabel setPosition:ccp(100,220)];
		[self addChild:buttonsLeftLabel];
		BitmapFontAtlas *musicVolumeLabel = [BitmapFontAtlas bitmapFontAtlasWithString:@"Music Volume" fntFile:@"KrungthepGreen.fnt"];
		[musicVolumeLabel setPosition:ccp(100, 160)];
		[self addChild:musicVolumeLabel z:1];
		BitmapFontAtlas *soundFxVolumeLabel = [BitmapFontAtlas bitmapFontAtlasWithString:@"Sound FX Volume" fntFile:@"KrungthepGreen.fnt"];
		[soundFxVolumeLabel setPosition:ccp(100, 100)];
		[self addChild:soundFxVolumeLabel z:1];
		
		// Toggle Switch
		MenuItemImage *buttonsLeftButtonOn = [MenuItemImage itemFromNormalImage:@"sliderthumb.png" selectedImage:@"sliderthumbsel.png"];
		MenuItemImage *buttonsLeftButtonOff = [MenuItemImage itemFromNormalImage:@"sliderthumbsel.png" selectedImage:@"sliderthumbsel.png"];
		MenuItemToggle *toggle = [MenuItemToggle itemWithTarget:self selector:@selector(buttonsLeftButtonCallback:) items:buttonsLeftButtonOn, buttonsLeftButtonOff, nil];
		toggle.selectedIndex = (int)buttonsLeft;;
		Menu *menuDummy = [Menu menuWithItems:toggle, nil]; 
		[menuDummy alignItemsVertically];
		menuDummy.position = ccp(240, 225);
		[self addChild:menuDummy];
		
		// Music volume slider
		Slider *musicVolumeSlider = [[[Slider alloc] initWithTarget:self 
												selector:@selector(musicVolumeSliderCallback:)] autorelease];
		musicVolumeSlider.value = musicVolume / 100.0f;
		[musicVolumeSlider setPosition:ccp(240, 140)];
		[self addChild:musicVolumeSlider z:1];
		
		// Sound fx slider
		Slider *soundFxSlider = [[[Slider alloc] initWithTarget:self 
													   selector:@selector(soundFxVolumeSliderCallback:)] autorelease];
		soundFxSlider.value = soundFxVolume / 100.0f;
		[soundFxSlider setPosition:ccp(240, 80)];
		[self addChild:soundFxSlider z:1];
		
		// Save
		BitmapFontAtlas *saveLabel = [BitmapFontAtlas bitmapFontAtlasWithString:@"Save" fntFile:@"punkGreen.fnt"];
		MenuItemLabel *saveItem = [MenuItemLabel itemWithLabel:saveLabel target:self selector:@selector(menuCallbackSaveOptions:)];
		
		// Cancel
		BitmapFontAtlas *cancelLabel = [BitmapFontAtlas bitmapFontAtlasWithString:@"Cancel" fntFile:@"punkGreen.fnt"];
		MenuItemLabel *cancelItem = [MenuItemLabel itemWithLabel:cancelLabel target:self selector:@selector(menuCallbackCancelOptions:)];
		
		// Create menu one back item
		Menu *menu = [Menu menuWithItems:saveItem, cancelItem, nil];
		[menu alignItemsHorizontally];
		[menu setPosition:ccp(240, 30)];
		[self addChild:menu z:1];
		
	}
	return self;
}

-(void)buttonsLeftButtonCallback:(id)sender
{
	buttonsLeft = !buttonsLeft;
}

-(void)musicVolumeSliderCallback:(SliderThumb *)sender
{
	musicVolume = [sender value] * 100;
}

-(void)soundFxVolumeSliderCallback:(SliderThumb *)sender
{
	soundFxVolume = [sender value] * 100;
}

-(void)menuCallbackSaveOptions:(id)sender
{
	[[NSUserDefaults standardUserDefaults] setInteger:musicVolume forKey:@"musicVolume"];
	[[NSUserDefaults standardUserDefaults] setInteger:soundFxVolume forKey:@"soundFXVolume"];
	[[NSUserDefaults standardUserDefaults] setBool:buttonsLeft forKey:@"enable_buttonsLeft"];
	[[Director sharedDirector] replaceScene:[ShrinkGrowTransition transitionWithDuration:1.0f scene:[MainMenuScene node]]];
}

-(void)menuCallbackCancelOptions:(id)sender
{
	[[Director sharedDirector] replaceScene:[ShrinkGrowTransition transitionWithDuration:1.0f scene:[MainMenuScene node]]];
}

@end

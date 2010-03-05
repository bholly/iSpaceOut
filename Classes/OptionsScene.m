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
		musicVolume = [[NSUserDefaults standardUserDefaults] integerForKey:@"musicVolume"];
		soundFxVolume = [[NSUserDefaults standardUserDefaults] integerForKey:@"soundFXVolume"];
		
		// Labels
		BitmapFontAtlas *musicVolumeLabel = [BitmapFontAtlas bitmapFontAtlasWithString:@"Music Volume" fntFile:@"KrungthepGreen.fnt"];
		[musicVolumeLabel setPosition:ccp(100, 240)];
		[self addChild:musicVolumeLabel z:1];
		BitmapFontAtlas *soundFxVolumeLabel = [BitmapFontAtlas bitmapFontAtlasWithString:@"Sound FX Volume" fntFile:@"KrungthepGreen.fnt"];
		[soundFxVolumeLabel setPosition:ccp(100, 160)];
		[self addChild:soundFxVolumeLabel z:1];
		
		
		// Music volume slider
		Slider *musicVolumeSlider = [[[Slider alloc] initWithTarget:self 
												selector:@selector(musicVolumeSliderCallback:)] autorelease];
		musicVolumeSlider.value = musicVolume / 100.0f;
		[musicVolumeSlider setPosition:ccp(240, 200)];
		[self addChild:musicVolumeSlider z:1];
		
		// Sound fx slider
		Slider *soundFxSlider = [[[Slider alloc] initWithTarget:self 
													   selector:@selector(soundFxVolumeSliderCallback:)] autorelease];
		soundFxSlider.value = soundFxVolume / 100.0f;
		[soundFxSlider setPosition:ccp(240, 120)];
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
	[[Director sharedDirector] replaceScene:[ShrinkGrowTransition transitionWithDuration:1.0f scene:[MainMenuScene node]]];
}

-(void)menuCallbackCancelOptions:(id)sender
{
	[[Director sharedDirector] replaceScene:[ShrinkGrowTransition transitionWithDuration:1.0f scene:[MainMenuScene node]]];
}

@end

//
//  iSpaceOutAppDelegate.m
//  iSpaceOut
//
//  Created by Dominik Fehn on 04.09.09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "iSpaceOutAppDelegate.h"
#import "cocos2d.h"
#import "MainMenuScene.h"
#import "GameScene.h"
#import "GameLayer.h"

@implementation iSpaceOutAppDelegate

@synthesize window;

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	// cocos2d will inherit these values
	[window setUserInteractionEnabled:YES];	
	[window setMultipleTouchEnabled:YES];
	
	// must be called before any othe call to the director
	// WARNING: FastDirector doesn't interact well with UIKit controls
	// [Director useFastDirector];
	
	// before creating any layer, set the landscape mode
	[[Director sharedDirector] setDeviceOrientation:CCDeviceOrientationLandscapeLeft];
	[[Director sharedDirector] setAnimationInterval:1.0/60];
	[[Director sharedDirector] setDisplayFPS:YES];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[Texture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA4444];
	
	// create an openGL view inside a window
	[[Director sharedDirector] attachInView:window];	
	[window makeKeyAndVisible];		
		
		
	[[Director sharedDirector] runWithScene: [MainMenuScene node]];
}


- (void)applicationWillResignActive:(UIApplication *)application {
	[[Director sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[[Director sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[TextureMgr sharedTextureMgr] removeAllTextures];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	id currentScene = [[Director sharedDirector] runningScene];
	// Create a savegame, if we're in a running game
	if ([currentScene isKindOfClass:[GameScene class]])
	{
		GameScene *gameScene = (GameScene *)currentScene;
		GameLayer *gameLayer = [gameScene gameLayer];
		NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:gameLayer];
		[encodedObject writeToFile:[self saveGamePath] atomically:YES];
	}
	else { // otherwise remove a possibly existing savegame
		NSFileManager *fileManager = [NSFileManager defaultManager];
		[fileManager removeItemAtPath:[self saveGamePath] error:NULL];
	}
	[[Director sharedDirector] end];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[Director sharedDirector] setNextDeltaTimeZero:YES];
}

- (NSString *)saveGamePath
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:@"saveGame"];
}

- (void)dealloc {
	[[Director sharedDirector] release];
	[window release];
	[super dealloc];
}

@end

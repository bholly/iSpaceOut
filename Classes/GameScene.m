//
//  GameScene.m
//  Cocos2DTest
//
//  Created by Dominik Fehn on 07.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "iSpaceOutAppDelegate.h"

@implementation GameScene

@synthesize gameLayer;

- (id) init {
    self = [super init];
    if (self != nil) {
		NSFileManager *fileManager = [NSFileManager defaultManager];
		iSpaceOutAppDelegate *delegate = (iSpaceOutAppDelegate *)[[UIApplication sharedApplication] delegate];
		saveGamePath = [[delegate saveGamePath] retain];
		if ([fileManager fileExistsAtPath:saveGamePath]) {
			[self CreateAlertView];
		}
		else {
			gameLayer = [GameLayer node];
			[self addChild:gameLayer z:0];
		}
    }
    return self;
}

-(void)CreateAlertView
{
	UIAlertView* dialog = [[UIAlertView alloc] init]; 
	[dialog setDelegate:self]; 
	[dialog setTitle:@"There's a saved game, would you like to continue?"]; 
	[dialog setMessage:@"Save game detected"]; 
	[dialog addButtonWithTitle:@"Cancel"]; 
	[dialog addButtonWithTitle:@"OK"]; 
	[dialog show];
	[dialog release]; 
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1)
	{
		NSData *data = [[NSData alloc] initWithContentsOfFile:saveGamePath];
		gameLayer = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	}
	else {
		gameLayer = [GameLayer node];
	}
	[self addChild:gameLayer z:0];

}
@end
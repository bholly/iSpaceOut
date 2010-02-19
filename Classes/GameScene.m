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
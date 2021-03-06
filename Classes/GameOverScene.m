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

#import "GameOverScene.h"
#import "SimpleAudioEngine.h"
#import "iSpaceOutAppDelegate.h"
#import "GameScene.h"
#import "ScoreServer.h"


@implementation GameOverScene
- (id) initWithScore:(int)score {
    self = [super init];
    if (self != nil) {
        [self addChild:[[GameOverLayer alloc] initWithScore:score] z:0];
    }
    return self;
}
@end

@implementation GameOverLayer

-(void)dealloc
{
	if (serverStateLabel)
	{
		[serverStateLabel release];
	}
	[label release];
	[super dealloc];
}

- (id) initWithScore:(int)score {
    self = [super init];
    if (self != nil) {
		
		_score = score;
		
		// Game over label with effect
		CGSize winSize = [[Director sharedDirector] winSize];
		label = [Label labelWithString:@"Game Over!" fontName:@"Marker Felt" fontSize:60];
		label.position = ccp(winSize.width / 2, winSize.height * 0.75);
		Liquid *liquidEffect = [Liquid actionWithWaves:2 amplitude:1.5f grid:ccg(15, 10) duration:2.0f];
		[label runAction: [RepeatForever actionWithAction: liquidEffect]];
		
		[self addChild:label z:0];
		
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"shadowingprt2.mp3"];
		
		// Continue with new game label
		BitmapFontAtlas *continueLabel = [BitmapFontAtlas bitmapFontAtlasWithString:@"New game" fntFile:@"punkGreen.fnt"];
		MenuItemLabel *continueItem = [MenuItemLabel itemWithLabel:continueLabel target:self selector:@selector(menuCallbackNewGame:)];
		// Quit game label
		BitmapFontAtlas *exitLabel = [BitmapFontAtlas bitmapFontAtlasWithString:@"Quit Game" fntFile:@"punkGreen.fnt"];
		MenuItemLabel *exitItem = [MenuItemLabel itemWithLabel:exitLabel target:self selector:@selector(menuCallbackExit:)]; 
		Menu *menu = [Menu menuWithItems:continueItem, exitItem, nil]; 
		[menu alignItemsHorizontally];
		[menu setPosition:ccp(240,30)];
		[self addChild:menu z:1];
		
		[self CreateInputBox];
		
	}
	return self;
}

-(void)menuCallbackNewGame:(id)sender
{
	[[Director sharedDirector] replaceScene:[ShrinkGrowTransition transitionWithDuration:1.0f scene:[GameScene node]]];
}

-(void)menuCallbackExit:(id)sender
{
	iSpaceOutAppDelegate *appDelegate = (iSpaceOutAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegate applicationWillTerminate:[UIApplication sharedApplication]];
	exit(0);
}

#pragma mark Name input

-(void)CreateInputBox
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter name" message:@"for high score server\n\n\n" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"Okay", nil];
	nameField = [[UITextField alloc] initWithFrame:CGRectMake(10.0, 60.0, 262.0, 31.0)];
	// [nameField setDelegate:self];
	[nameField setPlaceholder:@"Your name"];
	[nameField setBorderStyle:UITextBorderStyleBezel];
	[nameField setOpaque:NO];
	[nameField setFont:[UIFont fontWithName:@"Helvetica" size:19.0]];
	[nameField setTextColor:[UIColor whiteColor]];
	[nameField setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.0]];
	[nameField setTextAlignment:UITextAlignmentLeft];
	[nameField setKeyboardAppearance:UIKeyboardAppearanceAlert];
	[nameField becomeFirstResponder];
	[alert addSubview:nameField];
	[alert show];
	[alert release];
	/*
	UIAlertView* dialog = [[UIAlertView alloc] init]; 
	[dialog setDelegate:self]; 
	[dialog setTitle:@"Enter Name"]; 
	[dialog setMessage:@"for high score server\n"]; 
	[dialog addButtonWithTitle:@"Cancel"]; 
	[dialog addButtonWithTitle:@"OK"];
	dialog.frame = CGRectMake( 0, 0, 300, 260);
	nameField = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 45.0, 245.0, 25.0)]; 
	[nameField setBackgroundColor:[UIColor whiteColor]]; 
	[nameField setText: @"user name"]; 
	[dialog addSubview:nameField];
	// CGAffineTransform moveUp = CGAffineTransformMakeTranslation(0.0, 100.0); 
	// [dialog setTransform: moveUp]; 
	[dialog show]; 
	[nameField becomeFirstResponder];
	[nameField release];
	[dialog release]; 
	 */
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1)
	{
		NSString *name;
		if ([[nameField text] length] > 10)
		{
			name = [[nameField text] substringToIndex:9];
		}
		else {
			name = [nameField text];
		}

		BitmapFontAppearing *scoreMessageLabel = [[BitmapFontAppearing alloc] 
												  initWithString:[NSString stringWithFormat:@"Congratulations %@, your Score is %d", name, _score] 
												  fntFile:@"KrungthepGreen.fnt"];
		scoreMessageLabel.position = ccp(240,160);
		[self addChild:scoreMessageLabel z:1];
		[scoreMessageLabel startWithInterval:kFontAnimationSpeed];
		[scoreMessageLabel release];
		
		serverStateLabel = [[BitmapFontAppearing alloc] initWithString:@"Please wait, posting score to server ..." fntFile:@"KrungthepGreen.fnt"];
		serverStateLabel.position = ccp(240, 120);
		[self addChild:serverStateLabel z:1];
		[serverStateLabel startWithInterval:kFontAnimationSpeed];
		
		// Post to server
		ScoreServer *server = [[ScoreServer alloc] init];
		[server postScore:_score forPlayer:name postDelegate:self];
		[server release];
	}
}

// PostScore Delegate
-(void) scorePostOk: (id) sender
{
	[serverStateLabel stop];
	[serverStateLabel setString:@"Score post successful"];
	// Score post successful
	
	// Request rank
	ScoreServer *server = [[ScoreServer alloc] init];
	[server requestScoreRank:_score requestRankDelegate:self];
	[server release];
}

-(void) scorePostFail: (id) sender
{
	// score post failed
	// 
	tPostStatus status = [sender postStatus];
	if( status == kPostStatusPostFailed ) {
		// an error with the server ?
		// try again
		[serverStateLabel stop];
		[serverStateLabel setString:@"Score post: Error with server"];
	}
	else if( status == kPostStatusConnectionFailed ) {
		// a error establishing the connection ?
		// turn-on wifi, and then try again
		[serverStateLabel stop];
		[serverStateLabel setString:@"Score post: Error with connection"];
	}
}

// Just to avoid compiler warning
-(void) scoreRequestOk:(id)sender
{
}

// ScoreRequest delegate
-(void) scoreRequestRankOk: (id) sender
{
	// Parse rank
	int rank = [sender parseRank];
	
	BitmapFontAppearing *rankLabel = [[BitmapFontAppearing alloc] initWithString:
										  [NSString stringWithFormat:@"Your rank in high score list: %d", rank] fntFile:@"KrungthepGreen.fnt"];
	rankLabel.position = ccp(240, 80);
	[self addChild:rankLabel z:1];
	[rankLabel startWithInterval:kFontAnimationSpeed];
	[rankLabel release];
	
}

-(void) scoreRequestFail: (id) sender
{
	BitmapFontAppearing *rankLabel = [[BitmapFontAtlas alloc] initWithString:
								  [NSString stringWithFormat:@"Couldn't get ranking"] fntFile:@"KrungthepGreen.fnt"];
	rankLabel.position = ccp(240, 80);
	[self addChild:rankLabel z:1];
	[rankLabel startWithInterval:kFontAnimationSpeed];
	[rankLabel release];
}

@end


//
//  GameLayer.h
//  Cocos2DTest
//
//  Created by Dominik Fehn on 09.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Joystick.h"
#import "chipmunk.h"
#import "Bullet.h"
#import "SpaceRock.h"
#import "SpaceShip.h"
#import "Level.h"
#import "Gimmick.h"
#import "Button.h"

#define kSpaceRockSpeedDivisor 5.0
#define kFireButtonRightPosition ccp(438,42)
#define kFireButtonLeftPosition ccp(42,42)
#define kPauseButtonRightPosition ccp(454,254)
#define kPauseButtonLeftPosition ccp(26,254)

enum NodeTags {
	kScoreLabelTag = 0,
	kLabelTag = 1,
};

@interface GameLayer : Layer<GameButtonDelegate, NSCoding> {
	// Virtual joystick
	Joystick *joystick;
	// Chipmunk Space
	cpSpace *space;
	// Array of reusable bullets
	NSMutableArray *bullets;
	// Player = the Ship
	SpaceShip *theShip;
	// Array of reusable rocks
	NSMutableArray *rocks;
	// Array of reusable gimmicks
	NSMutableArray *gimmicks;
	// Fire button
	Button *fireButton;
	// Pause button
	Button *pauseButton;
	// Sprite sheet
	AtlasSpriteManager *sprites;
	// Game score
	int score;
	// Label to display score
	BitmapFontAtlas *scoreLabel;
	// Health bar
	ColorLayer *healthBar;
	// Game level
	Level *currentLevel;
	// Level increased label
	BitmapFontAtlas *levelIncreasedLabel;
	// Delay space rock generation timer in lower levels
	float spaceRockGenerationDelay;
	// Flag to indicate, if game is paused
	// Basically to prevent touch events being
	// directed to buttons
	BOOL paused;
	// Double fire mode
	BOOL doubleFire;
	// Left or right hand mode
	BOOL buttonsRight;
}

@property(nonatomic, readwrite) cpSpace *space;
@property(nonatomic, readwrite) int score;
@property(nonatomic, assign) BitmapFontAtlas *scoreLabel;
@property(nonatomic, assign) ColorLayer *healthBar;
@property(nonatomic, readonly) Level *currentLevel;
@property(nonatomic, readonly) AtlasSpriteManager *sprites;
@property(nonatomic, assign) BOOL doubleFire;

// Space rock creation offscreen
-(void)createSpaceRocks;
// Bullet creation
-(void)createBullets;
// Gimmick creation
-(void)createGimmicks;
// Explosion
-(void) createExplosionX: (float) x y: (float) y;
// Space Rock generation random mode
-(void) generateSpaceRock;
// Gimmick generation
-(void) generateGimmickX:(float)x Y:(float)y;
// Level timer method
-(void) levelTick;
// Health Bar setter
-(void) setValueOfHealthBar:(int)v;
// Button pressed handler
-(void)buttonPressed:(Button *)button;
// Paused setter and getter to be able to set
// pause button opacity when returning from PauseLayer
-(BOOL)paused;
-(void)setPaused:(BOOL)p;
// Method for ship shield timer
-(void)shieldEnded;
// Show a on screen fading in message
-(void)fadeInMessage:(NSString *)message;
// Method for double fire timer
-(void)doubleFireEnded;

@end
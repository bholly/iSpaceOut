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

#import "GameLayer.h"
#import "RockExplosion.h"
#import "SpaceRock.h"
#import "SimpleAudioEngine.h"
#import "GameOverScene.h"
#import "PauseLayer.h"

const int kNumberOfSpaceRocks = 10;

#pragma mark Collisions

// Chipmunk update physics bodies
static void eachShape(void *ptr, void* unused)
{
	cpShape *shape = (cpShape*) ptr;
	ChipmunkObject *object = shape->data;
	AtlasSprite *sprite = [object sprite];
	if( sprite ) {
		cpBody *body = shape->body;
		[sprite setPosition: cpv( body->p.x, body->p.y)];
		[sprite setRotation: (float) CC_RADIANS_TO_DEGREES( -body->a )];
	}
}

// Collision between SpaceRock (a) and bullet (b)
static int bulletCollision(cpShape *a, cpShape *b, cpContact *contacts, int numContacts, cpFloat normal_coef, void *data)
{
	// Destroy rock
	GameLayer *game = (GameLayer*) data;
	SpaceRock *rockObject = a->data;
	[rockObject setObjectCollided:YES];
	
	// Bullet is also used now
	Bullet *bullet = b->data;
	[bullet setBulletUsed:YES];
	
	// Maybe Generate gimmick
	int r = rand() % 10;
	if (r == 3)
	{
		[game generateGimmickX:[bullet getX] Y:[bullet getY]];
	}
	
	// Show explosion and increase score
	cpVect pos = a->body->p;
	RockExplosion *explosion;
	if ([rockObject type] == BigSpaceRock)
	{
		explosion = [[RockExplosion alloc] initWithTotalParticles:20];
		game.score += 5;
		[[SimpleAudioEngine sharedEngine] playEffect:@"bigRockExplosion.caf"];
	}
	else
	{
		explosion = [[RockExplosion alloc] initWithTotalParticles:4];
		game.score += 10;
		[[SimpleAudioEngine sharedEngine] playEffect:@"smallRockExplosion.caf"];
	}
	[explosion setPosition:pos];
	[game addChild:explosion z:3];
	// Release explosion
	if (explosion)
	{
		[explosion release];
	}
	[game.scoreLabel setString:[NSString stringWithFormat:@"Level %d    Score: %d", [game.currentLevel number], game.score]];
	
	return 1;
}

// Collision between ship (a) and SpaceRock (b)
static int shipCollision(cpShape *a, cpShape *b, cpContact *contacts, int numContacts, cpFloat normal_coef, void *data)
{
	// Decrease ship life
	GameLayer *game = (GameLayer*) data;
	SpaceShip *shipObject = a->data;
	[shipObject setLife:-1];
	
	// Play collision sound
	[[SimpleAudioEngine sharedEngine] playEffect:@"shipcrash.caf"];
	
	// Ship will blink
	[shipObject.sprite runAction:[Blink actionWithDuration:1.0f blinks:5]];
	
	// Draw bar
	[game setValueOfHealthBar:shipObject.life];
	if (shipObject.life < 1)
	{
		GameOverScene *goc = [[GameOverScene alloc] initWithScore:game.score];
		[[Director sharedDirector] replaceScene:goc];
		[goc release];
	}
	
	return 1;
}

// Collision between Ship (a) and Gimmick (b)
static int gimmickCollision(cpShape *a, cpShape *b, cpContact *contacts, int numContacts, cpFloat normal_coef, void *data)
{
	GameLayer *game = (GameLayer*) data;
	SpaceShip *ship = a->data;
	Gimmick *gimmick = b->data;
	
	[[SimpleAudioEngine sharedEngine] playEffect:@"arcadeBonus.caf"];
	
	if ([gimmick type] == ExtraLife)
	{
		[ship setLife:3];
		[game setValueOfHealthBar:ship.life];
		
	}
	if ([gimmick type] == BonusPoints)
	{
		game.score += 250;
		[game.scoreLabel setString:[NSString stringWithFormat:@"Level %d    Score: %d", [game.currentLevel number], game.score]];
	}
	if ([gimmick type] == Shield)
	{
		[ship setShield:YES];
		[game fadeInMessage:@"Shield activated"];
		[game schedule:@selector(shieldEnded) interval:15];
	}
	if ([gimmick type] == DoubleFire)
	{
		[game setDoubleFire:YES];
		[game fadeInMessage:@"Double fire"];
		[game schedule:@selector(doubleFireEnded) interval:30];
	}
	
	// "Destroy" gimmick
	[gimmick setObjectCollided:YES];
	return 1;
	
}


@implementation GameLayer

@synthesize space;
@synthesize score;
@synthesize scoreLabel;
@synthesize healthBar;
@synthesize currentLevel;
@synthesize sprites;
@synthesize doubleFire;

#pragma mark dealloc

- (void) dealloc {
	[joystick release];
	[theShip dealloc:self inSpace:space];
	[theShip release];
	for (Bullet *b in bullets)
	{
		[b dealloc:self inSpace:space];
	}
	[bullets release];
	for (SpaceRock *r in rocks)
	{
		[r dealloc:self inSpace:space];
	}
	[rocks release];
	for (Gimmick *g in gimmicks)
	{
		[g dealloc:self inSpace:space];
	}
	[gimmicks release];
	[currentLevel release];
	[pauseButton release];
	[fireButton release];
	cpSpaceFree(space);
	[super dealloc];
}

#pragma mark Init

- (id) init {
    self = [super init];
    if (self != nil) {
        isTouchEnabled = YES;
		CGSize winSize = [[Director sharedDirector] winSize];
		
		paused = NO;
		doubleFire = NO;
		
		// Joystick
		joystick = [[Joystick alloc] init:0 y:0 w:320 h:480];
		[self addChild:[joystick arrowSpriteManager] z:3];
		
		// Init chipmunk
		cpInitChipmunk();
		space = cpSpaceNew();
		cpSpaceResizeStaticHash(space, 100, 400); // 400.0f, 40
		cpSpaceResizeActiveHash(space, 100, 400); // 100, 600
		space->iterations = 5;
		space->gravity = cpv(0, 0);
		space->elasticIterations = space->iterations;
		
		// Update Chipmunk and game step
		[self schedule: @selector(step:)];
		
		// Level timer and Level itself
		currentLevel = [[Level alloc] init];
		[self schedule:@selector(levelTick) interval: 60.0];
		
		// Generate space rocks timer
		[self schedule:@selector(generateSpaceRock) interval: 0.2];
		
		// Game sprite sheet
		sprites = [AtlasSpriteManager spriteManagerWithFile:@"asteroidsSheet.png"];
		[self addChild:sprites z:2];
		
		// Background
		Sprite *bg = [Sprite spriteWithFile:@"starfield.png"];
		bg.position = cpv(240, 160);
		[self addChild:bg z:0];
		
		// Sun particle emitter
		ParticleSun *galaxy = [ParticleSun node];
		[galaxy setPosition:ccp(240, 160)];
		[self addChild:galaxy z:1];
		
		// Space Ship
		theShip = [[SpaceShip alloc] initWithCpSpace:space X:400 Y:50 
											  Sprite:[AtlasSprite spriteWithRect:CGRectMake(449, 311, 57, 26) spriteManager:sprites]];
		[sprites addChild:[theShip sprite] z:0];
		
		// Adjust buttons depending on settings
		buttonsRight = [[NSUserDefaults standardUserDefaults] boolForKey:@"enable_buttonsRight"];
		CGPoint fireButtonPos = kFireButtonRightPosition;
		CGPoint pauseButtonPos = kPauseButtonRightPosition;
		if (!buttonsRight)
		{
			fireButtonPos = kFireButtonLeftPosition;
			pauseButtonPos = kPauseButtonLeftPosition;
		}
		
		// Fire button
		fireButton = [[Button alloc] initWithSprite:@"fireButton.png" 
										atPosition:fireButtonPos
										opacity:kNotPressedOpacity 
										name:@"btnFire"];
		[fireButton setDelegate:self];
		[self addChild:fireButton z:3];
		
		// Pause button
		pauseButton = [[Button alloc] initWithSprite:@"pause.png" 
										atPosition:pauseButtonPos 
										opacity:kNotPressedOpacity
										name:@"btnPause"];
		[pauseButton setDelegate:self];
		[self addChild:pauseButton z:3];
		
		// Preload first sound and background music
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Chilled.mp3"];
		[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.7f];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"photon.caf"];
		
		// Label *label = [Label labelWithString:@"No touch by now..." fontName:@"Marker Felt" fontSize:20];
		// label.position =  ccp( winSize.width /2 , winSize.height/8);
		// [self addChild:label z:1 tag:kLabelTag];
	
		[self createBullets];
		
		// Init space rock generation delay
		spaceRockGenerationDelay = 0;
		[self createSpaceRocks];
		
		[self createGimmicks];
		
		// Collision between Rocks and Bullets
		cpSpaceAddCollisionPairFunc(space, 0, 2, &bulletCollision, self);
		// Collision between Ship and Rocks
		cpSpaceAddCollisionPairFunc(space, 1, 0, &shipCollision, self);
		// Collision between Gimmicks and Ship
		cpSpaceAddCollisionPairFunc(space, 1, 3, &gimmickCollision, self);
		
		// Score
		score = 0;
		scoreLabel = [BitmapFontAtlas bitmapFontAtlasWithString:
								 [NSString stringWithFormat:@"Level %d    Score: %d", [currentLevel number], score] fntFile:@"KrungthepGreen.fnt"];
		[scoreLabel setPosition:ccp(winSize.width * 0.3f, winSize.height * 0.94f)];
		[self addChild:scoreLabel z:3];
		
		levelIncreasedLabel = [BitmapFontAtlas bitmapFontAtlasWithString:@""
									fntFile:@"KrungthepGreen.fnt"];
		levelIncreasedLabel.position = ccp(240,160);
		[self addChild:levelIncreasedLabel z:3];
		
		// Health Bar
		healthBar = [ColorLayer layerWithColor:ccc4(0,255,0,kNotPressedOpacity) width:theShip.life * 10 height:20];
		healthBar.position = ccp(winSize.width * 0.75f, winSize.height * 0.92f);
		[self addChild:healthBar z:3];
		
    }
    return self;
}

#pragma mark Touches

// Redirect Touches to joystick
-(BOOL)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (!paused)
	{
		BOOL ret = kEventIgnored;
		// Pass touches to pause button
		[pauseButton ccTouchesBegan:touches withEvent:event];
	
		// Pass touches to fire button
		ret = [fireButton ccTouchesBegan:touches withEvent:event];
	
		if (ret == kEventIgnored)
		{
			// Pass touches on to joystick
			[joystick touchesBegan:touches withEvent:event];
		}
	}
	
	return kEventHandled;
}

-(BOOL)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	// Ignore movement, if fire button is pressed
	if (![fireButton pressed])
	{
		// Pass on to joystick
		[joystick touchesMoved:touches withEvent:event];
	}
	return kEventHandled;
}

-(BOOL)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	BOOL ret = [fireButton ccTouchesEnded:touches withEvent:event];
	if (ret == kEventIgnored)
	{
		// Pass on to joystick
		[joystick touchesEnded:touches withEvent:event];
	}
	// Reset fire button to be not pressed
	fireButton.opacity = kNotPressedOpacity;
	
	return kEventHandled;
}

#pragma mark Timed methods

// Chipmunk step
-(void) step: (ccTime) delta
{	
	// Get joystick value
	CGPoint velocity = [joystick getCurrentVelocity];
	CGPoint velAngle = [joystick getCurrentDegreeVelocity];
	
	int steps = 1;
	cpFloat dt = 1.0f/60.0f/(cpFloat)steps;
	
	for(int i=0; i<steps; i++){
		cpSpaceStep(space, dt);
	}
	cpSpaceHashEach(space->activeShapes, &eachShape, nil);
	// cpSpaceHashEach(space->staticShapes, &eachShape, nil);
	
	// Update ship
	[theShip updateWithJoystickVelocity:velocity andAngle:velAngle delta:delta];
	
	// Update bullets
	for(Bullet *b in bullets)
	{
		[b update:delta];
	}
	
	// Update rocks
	for(SpaceRock *r in rocks)
	{
		[r update:delta];
	}
	
	// Update gimmicks
	for (Gimmick *g in gimmicks)
	{
		[g update:delta];
	}
	
}

-(void) levelTick {
	spaceRockGenerationDelay = 0;
	[currentLevel increase];
	[scoreLabel setString:[NSString stringWithFormat:@"Level %d    Score: %d", [currentLevel number], score]];
	[self fadeInMessage:[NSString stringWithFormat:@"Level %d", [currentLevel number]]];
}

#pragma mark Object Creation

-(void) createSpaceRocks {
	// Space rocks
	rocks = [[NSMutableArray alloc] init];
	for(int i = 0; i < kNumberOfSpaceRocks; i++)
	{
		int rockX = 800;// rand() % 20 + 480;
		int rockY = 800 + i * 200;// rand() % 20 + 320;
		cpVect rockV = cpv(0,0);// cpv((240 - rockX) / 5, (160 - rockY) / 5);
		int type = rand() % 2;
		SpaceRock *r;
		if (type == 0)
		{
			r = [[SpaceRock alloc] initBigRockWithCpSpace:space X:rockX Y:rockY velocity:rockV
												   Sprite:[AtlasSprite spriteWithRect:CGRectMake(303, 21, 50, 41) spriteManager:sprites]];
		}
		else
		{
			r = [[SpaceRock alloc] initSmallRockWithCpSpace:space X:rockX Y:rockY velocity:rockV
													 Sprite:[AtlasSprite spriteWithRect:CGRectMake(274, 125, 23, 28) spriteManager:sprites]];
		}
		[sprites addChild:[r sprite] z:0];
		[rocks addObject: r];
		[r release];
	}
}

-(void) createBullets {
	//Bullet Manager, loads 10 bullets
	bullets = [[NSMutableArray alloc] init];
	for(int i = 0; i < 10; i++)
	{
		// Place bullets depending on buttons
		int offset = 10;
		if (!buttonsRight)
		{
			offset = 270;
		}
		Bullet *b = [[Bullet alloc] initWithCpSpace:space X:(offset + i*20) Y:10 velocity:cpv(0,0)
											 Sprite:[AtlasSprite spriteWithRect:CGRectMake(174, 218, 7, 7) spriteManager:sprites]];
		[sprites addChild:[b sprite] z:0];
		[bullets addObject: b];
		[b release];
	}
}

-(void) createGimmicks {
	// Gimmicks
	gimmicks = [[NSMutableArray alloc] init];
	for(int i = 0; i < 20; i++)
	{
		int gimmickX = -800;// rand() % 20 + 480;
		int gimmickY = -800 - i * 200;// rand() % 20 + 320;
		cpVect gimmickV = cpv(0,0);// cpv((240 - rockX) / 5, (160 - rockY) / 5);
		int type = rand() % 4;
		Gimmick *g;
		if (type == 0)
		{
			g = [[Gimmick alloc] initExtraLifeWithCpSpace:space X:gimmickX Y:gimmickY velocity:gimmickV
												   Sprite:[AtlasSprite spriteWithRect:CGRectMake(207, 239, 29, 17) spriteManager:sprites]];
		}
		else if (type == 1)
		{
			g = [[Gimmick alloc] initBonusPointsWithCpSpace:space X:gimmickX Y:gimmickY velocity:gimmickV
													 Sprite:[AtlasSprite spriteWithRect:CGRectMake(170, 239, 29, 17) spriteManager:sprites]];
		}
		else if (type == 2)
		{
			g = [[Gimmick alloc] initShieldWithCpSpace:space X:gimmickX Y:gimmickY velocity:gimmickV 
												Sprite:[AtlasSprite spriteWithRect:CGRectMake(244,239,29,17) spriteManager:sprites]];
		}
		else {
			g = [[Gimmick alloc] initDoubleFireWithCpSpace:space X:gimmickX Y:gimmickY velocity:gimmickV 
												Sprite:[AtlasSprite spriteWithRect:CGRectMake(95,239,29,17) spriteManager:sprites]];
		}

		[sprites addChild:[g sprite] z:0];
		[gimmicks addObject: g];
		[g release];
	}
}

-(void) createExplosionX: (float) x y: (float) y
{
	ParticleSystem *emitter = [RockExplosion node];
	emitter.position = cpv(x,y);
	[self addChild: emitter];
}

#pragma mark Object Activation

-(void) generateSpaceRock {
	if (spaceRockGenerationDelay == [currentLevel spaceRockGenerationDivisor])
	{
		spaceRockGenerationDelay = 0;
		for (SpaceRock *rock in rocks)
		{
			if ([rock ready])
			{
				[rock setReady:NO];
				
				// Sign -1 or 1
				int sign = rand() % 2;
				if (sign == 0)
				{
					sign = -1;
				}
				
				// Shall x or y be generated first
				int xFirst = rand() % 2;
				
				int rockX = 0;
				int rockY = 0;
				// First: generate number between
				// x1 = 210 and x2 = 270 (or y) then move
				// offscreen by either adding or
				// subtracting half of the screen (240)
				// The second number can then be generated
				// covering the whole x or y axis.
				//-----------------------
				//|			y1			|
				//|		  x1  x2		|
				//|			y2			|	
				//|						|
				//-----------------------
				if (xFirst == 1)
				{
					rockX = rand() % 60 + 210 + sign * 240;
					rockY = rand() % 380 - 30;
				}
				else 
				{
					rockY = rand() % 60 + 130 + sign * 160;
					rockX = rand() % 540 - 30;
				}
				
				// Let rocks move to middle of the screen
				cpVect rockV = cpv((240 - rockX) / [currentLevel spaceRockSpeedDivisor], 
								   (160 - rockY) / [currentLevel spaceRockSpeedDivisor]);
				/*
				NSLog(@"Rock generated at %d, %d v = %f, %f", rockX, rockY, 
					  rockV.x, rockV.y);
				 */
				[rock startMovingFromX:rockX Y:rockY velocity:rockV];
				break;
			}
		}
	}
	else 
	{
		spaceRockGenerationDelay += 1;
	}
}

-(void) generateGimmickX:(float)x Y:(float)y {
	// First: try random gimmick
	int gimmickFromPool = rand() % 20;
	Gimmick *rg = [gimmicks objectAtIndex:gimmickFromPool];
	if ([rg ready])
	{
		[rg setReady:NO];
		[rg startMovingFromX:x Y:y velocity:cpv(10,10)];
	} // After that: first one in list that is ready
	else {
		for (Gimmick *g in gimmicks)
		{
			if ([g ready])
			{
				[g setReady:NO];
				[g startMovingFromX:x Y:y velocity:cpv(10,10)];
				break;
			}
		}
	}
}

#pragma mark Helper / GUI methods

// Sets health bar to value v
-(void) setValueOfHealthBar:(int)v
{
	// Draw bar, make it red in case it reaches low level
	[healthBar changeWidth:v * 10];
	if (v < 4)
	{
		[healthBar setColor:ccc3(255,0,0)];
	}
	if (v > 4)
	{
		[healthBar setColor:ccc3(0,255,0)];
	}
	
}

// Button pressed routine, conforms to GameButtonDelegate protocol
-(void)buttonPressed:(Button *)button
{
	// Pause button
	if ([[button name] isEqualToString:@"btnPause"])
	{
		[self setPaused:YES];
	}
	// Fire button
	if ([[button name] isEqualToString:@"btnFire"])
	{
		// Calculate fire position
		cpVect shipPosition = [theShip getPosition];
		// We must consider rotation to fire bullet from 
		// end of ship
		float a = [theShip getRotation] + 1.5707f;
		float shipRotation = [theShip getRotation];
		
		fireButton.opacity = kPressedOpacity;
		
		[[SimpleAudioEngine sharedEngine] playEffect:@"photon.caf"];
		
		// Maximum: two bullets needed
		NSMutableArray *bulletsReady = [[NSMutableArray alloc] initWithCapacity:2];
		
		for(Bullet *b in bullets)
		{
			if([b ready])
			{
				[bulletsReady addObject:b];
				if ([bulletsReady count] == 2)
				{
					break;
				}
			}
		}
		
		if (doubleFire)
		{
			if (bulletsReady.count == 2)
			{
				Bullet *b1 = [bulletsReady objectAtIndex:0];
				Bullet *b2 = [bulletsReady objectAtIndex:1];
				[b1 fireFromX:shipPosition.x + 1 * cos(a) + 1 * sin(a) y:shipPosition.y + 1 * sin(a) + 1 * cos(a) angle:shipRotation levelFactor:[currentLevel number]];
				[b1 setReady: NO];
				[b2 fireFromX:shipPosition.x + 1 * cos(a) + 1 * sin(a) y:shipPosition.y + 1 * sin(a) + 1 * cos(a) angle:shipRotation levelFactor:[currentLevel number]];
				[b2 setReady: NO];
			}
		}
		else 
		{
			if (bulletsReady.count > 0)
			{
				Bullet *b = [bulletsReady objectAtIndex:0];
				[b fireFromX:shipPosition.x + 40 * cos(a) y:shipPosition.y + 40 * sin(a) angle:shipRotation levelFactor:[currentLevel number]];
				[b setReady: NO];
			}
		
		}
		[bulletsReady release];

	}
}

-(void)shieldEnded
{
	// Unschedule event
	[self fadeInMessage:@"Shield deactivated"];
	[self unschedule:@selector(shieldEnded)];
	[theShip setShield:NO];
}

-(void)doubleFireEnded
{
	
	// Unschedule event
	[self fadeInMessage:@"Single fire"];
	[self unschedule:@selector(doubleFireEnded)];
	[self setDoubleFire:NO];
}

-(void)fadeInMessage:(NSString *)message
{
	[levelIncreasedLabel setScale:1.0f];
	[levelIncreasedLabel setString:message];
	id scale = [ScaleBy actionWithDuration:1.0f scale:5.0f];
	id fadeout = [FadeOut actionWithDuration:1.0f];
	id labelspawn = [Spawn actions: scale, fadeout, nil];
	[levelIncreasedLabel runAction:labelspawn];
}

#pragma mark Pause handling

-(BOOL)paused
{
	return paused;
}

-(void)setPaused:(BOOL)p
{
	paused = p;
	if (paused)
	{
		pauseButton.opacity = kPressedOpacity;
		
		// Add pause menu layer
		[self addChild:[PauseLayer node] z:4];
		
		[[Director sharedDirector] pause];
	}
	else
	{
		pauseButton.opacity = kNotPressedOpacity;
	}
}

#pragma mark Serialization, NSCoding
-(void)encodeWithCoder:(NSCoder *)aCoder
{
	// "Native" data
	[aCoder encodeInt:score forKey:@"score"];
	[aCoder encodeFloat:spaceRockGenerationDelay forKey:@"spaceRockGenerationDelay"];
	[aCoder encodeBool:paused forKey:@"paused"];
	[aCoder encodeBool:doubleFire forKey:@"doubleFire"];
	[aCoder encodeBool:buttonsRight forKey:@"buttonsRight"];
	// Object data 
	// Ship:
	[aCoder encodeInt:[theShip life] forKey:@"theShip_life"];
	[aCoder encodeInt:[theShip getPosition].x forKey:@"theShip_xPosition"];
	[aCoder encodeInt:[theShip getPosition].y forKey:@"theShip_yPosition"];
	[aCoder encodeFloat:[theShip getRotation] forKey:@"theShip_rotation"];
	// SpaceRocks:
	for (int i = 0; i < [rocks count]; i++) {
		SpaceRock *rock = [rocks objectAtIndex:i];
		NSString *keyPrefix = [NSString stringWithFormat:@"spaceRock%d_", i];
		[aCoder encodeInt:[rock type] forKey:[NSString stringWithFormat:@"%@type", keyPrefix]];
		[aCoder encodeBool:[rock ready] forKey:[NSString stringWithFormat:@"%@ready", keyPrefix]];
		[aCoder encodeInt:[rock getPosition].x forKey:[NSString stringWithFormat:@"%@x", keyPrefix]];
		[aCoder encodeInt:[rock getPosition].y forKey:[NSString stringWithFormat:@"%@y", keyPrefix]];
		[aCoder encodeInt:[rock getVelocity].x forKey:[NSString stringWithFormat:@"%@vx", keyPrefix]];
		[aCoder encodeInt:[rock getVelocity].y forKey:[NSString stringWithFormat:@"%@vy", keyPrefix]];
		
	}
	
	// Level
	[aCoder encodeObject:currentLevel forKey:@"currentLevel"];
	
	/* Maybe this will be done later
	[aCoder encodeObject:bullets forKey:@"bullets"];
	[aCoder encodeObject:rocks forKey:@"rocks"];
	[aCoder encodeObject:gimmicks forKey:@"gimmicks"];
	[aCoder encodeObject:currentLevel forKey:@"currentLevel"];
	 */
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super init];
    if (self != nil) {
        isTouchEnabled = YES;
		CGSize winSize = [[Director sharedDirector] winSize];
		
		BOOL p = [aDecoder decodeBoolForKey:@"paused"];
		[self setPaused:p];
		doubleFire = [aDecoder decodeBoolForKey:@"doubleFire"];
		
		// Joystick
		joystick = [[Joystick alloc] init:0 y:0 w:320 h:480];
		[self addChild:[joystick arrowSpriteManager] z:3];
		
		// Init chipmunk
		cpInitChipmunk();
		space = cpSpaceNew();
		cpSpaceResizeStaticHash(space, 100, 400); // 400.0f, 40
		cpSpaceResizeActiveHash(space, 100, 400); // 100, 600
		space->iterations = 5;
		space->gravity = cpv(0, 0);
		space->elasticIterations = space->iterations;
		
		// Update Chipmunk and game step
		[self schedule: @selector(step:)];
		
		// Level timer and Level itself
		currentLevel = [[aDecoder decodeObjectForKey:@"currentLevel"] retain];
		[self schedule:@selector(levelTick) interval: 60.0];
		
		// Generate space rocks timer
		[self schedule:@selector(generateSpaceRock) interval: 0.2];
		
		// Game sprite sheet
		sprites = [AtlasSpriteManager spriteManagerWithFile:@"asteroidsSheet.png"];
		[self addChild:sprites z:2];
		
		// Background
		Sprite *bg = [Sprite spriteWithFile:@"starfield.png"];
		bg.position = cpv(240, 160);
		[self addChild:bg z:0];
		
		// Sun particle emitter
		ParticleSun *galaxy = [ParticleSun node];
		[galaxy setPosition:ccp(240, 160)];
		[self addChild:galaxy z:1];
		
		// Space Ship
		int shipX = [aDecoder decodeIntForKey:@"theShip_xPosition"];
		int shipY = [aDecoder decodeIntForKey:@"theShip_yPosition"];
		int shipLife = [aDecoder decodeIntForKey:@"theShip_life"];
		float shipRotation = [aDecoder decodeFloatForKey:@"theShip_rotation"];
		theShip = [[SpaceShip alloc] initWithCpSpace:space X:shipX Y:shipY 
											  Sprite:[AtlasSprite spriteWithRect:CGRectMake(449, 311, 57, 26) spriteManager:sprites]];
		[sprites addChild:[theShip sprite] z:0];
		[theShip setLife:shipLife];
		[theShip setRotation:shipRotation];
		
		// Adjust buttons depending on interrupted game
		buttonsRight = [aDecoder decodeBoolForKey:@"buttonsRight"];
		CGPoint fireButtonPos = kFireButtonRightPosition;
		CGPoint pauseButtonPos = kPauseButtonRightPosition;
		if (!buttonsRight)
		{
			fireButtonPos = kFireButtonLeftPosition;
			pauseButtonPos = kPauseButtonLeftPosition;
		}
		
		// Fire button
		fireButton = [[Button alloc] initWithSprite:@"fireButton.png" 
										 atPosition:fireButtonPos
											opacity:kNotPressedOpacity 
											   name:@"btnFire"];
		[fireButton setDelegate:self];
		[self addChild:fireButton z:3];
		
		// Pause button
		pauseButton = [[Button alloc] initWithSprite:@"pause.png" 
										  atPosition:pauseButtonPos 
											 opacity:kNotPressedOpacity
												name:@"btnPause"];
		[pauseButton setDelegate:self];
		[self addChild:pauseButton z:3];
		
		// Preload first sound and background music
		[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Chilled.mp3"];
		[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.7f];
		[[SimpleAudioEngine sharedEngine] preloadEffect:@"photon.caf"];
		
		// Label *label = [Label labelWithString:@"No touch by now..." fontName:@"Marker Felt" fontSize:20];
		// label.position =  ccp( winSize.width /2 , winSize.height/8);
		// [self addChild:label z:1 tag:kLabelTag];
		
		[self createBullets];
		
		// Init space rock generation delay
		spaceRockGenerationDelay = [aDecoder decodeFloatForKey:@"spaceRockGenerationDelay"];
		
		[self createSpaceRocks];
		// Saved space rock properties
		// SpaceRocks:
		for (int i = 0; i < [rocks count]; i++) {
			SpaceRock *rock = [rocks objectAtIndex:i];
			NSString *keyPrefix = [NSString stringWithFormat:@"spaceRock%d_", i];
			BOOL rdy = [aDecoder decodeBoolForKey:[NSString stringWithFormat:@"%@ready", keyPrefix]];
			[rock setReady:rdy];
			int rockX = [aDecoder decodeIntForKey:[NSString stringWithFormat:@"%@x", keyPrefix]];
			int rockY = [aDecoder decodeIntForKey:[NSString stringWithFormat:@"%@y", keyPrefix]];
			[rock setPosition:ccp(rockX, rockY)];
			int rockVx = [aDecoder decodeIntForKey:[NSString stringWithFormat:@"%@vx", keyPrefix]];
			int rockVy = [aDecoder decodeIntForKey:[NSString stringWithFormat:@"%@vy", keyPrefix]];
			[rock setVelocity:ccp(rockVx, rockVy)];
		}
		
		[self createGimmicks];
		
		// Collision between Rocks and Bullets
		cpSpaceAddCollisionPairFunc(space, 0, 2, &bulletCollision, self);
		// Collision between Ship and Rocks
		cpSpaceAddCollisionPairFunc(space, 1, 0, &shipCollision, self);
		// Collision between Gimmicks and Ship
		cpSpaceAddCollisionPairFunc(space, 1, 3, &gimmickCollision, self);
		
		// Score
		score = [aDecoder decodeIntForKey:@"score"];
		scoreLabel = [BitmapFontAtlas bitmapFontAtlasWithString:
					  [NSString stringWithFormat:@"Level %d    Score: %d", [currentLevel number], score] fntFile:@"KrungthepGreen.fnt"];
		[scoreLabel setPosition:ccp(winSize.width * 0.3f, winSize.height * 0.94f)];
		[self addChild:scoreLabel z:3];
		
		levelIncreasedLabel = [BitmapFontAtlas bitmapFontAtlasWithString:@""
																 fntFile:@"KrungthepGreen.fnt"];
		levelIncreasedLabel.position = ccp(240,160);
		[self addChild:levelIncreasedLabel z:3];
		
		// Health Bar
		healthBar = [ColorLayer layerWithColor:ccc4(0,255,0,kNotPressedOpacity) width:theShip.life * 10 height:20];
		healthBar.position = ccp(winSize.width * 0.75f, winSize.height * 0.92f);
		[self addChild:healthBar z:3];
		
    }
    return self;
	
	
}

@end


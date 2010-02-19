//
//  Joystick.m
//
//  Created by Jason Booth on 1/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Joystick.h"
#import "Director.h"
#import "chipmunk.h"



@implementation Joystick

@synthesize arrowSpriteManager;

-(id)init:(float)x y:(float)y w:(float)w h:(float)h
{
	self = [super init];
	if( self )
	{
		CGPoint location = [[Director sharedDirector]
							convertCoordinate:CGPointMake(x,y)];
		
		if ([[Director sharedDirector] deviceOrientation] == CCDeviceOrientationLandscapeLeft)
			mBounds = CGRectMake(location.x, location.y, h, w);
		else
			mBounds = CGRectMake(location.x, location.y, w, h);
		mCenter = CGPointMake(0,0);
		mCurPosition = CGPointMake(0,0);
		mActive = NO;
		mStaticCenter = NO;
		
		// Atlas Sprite stuff for Arrows
		arrowSpriteManager = [[AtlasSpriteManager spriteManagerWithFile:@"kuba_arrow.png"] retain];
		
		joystickUp = [[AtlasSprite spriteWithRect:CGRectMake(137, 200, 67, 36) spriteManager:arrowSpriteManager] retain];
		[arrowSpriteManager addChild:joystickUp];
		joystickUp.visible = NO;
		joystickUp.opacity = kNotPressedOpacity;
		
		joystickDown = [[AtlasSprite spriteWithRect:CGRectMake(63, 214, 67, 45) spriteManager:arrowSpriteManager] retain];
		[arrowSpriteManager addChild:joystickDown];
		joystickDown.visible = NO;
		joystickDown.opacity = kNotPressedOpacity;
		
		joystickLeft = [[AtlasSprite spriteWithRect:CGRectMake(201, 202, 67, 50) spriteManager:arrowSpriteManager] retain];
		[arrowSpriteManager addChild:joystickLeft];
		joystickLeft.visible = NO;
		joystickLeft.opacity = kNotPressedOpacity;
		
		joystickRight = [[AtlasSprite spriteWithRect:CGRectMake(0, 202, 67, 50) spriteManager:arrowSpriteManager] retain];
		[arrowSpriteManager addChild:joystickRight];
		joystickRight.visible = NO;
		joystickRight.opacity = kNotPressedOpacity;
	}
	return self;
}

-(void)setCenterX:(float)x y:(float)y
{
	mCenter = CGPointMake(x, y);
	mStaticCenter = YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	NSArray *allTouches = [touches allObjects];
	for (UITouch* t in allTouches)
	{
		CGPoint location = [[Director sharedDirector] convertCoordinate:[t locationInView:[t view]]];
		if (CGRectContainsPoint(mBounds, location))
		{
			mActive = YES;
			if (!mStaticCenter)
				mCenter = CGPointMake(location.x, location.y);
			mCurPosition = CGPointMake(location.x, location.y);
			// Visual representation
			joystickRight.position = cpv(mCenter.x + kButtonSpace, mCenter.y);
			joystickRight.visible = YES;
			joystickUp.position = cpv(mCenter.x, mCenter.y + kButtonSpace);
			joystickUp.visible = YES;
			joystickLeft.position = cpv(mCenter.x - kButtonSpace, mCenter.y);
			joystickLeft.visible = YES;
			joystickDown.position = cpv(mCenter.x, mCenter.y - kButtonSpace);
			joystickDown.visible = YES;
		}
	}
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (!mActive)
	{
		return;
	}
	NSArray *allTouches = [touches allObjects];
	for (UITouch* t in allTouches)
	{
		CGPoint location = [[Director sharedDirector] convertCoordinate:[t locationInView:[t view]]];
		if (CGRectContainsPoint(mBounds, location))
		{
			mCurPosition = CGPointMake(location.x, location.y);
			float angle = 180 - [self getCurrentDegreeVelocity].x;
			joystickLeft.opacity = kNotPressedOpacity;
			joystickUp.opacity = kNotPressedOpacity;
			joystickDown.opacity = kNotPressedOpacity;
			joystickRight.opacity = kNotPressedOpacity;
			if ((angle > 315) | (angle <= 45))
			{
				joystickRight.opacity = kPressedOpacity;
			}
			if ((angle > 45) & (angle <= 135))
			{
				joystickUp.opacity = kPressedOpacity;
			}
			if ((angle > 135) & (angle <= 225))
			{
				joystickLeft.opacity = kPressedOpacity;
			}
			if ((angle > 225) & (angle <= 315))
			{
				joystickDown.opacity = kPressedOpacity;
			}
		}
	}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (!mActive)
	{
		return;
	}
	NSArray *allTouches = [touches allObjects];
	for (UITouch* t in allTouches)
	{
		CGPoint location = [[Director sharedDirector] convertCoordinate:[t locationInView:[t view]]];
		if (CGRectContainsPoint(mBounds, location))
		{
			joystickUp.visible = NO;
			joystickDown.visible = NO;
			joystickLeft.visible = NO;
			joystickRight.visible = NO;
			joystickUp.opacity = kNotPressedOpacity;
			joystickDown.opacity = kNotPressedOpacity;
			joystickLeft.opacity = kNotPressedOpacity;
			joystickRight.opacity = kNotPressedOpacity;
			mActive = NO;
			if (!mStaticCenter)
				mCenter = CGPointMake(0,0);
			mCurPosition = CGPointMake(0,0);
		}
	}
}

-(CGPoint)getCurrentVelocity
{
	// return [Vector subtract:mCenter from:mCurPosition];
	return cpvsub(mCurPosition, mCenter);
	
}

-(CGPoint)getCurrentDegreeVelocity
{
	float dx = mCenter.x - mCurPosition.x;
	float dy = mCenter.y - mCurPosition.y;
	CGPoint vel = [self getCurrentVelocity];
	// vel.y = [Vector length:vel];
	vel.y = cpvlength(vel);
	vel.x = atan2f(-dy, dx) * (180/3.14);
	return vel;
}

@end

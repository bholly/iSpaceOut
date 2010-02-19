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

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#define TOUCH_INACCURACY 0
#define LIFT_OFF_INACCURACY 20

@interface Button : Sprite {
	// Button name to be able to distinguish them
	// in delegate
	NSString *name;
	// Delegate for Button pressed
	id delegate;
	// Flag to indicate, if button is pressed
	BOOL pressed;
}

@property(nonatomic, assign) id delegate;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, assign) BOOL pressed;

-(id)initWithSprite:(NSString *)imageFile atPosition:(CGPoint)p opacity:(float)o name:(NSString *)n;
-(BOOL)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(BOOL)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
-(BOOL)touchesWithinButton:(NSSet *)touches withEvent:(UIEvent *)event allowedInaccuracy:(int)inaccuracyPixel;

@end

// Protocol for Delegation
@protocol GameButtonDelegate
-(void)buttonPressed:(Button *)button;
@end

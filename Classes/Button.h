//
//  Button.h
//  iSpaceOut
//
//  Created by Dominik Fehn on 16.10.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

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

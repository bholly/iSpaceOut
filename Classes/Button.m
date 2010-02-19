//
//  Button.m
//  iSpaceOut
//
//  Created by Dominik Fehn on 16.10.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "Button.h"


@implementation Button

@synthesize delegate;
@synthesize name;
@synthesize pressed;

-(id)initWithSprite:(NSString *)imageFile atPosition:(CGPoint)p opacity:(float)o name:(NSString *)n
{
	if ((self = [super initWithFile:imageFile]))
	{
		self.name = n;
		self.position = p;
		self.opacity = o;
		pressed = NO;
	}
	return self;
}

-(BOOL)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if ([self touchesWithinButton:touches withEvent:event allowedInaccuracy:TOUCH_INACCURACY])
	{
		// Notify delegate
		if(delegate && [delegate respondsToSelector:@selector(buttonPressed:)])
		{
			[delegate buttonPressed:self];
		}
		pressed = YES;
		return kEventHandled;
	}
	return kEventIgnored;
}

-(BOOL)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if ([self touchesWithinButton:touches withEvent:event allowedInaccuracy:LIFT_OFF_INACCURACY])
	{
		pressed = NO;
		return kEventHandled;
	}
	else {
		return kEventIgnored;
	}

}

// Allowed inaccuracy allows touch to be a few pixels "beside" button
// important, if finger has moved a little while pressing and is then
// lifted up: without inaccuracy uplifting woun't be recognised
-(BOOL)touchesWithinButton:(NSSet *)touches withEvent:(UIEvent *)event allowedInaccuracy:(int)inaccuracyPixel
{
	// Check if touch was within button
	NSArray *allTouches = [touches allObjects];
	float width = self.contentSize.width;
	float height = self.contentSize.height;
	BOOL touchWithin = NO;
	for (UITouch* t in allTouches)
	{
		CGPoint location = [[Director sharedDirector] convertCoordinate:[t locationInView:[t view]]];
		int rectX = self.position.x - width / 2 - inaccuracyPixel;
		int rectY = self.position.y - height / 2 - inaccuracyPixel;
		// We've changed start point of rectangle, so we have to add 
		// inaccuracy two times: one time to compensate changed start point
		// and second time to finally add inaccuracy.
		int rectWidth = width + inaccuracyPixel * 2;
		int rectHeight = height + inaccuracyPixel * 2;
		if (CGRectContainsPoint(CGRectMake(rectX, 
										   rectY, 
										   rectWidth, 
										   rectHeight), location))
	    {
			touchWithin = YES;
		}
	}
	return touchWithin;
}

@end

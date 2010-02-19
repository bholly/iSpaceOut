//
//  Joystick.h
//
//  Created by Jason Booth on 1/7/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

// virtual joystick class
//
// Create a virtual touch joystick within the bounds passed in.
// Default mode is that any press begin in the bounds area becomes
// the center of the joystick. Call setCenter if you want a static
// joystick center position instead. Querry getCurrentVelocity
// for an X,Y velocity value, or getCurrentDegreeVelocity for a
// degree and velocity value.


#import <Foundation/Foundation.h>
#import "cocos2D.h"

#define kPressedOpacity 255
#define kNotPressedOpacity 100
#define kButtonSpace 45

@interface Joystick : NSObject
{
	bool mStaticCenter;
	CGPoint mCenter;
	CGPoint mCurPosition;
	CGPoint mVelocity;
	CGRect mBounds;
	bool mActive;
	AtlasSpriteManager *arrowSpriteManager;
	AtlasSprite *joystickUp;
	AtlasSprite *joystickDown;
	AtlasSprite *joystickLeft;
	AtlasSprite *joystickRight;
}

@property(nonatomic, retain) AtlasSpriteManager *arrowSpriteManager;


-(id)init:(float)x y:(float)y w:(float)w h:(float)h;
-(void)setCenterX:(float)x y:(float)y;
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
-(CGPoint)getCurrentVelocity;
-(CGPoint)getCurrentDegreeVelocity;

@end

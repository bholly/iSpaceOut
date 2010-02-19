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

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
#import "cocoslive.h"
#import "BitmapFontAppearing.h"

#define kFontAnimationSpeed 0.05f

@interface GameOverScene : Scene {
	
}

-(id)initWithScore:(int)score;

@end


@interface GameOverLayer : Layer <UIAlertViewDelegate, CocosLivePostDelegate, CocosLiveRequestDelegate> {
	Label *label;
	UITextField *nameField;
	BitmapFontAppearing *serverStateLabel;
	int _score;
}

-(id)initWithScore:(int)score;

-(void)menuCallbackNewGame:(id)sender;
-(void)menuCallbackExit:(id)sender;
-(void)CreateInputBox;

@end

//
//  GameOverScene.h
//  iSpaceOut
//
//  Created by Dominik Fehn on 13.09.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

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

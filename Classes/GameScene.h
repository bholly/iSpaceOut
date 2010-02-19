//
//  GameScene.h
//  Cocos2DTest
//
//  Created by Dominik Fehn on 07.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "GameLayer.h"

@interface GameScene : Scene <UIAlertViewDelegate> {
	GameLayer *gameLayer;
	NSString *saveGamePath;
}

@property(nonatomic, retain) GameLayer *gameLayer;

-(void)CreateAlertView;

@end
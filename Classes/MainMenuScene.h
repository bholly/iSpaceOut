//
//  MainMenuScene.h
//  iSpaceOut
//
//  Created by Dominik Fehn on 18.09.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface MainMenuScene : Scene {
	Menu *_menu;
}

-(void)menuCallbackPlay:(id)sender;
-(void)menuCallbackHelp:(id)sender;
-(void)menuCallbackAbout:(id)sender;
-(void)menuCallbackQuit:(id)sender;

@end

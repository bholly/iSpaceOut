//
//  PauseLayer.h
//  iSpaceOut
//
//  Created by Dominik Fehn on 16.10.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface PauseLayer : Layer {

}

// Pause menue callbacks
-(void)menuCallbackContinue:(id)sender;
-(void)menuCallbackExit:(id)sender;

@end

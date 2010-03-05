//
//  OptionsScene.h
//  iSpaceOut
//
//  Created by Dominik Fehn on 05.03.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Slider.h"


@interface OptionsScene : Scene {
	int musicVolume;
	int soundFxVolume;
}

-(void)musicVolumeSliderCallback:(SliderThumb *)sender;
-(void)soundFxVolumeSliderCallback:(SliderThumb *)sender;
-(void)menuCallbackSaveOptions:(id)sender;
-(void)menuCallbackCancelOptions:(id)sender;

@end

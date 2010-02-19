//
//  SpaceRock.h
//  Cocos2DTest
//
//  Created by Dominik Fehn on 14.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MovingObject.h"

enum SpaceRockType {
	BigSpaceRock,
	SmallSpaceRock
};

@interface SpaceRock : MovingObject {
	enum SpaceRockType type;
}

@property (readwrite) enum SpaceRockType type;

-(id)initBigRockWithCpSpace: (cpSpace *)space X:(float)x Y:(float)y velocity:(cpVect)v Sprite:(AtlasSprite *)atlasSprite;
-(id)initSmallRockWithCpSpace: (cpSpace *)space X:(float)x Y:(float)y velocity:(cpVect)v Sprite:(AtlasSprite *)atlasSprite;

@end

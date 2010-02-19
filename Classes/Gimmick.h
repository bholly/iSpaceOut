//
//  Gimmick.h
//  iSpaceOut
//
//  Created by Dominik Fehn on 13.10.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MovingObject.h"

enum GimmickType {
	ExtraLife,
	BonusPoints,
	Shield, 
	DoubleFire
};

@interface Gimmick : MovingObject {
	enum GimmickType type;
}

@property (readwrite) enum GimmickType type;

-(id)initExtraLifeWithCpSpace: (cpSpace *)space X:(float)x Y:(float)y velocity:(cpVect)v Sprite:(AtlasSprite *)atlasSprite;
-(id)initBonusPointsWithCpSpace: (cpSpace *)space X:(float)x Y:(float)y velocity:(cpVect)v Sprite:(AtlasSprite *)atlasSprite;
-(id)initShieldWithCpSpace: (cpSpace *)space X:(float)x Y:(float)y velocity:(cpVect)v Sprite:(AtlasSprite *)atlasSprite;
-(id)initDoubleFireWithCpSpace: (cpSpace *)space X:(float)x Y:(float)y velocity:(cpVect)v Sprite:(AtlasSprite *)atlasSprite;

@end

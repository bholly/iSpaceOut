//
//  Bullet.h
//  GameDemo
//
//  Created by Ronald Jett on 4/25/09.
//  http://morethanmachine.com/macdev
//	rlj3967@rit.edu
//

#import <Foundation/Foundation.h>
#import "ChipmunkObject.h"

@interface Bullet : ChipmunkObject {
	bool ready;
	cpVect startPosition;
	bool bulletUsed;
	cpSpace *_space;
	bool _needsToBeSetBack;
}
-(id)initWithCpSpace: (cpSpace *)space X:(float)x Y:(float)y velocity:(cpVect)v Sprite:(AtlasSprite *)atlasSprite; 
-(void)update: (ccTime)delta;
-(void) fireFromX: (float) x y:(float)y angle:(float)a levelFactor:(int)level;
-(float) getX;
-(void) setX:(float)x;
-(float) getY;
-(void) setY:(float)y;
-(void) resetPosition;

@property(readwrite) bool ready;
@property(readwrite) bool bulletUsed;

@end

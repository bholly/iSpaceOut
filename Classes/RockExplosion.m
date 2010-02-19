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

#import "RockExplosion.h"
#import "TextureMgr.h"
#import "Director.h"

@implementation RockExplosion
-(id) init
{
	return [self initWithTotalParticles:4];
}

-(id) initWithTotalParticles:(int)p
{
	if( !(self=[super initWithTotalParticles:p]) )
		return nil;
	
	// duration
	duration = 0.2f;
	
	// gravity
	gravity.x = 10;
	gravity.y = 10;
	
	// angle
	angle = 90;
	angleVar = 360;
	
	// speed of particles
	speed = 200;
	speedVar = 40;
	
	// radial
	radialAccel = 0;
	radialAccelVar = 0;
	
	// tagential
	tangentialAccel = 0;
	tangentialAccelVar = 0;
	
	totalParticles = p;
	
	posVar.x = 0;
	posVar.y = 0;
	
	// life of particles
	life = 5.0f;
	lifeVar = 2;
	
	// size, in pixels
	startSize = 10.0f;
	startSizeVar = 5.0f;
	
	// emits per second
	emissionRate = totalParticles/duration;
	
	// color of particles
	startColor.r = 0.99f;
	startColor.g = 0.99f;
	startColor.b = 0.99f;
	startColor.a = 1.0f;
	startColorVar.r = 0.0f;
	startColorVar.g = 0.0f;
	startColorVar.b = 0.0f;
	startColorVar.a = 0.0f;
	endColor.r = 0.0f;
	endColor.g = 0.0f;
	endColor.b = 0.0f;
	endColor.a = 1.0f;
	endColorVar.r = 0.0f;
	endColorVar.g = 0.0f;
	endColorVar.b = 0.0f;
	endColorVar.a = 0.0f;
	
	self.texture = [[TextureMgr sharedTextureMgr] addImage: @"asteroid_small.png"];
	
	// additive
	blendAdditive = NO;
	
	return self;
}


@end

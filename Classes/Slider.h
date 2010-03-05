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

//
//  Slider.m
//  Trundle
//
//  Created by Robert Blackwood on 11/13/09.
//  Copyright 2009 Mobile Bros. All rights reserved.
//

#import "cocos2d.h"

@interface SliderThumb : MenuItemImage
{
	
}
@property (readwrite, assign) float value;

-(id) initWithTarget:(id)t selector:(SEL)sel;

@end

/* Internal class only */
@class SliderTouchLogic;

@interface Slider : Layer 
{
	SliderTouchLogic* _touchLogic;
}

@property (readonly) SliderThumb* thumb;
@property (readwrite, assign) float value;
@property (readwrite, assign) BOOL liveDragging;

-(id) initWithTarget:(id)t selector:(SEL)sel;

@end



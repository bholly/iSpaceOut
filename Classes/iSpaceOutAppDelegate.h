//
//  iSpaceOutAppDelegate.h
//  iSpaceOut
//
//  Created by Dominik Fehn on 04.09.09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iSpaceOutAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
}

@property (nonatomic, retain) UIWindow *window;

-(NSString *)saveGamePath;

@end

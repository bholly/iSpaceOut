//
//  ScoreServer.h
//  iSpaceOut
//
//  Created by Dominik Fehn on 20.10.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocoslive.h"
#import "GameOverScene.h"


@interface ScoreServer : NSObject {

}

-(void) postScore:(int)score forPlayer:(NSString*)playername postDelegate:(GameOverLayer *)gameOverLayer;
-(void) requestScoreRank:(int)score requestRankDelegate:(GameOverLayer *)gameOverLayer;

@end

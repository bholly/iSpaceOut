//
//  ScoreServer.m
//  iSpaceOut
//
//  Created by Dominik Fehn on 20.10.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ScoreServer.h"


@implementation ScoreServer

-(void) postScore:(int)score forPlayer:(NSString*)playername postDelegate:(GameOverLayer *)gameOverLayer{
	// Create que "post" object for the game "DemoGame"
	// The gameKey is the secret key that is generated when you create you game in cocos live.
	// This secret key is used to prevent spoofing the high scores
	ScoreServerPost *server = [[ScoreServerPost alloc] initWithGameName:@"iSpaceOut" gameKey:@"d127a288fc9a0f0ac9bb7fd00952e324" delegate:gameOverLayer];
	
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];
	
	// usr_ are fields that can be modified.
	// set score
	[dict setObject: [NSNumber numberWithInt: score ] forKey:@"cc_score"];
	// set playername
	[dict setObject:playername forKey:@"cc_playername"];
	
	
	// cc_ are fields that cannot be modified. cocos fields
	// set category... it can be "easy", "medium", whatever you want.
	[dict setObject:@"Classic" forKey:@"cc_category"];
	
	[server updateScore:dict];
	
	// Release. It won't be freed from memory until the connection fails or suceeds
	[server release];
}

-(void) requestScoreRank:(int)score requestRankDelegate:(GameOverLayer *)gameOverLayer{
	// create a Request object for the game "DemoGame"
	// You need to implement the Score Request Delegate
	ScoreServerRequest *request = [[ScoreServerRequest alloc] initWithGameName:@"iSpaceOut" delegate:gameOverLayer];
	
	/* or use kQueryFlagCountry to request the best scores of your country */
	// tQueryFlags flags = kQueryFlagByCountry;
	
	// request the first 15 scores ( offset:0 limit:15)
	// request AllTime best scores (this is the only supported option in v0.1
	// request the scores for the category "easy"
	[request requestRankForScore:score andCategory:@"Classic"];
	
	// Release. It won't be freed from memory until the connection fails or suceeds
	[request release];
}

@end

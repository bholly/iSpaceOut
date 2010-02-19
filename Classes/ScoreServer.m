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

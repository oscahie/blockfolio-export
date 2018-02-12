//
//  BlockfolioClient.h
//  BlockfolioExport
//
//  Created by oscahie on 10/02/2018.
//  Copyright © 2018 oscahie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Coin.h"
#import "Trade.h"

/*
 A client for the Blockfolio REST API
 */
@interface BlockfolioClient : NSObject

/* The user's access token */
@property (strong) NSString *accessToken;

/*
 Retrieve the list of coins in the user's portfolio
 */
- (NSArray<Coin*> *)allCoinsInPortfolio;

/*
 Retrieve all the trades for the given coin
 */
- (NSArray<Trade*> *)tradesForCoin:(Coin *)coin;

@end

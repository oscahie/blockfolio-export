//
//  ExportJob.h
//  BlockfolioExport
//
//  Created by oscahie on 12/01/2018.
//

#import <Foundation/Foundation.h>
#import "BlockfolioClient.h"

/*
 Retrieves all the trades entered into the app, for any or all coins,
 and exports that data in some custom format suitable for other app.
 */
@interface ExportJob : NSObject

@property (strong) BlockfolioClient *client;

/*
 Export all the trades for each coin in the user's portfolio
 */
- (void)exportAllTrades;

/*
 Export the trades for the given coin name and base pair
 
 @param name    the ticker used for the coin by Blockfolio (eg. LTC)
 @param base    the base pair (eg. BTC)
 */
- (void)exportTradesForCoinWithName:(NSString *)name basePair:(NSString *)base;

@end

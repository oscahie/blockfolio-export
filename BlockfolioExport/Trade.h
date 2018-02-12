//
//  Trade.h
//  BlockfolioExport
//
//  Created by oscahie on 12/01/2018.
//

#import <Foundation/Foundation.h>
#import "Coin.h"

@interface Trade : NSObject

@property (strong) Coin *coin;
@property (assign) NSInteger tradeID;
@property (assign) double quantity;
@property (strong) NSString *quantityString;
@property (strong) NSString *exchange;
@property (strong) NSString *note;
@property (assign) double price;
@property (strong) NSString *priceString;
@property (assign) NSTimeInterval timestamp;

- (NSDate *)tradeDate;

@end

//
//  Coin.h
//  BlockfolioExport
//
//  Created by oscahie on 12/01/2018.
//

#import <Foundation/Foundation.h>

@interface Coin : NSObject

@property (strong) NSString *name;
@property (strong) NSString *basePair;
@property (assign) double quantity;
@property (assign) BOOL isWatchOnly;

@end

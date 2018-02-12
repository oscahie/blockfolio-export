//
//  Trade.m
//  BlockfolioExport
//
//  Created by oscahie on 12/01/2018.
//

#import "Trade.h"

@implementation Trade

- (NSDate *)tradeDate
{
    return [NSDate dateWithTimeIntervalSince1970:self.timestamp/1000];
}

@end

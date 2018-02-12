//
//  ExportJob.m
//  BlockfolioExport
//
//  Created by oscahie on 12/01/2018.
//

#import "ExportJob.h"

@implementation ExportJob

- (void)exportAllTrades
{
    NSArray<Coin *> *coinList = [self.client allCoinsInPortfolio];
    
    for (Coin *coin in coinList)
    {
        if (!coin.isWatchOnly)
        {
            [self exportTradesForCoin:coin];
        }
    }
}

- (void)exportTradesForCoinWithName:(NSString *)name basePair:(NSString *)base
{
    Coin *coin = [Coin new];
    coin.name = name;
    coin.basePair = base;
    
    [self exportTradesForCoin:coin];
}

- (void)exportTradesForCoin:(Coin *)coin
{
    NSArray<Trade*> *tradeList = [self.client tradesForCoin:coin];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY/MM/dd-HH:mm";
    
    for (Trade *trade in tradeList)
    {
        // TODO: here we could export the data in many ways, eg. to a CSV file with a certain format. It depends on what we want to use it for/with
        NSLog(@"%@ %@ %@ %@/%@ @ %@ on %@ | %@", [dateFormatter stringFromDate:trade.tradeDate], trade.quantity > 0 ? @"BUY" : @"SELL", trade.quantityString, trade.coin.name, trade.coin.basePair, trade.priceString, trade.exchange, trade.note);
    }
}

@end

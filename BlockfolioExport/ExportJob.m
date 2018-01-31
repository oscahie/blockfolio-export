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
    NSArray<Coin *> *coinList = [self allCoinsInPortfolio];
    
    for (Coin *coin in coinList)
    {
        if (!coin.isWatchOnly)
        {
            [self exportTradesForCoinWithName:coin.name basePair:coin.basePair];
        }
    }
}

- (void)exportTradesForCoinWithName:(NSString *)name basePair:(NSString *)base;
{
    NSString *blockfolioPairFormat = [NSString stringWithFormat:@"%@-%@", base, name];
    NSArray<Trade*> *tradeList = [self tradesForCoinPair:blockfolioPairFormat];
    
    for (Trade *trade in tradeList)
    {
        // TODO: here we could export the data in many ways, eg. to a CSV file with a certain format. It depends on what we want to use it for/with
        NSLog(@"Trade: %@ %@ %@/%@ @ %@ on %@", trade.quantity > 0 ? @"BUY" : @"SELL", trade.quantityString, trade.coin.name, trade.coin.basePair, trade.priceString, trade.exchange);
    }
}

- (NSURL *)URLToGetAllPositions
{
    return [NSURL URLWithString:[@"http://api-v0.blockfolio.com/rest/get_all_positions/" stringByAppendingString:self.accessToken]];
}

- (NSURL *)URLToGetTradesForPair:(NSString *)pair
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://api-v0.blockfolio.com/rest/get_positions_v2/%@/%@", self.accessToken, pair]];
}

- (NSArray<Coin*> *)allCoinsInPortfolio
{
    NSURL *apiURL = [self URLToGetAllPositions];
    NSURLSession *session = [NSURLSession sharedSession];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block NSArray *result;
    
    NSLog(@"Sending HTTP request to %@", apiURL);
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:apiURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error)
        {
            NSLog(@"Request failed with error: %@", error);
        }
        else if (((NSHTTPURLResponse *)response).statusCode != 200)
        {
            NSLog(@"Request failed with HTTP status code: %@", @(((NSHTTPURLResponse *)response).statusCode));
        }
        else
        {
            NSLog(@"Received response data (%@ bytes)", @(data.length));
            result = [self parseAllPositionsJSON:data];
        }
        
        dispatch_semaphore_signal(semaphore);
    }];
    
    [task resume];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return result;
}

- (NSArray<Trade*> *)tradesForCoinPair:(NSString *)pair
{
    NSURL *apiURL = [self URLToGetTradesForPair:pair];
    NSURLSession *session = [NSURLSession sharedSession];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block NSArray *result;
    
    NSLog(@"Sending HTTP request to %@", apiURL);
    
    NSURLSessionDataTask *task = [session dataTaskWithURL:apiURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error)
        {
            NSLog(@"Request failed with error: %@", error);
        }
        else if (((NSHTTPURLResponse *)response).statusCode != 200)
        {
            NSLog(@"Request failed with HTTP status code: %@", @(((NSHTTPURLResponse *)response).statusCode));
        }
        else
        {
            NSLog(@"Received response data (%@ bytes)", @(data.length));
            result = [self parseCoinTradesJSON:data];
        }
        
        dispatch_semaphore_signal(semaphore);
    }];
    
    [task resume];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return result;
}

- (NSArray<Coin*> *)parseAllPositionsJSON:(NSData *)payload
{
    NSMutableArray<Coin*> *coinList = [NSMutableArray new];
    NSError *error;
    NSDictionary *items = [NSJSONSerialization JSONObjectWithData:payload options:0 error:&error];
   
    if (error)
    {
        NSLog(@"Failed to parse the JSON: %@", error);
    }
    else
    {
        for (NSDictionary *position in items[@"positionList"])
        {
            Coin *coin = [Coin new];
            coin.name = position[@"coin"];
            coin.basePair = position[@"base"];
            coin.quantity = [position[@"quantity"] doubleValue];
            coin.isWatchOnly = [position[@"watchOnly"] boolValue];
            
            [coinList addObject:coin];
        }
    }
    
    return coinList;
}

- (NSArray<Trade*> *)parseCoinTradesJSON:(NSData *)payload
{
    NSMutableArray<Trade*> *tradeList = [NSMutableArray new];
    NSError *error;
    NSDictionary *items = [NSJSONSerialization JSONObjectWithData:payload options:0 error:&error];
    
    if (error)
    {
        NSLog(@"Failed to parse the JSON: %@", error);
    }
    else
    {
        for (NSDictionary *position in items[@"positionList"])
        {
            Coin *coin = [Coin new];
            coin.name = position[@"coin"];
            coin.basePair = position[@"base"];
            
            Trade *trade = [Trade new];
            trade.coin = coin;
            trade.quantity = [position[@"quantity"] doubleValue];
            trade.quantityString = position[@"quantityLocaleString"];
            trade.note = position[@"note"];
            trade.exchange = position[@"exchange"];
            trade.date = [position[@"date"] doubleValue];
            trade.price = [position[@"price"] doubleValue];
            trade.priceString = position[@"priceString"];
            
            [tradeList addObject:trade];
        }
    }
    
    return tradeList;
}

@end

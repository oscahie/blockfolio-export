//
//  BlockfolioClient.m
//  BlockfolioExport
//
//  Created by oscahie on 10/02/2018.
//  Copyright © 2018 oscahie. All rights reserved.
//

#import "BlockfolioClient.h"

@implementation BlockfolioClient

static const NSString *kBlockfolioRestAPIBaseURL = @"http://api-v0.blockfolio.com/rest";

- (NSURL *)URLToGetAllPositions
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/get_all_positions/%@", kBlockfolioRestAPIBaseURL, self.accessToken]];
}

- (NSURL *)URLToGetTradesForCoin:(Coin *)coin
{
    // Blockfolio puts the base coin first, eg: 'BTC-ETH' for the trading pair ETH/BTC
    NSString *blockfolioPairFormat = [NSString stringWithFormat:@"%@-%@", coin.basePair, coin.name];
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/get_positions_v2/%@/%@", kBlockfolioRestAPIBaseURL, self.accessToken, blockfolioPairFormat]];
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

- (NSArray<Trade*> *)tradesForCoin:(Coin *)coin
{
    NSURL *apiURL = [self URLToGetTradesForCoin:coin];
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
            trade.timestamp = [position[@"date"] doubleValue];
            trade.price = [position[@"price"] doubleValue];
            trade.priceString = position[@"priceString"];
            trade.tradeID = [position[@"positionId"] integerValue];
            
            [tradeList addObject:trade];
        }
    }
    
    return tradeList;
}

@end

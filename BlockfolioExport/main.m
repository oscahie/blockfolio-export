//
//  main.m
//  BlockfolioExport
//
//  Created by oscahie on 12/01/2018.
//

#import <Foundation/Foundation.h>
#import "ExportJob.h"
#import "BlockfolioClient.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSLog(@"Export begins");
        
        BlockfolioClient *client = [BlockfolioClient new];
        // set your access token as shown by Blockfolio under the Settings menu
        client.accessToken = @"<INSERT_BLOCKFOLIO_TOKEN_HERE>";
        
        ExportJob *job = [ExportJob new];
        job.client = client;
        
        // export all trades for all coins in your portfolio
        [job exportAllTrades];
        
        // or export the trades only for a certain coin
        //[job exportTradesForCoinWithName:@"ZRX" basePair:@"BTC"];
        
        NSLog(@"Export finished");
    }
    return 0;
}

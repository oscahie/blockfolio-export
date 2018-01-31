//
//  main.m
//  BlockfolioExport
//
//  Created by oscahie on 12/01/2018.
//

#import <Foundation/Foundation.h>
#import "ExportJob.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        NSLog(@"Export begins");
        
        ExportJob *job = [ExportJob new];
        
        // set your access token as shown by Blockfolio under the Settings menu
        job.accessToken = @"<INSERT_BLOCKFOLIO_TOKEN_HERE>";
        
        // export all trades for all coins in your portfolio
        [job exportAllTrades];
        
        // or export the trades only for a certain coin
        //[job exportTradesForCoinWithName:@"ZRX" basePair:@"BTC"];
        
        NSLog(@"Export finished");
    }
    return 0;
}

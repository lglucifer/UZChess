//
//  UZChessGameController.m
//  UZChess
//
//  Created by Xiaoyu Liu on 17/5/8.
//  Copyright © 2017年 com.uzero. All rights reserved.
//

#import "UZChessGameController.h"
#import "EngineController.h"
#import "UZChessSettingStore.h"

#import "Util.h"

@interface UZChessGameController()

@end

@implementation UZChessGameController


#pragma mark -- Public Method

- (void)startEngine {
    engineController = [[EngineController alloc] initWithGameController: self];
    [engineController sendCommand: @"uci"];
    [engineController sendCommand: @"isready"];
    [engineController sendCommand: @"ucinewgame"];
    
    UZChessSettings *chessSettings = (UZChessSettings *)[UZChessSettingStore defaultStore].storeSettings;
    [engineController setPlayStyle:[chessSettings AIModeFormat]];
    if (chessSettings.enablePonder) {
        [engineController setOption: @"Ponder" value: @"true"];
    } else {
        [engineController setOption: @"Ponder" value: @"false"];
    }
    [engineController setOption: @"Threads"
                          value: [NSString stringWithFormat: @"%d", [Util CPUCount]]];
#ifdef __LP64__
    // Since we're running on a 64-bit CPU, it's safe to assume that this is a modern
    // device with plenty of RAM, and we can afford a bigger transposition table.
    [engineController setOption: @"Hash" value: @"64"];
#else
    [engineController setOption: @"Hash" value: @"32"];
#endif
//    [engineController setOption: @"Skill Level" value: [NSString stringWithFormat: @"%d",
//                                                        [[Options sharedOptions] strength]]];
    
    [engineController commitCommands];
}

- (void)displayPV:(NSString *)pv
            depth:(int)depth
            score:(int)score
        scoreType:(int)scoreType
             mate:(BOOL)mate {
    
}

- (void)displayCurrentMove:(NSString *)currentMove
         currentMoveNumber:(int)currentMoveNumber
             numberOfMoves:(int)totalMoveCount
                     depth:(int)depth
                      time:(long)time
                     nodes:(int64_t)nodes {
    
}

- (void)engineMadeMove:(NSArray *)array {
    
}

@end

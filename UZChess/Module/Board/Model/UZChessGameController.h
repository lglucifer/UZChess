//
//  UZChessGameController.h
//  UZChess
//
//  Created by Xiaoyu Liu on 17/5/8.
//  Copyright © 2017年 com.uzero. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EngineController;
@interface UZChessGameController : NSObject {
    EngineController *engineController;
}

- (void)startEngine;

- (void)displayPV:(NSString *)pv
            depth:(int)depth
            score:(int)score
        scoreType:(int)scoreType
             mate:(BOOL)mate;

- (void)displayCurrentMove:(NSString *)currentMove
         currentMoveNumber:(int)currentMoveNumber
             numberOfMoves:(int)totalMoveCount
                     depth:(int)depth
                      time:(long)time
                     nodes:(int64_t)nodes;

- (void)engineMadeMove:(NSArray *)array;

@end

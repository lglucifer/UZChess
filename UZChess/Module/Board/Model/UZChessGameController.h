//
//  UZChessGameController.h
//  UZChess
//
//  Created by Xiaoyu Liu on 17/5/8.
//  Copyright © 2017年 com.uzero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UZChessBoardView.h"
#import "MoveListView.h"
#include "piece.h"

using namespace Chess;

@class EngineController;

@interface UZChessGameController : NSObject {
    EngineController *engineController;
    UIImage *pieceImages[16];
    UILabel *analysisView, *bookMovesView, *__weak whiteClockView, *__weak blackClockView, *__weak searchStatsView;
    MoveListView *moveListView;
    UZChessBoardView *boardView;
}

- (id)initWithBoardView:(UZChessBoardView *)bv
           moveListView:(MoveListView *)mlv
           analysisView:(UILabel *)av
          bookMovesView:(UILabel *)bmv
         whiteClockView:(UILabel *)wcv
         blackClockView:(UILabel *)bcv
        searchStatsView:(UILabel *)ssv;
//加载棋盘图片资源信息
- (void)loadPieceImages;

- (void)startEngine;

- (void)startNewGame;

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

#pragma mark -- Rotated

- (void)rotateBoard;

@end

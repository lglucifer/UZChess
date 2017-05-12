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
#include "square.h"

using namespace Chess;

@class EngineController;

@interface UZChessGameController : NSObject {
    EngineController *engineController;
    UIImage *pieceImages[16];
    UILabel *analysisView, *bookMovesView, *__weak whiteClockView, *__weak blackClockView, *__weak searchStatsView;
    MoveListView *moveListView;
}

#pragma mark -- Initial
- (id)initWithBoardView:(UZChessBoardView *)bv
           moveListView:(MoveListView *)mlv
           analysisView:(UILabel *)av
          bookMovesView:(UILabel *)bmv
         whiteClockView:(UILabel *)wcv
         blackClockView:(UILabel *)bcv
        searchStatsView:(UILabel *)ssv;

- (void)gameFromFEN:(NSString *)fen;
#pragma mark -- Piece
//加载棋盘图片资源信息
- (void)loadPieceImages;
//在棋盘上显示棋子资源
- (void)showPieceImagesAnimated:(BOOL)animated;
//是否开启棋子交互
- (void)piecesSetUserInteractionEnabled:(BOOL)enabled;
#pragma mark -- Engine
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
//AI移动
- (void)engineGo;
#pragma mark -- Move
- (BOOL)moveIsPending;
//移动棋子 promotion:允许"升兵"
- (void)doMoveFrom:(Square)fSq
                to:(Square)tSq
         promotion:(PieceType)prom;
//返回目标square信息
- (int)destinationSquaresFrom:(Square)sq
                  saveInArray:(Square *)sqs;

- (BOOL)pieceCanMoveFrom:(Square)sq;

- (int)pieceCanMoveFrom:(Square)fSq
                     to:(Square)tSq;

- (void)animateMoveFrom:(Square)fSq to:(Square)tSq;

- (BOOL)usersTurnToMove;

- (BOOL)computersTurnToMove;

#pragma mark -- Rotated

- (void)rotateBoard;

@end

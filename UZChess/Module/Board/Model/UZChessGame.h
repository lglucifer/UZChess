//
//  UZChessGame.h
//  UZChess
//
//  Created by Xiaoyu Liu on 17/5/8.
//  Copyright © 2017年 com.uzero. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UZChessGameController.h"
#include "../../../ThirdSource/Stockfish/Chess/position.h"
#include "../../../ThirdSource/Stockfish/Chess/color.h"

using namespace Chess;

@interface UZChessGame : NSObject

- (instancetype)initWithGameController:(UZChessGameController *)gc
                         FEN:(NSString *)fen;

- (instancetype)initWithGameController:(UZChessGameController *)gc
                   PGNString:(NSString *)string;

- (instancetype)initWithGameController:(UZChessGameController *)gc;

//返回当前游戏位置对应的piece信息
- (Piece)pieceOnSquare:(Square)square;

#pragma mark -- Move
//返回当前游戏可以移动的一方玩家对应颜色
- (Color)sideToMove;
//
- (int)movesFrom:(Square)sq saveInArray:(Move *)mlist;

- (BOOL)pieceCanMoveFrom:(Square)sq;

- (int)pieceCanMoveFrom:(Square)fSq
                     to:(Square)tSq;

- (void)doMove:(Move)m;

- (Move)doMoveFrom:(Square)fSq
                to:(Square)tSq
         promotion:(PieceType)prom;

- (void)doMoveFrom:(Square)fSq
                to:(Square)tSq;

@end

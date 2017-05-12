//
//  UZChessGame.m
//  UZChess
//
//  Created by Xiaoyu Liu on 17/5/8.
//  Copyright © 2017年 com.uzero. All rights reserved.
//

#import "UZChessGame.h"

@interface UZChessGame() {
    Position *startPosition;
    Position *currentPosition;
}

@end

@implementation UZChessGame

- (void)dealloc {
    NSLog(@"Dealloc Game:[%@]", self);
    delete startPosition;
    delete currentPosition;
}

#pragma mark -- Initial

- (instancetype)initWithGameController:(UZChessGameController *)gc {
    return [[UZChessGame alloc] initWithGameController:gc
                                                   FEN:@"rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"];
}

- (instancetype)initWithGameController:(UZChessGameController *)gc FEN:(NSString *)fen {
    if (self = [super init]) {
        currentPosition = new Position;
        startPosition = new Position;
        startPosition->from_fen([fen UTF8String]);
        currentPosition->copy(*startPosition);
    }
    return self;
}

- (instancetype)initWithGameController:(UZChessGameController *)gc PGNString:(NSString *)string {
    if (self = [super init]) {
        
    }
    return self;
}

/// pieceOn: returns the piece on a given square in the current game position.
- (Piece)pieceOnSquare:(Square)square {
    assert(square_is_ok(square));
    return currentPosition->piece_on(square);
}

/// The side to move in the current game position.
- (Color)sideToMove {
    return currentPosition->side_to_move();
}

/// destinationSquaresFrom:saveI nArray takes a square and a C array of squares
/// as input, finds all squares the piece on the given square can move to,
/// and stores these possible destination squares in the array. This is used
/// in the GUI in order to highlight the squares a piece can move to.
- (int)movesFrom:(Square)sq saveInArray:(Move *)mlist {
    assert(square_is_ok(sq));
    assert(mlist != NULL);
    
    return currentPosition->moves_from(sq, mlist);
}

/// pieceCanMoveFrom: takes a square as input, and returns YES or NO depending
/// on whether the piece on that square in the current position has any legal
/// moves.
- (BOOL)pieceCanMoveFrom:(Square)sq {
    Move mlist[32];
    
    assert(square_is_ok(sq));
    return currentPosition->moves_from(sq, mlist) > 0;
}

/// pieceCanMoveFrom:to: takes a source square and a destination square as
/// input, and returns the number of legal moves between the two squares in
/// the current game position. The number of legal moves is usually 0 or 1,
/// but can be more for positions with pawn promotions.
- (int)pieceCanMoveFrom:(Square)fSq
                     to:(Square)tSq {
    Move mlist[32];
    int i, n, count;
    
    assert(square_is_ok(fSq));
    assert(square_is_ok(tSq));
    n = currentPosition->moves_from(fSq, mlist);
    for (i = 0, count = 0; i < n; i++)
        if (move_to(mlist[i]) == tSq)
            count++;
    return count;
}

/// doMove: takes a move as input, executes the move, and updates the current
/// position and move list.  The move is assumed to be legal.
- (void)doMove:(Move)m {
    UndoInfo u;
    currentPosition->do_move(m, u);
//    ChessMove *cm = [[ChessMove alloc] initWithMove: m undoInfo: u];
//    if (![self atEnd]) {
//        // We are not at the end of the game. We don't want to mess with
//        // multiple variations in the game on the iPhone, so we just remove
//        // all moves at the end of the move list.
//        [moves removeObjectsInRange:
//         NSMakeRange(currentMoveIndex, [moves count] - currentMoveIndex)];
//    }
//    [moves addObject: cm];
//    currentMoveIndex++;
//    
//    [self computeOpeningString];
//    
//    [self pushClock];
//    
//    assert([self atEnd]);
}

/// doMoveFrom:to:promotion: takes a source square, a destination square and
/// a piece type representing a promotion as input, finds the matching legal
/// move, and updates the current position and the move list. It is assumed
/// that a single legal move matches the input parameters.
- (Move)doMoveFrom:(Square)fSq to:(Square)tSq promotion:(PieceType)prom {
    assert(square_is_ok(fSq));
    assert(square_is_ok(tSq));
    assert(prom == NO_PIECE_TYPE || (prom >= KNIGHT && prom <= QUEEN));
    
    // Find the matching move
    Move mlist[32], move = MOVE_NONE;
    int n, i, matches;
    n = currentPosition->moves_from(fSq, mlist);
    for (i = 0, matches = 0; i < n; i++)
        if (move_to(mlist[i]) == tSq && move_promotion(mlist[i]) == prom) {
            move = mlist[i];
            matches++;
        }
    assert(matches == 1);
    
    // Update position
    UndoInfo u;
    currentPosition->do_move(move, u);
    
//    // Update move list
//    ChessMove *cm = [[ChessMove alloc] initWithMove: move undoInfo: u];
//    if (![self atEnd]) {
//        // We are not at the end of the game. We don't want to mess with
//        // multiple variations in the game on the iPhone, so we just remove
//        // all moves at the end of the move list.
//        [moves removeObjectsInRange:
//         NSMakeRange(currentMoveIndex, [moves count] - currentMoveIndex)];
//    }
//    [moves addObject: cm];
//    currentMoveIndex++;
//    
//    [self computeOpeningString];
//    
//    [self pushClock];
//    
//    assert([self atEnd]);
    
    return move;
}

/// doMoveFrom:to takes a source square and a destination square as input,
/// finds the matching legal move, and updates the current position and the
/// move list. It is assumed that a single legal move matches the input
/// parameters.
- (void)doMoveFrom:(Square)fSq to:(Square)tSq {
    [self doMoveFrom:fSq to:tSq promotion:NO_PIECE_TYPE];
}

@end

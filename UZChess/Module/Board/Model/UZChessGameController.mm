//
//  UZChessGameController.m
//  UZChess
//
//  Created by Xiaoyu Liu on 17/5/8.
//  Copyright © 2017年 com.uzero. All rights reserved.
//

#import "UZChessGameController.h"
#import "UZChessGame.h"
#import "EngineController.h"

#import "PieceImageView.h"

#import "UZChessSettingStore.h"
#import "Util.h"

@interface UZChessGameController()

@property (nonatomic, assign) Square pendingFromSquare;

@property (nonatomic, assign) Square pendingToSquare;

@property (nonatomic, strong) UZChessGame *chessGame;

@property (nonatomic, assign) BOOL rotated;

@property (nonatomic, weak) UZChessBoardView *boardView;

@property (nonatomic, strong) NSMutableArray *pieceViews;

@property (nonatomic, assign) BOOL engineIsPlaying;

@end

@implementation UZChessGameController

- (void)dealloc {
    _chessGame = nil;
    _pieceViews = nil;
}

- (id)initWithBoardView:(UZChessBoardView *)bv
           moveListView:(MoveListView *)mlv
           analysisView:(UILabel *)av
          bookMovesView:(UILabel *)bmv
         whiteClockView:(UILabel *)wcv
         blackClockView:(UILabel *)bcv
        searchStatsView:(UILabel *)ssv {
    if (self = [super init]) {
        self.boardView = bv;
        moveListView = mlv;
        analysisView = av;
        bookMovesView = bmv;
        whiteClockView = wcv;
        blackClockView = bcv;
        searchStatsView = ssv;
        self.chessGame = [[UZChessGame alloc] initWithGameController: self];
    }
    return self;
}

- (void)gameFromFEN:(NSString *)fen {
    for (PieceImageView *piv in self.pieceViews) {
        [piv removeFromSuperview];
    }
    
    if (self.chessGame) {
        self.chessGame = nil;
    }
    self.chessGame = [[UZChessGame alloc] initWithGameController:self
                                                             FEN:fen];
//    gameLevel = [[Options sharedOptions] gameLevel];
//    gameMode = [[Options sharedOptions] gameMode];
//    [game setTimeControlWithTime: [[Options sharedOptions] baseTime]
//                       increment: [[Options sharedOptions] timeIncrement]];
    self.pieceViews = [[NSMutableArray alloc] init];
    self.pendingFromSquare = SQ_NONE;
    self.pendingToSquare = SQ_NONE;
    
    [self showPieceImagesAnimated:YES];
    
//    [moveListView setText: [game htmlString]
//              scrollToPly: [game currentMoveIndex]];
    [self showBookMoves];
    
    self.engineIsPlaying = NO;
    [engineController abortSearch];
    [engineController sendCommand: @"ucinewgame"];
    [engineController commitCommands];
    
//    if (gameMode == GAME_MODE_ANALYSE)
//        [self engineGo];
}

#pragma mark -- Piece

- (NSMutableArray *)pieceViews {
    if (!_pieceViews) {
        _pieceViews = [[NSMutableArray alloc] init];
    }
    return _pieceViews;
}

- (void)loadPieceImages {
    for (Piece p = WP; p <= BK; p++);
    static NSString *pieceImageNames[16] = {
        nil, @"WPawn", @"WKnight", @"WBishop", @"WRook", @"WQueen", @"WKing", nil,
        nil, @"BPawn", @"BKnight", @"BBishop", @"BRook", @"BQueen", @"BKing", nil
    };
    UZChessSettings *chessSettings = (UZChessSettings *)[UZChessSettingStore defaultStore].storeSettings;
    for (Piece p = WP; p <= BK; p++) {
        if (piece_is_ok(p)) {
            pieceImages[p] =
            [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",
                                 [chessSettings pieceThemeFormat], pieceImageNames[p]]];
        } else {
            pieceImages[p] = nil;
        }
    }
}

- (void)showPieceImagesAnimated:(BOOL)animated {
    float squareSize = self.boardView.boardInnerView.squareSize;
    CGRect pieceImageRect = CGRectMake(0, 0, squareSize, squareSize);
    for (Square sq = SQ_A1; sq <= SQ_H8; sq++) {
        Square square = [self rotateSquare:sq];
        Piece piece = [self inner_PieceOnSquare:square];
        if (piece != EMPTY) {
            assert(piece_is_ok(piece));
            pieceImageRect.origin = CGPointMake(int(square) % 8 * squareSize,
                                                (7 - int(square) / 8) * squareSize);
            PieceImageView *pieceImageView = [[PieceImageView alloc] initWithFrame:pieceImageRect
                                                                    gameController:self
                                                                         boardView:self.boardView];
            pieceImageView.image = pieceImages[piece];
            pieceImageView.userInteractionEnabled = YES;
            pieceImageView.alpha = 0.f;
            [self.boardView.boardInnerView addSubview:pieceImageView];
            [self.pieceViews addObject:pieceImageView];
        }
    }
    
    if (animated) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.f];
        for (PieceImageView *piv in self.pieceViews) {
            piv.alpha = 1.f;
        }
        [UIView commitAnimations];
    } else {
        for (PieceImageView *piv in self.pieceViews) {
            piv.alpha = 1.f;
        }
    }
}

- (void)piecesSetUserInteractionEnabled:(BOOL)enabled {
    for (PieceImageView *piv in self.pieceViews) {
        piv.userInteractionEnabled = enabled;
    }
}

- (Piece)inner_PieceOnSquare:(Square)square {
    assert(square_is_ok(square));
    return [self.chessGame pieceOnSquare:[self rotateSquare:square]];
}

- (PieceImageView *)pieceImageViewForSquare:(Square)sq {
    sq = [self rotateSquare: sq];
    PieceImageView *__block pieceForSquare = nil;
    [self.pieceViews enumerateObjectsUsingBlock:^(PieceImageView *piv, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([piv square] == sq) {
            pieceForSquare = piv;
        }
    }];
    return pieceForSquare;
}

/// putPiece:on: inserts a new PieceImage subview to the board view. This method
/// is called when the user takes back a capturing move.
- (void)putPiece:(Piece)p on:(Square)sq {
    assert(piece_is_ok(p));
    assert(square_is_ok(sq));
    
    sq = [self rotateSquare:sq];
    
    float sqSize = self.boardView.boardInnerView.squareSize;
    CGRect rect = CGRectMake(0.0f, 0.0f, sqSize, sqSize);
    rect.origin = CGPointMake((int(sq)%8) * sqSize, (7-int(sq)/8) * sqSize);
    
    PieceImageView *piv = [[PieceImageView alloc] initWithFrame:rect
                                                 gameController:self
                                                      boardView:self.boardView];
    [piv setImage:pieceImages[p]];
    [piv setUserInteractionEnabled: YES];
    [piv setAlpha: 0.0];
    [self.boardView.boardInnerView addSubview: piv];
    [self.pieceViews addObject:piv];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations: nil context: context];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration: 0.25];
    [piv setAlpha: 1.0];
    [UIView commitAnimations];
    
}

/// removePieceOn: removes a piece from the board view.  The piece is
/// assumed to still be present on the board in the current position
/// in the game: The method is called directly before a captured piece
/// is removed from the game board.
- (void)removePieceOn:(Square)sq {
    sq = [self rotateSquare:sq];
    assert(square_is_ok(sq));
    for (int i = 0; i < [self.pieceViews count]; i++) {
        if ([self.pieceViews[i] square] == sq) {
            [self.pieceViews[i] removeFromSuperview];
            [self.pieceViews removeObjectAtIndex:i];
            break;
        }
    }
}
#pragma mark -- Move
/// moveIsPending tests if there is a pending move waiting for the user to
/// choose the promotion piece. Related to the hideous hack in
/// doMoveFrom:to:promotion.
- (BOOL)moveIsPending {
    return self.pendingFromSquare != SQ_NONE;
}

/// doMoveFrom:to:promotion executes a move made by the user, and is called by
/// touchesEnded:withEvent in the PieceImageView class. Legality is checked
/// by that method, so at present we can safely assume that the move is legal.
/// Update the game, and do necessary updates to the board view (remove
/// captured pieces, move rook in case of castling).
- (void)doMoveFrom:(Square)fSq
                to:(Square)tSq
         promotion:(PieceType)prom {
    assert(square_is_ok(fSq));
    assert(square_is_ok(tSq));
    
    fSq = [self rotateSquare:fSq];
    tSq = [self rotateSquare:tSq];
    
    Piece movingPiece = [self.chessGame pieceOnSquare:fSq];
    
    // HACK to fix annoying UIActionSheet behavior in iOS 8. Of course we should
    // use UIAlertControllers instead of UIActionSheets in iOS 8, but unfortunately
    // that wouldn't work in iOS 7. Later on, we should probably roll our own
    // modal dialogs that uses UIActionSheets or UIAlertControllers depending on
    // the iOS version.
    if (movingPiece == EMPTY) {
        return;
    }
    
    BOOL isCapture = [self.chessGame pieceOnSquare:tSq] != EMPTY;
    
    if ([self.chessGame pieceCanMoveFrom:fSq to:tSq] > 1 && prom == NO_PIECE_TYPE) {
        // More than one legal move between the two squares. This means that the
        // user tries to do a promotion move, even though the "prom" parameter
        // doesn't say so. Handling this is really messy, because the iPhone SDK
        // doesn't seem to have anything equivalent to Cocoa's NSAlert() function.
        // What we really want to do is to bring up a modal dialog and wait
        // until the user chooses a piece to promote to. This doesn't seem to be
        // possible: When the user chooses a menu option, the delegate method
        // actionSheet:clickedButtonAtIndex: function is called, and control never
        // returns to the present function.
        //
        // We hack around this problem by remembering fSq and tSq, and calling
        // doMoveFrom:to:promotion again with the remembered values and the chosen
        // promotion piece from the delegate method. This is really ugly.  :-(
        self.pendingFromSquare = [self rotateSquare:fSq];
        self.pendingToSquare = [self rotateSquare:tSq];
        //        UIActionSheet *menu =
        //        [[UIActionSheet alloc]
        //         initWithTitle: @"Promote to"
        //         delegate: self
        //         cancelButtonTitle: nil
        //         destructiveButtonTitle: nil
        //         otherButtonTitles: @"Queen", @"Rook", @"Knight", @"Bishop", nil];
        //        [menu showInView: [boardView superview]];
        
        //TODO: Show ActionSheet "升兵"
        return;
    }
    
    // HACK: Castling. The user probably tries to move the king two squares to
    // the side when castling, but Stockfish internally encodes castling moves
    // as "king captures rook". We handle this by adjusting tSq when the user
    // tries to move the king two squares to the side:
    static const int woo = 1, wooo = 2, boo = 3, booo = 4;
    int castle = 0;
    if (fSq == SQ_E1 && tSq == SQ_G1 && [self.chessGame pieceOnSquare:fSq] == WK) {
        tSq = SQ_H1; castle = woo;
    } else if (fSq == SQ_E1 && tSq == SQ_C1 && [self.chessGame pieceOnSquare:fSq] == WK) {
        tSq = SQ_A1; castle = wooo;
    } else if (fSq == SQ_E8 && tSq == SQ_G8 && [self.chessGame pieceOnSquare:fSq] == BK) {
        tSq = SQ_H8; castle = boo;
    } else if (fSq == SQ_E8 && tSq == SQ_C8 && [self.chessGame pieceOnSquare:fSq] == BK) {
        tSq = SQ_A8; castle = booo;
    }
    
    if (castle) {
        // Move the rook.
        PieceImageView *piv;
        Square rsq;
        
        if (castle == woo) {
            piv = [self pieceImageViewForSquare:SQ_H1];
            rsq = [self rotateSquare:SQ_F1];
        } else if (castle == wooo) {
            piv = [self pieceImageViewForSquare:SQ_A1];
            rsq = [self rotateSquare:SQ_D1];
        } else if (castle == boo) {
            piv = [self pieceImageViewForSquare:SQ_H8];
            rsq = [self rotateSquare:SQ_F8];
        } else if (castle == booo) {
            piv = [self pieceImageViewForSquare:SQ_A8];
            rsq = [self rotateSquare:SQ_D8];
        } else {
            assert(false);
            rsq = SQ_NONE; // Just to muffle a compiler warning
        }
        [piv moveToSquare: rsq];
        isCapture = NO;
    }
    else if ([self.chessGame pieceOnSquare:tSq] != EMPTY)
        // Capture. Remove captured piece.
        [self removePieceOn: tSq];
    else if (type_of_piece([self.chessGame pieceOnSquare:fSq]) == PAWN
             && square_file(tSq) != square_file(fSq)) {
        // Pawn moves to a different file, and destination square is empty. This
        // must be an en passant capture. Remove captured pawn:
        Square epSq = tSq - pawn_push([self.chessGame sideToMove]);
        assert([self.chessGame pieceOnSquare:epSq]
               == pawn_of_color(opposite_color([self.chessGame sideToMove])));
        [self removePieceOn: epSq];
    }
    
    // In case of promotion, update the piece image view.
    if (prom) {
        [self removePieceOn: fSq];
        [self putPiece: piece_of_color_and_type([self.chessGame sideToMove], prom)
                    on: tSq];
    }
    
    // Update the game and move list:
    [self.chessGame doMoveFrom:fSq
                            to:tSq
                     promotion:prom];
    [self updateMoveList];
    [self showBookMoves];
    
    self.pendingFromSquare = SQ_NONE;
    self.pendingToSquare = SQ_NONE;
    
    // Play a sound when the move has been made.
    [self playMoveSound:movingPiece capture:isCapture];
    
    // Game over?
    [self gameEndTest];
    
    // Clear the search stats view
    [searchStatsView setText: @""];
    
    // HACK to handle promotions
    if (prom)
        [self engineGo];
}

- (void)animateMoveFrom:(Square)fSq to:(Square)tSq {
    assert(square_is_ok(fSq));
    assert(square_is_ok(tSq));
    
    fSq = [self rotateSquare: fSq];
    tSq = [self rotateSquare: tSq];
    Piece movingPiece = [self.chessGame pieceOnSquare:fSq];
    BOOL isCapture = [self.chessGame pieceOnSquare:tSq] != EMPTY;
    
    if ([self.chessGame pieceCanMoveFrom:fSq to:tSq] > 1) {
        self.pendingFromSquare = fSq;
        self.pendingToSquare = tSq;
//        [self promotionMenu];
        return;
    }
    
    // HACK: Castling. The user probably tries to move the king two squares to
    // the side when castling, but Stockfish internally encodes castling moves
    // as "king captures rook". We handle this by adjusting tSq when the user
    // tries to move the king two squares to the side:
    static const int woo = 1, wooo = 2, boo = 3, booo = 4;
    int castle = 0;
    BOOL ep = NO;
    if (fSq == SQ_E1 && tSq == SQ_G1 && [self.chessGame pieceOnSquare:fSq] == WK) {
        tSq = SQ_H1; castle = woo;
    } else if (fSq == SQ_E1 && tSq == SQ_C1 && [self.chessGame pieceOnSquare:fSq] == WK) {
        tSq = SQ_A1; castle = wooo;
    } else if (fSq == SQ_E8 && tSq == SQ_G8 && [self.chessGame pieceOnSquare:fSq] == BK) {
        tSq = SQ_H8; castle = boo;
    } else if (fSq == SQ_E8 && tSq == SQ_C8 && [self.chessGame pieceOnSquare:fSq] == BK) {
        tSq = SQ_A8; castle = booo;
    }
    else if (type_of_piece([self.chessGame pieceOnSquare:fSq]) == PAWN &&
             [self.chessGame pieceOnSquare:tSq] == EMPTY &&
             square_file(fSq) != square_file(tSq))
        ep = YES;
    
    Move m;
    if (castle) {
        isCapture = NO;
        m = make_castle_move(fSq, tSq);
    }
    else if (ep)
        m = make_ep_move(fSq, tSq);
    else
        m = make_move(fSq, tSq);
    
    [self animateMove:m];
    [self.chessGame doMove:m];
    
    [self updateMoveList];
    [self showBookMoves];
    [self playMoveSound:movingPiece capture:isCapture];
    [self gameEndTest];
    [self engineGo];
}

/// destinationSquaresFrom:saveInArray takes a square and a C array of squares
/// as input, finds all squares the piece on the given square can move to,
/// and stores these possible destination squares in the array. This is used
/// in the GUI in order to highlight the squares a piece can move to.
- (int)destinationSquaresFrom:(Square)sq
                  saveInArray:(Square *)sqs {
    int i, j, n;
    Move mlist[32];
    
    assert(square_is_ok(sq));
    assert(sqs != NULL);
    
    sq = [self rotateSquare: sq];
    
    n = [self.chessGame movesFrom: sq saveInArray: mlist];
    for (i = 0, j = 0; i < n; i++)
        // Only include non-promotions and queen promotions, in order to avoid
        // having the same destination squares multiple times in the array.
        if (!move_promotion(mlist[i]) || move_promotion(mlist[i]) == QUEEN) {
            // For castling moves, adjust the destination square so that it displays
            // correctly when squares are highlighted in the GUI.
            if (move_is_long_castle(mlist[i]))
                sqs[j] = [self rotateSquare: move_to(mlist[i]) + 2];
            else if (move_is_short_castle(mlist[i]))
                sqs[j] = [self rotateSquare: move_to(mlist[i]) - 1];
            else
                sqs[j] = [self rotateSquare: move_to(mlist[i])];
            j++;
        }
    sqs[j] = SQ_NONE;
    return j;
}

- (BOOL)pieceCanMoveFrom:(Square)sq {
    assert(square_is_ok(sq));
    return [self.chessGame pieceCanMoveFrom:[self rotateSquare:sq]];
}

- (int)pieceCanMoveFrom:(Square)fSq
                     to:(Square)tSq {
    fSq = [self rotateSquare: fSq];
    tSq = [self rotateSquare: tSq];
    
    // If the squares are invalid, the move can't be legal.
    if (!square_is_ok(fSq) || !square_is_ok(tSq))
        return 0;
    
    // Make sure we don't capture a friendly piece. This is important, because
    // of the way castling moves are encoded.
    if (color_of_piece([self.chessGame pieceOnSquare:tSq]) == color_of_piece([self.chessGame pieceOnSquare:fSq]))
        return 0;
    
    // HACK: Castling. The user probably tries to move the king two squares to
    // the side when castling, but Stockfish internally encodes castling moves
    // as "king captures rook". We handle this by adjusting tSq when the user
    // tries to move the king two squares to the side:
    if (fSq == SQ_E1 && tSq == SQ_G1 && [self.chessGame pieceOnSquare:fSq] == WK)
        tSq = SQ_H1;
    else if (fSq == SQ_E1 && tSq == SQ_C1 && [self.chessGame pieceOnSquare:fSq] == WK)
        tSq = SQ_A1;
    else if (fSq == SQ_E8 && tSq == SQ_G8 && [self.chessGame pieceOnSquare:fSq] == BK)
        tSq = SQ_H8;
    else if (fSq == SQ_E8 && tSq == SQ_C8 && [self.chessGame pieceOnSquare:fSq] == BK)
        tSq = SQ_A8;
    
    return [self.chessGame pieceCanMoveFrom:fSq
                                         to:tSq];
}

- (BOOL)usersTurnToMove {
    UZChessSettings *chessSettings = (UZChessSettings *)[UZChessSettingStore defaultStore].storeSettings;
    BOOL _usersTurnToMove = NO;
    if (chessSettings.gameMode == UZChessGameMode_TWO_PLAYER ||
        chessSettings.gameMode == UZChessGameMode_ANALYSE ||
        ((chessSettings.gameMode == UZChessGameMode_COMPUTER_BLACK) &&
         ([self.chessGame sideToMove] == WHITE)) ||
        ((chessSettings.gameMode == UZChessGameMode_COMPUTER_WHITE) &&
         ([self.chessGame sideToMove] == BLACK))) {
            _usersTurnToMove = YES;
        }
    return _usersTurnToMove;
}

- (BOOL)computersTurnToMove {
    return ![self usersTurnToMove];
}

- (void)animateMove:(Move)m {
    Square from = move_from(m), to = move_to(m);
    
    // HACK: Castling. Stockfish internally encodes castling moves as "king
    // captures rook", which means that the "to" square does not contain the
    // king's current square on the board. Adjust the "to" square, and check
    // what sort of castling move it is, to help us move the rook later.
    static const int woo = 1, wooo = 2, boo = 3, booo = 4;
    int castle = 0;
    if (move_is_short_castle(m)) {
        castle = ([self.chessGame sideToMove] == WHITE)? woo : boo;
        to = ([self.chessGame sideToMove] == WHITE)? SQ_G1 : SQ_G8;
    }
    else if (move_is_long_castle(m)) {
        castle = ([self.chessGame sideToMove] == WHITE)? wooo : booo;
        to = ([self.chessGame sideToMove] == WHITE)? SQ_C1 : SQ_C8;
    }
    
    // In the case of a capture, remove the captured piece.
    if ([self.chessGame pieceOnSquare: to] != EMPTY)
        [self removePieceOn: to];
    else if (move_is_ep(m))
        [self removePieceOn: to - pawn_push([self.chessGame sideToMove])];
    
    // Move the piece
    [[self pieceImageViewForSquare: from] moveToSquare:
     [self rotateSquare: to]];
    
    // If move is promotion, update the piece image:
    if (move_promotion(m))
        [[self pieceImageViewForSquare: to]
         setImage:
         pieceImages[piece_of_color_and_type([self.chessGame sideToMove],
                                             move_promotion(m))]];
    
    // If move is a castle, move the rook
    if (castle == woo)
        [[self pieceImageViewForSquare: SQ_H1]
         moveToSquare: [self rotateSquare: SQ_F1]];
    else if (castle == wooo)
        [[self pieceImageViewForSquare: SQ_A1]
         moveToSquare: [self rotateSquare: SQ_D1]];
    else if (castle == boo)
        [[self pieceImageViewForSquare: SQ_H8]
         moveToSquare: [self rotateSquare: SQ_F8]];
    else if (castle == booo)
        [[self pieceImageViewForSquare: SQ_A8]
         moveToSquare: [self rotateSquare: SQ_D8]];
}
#pragma mark -- Engine

- (void)startEngine {
    engineController = [[EngineController alloc] initWithGameController: self];
    [engineController sendCommand: @"uci"];
    [engineController sendCommand: @"isready"];
    [engineController sendCommand: @"ucinewgame"];
    
    UZChessSettings *chessSettings = (UZChessSettings *)[UZChessSettingStore defaultStore].storeSettings;
    [engineController setPlayStyle:[chessSettings AIStyleFormat]];
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
    [engineController setOption: @"Skill Level" value: [NSString stringWithFormat: @"%@", chessSettings.strength]];
    
    [engineController commitCommands];
    //
    [self showBookMoves];
}

- (void)showBookMoves {
    UZChessSettings *chessSettings = (UZChessSettings *)[UZChessSettingStore defaultStore].storeSettings;
//    if (chessSettings.showBookMoves) {
//        NSString *s = [game bookMovesAsString];
//        if (s)
//            [bookMovesView setText: [NSString stringWithFormat: @"  Book: %@",
//                                     [game bookMovesAsString]]];
//        else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//            [bookMovesView setText: @"  Book:"];
//        else if ([[bookMovesView text] hasPrefix: @"  Book:"])
//            [bookMovesView setText: @""];
//    } else if ([self.bookMoveLb.text hasPrefix: @"  Book:"]) {
//        self.bookMoveLb.text = @"";
//    }
}

- (void)startNewGame {
    NSLog(@"start New Game");
    
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

/// engineGo is called directly after the user has made a move.  It checks
/// the game mode, and sends a UCI "go" command to the engine if necessary.
- (void)engineGo {
//    if (!engineController)
//        [self startEngine];
//    
//    if ([game positionIsTerminal]) {
//        if ([self engineIsThinking])
//            [engineController abortSearch];
//    } else {
//        if (gameMode == GAME_MODE_ANALYSE) {
//            engineIsPlaying = NO;
//            [engineController abortSearch];
//            [engineController sendCommand: [game uciGameString]];
//            [engineController setOption: @"UCI_AnalyseMode" value: @"true"];
//            [engineController sendCommand: @"go infinite"];
//            [engineController commitCommands];
//            return;
//        }
//        if (isPondering) {
//            if ([game currentMove] == ponderMove) {
//                [engineController ponderhit];
//                isPondering = NO;
//                return;
//            } else {
//                NSLog(@"REAL pondermiss");
//                [engineController pondermiss];
//                while ([engineController engineIsThinking]);
//            }
//            isPondering = NO;
//        }
//        if ((gameMode==GAME_MODE_COMPUTER_BLACK && [game sideToMove]==BLACK) ||
//            (gameMode==GAME_MODE_COMPUTER_WHITE && [game sideToMove]==WHITE)) {
//            // Computer's turn to move.  First look for a book move.  If no book move
//            // is found, start a search.
//            Move m;
//            if ([[Options sharedOptions] maxStrength] ||
//                [game currentMoveIndex] < 10 + [[Options sharedOptions] strength] * 2)
//                m = [game getBookMove];
//            else
//                m = MOVE_NONE;
//            if (m != MOVE_NONE)
//                [self doEngineMove: m];
//            else {
//                // Update play style, if necessary
//                if ([[Options sharedOptions] playStyleWasChanged]) {
//                    NSLog(@"play style was changed to: %@",
//                          [[Options sharedOptions] playStyle]);
//                    [engineController setPlayStyle: [[Options sharedOptions] playStyle]];
//                    [engineController commitCommands];
//                }
//                
//                // Update strength, if necessary
//                if ([[Options sharedOptions] strengthWasChanged]) {
//                    [engineController sendCommand: @"setoption name Clear Hash"];
//                    [engineController setOption: @"Skill Level" value: [NSString stringWithFormat: @"%d",
//                                                                        [[Options sharedOptions] strength]]];
//                    [engineController commitCommands];
//                }
//                
//                // Start thinking.
//                engineIsPlaying = YES;
//                [engineController sendCommand: [game uciGameString]];
//                if ([[Options sharedOptions] isFixedTimeLevel])
//                    [engineController
//                     sendCommand: [NSString stringWithFormat: @"go movetime %d",
//                                   [[Options sharedOptions] timeIncrement]]];
//                else
//                    [engineController
//                     sendCommand: [NSString stringWithFormat: @"go wtime %d btime %d winc %d binc %d",
//                                   [[game clock] whiteRemainingTime],
//                                   [[game clock] blackRemainingTime],
//                                   [[game clock] whiteIncrement],
//                                   [[game clock] blackIncrement]]];
//                [engineController commitCommands];
//            }
//        }
//    }
}

- (void)gameEndTest {
//    if ([game positionIsMate]) {
//        [[[UIAlertView alloc] initWithTitle: (([game sideToMove] == WHITE)?
//                                              @"Black wins" : @"White wins")
//                                    message: @"Checkmate!"
//                                   delegate: self
//                          cancelButtonTitle: nil
//                          otherButtonTitles: @"OK", nil]
//         show];
//        [game setResult: (([game sideToMove] == WHITE)? @"0-1" : @"1-0")];
//    } else if ([game positionIsDraw]) {
//        [[[UIAlertView alloc] initWithTitle: @"Game drawn"
//                                    message: [game drawReason]
//                                   delegate: self
//                          cancelButtonTitle: nil
//                          otherButtonTitles: @"OK", nil]
//         show];
//        [game setResult: @"1/2-1/2"];
//    }
}

#pragma mark -- Move list

- (void)updateMoveList {
    //TODO:Update Move list
//    [moveListView setText: [game htmlString]
//              scrollToPly: [game currentMoveIndex]];
}

#pragma mark -- Audio

- (void)playMoveSound:(Piece)p capture:(BOOL)capture {
//    if ([[Options sharedOptions] moveSound]) {
//        if (capture)
//            AudioServicesPlaySystemSound(captureSounds[random() & 7]);
//        else if (piece_is_ok(p))
//            AudioServicesPlaySystemSound(pieceSounds[int(p) & 7][random() % 2]);
//    }
}

#pragma mark -- Rotate

- (Square)rotateSquare:(Square)square {
    return self.rotated ? Square(SQ_H8 - square) : square;
}

- (void)rotateBoard {
    
}

@end

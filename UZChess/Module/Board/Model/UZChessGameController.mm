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

@property (nonatomic, assign) BOOL rotated;

@end

@implementation UZChessGameController

- (void)dealloc {
    
}

- (id)initWithBoardView:(UZChessBoardView *)bv
           moveListView:(MoveListView *)mlv
           analysisView:(UILabel *)av
          bookMovesView:(UILabel *)bmv
         whiteClockView:(UILabel *)wcv
         blackClockView:(UILabel *)bcv
        searchStatsView:(UILabel *)ssv {
    if (self = [super init]) {
        boardView = bv;
        moveListView = mlv;
        analysisView = av;
        bookMovesView = bmv;
        whiteClockView = wcv;
        blackClockView = bcv;
        searchStatsView = ssv;
    }
    return self;
}

#pragma mark -- Public Method

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

#pragma mark -- Rotate

- (Square)rotateSquare:(Square)square {
    return self.rotated ? Square(SQ_H8 - square) : square;
}

- (void)rotateBoard {
    
}

@end

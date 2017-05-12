//
//  UZChessBoardInnerView.m
//  UZChess
//
//  Created by Xiaoyu Liu on 17/5/11.
//  Copyright © 2017年 com.uzero. All rights reserved.
//

#import "UZChessBoardInnerView.h"
#import "UZChessLastMoveView.h"
#import "UZChessSelectedSquareView.h"
#import "UZChessLegalMovesSquareView.h"

#import "UZChessSettingStore.h"
#import "UZChessGameController.h"

@interface UZChessBoardInnerView()

@property (nonatomic, weak) UZChessLastMoveView *lastMoveView;
@property (nonatomic, weak) UZChessSelectedSquareView *selectedSquareView;
@property (nonatomic, weak) UZChessLegalMovesSquareView *legalMovesSquareView;

@property (nonatomic, strong) UIColor *darkSquareColor;
@property (nonatomic, strong) UIColor *lightSquareColor;
@property (nonatomic, strong) UIImage *darkSquareImage;
@property (nonatomic, strong) UIImage *lightSquareImage;

@property (nonatomic, assign, readwrite) Square fromSquare;
@property (nonatomic, assign) Square selectedSquare;

@property (nonatomic, assign, readwrite) float squareSize;

@end

@implementation UZChessBoardInnerView

- (void)dealloc {
    _darkSquareColor = nil;
    _lightSquareColor = nil;
    _darkSquareImage = nil;
    _lightSquareImage = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self inner_SetUpBoard];
        self.squareSize = frame.size.width / 8;
        
        self.fromSquare = SQ_NONE;
        self.selectedSquare = SQ_NONE;
    }
    return self;
}

- (void)inner_SetUpBoard {
    UZChessSettings *chessSettings = (UZChessSettings *)[UZChessSettingStore defaultStore].storeSettings;
    self.darkSquareColor = chessSettings.darkSquareColor;
    self.lightSquareColor = chessSettings.lightSquareColor;
    self.darkSquareImage = chessSettings.darkSquareImage;
    self.lightSquareImage = chessSettings.lightSquareImage;
}

- (void)drawRect:(CGRect)rect {
    for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 8; j++) {
            if (self.darkSquareImage &&
                self.lightSquareImage) {
                UIImage *drawImage = ((i + j) & 1) ? self.darkSquareImage : self.lightSquareImage;
                [drawImage drawAtPoint:CGPointMake(i * self.squareSize, j * self.squareSize)];
            } else {
                UIColor *drawColor = ((i + j) & 1) ? self.darkSquareColor : self.lightSquareColor;
                [drawColor set];
                UIRectFill(CGRectMake(i * self.squareSize,
                                      j * self.squareSize,
                                      self.squareSize,
                                      self.squareSize));
            }
        }
    }
}

#pragma mark -- Square

- (Square)squareAtPoint:(CGPoint)point {
    File f = File(point.x / self.squareSize);
    Rank r = Rank((8 * self.squareSize - point.y) / self.squareSize);
    return (file_is_ok(f) && rank_is_ok(r))? make_square(f, r) : SQ_NONE;
}

- (void)highlightSquares:(Square *)sqs {
    
}

- (void)stopHighlighting {
    
}

- (CGPoint)originOfSquare:(Square)sq {
    return CGPointMake(int(square_file(sq)) * self.squareSize,
                       (7 - int(square_rank(sq))) * self.squareSize);
}

- (CGRect)rectForSquare:(Square)sq {
    CGRect r = CGRectMake(0.0f, 0.0f, self.squareSize, self.squareSize);
    r.origin = [self originOfSquare: sq];
    return r;
}

- (void)pieceTouchedAtSquare:(Square)s {
    [self hideLastMove];
    // HACK
    [self showLastMoveWithFrom:s
                            to:s];
    self.fromSquare = s;
}

#pragma mark -- Legal Moves

- (void)selectionMovedToPoint: (CGPoint)point {
    Square s = [self squareAtPoint: point];
    if (s == SQ_NONE) {
        [self.selectedSquareView hide];
        self.selectedSquare = SQ_NONE;
    }
    else if (s != self.selectedSquare) {
        int i;
        for (i = 0; highlightedSquares[i] != SQ_NONE; i++)
            if (highlightedSquares[i] == s) {
                self.selectedSquare = s;
                [self.selectedSquareView moveToPoint:CGPointMake(int(square_file(s)) * self.squareSize - 2 * self.squareSize,
                                                                 (7-int(square_rank(s))) * self.squareSize - 2 * self.squareSize)];
                return;
            }
        [self.selectedSquareView hide];
        self.selectedSquare = SQ_NONE;
    }
}

- (void)showLastMoveWithFrom:(Square)s1 to:(Square)s2 {
    if (self.lastMoveView) {
        [self.lastMoveView removeFromSuperview];
    }
    UZChessLastMoveView *lastMoveView = [[UZChessLastMoveView alloc] initWithFrame:self.bounds
                                                                            fromSq:s1
                                                                              toSq:s2
                                                                            sqSize:self.squareSize];
    [self addSubview:lastMoveView];
    self.lastMoveView = lastMoveView;
    
    [self bringArrowToFront];
}

- (void)hideLastMove {
    if (self.lastMoveView) {
        [self.lastMoveView removeFromSuperview];
    }
    self.fromSquare = SQ_NONE;
}

#pragma mark -- UIView Hierarchy

- (void)bringArrowToFront {
    
}

#pragma mark -- UITouch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.fromSquare == SQ_NONE) {
        [self hideLastMove];
    } else {
        CGPoint point = [[touches anyObject] locationInView:self];
        if ([self squareAtPoint:point] == self.fromSquare) {
            [self stopHighlighting];
            [self hideLastMove];
        } else {
            [self selectionMovedToPoint:point];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.fromSquare == SQ_NONE) {
        return;
    }
    [self selectionMovedToPoint:[[touches anyObject] locationInView:self]];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.fromSquare == SQ_NONE) {
        [self hideLastMove];
        [self stopHighlighting];
    } else {
        CGPoint pt = [[touches anyObject] locationInView: self];
        Square fSq = self.fromSquare;
        Square tSq = [self squareAtPoint:pt];
        [self hideLastMove];
        [self stopHighlighting];
        if ([self.gameController pieceCanMoveFrom:fSq to:tSq])
            [self.gameController animateMoveFrom:fSq to:tSq];
    }
    self.fromSquare = SQ_NONE;
}

- (void)resetBoardView {
    if (self.lastMoveView) {
        [self.lastMoveView removeFromSuperview];
    }
    self.fromSquare = SQ_NONE;
    self.selectedSquare = SQ_NONE;
}

@end

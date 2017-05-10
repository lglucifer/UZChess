//
//  UZChessBoardView.m
//  UZChess
//
//  Created by Xiaoyu Liu on 17/5/8.
//  Copyright © 2017年 com.uzero. All rights reserved.
//

#import "UZChessBoardView.h"

#import "UZCoordinateView.h"
#import "UZChessLastMoveView.h"
#import "UZChessSelectedSquareView.h"
#import "UZChessLegalMovesSquareView.h"

#import "UZChessSettingStore.h"

#define kChessBoardInnerPadding 15

@interface UZChessBoardView()

@property (nonatomic, weak) UZCoordinateView *coordinateView;
@property (nonatomic, weak) UZChessLastMoveView *lastMoveView;
@property (nonatomic, weak) UZChessSelectedSquareView *selectedSquareView;
@property (nonatomic, weak) UZChessLegalMovesSquareView *legalMovesSquareView;

@property (nonatomic, strong) UIColor *darkSquareColor;
@property (nonatomic, strong) UIColor *lightSquareColor;
@property (nonatomic, strong) UIImage *darkSquareImage;
@property (nonatomic, strong) UIImage *lightSquareImage;

@property (nonatomic, assign) Square fromSquare;
@property (nonatomic, assign) Square selectedSquare;

@property (nonatomic, assign) float squareSize;

@end

@implementation UZChessBoardView

- (void)dealloc {
    _darkSquareColor = nil;
    _lightSquareColor = nil;
    _darkSquareImage = nil;
    _lightSquareImage = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1.f / [UIScreen mainScreen].scale;
        self.layer.borderColor = [UIColor colorWithRGB:0x333333].CGColor;
        
        UZCoordinateView *coordinateView = [[UZCoordinateView alloc] initWithFrame:self.bounds
                                                                      innerPadding:kChessBoardInnerPadding];
        [self addSubview:coordinateView];
        self.coordinateView = coordinateView;
        
        [self inner_SetUpBoard];
        self.squareSize = (frame.size.width - kChessBoardInnerPadding * 2) / 8;
        
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
                [drawImage drawAtPoint:CGPointMake(kChessBoardInnerPadding + i * self.squareSize, kChessBoardInnerPadding + j * self.squareSize)];
            } else {
                UIColor *drawColor = ((i + j) & 1) ? self.darkSquareColor : self.lightSquareColor;
                [drawColor set];
                UIRectFill(CGRectMake(kChessBoardInnerPadding + i * self.squareSize,
                                      kChessBoardInnerPadding + j * self.squareSize,
                                      self.squareSize,
                                      self.squareSize));
            }
        }
    }
}

#pragma mark -- Private

- (Square)inner_SquareAtPoint:(CGPoint)point {
    return SQ_NONE;
}

#pragma mark -- UITouch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.fromSquare == SQ_NONE) {
        //TODO:
    } else {
        CGPoint point = [[touches anyObject] locationInView:self];
        if ([self inner_SquareAtPoint:point] == self.fromSquare) {
            //TODO:
        } else {
            //TODO:
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.fromSquare == SQ_NONE) {
        return;
    }
    //TODO:
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.fromSquare == SQ_NONE) {
        //TODO:
    } else {
        //TODO:
    }
    self.fromSquare = SQ_NONE;
}

- (void)resetBoardView {
    if (self.lastMoveView) {
        self.lastMoveView.hidden = YES;
    }
    self.fromSquare = SQ_NONE;
    self.selectedSquare = SQ_NONE;
}

@end

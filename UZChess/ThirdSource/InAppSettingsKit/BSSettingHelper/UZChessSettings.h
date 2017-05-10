//
//  UZChessSettings.h
//  UZChess
//
//  Created by Xiaoyu Liu on 17/5/4.
//  Copyright © 2017年 com.uzero. All rights reserved.
//

#import "UZAbstractSettings.h"

typedef NS_ENUM(NSUInteger, UZChessGameMode) {
    UZChessGameMode_Idle    = (0)
};

typedef NS_ENUM(NSUInteger, UZChessGameLevel) {
    UZChessGameLevel_Idle   = (0)
};

typedef NS_ENUM(NSUInteger, UZChessBoardSquareTheme) {
    UZChessBoardSquareTheme_Green   = (0),
    UZChessBoardSquareTheme_Blue    = (1),
    UZChessBoardSquareTheme_Newspaper  = (2),
    UZChessBoardSquareTheme_Brown   = (3),
    UZChessBoardSquareTheme_Gray    = (4),
    UZChessBoardSquareTheme_Red     = (5),
    UZChessBoardSquareTheme_Wood    = (6)
};

typedef NS_ENUM(NSUInteger, UZChessBoardPieceTheme) {
    UZChessBoardPieceTheme_Alpha    = (0),
    UZChessBoardPieceTheme_Merida   = (1),
    UZChessBoardPieceTheme_Leipzig  = (2),
    UZChessBoardPieceTheme_USCF     = (3),
    UZChessBoardPieceTheme_Russian  = (4),
    UZChessBoardPieceTheme_Modern   = (5),
    UZChessBoardPieceTheme_Berlin   = (6),
    UZChessBoardPieceTheme_Cheq     = (7),
    UZChessBoardPieceTheme_Maya     = (8),
    UZChessBoardPieceTheme_Invisible    = (9)
};

typedef NS_ENUM(NSUInteger, UZChessAIStyle) {
    UZChessAIStyle_Passive  = (0),
    UZChessAIStyle_Solid    = (1),
    UZChessAIStyle_Active   = (2),
    UZChessAIStyle_Aggressive   = (3),
    UZChessAIStyle_Suicidal = (4)
};

typedef NS_ENUM(NSUInteger, UZChessBookVariety) {
    UZChessBookVariety_Low      = (0),
    UZChessBookVariety_Medium   = (1),
    UZChessBookVariety_High     = (2)
};

@interface UZChessSettings : UZAbstractSettings
//显示分析
@property (nonatomic, assign) BOOL showAnalysis;
//显示本次移动的路径
@property (nonatomic, assign) BOOL showBookMoves;
//显示允许移动的路径
@property (nonatomic, assign) BOOL showLegalMoves;
//显示棋盘坐标
@property (nonatomic, assign) BOOL showCoordinates;
//显示分析箭头
@property (nonatomic, assign) BOOL showAnalysisArrows;
//允许AI思考下一步动作
@property (nonatomic, assign) BOOL enablePonder;
//移动路径显示对应棋子的图标符号
@property (nonatomic, assign) BOOL enableFigurineNotation;
//AI游戏风格
@property (nonatomic, assign) UZChessAIStyle AIMode;
//AI级别
@property (nonatomic, assign) UZChessBookVariety bookVariety;
//棋盘格子主题
@property (nonatomic, assign) UZChessBoardSquareTheme boardSquareTheme;
//棋子主题
@property (nonatomic, assign) UZChessBoardPieceTheme boardPieceTheme;

@property (nonatomic, strong) NSNumber *strength;
//主题对应格子颜色
@property (nonatomic, strong, readonly) UIColor *darkSquareColor;
@property (nonatomic, strong, readonly) UIColor *lightSquareColor;
@property (nonatomic, strong, readonly) UIColor *highlightSqureColor;
//主题对应格子背景图片
@property (nonatomic, strong, readonly) UIImage *darkSquareImage;
@property (nonatomic, strong, readonly) UIImage *lightSquareImage;

- (void)configureSquareWithSquareTheme;

- (NSString *)AIModeFormat;

- (NSString *)pieceThemeFormat;

@end

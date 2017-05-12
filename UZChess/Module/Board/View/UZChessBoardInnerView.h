//
//  UZChessBoardInnerView.h
//  UZChess
//
//  Created by Xiaoyu Liu on 17/5/11.
//  Copyright © 2017年 com.uzero. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "square.h"

using namespace Chess;

@class UZChessGameController;
@interface UZChessBoardInnerView : UIView {
    Square highlightedSquares[32];
}

@property (nonatomic, assign, readonly) Square fromSquare;
@property (nonatomic, assign, readonly) float squareSize;

@property (nonatomic, weak) UZChessGameController *gameController;

- (void)resetBoardView;

#pragma mark -- Square

- (Square)squareAtPoint:(CGPoint)point;
//高亮legalMoves区域
- (void)highlightSquares:(Square *)sqs;

- (void)stopHighlighting;

- (CGRect)rectForSquare:(Square)sq;

- (CGPoint)originOfSquare:(Square)sq;

- (void)pieceTouchedAtSquare:(Square)s;

- (void)bringArrowToFront;

- (void)selectionMovedToPoint:(CGPoint)sq;
//显示路径提示
- (void)showLastMoveWithFrom:(Square)s1 to:(Square)s2;
//隐藏上次操作移动路径提示
- (void)hideLastMove;

@end

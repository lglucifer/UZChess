//
//  UZChessBoardView.m
//  UZChess
//
//  Created by Xiaoyu Liu on 17/5/8.
//  Copyright © 2017年 com.uzero. All rights reserved.
//

#import "UZChessBoardView.h"
#import "UZChessSettingStore.h"

@interface UZChessBoardView()

@property (nonatomic, strong) UIColor *darkSquareColor;
@property (nonatomic, strong) UIColor *lightSquareColor;
@property (nonatomic, strong) UIImage *darkSquareImage;
@property (nonatomic, strong) UIImage *lightSquareImage;

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
        [self inner_SetUpBoard];
        self.squareSize = frame.size.width / 8;
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

@end

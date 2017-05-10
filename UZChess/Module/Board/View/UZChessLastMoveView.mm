//
//  UZChessLastMoveView.m
//  UZChess
//
//  Created by Xiaoyu Liu on 17/5/10.
//  Copyright © 2017年 com.uzero. All rights reserved.
//

#import "UZChessLastMoveView.h"

@interface UZChessLastMoveView() {
    Square _fromSq;
    Square _toSq;
    float _sqSize;
}

@end

@implementation UZChessLastMoveView

- (id)initWithFrame:(CGRect)frame
             fromSq:(Square)fSq
               toSq:(Square)tSq
             sqSize:(float)sqSize {
    if (self = [super initWithFrame:frame]) {
        _fromSq = fSq;
        _toSq = tSq;
        _sqSize = sqSize;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    int file, rank;
    CGRect frame;
    
    [[UIColor redColor] set];
    
    file = int(square_file(_fromSq));
    rank = 7 - int(square_rank(_fromSq));
    frame = CGRectMake(file * _sqSize,
                       rank * _sqSize,
                       _sqSize,
                       _sqSize);
    UIRectFrame(frame);
    UIRectFrame(CGRectInset(frame, 1.f, 1.f));
    
    file = int(square_file(_toSq));
    rank = 7 - int(square_rank(_toSq));
    frame = CGRectMake(file * _sqSize,
                       rank * _sqSize,
                       _sqSize,
                       _sqSize);
    UIRectFrame(frame);
    UIRectFrame(CGRectInset(frame, 1.f, 1.f));
}

- (void)dealloc {
    
}

@end

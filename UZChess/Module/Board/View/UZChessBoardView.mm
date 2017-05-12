//
//  UZChessBoardView.m
//  UZChess
//
//  Created by Xiaoyu Liu on 17/5/8.
//  Copyright © 2017年 com.uzero. All rights reserved.
//

#import "UZChessBoardView.h"
#import "UZCoordinateView.h"

#define kChessBoardInnerPadding 15

@interface UZChessBoardView()

@property (nonatomic, weak) UZCoordinateView *coordinateView;
@property (nonatomic, weak, readwrite) UZChessBoardInnerView *boardInnerView;

@end

@implementation UZChessBoardView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1.f / [UIScreen mainScreen].scale;
        self.layer.borderColor = [UIColor colorWithRGB:0x333333].CGColor;
        
        UZCoordinateView *coordinateView = [[UZCoordinateView alloc] initWithFrame:self.bounds
                                                                      innerPadding:kChessBoardInnerPadding];
        [self addSubview:coordinateView];
        self.coordinateView = coordinateView;
        
        UZChessBoardInnerView *boardInnerView = [[UZChessBoardInnerView alloc] initWithFrame:CGRectInset(self.bounds,
                                                                                                         kChessBoardInnerPadding,
                                                                                                         kChessBoardInnerPadding)];
        [self addSubview:boardInnerView];
        self.boardInnerView = boardInnerView;
    }
    return self;
}

@end

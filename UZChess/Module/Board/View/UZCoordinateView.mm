//
//  UZCoordinateView.m
//  UZChess
//
//  Created by Xiaoyu Liu on 17/5/9.
//  Copyright © 2017年 com.uzero. All rights reserved.
//

#import "UZCoordinateView.h"

@interface UZCoordinateView() {
    UILabel *fileTopLbs[8];
    UILabel *fileBottomLbs[8];
    UILabel *rankLeftLbs[8];
    UILabel *rankRightLbs[8];
    float sqSize;
}

@end

@implementation UZCoordinateView

- (instancetype)initWithFrame:(CGRect)frame
                 innerPadding:(CGFloat)innerPadding {
    if (self = [super initWithFrame:frame]) {
        sqSize = (frame.size.width - 2 * innerPadding) / 8;
        [self setUserInteractionEnabled:NO];
        for (int i = 0; i < 8; i++) {
            fileTopLbs[i] =
            [[UILabel alloc] initWithFrame:CGRectMake(innerPadding + (i) * sqSize,
                                                      0,
                                                      sqSize,
                                                      innerPadding)];
            [fileTopLbs[i] setFont:[UIFont systemFontOfSize:11.0f]];
            fileTopLbs[i].textAlignment = NSTextAlignmentCenter;
            
            fileBottomLbs[i] =
            [[UILabel alloc] initWithFrame:CGRectMake(innerPadding + (i) * sqSize,
                                                      frame.size.width - innerPadding,
                                                      sqSize,
                                                      innerPadding)];
            [fileBottomLbs[i] setFont:[UIFont systemFontOfSize:11.0f]];
            fileBottomLbs[i].textAlignment = NSTextAlignmentCenter;
            
            rankLeftLbs[i] =
            [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                      i * sqSize + innerPadding,
                                                      innerPadding,
                                                      sqSize)];
            [rankLeftLbs[i] setFont:[UIFont systemFontOfSize:11.0f]];
            rankLeftLbs[i].textAlignment = NSTextAlignmentCenter;

            rankRightLbs[i] =
            [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - innerPadding,
                                                      i * sqSize + innerPadding,
                                                      innerPadding,
                                                      sqSize)];
            [rankRightLbs[i] setFont:[UIFont systemFontOfSize:11.0f]];
            rankRightLbs[i].textAlignment = NSTextAlignmentCenter;

            [fileTopLbs[i]
             setText:[NSString stringWithFormat: @"%c",
                      (char)(i + 'a')]];
            [fileBottomLbs[i]
             setText:[NSString stringWithFormat: @"%c",
                      (char)(i + 'a')]];
            
            [rankLeftLbs[i]
             setText:[NSString stringWithFormat: @"%c",
                      (char)((7 - i) + '1')]];
            [rankRightLbs[i]
             setText:[NSString stringWithFormat: @"%c",
                      (char)((7 - i) + '1')]];
                             

            [fileTopLbs[i] setTextColor:[UIColor blackColor]];
            [self addSubview:fileTopLbs[i]];
            
            [rankLeftLbs[i] setTextColor:[UIColor blackColor]];
            [self addSubview:rankLeftLbs[i]];
            
            [fileBottomLbs[i] setTextColor:[UIColor blackColor]];
            [self addSubview:fileBottomLbs[i]];
            
            [rankRightLbs[i] setTextColor:[UIColor blackColor]];
            [self addSubview:rankRightLbs[i]];
        }
    }
    return self;
}

@end

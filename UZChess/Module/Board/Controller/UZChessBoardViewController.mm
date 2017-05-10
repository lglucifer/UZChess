//
//  UZBoardViewController.m
//  UZChess
//
//  Created by Xiaoyu Liu on 17/5/4.
//  Copyright © 2017年 com.uzero. All rights reserved.
//

#import "UZChessBoardViewController.h"
#import "UZChessBoardView.h"
#import "UZCoordinateView.h"

@interface UZChessBoardViewController ()

@end

@implementation UZChessBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat boardSize = SCREEN_WIDTH - 10;
    CGFloat boardOffSetY = (SCREEN_Height - boardSize) / 2;
    UZChessBoardView *boardView = [[UZChessBoardView alloc] initWithFrame:CGRectMake(5,
                                                                                     boardOffSetY,
                                                                                     boardSize,
                                                                                     boardSize)];
    [self.view addSubview:boardView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

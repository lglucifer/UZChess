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

#import "UZChessGameController.h"

@interface UZChessBoardViewController ()

@property (nonatomic, weak) UZChessGameController *gameController;

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
    self.boardView = boardView;
}

- (void)configureWithGameController:(UZChessGameController *)gameController {
    self.gameController = gameController;
    self.boardView.boardInnerView.gameController = gameController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

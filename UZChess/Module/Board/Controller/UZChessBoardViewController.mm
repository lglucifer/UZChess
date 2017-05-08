//
//  UZBoardViewController.m
//  UZChess
//
//  Created by Xiaoyu Liu on 17/5/4.
//  Copyright © 2017年 com.uzero. All rights reserved.
//

#import "UZChessBoardViewController.h"
#import "UZChessBoardView.h"

@interface UZChessBoardViewController ()

@end

@implementation UZChessBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UZChessBoardView *boardView = [[UZChessBoardView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:boardView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

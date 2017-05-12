//
//  UZBoardViewController.h
//  UZChess
//
//  Created by Xiaoyu Liu on 17/5/4.
//  Copyright © 2017年 com.uzero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UZChessBoardView.h"
#import "UZChessGameController.h"

@interface UZChessBoardViewController : UIViewController

@property (nonatomic, weak) UZChessBoardView *boardView;

- (void)configureWithGameController:(UZChessGameController *)gameController;

@end

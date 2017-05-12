//
//  UZChessBoardView.h
//  UZChess
//
//  Created by Xiaoyu Liu on 17/5/8.
//  Copyright © 2017年 com.uzero. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UZChessBoardInnerView.h"

@interface UZChessBoardView : UIView

@property (nonatomic, weak, readonly) UZChessBoardInnerView *boardInnerView;

@end

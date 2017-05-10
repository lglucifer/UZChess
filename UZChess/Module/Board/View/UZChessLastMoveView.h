//
//  UZChessLastMoveView.h
//  UZChess
//
//  Created by Xiaoyu Liu on 17/5/10.
//  Copyright © 2017年 com.uzero. All rights reserved.
//

#import <UIKit/UIKit.h>

#include "square.h"

using namespace Chess;

@interface UZChessLastMoveView : UIView

- (id)initWithFrame:(CGRect)frame
             fromSq:(Square)fSq
               toSq:(Square)tSq
             sqSize:(float)sqSize;

@end

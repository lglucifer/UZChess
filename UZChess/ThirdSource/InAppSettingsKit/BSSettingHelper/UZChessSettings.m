//
//  UZChessSettings.m
//  UZChess
//
//  Created by Xiaoyu Liu on 17/5/4.
//  Copyright © 2017年 com.uzero. All rights reserved.
//

#import "UZChessSettings.h"
#import "UZChessSettingStore.h"

@interface UZChessSettings()

@property (nonatomic, strong, readwrite) UIColor *darkSquareColor;
@property (nonatomic, strong, readwrite) UIColor *lightSquareColor;
@property (nonatomic, strong, readwrite) UIColor *highlightSqureColor;

@property (nonatomic, strong, readwrite) UIImage *darkSquareImage;
@property (nonatomic, strong, readwrite) UIImage *lightSquareImage;

@end

@implementation UZChessSettings

+ (NSString *)settingPropertyKeyPrefix {
    return UZSettingStoreChessSettingKeyPrefix;
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [self installSettingHelper];
        }
    });
}

- (instancetype)initWithSettingStore:(UZBaseSettingStore *)settingStore {
    if (self = [super initWithSettingStore:settingStore]) {
        [self configureSquareWithSquareTheme];
    }
    return self;
}

+ (NSDictionary *)settingPropertyKeysWithDefaultValues {
    return
    @{
      @"gameMode": @(0),
      @"AIStyle": @(0),
      @"boardSquareTheme": @(6),
      @"enablePonder": @(YES)
    };
}

- (void)configureSquareWithSquareTheme {
    switch (self.boardSquareTheme) {
        case UZChessBoardSquareTheme_Red:
            self.darkSquareColor = [UIColor colorWithRed:0.6
                                                   green:0.28
                                                    blue:0.28
                                                   alpha:1.0];
            self.lightSquareColor = [UIColor colorWithRed:1.0
                                                    green:0.8
                                                     blue:0.8
                                                    alpha:1.0];
            self.highlightSqureColor = [UIColor blueColor];
            self.darkSquareImage = nil;
            self.lightSquareImage = nil;
            break;
        case UZChessBoardSquareTheme_Blue:
            self.darkSquareColor = [UIColor colorWithRed:0.24
                                                   green:0.48
                                                    blue:0.84
                                                   alpha:1.0];
            self.lightSquareColor = [UIColor colorWithRed:0.7
                                                    green:0.8
                                                     blue:1.0
                                                    alpha:1.0];
            self.highlightSqureColor = [UIColor purpleColor];
            self.darkSquareImage = nil;
            self.lightSquareImage = nil;
            break;
        case UZChessBoardSquareTheme_Gray:
            self.darkSquareColor = [UIColor colorWithRed:0.5
                                                   green:0.5
                                                    blue:0.5
                                                   alpha:1.0];
            self.lightSquareColor = [UIColor colorWithRed:0.8
                                                    green:0.8
                                                     blue:0.8
                                                    alpha:1.0];
            self.highlightSqureColor = [UIColor blueColor];
            self.darkSquareImage = nil;
            self.lightSquareImage = nil;
            break;
        case UZChessBoardSquareTheme_Wood:
            self.darkSquareColor = [UIColor colorWithRed:0.57
                                                   green:0.4
                                                    blue:0.35
                                                   alpha:1.0];
            self.lightSquareColor = [UIColor colorWithRed:0.9
                                                    green:0.8
                                                     blue:0.7
                                                    alpha:1.0];
            self.highlightSqureColor = [UIColor blueColor];
            self.darkSquareImage = [UIImage imageNamed:@"DarkWood"];
            self.lightSquareImage = [UIImage imageNamed:@"LightWood"];
            break;
        case UZChessBoardSquareTheme_Brown:
            self.darkSquareColor = [UIColor colorWithRed:0.74
                                                   green:0.49
                                                    blue:0.32
                                                   alpha:1.0];
            self.lightSquareColor = [UIColor colorWithRed:0.96
                                                    green:0.84
                                                     blue:0.66
                                                    alpha:1.0];
            self.highlightSqureColor = [UIColor blueColor];
            self.darkSquareImage = nil;
            self.lightSquareImage = nil;
            break;
        case UZChessBoardSquareTheme_Green:
            self.darkSquareColor = [UIColor colorWithRed:0.26
                                                   green:0.37
                                                    blue:0.26
                                                   alpha:1.0];
            self.lightSquareColor = [UIColor colorWithRed:0.56
                                                    green:0.71
                                                     blue:0.52
                                                    alpha:1.0];
            self.highlightSqureColor = [UIColor blueColor];
            self.darkSquareImage = nil;
            self.lightSquareImage = nil;
            break;
        case UZChessBoardSquareTheme_Newspaper:
            self.darkSquareColor = [UIColor colorWithRed:0.57
                                                   green:0.4
                                                    blue:0.35
                                                   alpha:1.0];
            self.lightSquareColor = [UIColor colorWithRed:0.9
                                                    green:0.8
                                                     blue:0.7
                                                    alpha:1.0];
            self.highlightSqureColor = [UIColor blueColor];
            self.darkSquareImage = [UIImage imageNamed:@"DarkNewspaper"];
            self.lightSquareImage = [UIImage imageNamed:@"LightNewspaper"];
            break;
        default:
            self.darkSquareColor = [UIColor colorWithRed:0.74
                                                   green:0.49
                                                    blue:0.32
                                                   alpha:1.0];
            self.lightSquareColor = [UIColor colorWithRed:0.96
                                                    green:0.84
                                                     blue:0.66
                                                    alpha:1.0];
            self.highlightSqureColor = [UIColor blueColor];
            self.darkSquareImage = nil;
            self.lightSquareImage = nil;
            break;
    }
}

- (NSString *)AIStyleFormat {
    switch (self.AIStyle) {
        case UZChessAIStyle_Active:
            return @"Active";
        case UZChessAIStyle_Solid:
            return @"Solid";
        case UZChessAIStyle_Passive:
            return @"Passive";
        case UZChessAIStyle_Suicidal:
            return @"Suicidal";
        case UZChessAIStyle_Aggressive:
            return @"Aggressive";
        default:
            return @"active";
    }
}

- (NSString *)pieceThemeFormat {
    switch (self.boardPieceTheme) {
        case UZChessBoardPieceTheme_Cheq:
            return @"Cheq";
        case UZChessBoardPieceTheme_Maya:
            return @"Maya";
        case UZChessBoardPieceTheme_USCF:
            return @"USCF";
        case UZChessBoardPieceTheme_Alpha:
            return @"Alpha";
        case UZChessBoardPieceTheme_Berlin:
            return @"Berlin";
        case UZChessBoardPieceTheme_Merida:
            return @"Merida";
        case UZChessBoardPieceTheme_Modern:
            return @"Modern";
        case UZChessBoardPieceTheme_Leipzig:
            return @"Leipzig";
        case UZChessBoardPieceTheme_Russian:
            return @"Russian";
        case UZChessBoardPieceTheme_Invisible:
            return @"Invisible";
        default:
            return @"Modern";
    }
}

@end

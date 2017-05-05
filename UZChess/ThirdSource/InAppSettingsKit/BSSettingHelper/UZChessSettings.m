//
//  UZChessSettings.m
//  UZChess
//
//  Created by Xiaoyu Liu on 17/5/4.
//  Copyright © 2017年 com.uzero. All rights reserved.
//

#import "UZChessSettings.h"
#import "UZChessSettingStore.h"

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

+ (NSDictionary *)settingPropertyKeysWithDefaultValues {
    return @{};
}

@end

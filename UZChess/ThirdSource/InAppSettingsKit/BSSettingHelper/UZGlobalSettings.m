//
//  UZGlobalSettings.m
//  UZChess
//
//  Created by Xiaoyu Liu on 17/5/4.
//  Copyright © 2017年 com.uzero. All rights reserved.
//

#import "UZGlobalSettings.h"
#import "UZSettingStore.h"

@implementation UZGlobalSettings

+ (NSString *)settingPropertyKeyPrefix {
    return UZSettingStoreGlobalSettingKeyPrefix;
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

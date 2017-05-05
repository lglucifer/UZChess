//
//  UZAbstractSettings.h
//  CHBookstore
//
//  Created by liuxiaoyu on 14-2-25.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UZBaseSettingStore;
@interface UZAbstractSettings : NSObject

@property (nonatomic, strong, readonly) NSDictionary *defaultSettings;

- (instancetype)initWithSettingStore:(UZBaseSettingStore *)settingStore;

+ (void)installSettingHelper;

@end

@interface UZAbstractSettings (SubclassingHooks)

+ (NSString *)settingPropertyKeyPrefix;

+ (NSDictionary *)settingPropertyKeysWithDefaultValues;

@end

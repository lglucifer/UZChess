//
//  UZBaseSettingStore.h
//  UZChess
//
//  Created by Xiaoyu Liu on 17/5/4.
//  Copyright © 2017年 com.uzero. All rights reserved.
//

#import "IASKSettingsStore.h"
#import "UZAbstractSettings.h"

extern NSString *const UZSettingStoreChangedSettingKey;
extern NSString *const UZSettingStoreChangedSettingOldValueKey;
extern NSString *const UZSettingStoreChangedSettingNewValueKey;

@interface UZBaseSettingStore : IASKAbstractSettingsStore

@property (nonatomic, strong, readonly) NSDictionary *settingsInStore;

- (NSString *)plistPathComponentName;

- (NSString *)settingStoreKeyPrefix;

- (NSString *)settingStoreDidChangeNotificationName;

- (void)purgeAllSettings;

@end

@interface UZBaseSettingStore(Helper)

@property (nonatomic, strong, readonly) UZAbstractSettings *storeSettings;

@end

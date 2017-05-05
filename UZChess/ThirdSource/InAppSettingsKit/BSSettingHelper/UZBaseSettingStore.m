//
//  UZBaseSettingStore.m
//  UZChess
//
//  Created by Xiaoyu Liu on 17/5/4.
//  Copyright © 2017年 com.uzero. All rights reserved.
//

#import "UZBaseSettingStore.h"

NSString *const UZSettingStoreChangedSettingKey = @"UZSettingStoreChangedSettingKey";
NSString *const UZSettingStoreChangedSettingOldValueKey = @"UZSettingStoreChangedSettingOldValueKey";
NSString *const UZSettingStoreChangedSettingNewValueKey = @"UZSettingStoreChangedSettingNewValueKey";

@interface UZBaseSettingStore()

@property (nonatomic, strong, readwrite) NSDictionary *settingsInStore;

@end

@implementation UZBaseSettingStore

- (NSString *)settingFloderPath {
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
}

- (NSString *)plistPathComponentName {
    return nil;
}

- (NSString *)globalSettingFilePath {
    NSString *plistPathComponentName = [self plistPathComponentName];
    NSParameterAssert(plistPathComponentName);
    return [[self settingFloderPath] stringByAppendingPathComponent:plistPathComponentName];
}

- (NSDictionary *)settingsInStore {
    if (!_settingsInStore) {
        NSMutableDictionary *settingsInStore = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfFile:self.globalSettingFilePath]];
        [self.storeSettings.defaultSettings enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            if (!settingsInStore[key]) {
                settingsInStore[key] = obj;
            }
        }];
        _settingsInStore = settingsInStore.copy;
    }
    return _settingsInStore;
}

- (NSString *)settingStoreKeyPrefix {
    return nil;
}

- (NSString *)settingStoreDidChangeNotificationName {
    return nil;
}

- (void)setObject:(id)value forKey:(NSString *)key {
    void(^setKeyValueInDictionary)(NSMutableDictionary*) = ^(NSMutableDictionary *dictionary) {
        id oldValue = dictionary[key];
        dictionary[key] = value;
        
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        userInfo[UZSettingStoreChangedSettingKey] = key;
        userInfo[UZSettingStoreChangedSettingNewValueKey] = value;
        if (oldValue) {
            userInfo[UZSettingStoreChangedSettingOldValueKey] = oldValue;
        }
        
        NSString *settingStoreDidChangeNotificationName = [self settingStoreDidChangeNotificationName];
        NSParameterAssert(settingStoreDidChangeNotificationName);
        [[NSNotificationCenter defaultCenter] postNotificationName:settingStoreDidChangeNotificationName object:self userInfo:userInfo.copy];
    };
    
    NSString *settingStoreKeyPrefix = [self settingStoreKeyPrefix];
    NSParameterAssert(settingStoreKeyPrefix);
    if ([key hasPrefix:settingStoreKeyPrefix]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:self.settingsInStore];
        setKeyValueInDictionary(dictionary);
        self.settingsInStore = dictionary.copy;
    }
    [self synchronize];
}

- (id)objectForKey:(NSString *)key {
    NSString *settingStoreKeyPrefix = [self settingStoreKeyPrefix];
    NSParameterAssert(settingStoreKeyPrefix);
    if ([key hasPrefix:settingStoreKeyPrefix]) {
        return self.settingsInStore[key];
    }
    return nil;
}

- (BOOL)synchronize {
    [self.settingsInStore writeToFile:[self globalSettingFilePath] atomically:YES];
    return YES;
}

- (void)purgeAllSettings {
    
}

@end

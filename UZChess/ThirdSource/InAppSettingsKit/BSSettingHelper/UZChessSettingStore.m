//
//  UZChessSettingStore.m
//  UZChess
//
//  Created by Xiaoyu Liu on 17/5/4.
//  Copyright © 2017年 com.uzero. All rights reserved.
//

#import "UZChessSettingStore.h"

NSString *const UZSettingStoreChessSettingKeyPrefix = @"C_";
NSString *const UZSettingStoreChessSettingDidChangeNotification = @"UZSettingStoreChessSettingDidChangeNotification";

@interface UZChessSettingStore()

@property (nonatomic, copy) NSString *name;

@end

@implementation UZChessSettingStore

+ (UZChessSettingStore *)defaultStore {
    static UZChessSettingStore *_defaultStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultStore = [[UZChessSettingStore alloc] initWithName:@"Default"];
    });
    return _defaultStore;
}

- (id)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"%@ Failed to call designated initializer. Invoke `initWithName:` instead.", NSStringFromClass([self class])] userInfo:nil];
}

- (id)initWithName:(NSString *)name {
    if (self = [super init]) {
        NSParameterAssert(name);
        self.name = name;
    }
    return self;
}

- (NSString *)plistPathComponentName {
    return @"ChessSettings.plist";
}

- (NSString *)settingStoreKeyPrefix {
    return UZSettingStoreChessSettingKeyPrefix;
}

- (NSString *)settingStoreDidChangeNotificationName {
    return UZSettingStoreChessSettingDidChangeNotification;
}

@end

#import <objc/runtime.h>

@implementation UZChessSettingStore (Helper)

- (UZChessSettings *)storeSettings {
    static NSString *UZSettingStoreChessSettingAssociationKey = @"UZSettingStoreChessSettingAssociationKey";
    UZChessSettings *storeSettings = objc_getAssociatedObject(self, &UZSettingStoreChessSettingAssociationKey);
    if (!storeSettings) {
        storeSettings = [[UZChessSettings alloc] initWithSettingStore:self];
        objc_setAssociatedObject(self, &UZSettingStoreChessSettingAssociationKey, storeSettings, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return storeSettings;
}

@end

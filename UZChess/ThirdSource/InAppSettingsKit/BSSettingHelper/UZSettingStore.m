//
//  UZSettingStore.m
//  CHBookstore
//
//  Created by liuxiaoyu on 14-2-25.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "UZSettingStore.h"

NSString *const UZSettingStoreGlobalSettingKeyPrefix = @"G_";
NSString *const UZSettingStoreSettingDidChangeNotification = @"UZSettingStoreSettingDidChangeNotification";

@interface UZSettingStore()

@property (nonatomic, copy) NSString *name;

@end

@implementation UZSettingStore

+ (UZSettingStore *)defaultStore {
	static UZSettingStore *_defaultStore = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_defaultStore = [[UZSettingStore alloc] initWithName:@"Default"];
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
	return @"GlobalSettings.plist";
}

- (NSString *)settingStoreKeyPrefix {
    return UZSettingStoreGlobalSettingKeyPrefix;
}

- (NSString *)settingStoreDidChangeNotificationName {
    return UZSettingStoreSettingDidChangeNotification;
}

@end

#import <objc/runtime.h>

@implementation UZSettingStore (Helper)

- (UZGlobalSettings *)storeSettings {
	static NSString *UZSettingStoreGlobalSettingAssociationKey = @"UZSettingStoreGlobalSettingAssociationKey";
	UZGlobalSettings *storeSettings = objc_getAssociatedObject(self, &UZSettingStoreGlobalSettingAssociationKey);
	if (!storeSettings) {
		storeSettings = [[UZGlobalSettings alloc] initWithSettingStore:self];
		objc_setAssociatedObject(self, &UZSettingStoreGlobalSettingAssociationKey, storeSettings, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	return storeSettings;
}

@end

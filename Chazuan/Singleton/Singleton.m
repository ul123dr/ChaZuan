//
//  Singleton.m
//  Chazuan
//
//  Created by BecksZ on 2019/4/30.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "Singleton.h"
#import "SAMKeychain.h"

#define CONFIG_PATH [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Config.plist"]

@interface Singleton ()

@end

@implementation Singleton

static Singleton *sharedInstance = nil;
/* 单例调用 */
+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Singleton alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // 把 config 配置文件写入内存
        NSString *config_path = CONFIG_PATH;
        if(![[NSFileManager defaultManager] fileExistsAtPath:config_path]){
            [[NSFileManager defaultManager] copyItemAtPath:[[NSBundle mainBundle] pathForResource:@"Config" ofType:@"plist"] toPath:config_path error:nil];
        }
    }
    return self;
}

/* 获取设备唯一标识 */
+ (NSString *)getUniqueDeviceIdentifierAsString {
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    
    NSString *strApplicationUUID =  [SAMKeychain passwordForService:appName account:@"incoding"];
    if (kStringIsEmpty(strApplicationUUID)) {
        // 获取设备唯一标识（该标识每次获取都会改变，所以使用keychain钥匙串保存）
        strApplicationUUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        
        NSError *error = nil;
        SAMKeychainQuery *query = [[SAMKeychainQuery alloc] init];
        query.service = appName;
        query.account = @"incoding";
        query.password = strApplicationUUID;
        query.synchronizationMode = SAMKeychainQuerySynchronizationModeNo;
        [query save:&error];
    }
    
    return strApplicationUUID;
}

// MARK: - 属性方法
// 字符串相关
- (void)setString:(NSString *)obj forKey:(NSString *)key {
    if (kStringIsEmpty(key)) return;
    if (kStringIsEmpty(obj)) obj = @"";
    NSMutableDictionary *plist = [NSMutableDictionary dictionaryWithContentsOfFile:CONFIG_PATH];
    [plist setObject:obj forKey:key];
    [plist writeToFile:CONFIG_PATH  atomically:YES];
}
- (NSString *)stringForKey:(NSString *)key {
    if (kStringIsEmpty(key)) return @"";
    NSMutableDictionary *plist = [NSMutableDictionary dictionaryWithContentsOfFile:CONFIG_PATH];
    NSString *value = [plist objectForKey:key];
    if (kStringIsEmpty(value)) return @"";
    return value;
}
- (void)removeStringForKey:(NSString *)key {
    if (kStringIsEmpty(key)) return;
    NSMutableDictionary *plist = [NSMutableDictionary dictionaryWithContentsOfFile:CONFIG_PATH];
    [plist removeObjectForKey:key];
    [plist writeToFile:CONFIG_PATH  atomically:YES];
}
// 数值相关
- (void)setNumber:(NSNumber *)obj forKey:(NSString *)key {
    if (kStringIsEmpty(key)) return;
    if (kObjectIsNil(obj)) obj = @(0);
    NSMutableDictionary *plist = [NSMutableDictionary dictionaryWithContentsOfFile:CONFIG_PATH];
    [plist setObject:obj forKey:key];
    [plist writeToFile:CONFIG_PATH  atomically:YES];
}
- (NSNumber *)numberForKey:(NSString *)key {
    if (kStringIsEmpty(key)) return @(0);
    NSMutableDictionary *plist = [NSMutableDictionary dictionaryWithContentsOfFile:CONFIG_PATH];
    NSNumber *value = [plist objectForKey:key];
    if (kObjectIsNil(value)) return @(0);
    return value;
}
- (void)removeNumberForKey:(NSString *)key {
    if (kStringIsEmpty(key)) return;
    NSMutableDictionary *plist = [NSMutableDictionary dictionaryWithContentsOfFile:CONFIG_PATH];
    [plist removeObjectForKey:key];
    [plist writeToFile:CONFIG_PATH  atomically:YES];
}
// bool相关操作
- (void)setBool:(BOOL)obj forKey:(NSString *)key {
    [self setNumber:[NSNumber numberWithBool:obj] forKey:key];
}
- (BOOL)boolForKey:(NSString *)key {
    return [[self numberForKey:key] boolValue];
}
- (void)removeBool:(NSString *)key {
    [self removeNumberForKey:key];
}

/* 判断 key 是否有值，当前 key 未存储时，也返回 NO */
- (BOOL)hasValueForKey:(NSString *)key {
    if (kStringIsEmpty(key)) return NO;
    NSMutableDictionary *plist = [NSMutableDictionary dictionaryWithContentsOfFile:CONFIG_PATH];
    if (![plist.allKeys containsObject:key]) { return NO; }
    id value = [plist objectForKey:key];
    if (kObjectIsNil(value)) { return NO; }
    return YES;
}

/// MARK: - 账号密码
// 账号密码操作
- (NSString *)getUserName {
    return [self stringForKey:ZGCUserNameKey];
}
- (void)setUserName:(NSString *)name {
    [self setString:name forKey:ZGCUserNameKey];
}
- (NSString *)getPassword {
    return [self stringForKey:ZGCPasswordKey];
}
- (void)setPassword:(NSString *)pwd {
    [self setString:pwd forKey:ZGCPasswordKey];
}

/// MARK: - 角色
- (NSString *)getRoleName:(NSInteger)lever {
    switch (lever) {
        case 1: return @"会员";
        case 2: return @"采购专员";
        case 3: return @"销售专员";
        case 4: return @"物流专员";
        case 5: return @"管理层";
        case 6: return @"guest";
        case 9: return @"采购专员";
        case 99: return @"网站所有者";
        default: return @"";
    }
}

@end

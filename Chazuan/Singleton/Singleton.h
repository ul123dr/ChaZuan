//
//  Singleton.h
//  Chazuan
//
//  Created by BecksZ on 2019/4/30.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Singleton : NSObject

/// 单例调用
+ (instancetype)shareInstance;

/// 获取设备唯一标识
/// @return 标识字符串
+ (NSString *)getUniqueDeviceIdentifierAsString;

// MARK: - 属性方法
// 字符串相关
- (void)setString:(nullable NSString *)obj forKey:(nullable NSString *)key;
- (NSString *)stringForKey:(nullable NSString *)key;
- (void)removeStringForKey:(nullable NSString *)key;
// 数值相关
- (void)setNumber:(nullable NSNumber *)obj forKey:(nullable NSString *)key;
- (NSNumber *)numberForKey:(nullable NSString *)key;
- (void)removeNumberForKey:(nullable NSString *)key;
// bool相关操作
- (void)setBool:(BOOL)obj forKey:(nullable NSString *)key;
- (BOOL)boolForKey:(nullable NSString *)key;
- (void)removeBool:(nullable NSString *)key;

/// 判断 key 是否有值，当前 key 未存储时，也返回 NO
- (BOOL)hasValueForKey:(nullable NSString *)key;

/// MARK: - 账号密码
// 账号密码操作
- (NSString *)getUserName;
- (void)setUserName:(nullable NSString *)name;
- (NSString *)getPassword;
- (void)setPassword:(nullable NSString *)pwd;

/// MARK: - 角色
- (NSString *)getRoleName:(NSInteger)lever;


@end

NS_ASSUME_NONNULL_END

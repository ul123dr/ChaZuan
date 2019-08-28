//
//  KeyedSubscript.h
//  chazuan
//
//  Created by BecksZ on 2019/4/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyedSubscript : NSObject

/// 类方法
+ (instancetype)subscript;
/// 拼接一个字典
+ (instancetype)subscriptWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (id)objectForKeyedSubscript:(id)key;
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;

/// 转换为字典
- (NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END

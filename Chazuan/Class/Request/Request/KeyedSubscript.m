//
//  KeyedSubscript.m
//  chazuan
//
//  Created by BecksZ on 2019/4/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "KeyedSubscript.h"

@interface KeyedSubscript ()
/// 字典
@property (nonatomic, readwrite, strong) NSMutableDictionary *kvs;
@end

@implementation KeyedSubscript

+ (instancetype)subscript {
    return [[self alloc] init];
}

+ (instancetype)subscriptWithDictionary:(NSDictionary *)dict {
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.kvs = [NSMutableDictionary dictionary];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.kvs = [NSMutableDictionary dictionary];
        if ([dict count]) {
            [self.kvs addEntriesFromDictionary:dict];
        }
    }
    return self;
}

- (id)objectForKeyedSubscript:(id)key {
    return key ? [self.kvs objectForKey:key] : nil;
}

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key {
    if (key) {
        if (obj) {
            [self.kvs setObject:obj forKey:key];
        } else {
            [self.kvs removeObjectForKey:key];
        }
    }
}

- (NSDictionary *)dictionary {
    return self.kvs.copy;
}

@end

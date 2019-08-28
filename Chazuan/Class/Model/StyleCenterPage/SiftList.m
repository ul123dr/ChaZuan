//
//  SiftList.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/17.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "SiftList.h"

@implementation SiftList

+ (instancetype)listWithId:(NSNumber *)listId name:(NSString *)name {
    return [[self alloc] initWithId:listId name:name];
}

- (instancetype)initWithId:(NSNumber *)listId name:(NSString *)name {
    self = [super init];
    if (self) {
        if (kObjectIsNotNil(listId)) self.listId = listId;
        self.name = name;
    }
    return self;
}

@end


//
//  SiftList.h
//  Chazuan
//
//  Created by BecksZ on 2019/7/17.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MHObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface SiftList : MHObject

+ (instancetype)listWithId:(NSNumber *)listId name:(NSString *)name;

@property (nonatomic, readwrite, strong) NSNumber *listId;
@property (nonatomic, readwrite, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END

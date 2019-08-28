//
//  DiamSearchResultItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "DiamSearchResultItemViewModel.h"

@implementation DiamSearchResultItemViewModel

+ (instancetype)itemViewModel {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        self.rowHeight = ZGCConvertToPx(40);
    }
    return self;
}

@end

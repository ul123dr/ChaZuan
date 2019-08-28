//
//  CommonGroupViewModel.m
//  chazuan
//
//  Created by BecksZ on 2019/4/15.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CommonGroupViewModel.h"

@implementation CommonGroupViewModel

+ (instancetype)groupViewModel {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _footerHeight = CGFLOAT_MIN;
        _headerHeight = CGFLOAT_MIN;
        _footerBackColor = COLOR_BG;
        _headerBackColor = COLOR_BG;
    }
    return self;
}

@end

//
//  DiamSearchItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/6.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "DiamSearchItemViewModel.h"
#import "DiamSearchCell.h"

@implementation DiamSearchItemViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.addNum = @"0";
        self.tableViewCellClass = DiamSearchCell.class;
    }
    return self;
}

@end

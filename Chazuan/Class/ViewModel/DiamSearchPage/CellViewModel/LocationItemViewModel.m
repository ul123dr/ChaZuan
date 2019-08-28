//
//  LocationItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/6.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "LocationItemViewModel.h"
#import "DiamLocationCell.h"

@implementation LocationItemViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectArr = @[@(NO),@(NO),@(NO)];
        self.tableViewCellClass = DiamLocationCell.class;
    }
    return self;
}

@end

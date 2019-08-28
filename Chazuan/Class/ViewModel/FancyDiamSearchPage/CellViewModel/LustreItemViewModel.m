//
//  LustreItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/7.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "LustreItemViewModel.h"
#import "FancyLustreCell.h"

@implementation LustreItemViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectArr = @[@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO)];
        self.tableViewCellClass = FancyLustreCell.class;
    }
    return self;
}

@end

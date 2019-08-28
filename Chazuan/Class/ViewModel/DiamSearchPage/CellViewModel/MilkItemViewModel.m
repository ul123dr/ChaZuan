//
//  MilkItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/6.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MilkItemViewModel.h"
#import "DiamMilkCell.h"

@implementation MilkItemViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.milkSelectArr = @[@(NO),@(NO),@(NO),@(NO)];
        self.blackSelectArr = @[@(NO),@(NO)];
        self.tableViewCellClass = DiamMilkCell.class;
    }
    return self;
}

@end

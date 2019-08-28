//
//  StrengthItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/7.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "StrengthItemViewModel.h"
#import "FancyStrengthCell.h"

@implementation StrengthItemViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectArr = @[@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO)];
        self.tableViewCellClass = FancyStrengthCell.class;
    }
    return self;
}

@end

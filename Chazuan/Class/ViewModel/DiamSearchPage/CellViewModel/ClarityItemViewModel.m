//
//  ClarityItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/5.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "ClarityItemViewModel.h"
#import "DiamClarityCell.h"

@implementation ClarityItemViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectArr = @[@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO)];
        self.tableViewCellClass = DiamClarityCell.class;
    }
    return self;
}

@end

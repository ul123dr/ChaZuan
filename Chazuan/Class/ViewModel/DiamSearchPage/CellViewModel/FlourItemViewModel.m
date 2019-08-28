//
//  FlourItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/5.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "FlourItemViewModel.h"
#import "DiamFlourCell.h"

@implementation FlourItemViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectArr = @[@(NO),@(NO),@(NO),@(NO),@(NO)];
        self.tableViewCellClass = DiamFlourCell.class;
    }
    return self;
}

@end

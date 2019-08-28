//
//  FancyColorItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/7.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "FancyColorItemViewModel.h"
#import "FancyColorCell.h"

@implementation FancyColorItemViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectArr = @[@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO)];
        self.tableViewCellClass = FancyColorCell.class;
    }
    return self;
}


@end

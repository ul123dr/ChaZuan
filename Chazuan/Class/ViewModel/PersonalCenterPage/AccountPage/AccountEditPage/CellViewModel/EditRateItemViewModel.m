//
//  EditRateItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "EditRateItemViewModel.h"
#import "EditRateCell.h"

@implementation EditRateItemViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.shouldEdited = YES;
        self.tableViewCellClass = EditRateCell.class;
    }
    return self;
}

@end

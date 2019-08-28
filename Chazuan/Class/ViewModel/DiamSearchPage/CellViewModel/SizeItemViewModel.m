//
//  SizeItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/5.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "SizeItemViewModel.h"
#import "DiamSizeCell.h"

@implementation SizeItemViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tableViewCellClass = DiamSizeCell.class;
    }
    return self;
}

@end

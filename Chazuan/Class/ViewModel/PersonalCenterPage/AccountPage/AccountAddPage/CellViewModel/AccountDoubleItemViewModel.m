//
//  AccountDoubleItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/18.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "AccountDoubleItemViewModel.h"
#import "AccountDoubleSelectCell.h"

@implementation AccountDoubleItemViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.shouldEdited = YES;
        self.show = YES;
        self.tableViewCellClass = AccountDoubleSelectCell.class;
    }
    return self;
}

@end

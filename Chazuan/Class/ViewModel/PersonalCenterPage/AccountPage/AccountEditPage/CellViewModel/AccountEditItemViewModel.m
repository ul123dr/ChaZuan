//
//  AccountEditItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "AccountEditItemViewModel.h"
#import "AccountEditCell.h"

@implementation AccountEditItemViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.tableViewCellClass = AccountEditCell.class;
    }
    return self;
}

@end

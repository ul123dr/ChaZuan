//
//  AccountAddItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/18.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "AccountAddItemViewModel.h"
#import "AccountAddCell.h"

@implementation AccountAddItemViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.tableViewCellClass = AccountAddCell.class;
    }
    return self;
}

@end

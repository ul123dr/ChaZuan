//
//  OrderItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/4/30.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "OrderItemViewModel.h"
#import "OrderCell.h"

@implementation OrderItemViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tableViewCellClass = OrderCell.class;
    }
    return self;
}

@end

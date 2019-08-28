//
//  CartItemViewModel.m
//  chazuan
//
//  Created by BecksZ on 2019/4/19.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CartItemViewModel.h"
#import "ShopCartCell.h"

@implementation CartItemViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tableViewCellClass = ShopCartCell.class;
    }
    return self;
}

@end

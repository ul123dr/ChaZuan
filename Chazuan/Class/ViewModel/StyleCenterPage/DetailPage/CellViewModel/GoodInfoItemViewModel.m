//
//  GoodInfoItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/28.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "GoodInfoItemViewModel.h"
#import "GoodInfoCell.h"

@implementation GoodInfoItemViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tableViewCellClass = GoodInfoCell.class;
    }
    return self;
}

@end

//
//  VipRateItemViewModel.m
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "VipRateItemViewModel.h"
#import "VipRateCell.h"

@implementation VipRateItemViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.tableViewCellClass = VipRateCell.class;
    }
    return self;
}

@end

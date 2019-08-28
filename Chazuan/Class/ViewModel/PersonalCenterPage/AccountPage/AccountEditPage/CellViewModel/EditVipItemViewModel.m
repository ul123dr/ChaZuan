//
//  EditVipItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "EditVipItemViewModel.h"
#import "EditVipCell.h"

@implementation EditVipItemViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.shouldEdited = YES;
        self.tableViewCellClass = EditVipCell.class;
    }
    return self;
}

@end

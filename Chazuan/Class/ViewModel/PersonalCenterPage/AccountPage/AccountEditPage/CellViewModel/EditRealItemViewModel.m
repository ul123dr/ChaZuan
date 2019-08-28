//
//  EditRealItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "EditRealItemViewModel.h"
#import "EditRealCell.h"

@implementation EditRealItemViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.shouldEdited = YES;
        self.tableViewCellClass = EditRealCell.class;
    }
    return self;
}

@end

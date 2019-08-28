//
//  EditSellerItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "EditSellerItemViewModel.h"
#import "EditSellerCell.h"

@implementation EditSellerItemViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.shouldEdited = YES;
        self.tableViewCellClass = EditSellerCell.class;
    }
    return self;
}

@end

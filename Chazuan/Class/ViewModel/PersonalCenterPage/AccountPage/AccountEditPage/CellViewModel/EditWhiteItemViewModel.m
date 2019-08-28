//
//  EditWhiteItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "EditWhiteItemViewModel.h"
#import "EditWhiteCell.h"

@implementation EditWhiteItemViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.shouldEdited = YES;
        self.tableViewCellClass = EditWhiteCell.class;
    }
    return self;
}

@end

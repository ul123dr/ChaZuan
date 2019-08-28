//
//  EditWhiteItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "EditDiscItemViewModel.h"
#import "EditDiscCell.h"

@implementation EditDiscItemViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.shouldEdited = YES;
        self.tableViewCellClass = EditDiscCell.class;
    }
    return self;
}

@end

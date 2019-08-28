//
//  EditFromItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "EditFromItemViewModel.h"
#import "EditFromCell.h"

@implementation EditFromItemViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.shouldEdited = YES;
        self.tableViewCellClass = EditFromCell.class;
    }
    return self;
}

@end

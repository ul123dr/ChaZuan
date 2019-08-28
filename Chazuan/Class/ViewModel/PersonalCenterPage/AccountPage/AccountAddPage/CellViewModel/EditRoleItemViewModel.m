//
//  EditRoleItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "EditRoleItemViewModel.h"
#import "EditRoleCell.h"

@implementation EditRoleItemViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.shouldEdited = YES;
        self.tableViewCellClass = EditRoleCell.class;
    }
    return self;
}

@end

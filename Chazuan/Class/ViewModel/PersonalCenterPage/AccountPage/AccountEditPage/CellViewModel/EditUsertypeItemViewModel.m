//
//  EditUsertypeItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "EditUsertypeItemViewModel.h"
#import "EditUsertypeCell.h"

@implementation EditUsertypeItemViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.shouldEdited = YES;
        self.tableViewCellClass = EditUsertypeCell.class;
    }
    return self;
}

@end

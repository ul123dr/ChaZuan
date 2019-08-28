//
//  EditFancyItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "EditFancyItemViewModel.h"
#import "EditFancyCell.h"

@implementation EditFancyItemViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.shouldEdited = YES;
        self.tableViewCellClass = EditFancyCell.class;
    }
    return self;
}


@end

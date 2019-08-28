//
//  EditRightItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "EditRightItemViewModel.h"
#import "EditRightCell.h"

@implementation EditRightItemViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.shouldEdited = YES;
        self.show = YES;
        self.tableViewCellClass = EditRightCell.class;
    }
    return self;
}


@end

//
//  DoneItemViewModel.m
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "DoneItemViewModel.h"
#import "DoneCell.h"

@implementation DoneItemViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.tableViewCellClass = DoneCell.class;
    }
    return self;
}

@end

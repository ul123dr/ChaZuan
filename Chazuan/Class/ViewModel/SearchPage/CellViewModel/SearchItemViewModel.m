//
//  SearchItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/5/6.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "SearchItemViewModel.h"
#import "SearchCell.h"

@implementation SearchItemViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tableViewCellClass = SearchCell.class;
    }
    return self;
}

@end

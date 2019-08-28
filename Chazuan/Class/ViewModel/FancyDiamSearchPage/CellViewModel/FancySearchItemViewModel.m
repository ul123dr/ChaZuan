//
//  FancySearchItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/7.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "FancySearchItemViewModel.h"
#import "FancySearchCell.h"

@implementation FancySearchItemViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tableViewCellClass = FancySearchCell.class;
    }
    return self;
}

@end

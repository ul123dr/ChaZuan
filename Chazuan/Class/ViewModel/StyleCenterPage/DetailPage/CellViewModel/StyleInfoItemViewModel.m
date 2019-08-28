//
//  StyleInfoItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/25.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "StyleInfoItemViewModel.h"
#import "StyleInfoCell.h"

@implementation StyleInfoItemViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tableViewCellClass = StyleInfoCell.class;
        self.shouldHideDividerLine = YES;
    }
    return self;
}

@end

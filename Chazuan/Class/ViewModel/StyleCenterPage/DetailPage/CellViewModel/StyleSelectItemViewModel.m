//
//  StyleSelectItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/26.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "StyleSelectItemViewModel.h"
#import "StyleSelectCell.h"

@implementation StyleSelectItemViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tableViewCellClass = StyleSelectCell.class;
        self.shouldHideDividerLine = YES;
    }
    return self;
}

@end

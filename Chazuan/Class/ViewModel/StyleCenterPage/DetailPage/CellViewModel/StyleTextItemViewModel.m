//
//  StyleTextItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/26.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "StyleTextItemViewModel.h"
#import "StyleInputCell.h"

@implementation StyleTextItemViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tableViewCellClass = StyleInputCell.class;
        self.shouldHideDividerLine = YES;
    }
    return self;
}


@end

//
//  FancyCutItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/7.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "FancyCutItemViewModel.h"
#import "FancyCutCell.h"

@implementation FancyCutItemViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectArr = @[@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO)];
        self.tableViewCellClass = FancyCutCell.class;
    }
    return self;
}


@end

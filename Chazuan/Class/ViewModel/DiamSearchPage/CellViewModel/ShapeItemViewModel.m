//
//  ShapeItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/4.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "ShapeItemViewModel.h"
#import "DiamShapeCell.h"

@implementation ShapeItemViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectArr = @[@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO),@(NO)];
        self.tableViewCellClass = DiamShapeCell.class;
    }
    return self;
}

@end

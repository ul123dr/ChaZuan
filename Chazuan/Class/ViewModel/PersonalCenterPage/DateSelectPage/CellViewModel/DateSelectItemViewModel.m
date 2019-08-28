//
//  DateSelectItemViewModel.m
//  chazuan
//
//  Created by BecksZ on 2019/4/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "DateSelectItemViewModel.h"
#import "DateSelectCell.h"

@implementation DateSelectItemViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.tableViewCellClass = DateSelectCell.class;
    }
    return self;
}

@end

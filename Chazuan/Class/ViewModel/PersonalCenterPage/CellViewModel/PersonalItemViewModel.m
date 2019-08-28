//
//  PersonalItemViewMdoel.m
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "PersonalItemViewModel.h"
#import "PersonalHeaderCell.h"

@implementation PersonalItemViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.tableViewCellClass = PersonalHeaderCell.class;
    }
    return self;
}

@end

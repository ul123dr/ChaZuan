//
//  ChangeProfileItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/18.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "ChangeProfileItemViewModel.h"
#import "ChangeProfileCell.h"

@implementation ChangeProfileItemViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.tableViewCellClass = ChangeProfileCell.class;
    }
    return self;
}


@end

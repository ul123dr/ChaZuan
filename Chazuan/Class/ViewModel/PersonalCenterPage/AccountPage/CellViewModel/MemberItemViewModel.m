//
//  MemberItemViewModel.m
//  chazuan
//
//  Created by BecksZ on 2019/4/24.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "MemberItemViewModel.h"
#import "AccountCell.h"

@implementation MemberItemViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.tableViewCellClass = AccountCell.class;
    }
    return self;
}

@end

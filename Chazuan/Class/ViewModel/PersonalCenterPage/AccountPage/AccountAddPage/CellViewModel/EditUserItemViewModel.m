//
//  EditUserItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "EditUserItemViewModel.h"
#import "AccountAddCell.h"

@implementation EditUserItemViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.shouldEdited = YES;
        self.tableViewCellClass = AccountAddCell.class;
    }
    return self;
}

@end

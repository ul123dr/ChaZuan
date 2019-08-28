//
//  PasswordItemViewModel.m
//  chazuan
//
//  Created by BecksZ on 2019/4/23.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "PasswordItemViewModel.h"
#import "PasswordInputCell.h"

@implementation PasswordItemViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.tableViewCellClass = PasswordInputCell.class;
    }
    return self;
}

@end

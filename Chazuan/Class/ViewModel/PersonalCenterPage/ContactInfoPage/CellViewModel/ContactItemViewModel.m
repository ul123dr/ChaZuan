//
//  ContactItemViewModel.m
//  chazuan
//
//  Created by BecksZ on 2019/4/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "ContactItemViewModel.h"
#import "ContactInfoCell.h"

@implementation ContactItemViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.tableViewCellClass = ContactInfoCell.class;
    }
    return self;
}

@end

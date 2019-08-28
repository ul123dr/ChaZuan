//
//  AvatarItemViewModel.m
//  chazuan
//
//  Created by BecksZ on 2019/4/24.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "AvatarItemViewModel.h"
#import "AvatarCell.h"

@implementation AvatarItemViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.tableViewCellClass = AvatarCell.class;
    }
    return self;
}

@end

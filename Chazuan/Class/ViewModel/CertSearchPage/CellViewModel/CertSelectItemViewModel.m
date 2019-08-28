//
//  CertSelectItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/20.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CertSelectItemViewModel.h"
#import "CertSelectCell.h"

@implementation CertSelectItemViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tableViewCellClass = CertSelectCell.class;
    }
    return self;
}

@end

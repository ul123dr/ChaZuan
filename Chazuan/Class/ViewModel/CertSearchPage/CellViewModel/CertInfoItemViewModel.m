//
//  CertInfoItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/22.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CertInfoItemViewModel.h"
#import "CertInfoCell.h"

@implementation CertInfoItemViewModel

- (instancetype)init {
    if (self = [super init]) {
        self.tableViewCellClass = CertInfoCell.class;
    }
    return self;
}

@end

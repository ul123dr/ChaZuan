//
//  CertSearchItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/6/21.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CertSearchItemViewModel.h"
#import "CertSearchCell.h"

@implementation CertSearchItemViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.tableViewCellClass = CertSearchCell.class;
    }
    return self;
}

@end

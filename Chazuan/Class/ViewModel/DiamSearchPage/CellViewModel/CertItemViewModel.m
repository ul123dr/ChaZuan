//
//  CertItemViewModel.m
//  Chazuan
//
//  Created by BecksZ on 2019/7/5.
//  Copyright © 2019 BecksZeng. All rights reserved.
//

#import "CertItemViewModel.h"
#import "DiamCertCell.h"

@implementation CertItemViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.selectArr = @[@(NO),@(NO),@(NO),@(NO),@(NO)];
        self.tableViewCellClass = DiamCertCell.class;
    }
    return self;
}

@end
